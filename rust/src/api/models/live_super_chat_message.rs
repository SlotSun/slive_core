use flutter_rust_bridge::frb;
use platforms_parser::danmaku::message as danmu;
use platforms_parser::extractor::models as ext;

#[frb(type_64bit_int)]
#[derive(Debug, Clone)]
#[frb(json_serializable)]
pub struct LiveSuperChatMessage {
    pub user_name: String,
    pub face: String,
    pub message: String,
    pub price: i32,
    /// Unix timestamp in milliseconds.
    pub start_time: i64,
    /// Unix timestamp in milliseconds.
    pub end_time: i64,
    pub background_color: String,
    pub background_bottom_color: String,
}

impl From<ext::LiveSuperChatMessage> for LiveSuperChatMessage {
    fn from(m: ext::LiveSuperChatMessage) -> Self {
        Self {
            user_name: m.user_name,
            face: m.face,
            message: m.message,
            price: m.price,
            start_time: m.start_time,
            end_time: m.end_time,
            background_color: m.background_color,
            background_bottom_color: m.background_bottom_color,
        }
    }
}

impl From<danmu::DanmuMessage> for LiveSuperChatMessage {
    fn from(m: danmu::DanmuMessage) -> Self {
        let meta = m.metadata.as_ref();
        let price = meta
            .and_then(|h| h.get("price"))
            .and_then(|v| v.as_u64())
            .unwrap_or(0) as i32;
        let keep_time = meta
            .and_then(|h| h.get("keep_time"))
            .and_then(|v| v.as_u64())
            .unwrap_or(0);

        // Prefer explicit start_time/end_time from metadata (seconds),
        // fall back to timestamp + keep_time calculation.
        let start_time = meta
            .and_then(|h| h.get("start_time"))
            .and_then(|v| v.as_i64())
            .filter(|&v| v > 0)
            .map(|v| v * 1000)
            .unwrap_or_else(|| m.timestamp.timestamp_millis());
        let end_time = meta
            .and_then(|h| h.get("end_time"))
            .and_then(|v| v.as_i64())
            .filter(|&v| v > 0)
            .map(|v| v * 1000)
            .unwrap_or(start_time + (keep_time as i64 * 1000));

        let face = meta
            .and_then(|h| h.get("face"))
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();
        let background_color = meta
            .and_then(|h| h.get("background_color"))
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();
        let background_bottom_color = meta
            .and_then(|h| h.get("background_bottom_color"))
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();

        Self {
            user_name: m.username,
            face,
            message: m.content,
            price,
            start_time,
            end_time,
            background_color,
            background_bottom_color,
        }
    }
}
