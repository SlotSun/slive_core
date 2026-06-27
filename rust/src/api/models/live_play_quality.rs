use platforms_parser::extractor::models as ext;

#[derive(Debug, Clone)]
pub struct LivePlayQuality {
    pub quality: String,
    pub data: String,
    pub sort: i32,
}

impl From<LivePlayQuality> for ext::LivePlayQuality {
    fn from(q: LivePlayQuality) -> Self {
        Self {
            quality: q.quality,
            data: q.data,
        }
    }
}

impl From<ext::LivePlayQuality> for LivePlayQuality {
    fn from(q: ext::LivePlayQuality) -> Self {
        Self {
            quality: q.quality,
            data: q.data,
            sort: 0,
        }
    }
}
