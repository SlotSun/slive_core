use platforms_parser::extractor::models as ext;

use super::LiveRoomItem;

#[derive(Debug, Clone)]
pub struct LiveSearchRoomResult {
    pub has_more: bool,
    pub items: Vec<LiveRoomItem>,
}

impl From<ext::LiveSearchRoomResult> for LiveSearchRoomResult {
    fn from(r: ext::LiveSearchRoomResult) -> Self {
        Self {
            has_more: r.has_more,
            items: r.items.into_iter().map(Into::into).collect(),
        }
    }
}
