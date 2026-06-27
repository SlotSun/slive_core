use platforms_parser::extractor::models as ext;

#[derive(Debug, Clone)]
pub struct LiveSubCategory {
    pub id: String,
    pub name: String,
    pub parent_id: String,
    pub pic: Option<String>,
}

impl From<LiveSubCategory> for ext::LiveSubCategory {
    fn from(c: LiveSubCategory) -> Self {
        Self {
            id: c.id,
            name: c.name,
            parent_id: Some(c.parent_id),
            pic: c.pic,
        }
    }
}

impl From<ext::LiveSubCategory> for LiveSubCategory {
    fn from(c: ext::LiveSubCategory) -> Self {
        Self {
            id: c.id,
            name: c.name,
            parent_id: c.parent_id.unwrap_or_default(),
            pic: c.pic,
        }
    }
}
