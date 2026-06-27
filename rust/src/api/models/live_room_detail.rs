use flutter_rust_bridge::frb;
use platforms_parser::extractor::models as ext;

#[frb(type_64bit_int)]
#[derive(Debug, Clone)]
pub struct LiveRoomDetail {
    pub room_id: String,
    pub title: String,
    pub cover: String,
    pub user_name: String,
    pub user_avatar: String,
    pub online: i64,
    pub introduction: Option<String>,
    pub notice: Option<String>,
    pub status: bool,
    /// Platform-specific data serialized as JSON string.
    pub data: Option<String>,
    /// Danmaku connection data serialized as JSON string.
    pub danmaku_data: Option<String>,
    pub url: String,
    pub is_record: bool,
}

impl From<LiveRoomDetail> for ext::LiveRoomDetail {
    fn from(d: LiveRoomDetail) -> Self {
        Self {
            room_id: d.room_id,
            title: d.title,
            cover: d.cover,
            online: d.online as u64,
            status: d.status,
            url: d.url,
            user_name: d.user_name,
            user_avatar: d.user_avatar,
            platform: String::new(),
            data: d.data.and_then(|s| serde_json::from_str(&s).ok()),
            danmaku_data: d.danmaku_data.and_then(|s| serde_json::from_str(&s).ok()),
        }
    }
}

impl From<ext::LiveRoomDetail> for LiveRoomDetail {
    fn from(d: ext::LiveRoomDetail) -> Self {
        Self {
            room_id: d.room_id,
            title: d.title,
            cover: d.cover,
            user_name: d.user_name,
            user_avatar: d.user_avatar,
            online: d.online as i64,
            introduction: None,
            notice: None,
            status: d.status,
            data: d.data.map(|v| v.to_string()),
            danmaku_data: d.danmaku_data.map(|v| v.to_string()),
            url: d.url,
            is_record: false,
        }
    }
}
