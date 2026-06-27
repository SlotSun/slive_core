use platforms_parser::extractor::models as ext;
use std::collections::HashMap;

#[derive(Debug, Clone)]
pub struct LivePlayUrl {
    pub urls: Vec<String>,
    pub headers: Option<HashMap<String, String>>,
}

impl From<ext::LivePlayUrl> for LivePlayUrl {
    fn from(u: ext::LivePlayUrl) -> Self {
        let _ = u.url_type; // not exposed in reference model
        Self {
            urls: u.urls,
            headers: u.headers.map(|h| h.into_iter().collect()),
        }
    }
}
