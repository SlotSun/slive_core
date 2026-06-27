use platforms_parser::extractor::models as ext;

use super::LiveAnchorItem;

#[derive(Debug, Clone)]
pub struct LiveSearchAnchorResult {
    pub has_more: bool,
    pub items: Vec<LiveAnchorItem>,
}

impl From<ext::LiveSearchAnchorResult> for LiveSearchAnchorResult {
    fn from(r: ext::LiveSearchAnchorResult) -> Self {
        Self {
            has_more: r.has_more,
            items: r.items.into_iter().map(Into::into).collect(),
        }
    }
}
