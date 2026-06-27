use platforms_parser::extractor::models as ext;

#[derive(Debug, Clone)]
pub struct LiveAnchorItem {
    pub room_id: String,
    pub avatar: String,
    pub user_name: String,
    pub live_status: bool,
}

impl From<ext::LiveAnchorItem> for LiveAnchorItem {
    fn from(a: ext::LiveAnchorItem) -> Self {
        Self {
            room_id: a.room_id.unwrap_or_default(),
            avatar: a.user_avatar,
            user_name: a.user_name,
            live_status: a.is_live,
        }
    }
}
