//! Concrete danmaku provider wrappers for each platform.

use crate::api::models;
use platforms_parser::danmaku::DanmuProvider as _;

/// Opaque connection handle — wraps the inner DanmuConnection.
#[flutter_rust_bridge::frb(opaque)]
pub struct LiveDanmuConnection {
    inner: platforms_parser::danmaku::DanmuConnection,
}

impl LiveDanmuConnection {
    pub fn is_connected(&self) -> bool {
        self.inner.is_connected
    }

    pub fn room_id(&self) -> String {
        self.inner.room_id.clone()
    }

    pub fn platform(&self) -> String {
        self.inner.platform.clone()
    }
}

/// Generate a concrete danmaku provider wrapper.
macro_rules! impl_danmu_provider {
    ($name:ident, $inner:ty, $platform_id:expr) => {
        pub struct $name {
            pub(crate) inner: $inner,
        }

        impl $name {
            pub fn new() -> Self {
                Self {
                    inner: <$inner>::new(),
                }
            }

            pub fn supports_url(&self, url: String) -> bool {
                self.inner.supports_url(&url)
            }

            pub fn extract_room_id(&self, url: String) -> Option<String> {
                self.inner.extract_room_id(&url)
            }

            pub async fn connect(
                &self,
                room_id: String,
                cookies: Option<String>,
                danmaku_data: Option<String>,
            ) -> anyhow::Result<LiveDanmuConnection> {
                let extras = danmaku_data.and_then(|data| {
                    serde_json::from_str::<
                        std::collections::HashMap<String, serde_json::Value>,
                    >(&data)
                    .ok()
                    .map(|map| {
                        map.into_iter()
                            .map(|(k, v)| {
                                let s = match v {
                                    serde_json::Value::String(s) => s,
                                    other => other.to_string(),
                                };
                                (k, s)
                            })
                            .collect()
                    })
                });
                let config = platforms_parser::danmaku::ConnectionConfig {
                    cookies,
                    websocket: None,
                    extras,
                };
                let conn = self.inner.connect(&room_id, config).await?;
                Ok(LiveDanmuConnection { inner: conn })
            }

            pub async fn receive(
                &self,
                connection: &LiveDanmuConnection,
            ) -> anyhow::Result<Option<models::LiveDanmuItem>> {
                let item = self.inner.receive(&connection.inner).await?;
                Ok(item.map(Into::into))
            }

            pub async fn disconnect(
                &self,
                connection: &mut LiveDanmuConnection,
            ) -> anyhow::Result<()> {
                self.inner.disconnect(&mut connection.inner).await?;
                Ok(())
            }
        }
    };
}

impl_danmu_provider!(
    LiveBilibiliDanmakuProvider,
    platforms_parser::extractor::platforms::bilibili::danmaku::BilibiliDanmuProvider,
    "bilibili"
);
impl_danmu_provider!(
    LiveDouyinDanmakuProvider,
    platforms_parser::extractor::platforms::douyin::danmaku::DouyinDanmuProvider,
    "douyin"
);
impl_danmu_provider!(
    LiveDouyuDanmakuProvider,
    platforms_parser::extractor::platforms::douyu::danmaku::DouyuDanmuProvider,
    "douyu"
);
impl_danmu_provider!(
    LiveHuyaDanmakuProvider,
    platforms_parser::extractor::platforms::huya::danmaku::HuyaDanmuProvider,
    "huya"
);

impl_danmu_provider!(
    LiveTwitchDanmakuProvider,
    platforms_parser::extractor::platforms::twitch::danmaku::TwitchDanmuProvider,
    "twitch"
);

/// Diagnostic: test Douyu danmaku connection end-to-end from the Rust side.
/// Returns a log of what happened during the test.
pub async fn douyu_danmaku_diagnostic(room_id: String) -> String {
    use platforms_parser::danmaku::DanmuProvider;
    use std::fmt::Write;

    let mut log = String::new();
    let _ = writeln!(log, "=== Douyu Danmaku Diagnostic ===");
    let _ = writeln!(log, "Room ID: {room_id}");

    // 1. Create provider
    let provider =
        platforms_parser::extractor::platforms::douyu::danmaku::DouyuDanmuProvider::new();
    let _ = writeln!(log, "Provider created");

    // 2. Connect
    let config = platforms_parser::danmaku::ConnectionConfig::default();
    let _ = writeln!(log, "Connecting...");
    let conn = match provider.connect(&room_id, config).await {
        Ok(c) => {
            let _ = writeln!(log, "Connected! id={}, platform={}", c.id, c.platform);
            c
        }
        Err(e) => {
            let _ = writeln!(log, "Connect FAILED: {e}");
            return log;
        }
    };

    // 3. Try receiving messages for 5 seconds
    let _ = writeln!(log, "Receiving messages for 5 seconds...");
    let deadline = tokio::time::Instant::now() + tokio::time::Duration::from_secs(5);
    let mut count = 0u32;
    let mut errors = 0u32;
    let mut timeouts = 0u32;

    loop {
        if tokio::time::Instant::now() >= deadline {
            break;
        }
        match provider.receive(&conn).await {
            Ok(Some(item)) => {
                count += 1;
                if count <= 5 {
                    let _ = writeln!(log, "  Message {count}: {item:?}");
                }
            }
            Ok(None) => {
                timeouts += 1;
            }
            Err(e) => {
                errors += 1;
                let _ = writeln!(log, "  Error: {e}");
                if errors >= 3 {
                    let _ = writeln!(log, "Too many errors, stopping");
                    break;
                }
            }
        }
    }

    let _ = writeln!(
        log,
        "Results: {count} messages, {timeouts} timeouts, {errors} errors"
    );

    // 4. Disconnect
    let mut conn = conn;
    let _ = provider.disconnect(&mut conn).await;
    let _ = writeln!(log, "Disconnected");
    let _ = writeln!(log, "=== End Diagnostic ===");

    log
}
