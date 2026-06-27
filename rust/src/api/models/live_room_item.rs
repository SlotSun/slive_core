use flutter_rust_bridge::frb;
use platforms_parser::extractor::models as ext;

#[frb(type_64bit_int)]
#[derive(Debug, Clone)]
pub struct LiveRoomItem {
    pub room_id: String,
    pub title: String,
    pub cover: String,
    pub user_name: String,
    pub online: i64,
}

impl From<ext::LiveRoomItem> for LiveRoomItem {
    fn from(r: ext::LiveRoomItem) -> Self {
        Self {
            room_id: r.room_id,
            title: r.title,
            cover: r.cover,
            user_name: r.user_name,
            online: r.online as i64,
        }
    }
}
