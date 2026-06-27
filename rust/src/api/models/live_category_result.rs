use platforms_parser::extractor::models as ext;

use super::LiveRoomItem;

#[derive(Debug, Clone)]
pub struct LiveCategoryResult {
    pub has_more: bool,
    pub items: Vec<LiveRoomItem>,
}

impl From<ext::LiveCategoryResult> for LiveCategoryResult {
    fn from(r: ext::LiveCategoryResult) -> Self {
        Self {
            has_more: r.has_more,
            items: r.items.into_iter().map(Into::into).collect(),
        }
    }
}
