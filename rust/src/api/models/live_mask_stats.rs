use flutter_rust_bridge::frb;
use platforms_parser::danmaku_mask::mask_provider::MaskStats;

/// frb-compatible mirror of `MaskStats`.
#[derive(Debug, Clone)]
#[frb(type_64bit_int)]
pub struct LiveMaskStats {
    /// Total messages received from the inner provider.
    pub total_received: u64,
    /// Messages that passed the mask.
    pub passed: u64,
    /// Messages blocked by the mask.
    pub blocked: u64,
}

impl From<MaskStats> for LiveMaskStats {
    fn from(s: MaskStats) -> Self {
        Self {
            total_received: s.total_received,
            passed: s.passed,
            blocked: s.blocked,
        }
    }
}
