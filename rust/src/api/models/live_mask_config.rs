use platforms_parser::danmaku_mask::mask_config::{FrequencyConfig, MaskConfig};

/// frb-compatible mirror of `MaskConfig`.
#[derive(Debug, Clone)]
pub struct LiveMaskConfig {
    pub frequency: Option<LiveFrequencyConfig>,
    pub blacklist_words: Option<Vec<String>>,
}

/// frb-compatible mirror of `FrequencyConfig`.
#[derive(Debug, Clone)]
pub struct LiveFrequencyConfig {
    pub base_window_ms: u32,
    pub bucket_count: u16,
    pub use_normalization: bool,
    pub max_frequency: u16,
}

impl From<LiveMaskConfig> for MaskConfig {
    fn from(c: LiveMaskConfig) -> Self {
        Self {
            frequency: c.frequency.map(|f| f.into()),
            blacklist_words: c.blacklist_words,
        }
    }
}

impl From<LiveFrequencyConfig> for FrequencyConfig {
    fn from(f: LiveFrequencyConfig) -> Self {
        Self {
            base_window_ms: f.base_window_ms,
            bucket_count: f.bucket_count,
            use_normalization: f.use_normalization,
            max_frequency: f.max_frequency,
        }
    }
}
