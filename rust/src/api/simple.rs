//! Utility functions.

/// Test logging — call from Dart to verify Rust→Dart log bridge works.
pub fn test_log() {
    log::error!("[test] this is an error log");
    log::warn!("[test] this is a warn log");
    log::info!("[test] this is an info log");
    log::debug!("[test] this is a debug log");
}

/// Detect platform from a live stream URL.
/// Returns the platform ID (e.g. "bilibili", "douyin", "douyu", "huya", "twitch") or None.
pub fn detect_platform(url: String) -> Option<String> {
    if url.contains("bilibili.com") {
        Some("bilibili".to_string())
    } else if url.contains("douyin.com") {
        Some("douyin".to_string())
    } else if url.contains("douyu.com") {
        Some("douyu".to_string())
    } else if url.contains("huya.com") {
        Some("huya".to_string())
    } else if url.contains("twitch.tv") {
        Some("twitch".to_string())
    } else {
        None
    }
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
