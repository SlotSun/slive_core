use platforms_parser::extractor::models as ext;

use super::LiveSubCategory;

#[derive(Debug, Clone)]
pub struct LiveCategory {
    pub id: String,
    pub name: String,
    pub children: Vec<LiveSubCategory>,
}

impl From<ext::LiveCategory> for LiveCategory {
    fn from(c: ext::LiveCategory) -> Self {
        Self {
            id: c.id,
            name: c.name,
            children: c.sub_categories.into_iter().map(Into::into).collect(),
        }
    }
}
