use flutter_rust_bridge::frb;
use platforms_parser::danmaku::message as danmu;

use super::{LiveMessageColor, LiveMessageType};

/// Mirrors `DanmuMessage` from platforms-parser.
#[frb(type_64bit_int)]
#[derive(Debug, Clone)]
pub struct LiveMessage {
    pub id: String,
    pub user_id: String,
    pub user_name: String,
    pub message: String,
    pub color: LiveMessageColor,
    /// Unix timestamp in milliseconds.
    pub time_millis: i64,
    pub message_type: LiveMessageType,
    /// Platform-specific metadata serialized as JSON string.
    pub metadata: Option<String>,
}

fn danmu_type_to_message_type(t: danmu::DanmakuType) -> LiveMessageType {
    match t {
        danmu::DanmakuType::Chat => LiveMessageType::Chat,
        danmu::DanmakuType::Gift => LiveMessageType::Gift,
        danmu::DanmakuType::SuperChat => LiveMessageType::SuperChat,
        danmu::DanmakuType::System => LiveMessageType::Chat,
        danmu::DanmakuType::UserJoin => LiveMessageType::Chat,
        danmu::DanmakuType::Follow => LiveMessageType::Chat,
        danmu::DanmakuType::Subscription => LiveMessageType::Chat,
        danmu::DanmakuType::Other => LiveMessageType::Chat,
    }
}

fn parse_hex_color(hex: &str) -> LiveMessageColor {
    let clean = hex.trim_start_matches('#');
    if clean.len() >= 6 {
        let r = i32::from_str_radix(&clean[0..2], 16).unwrap_or(255);
        let g = i32::from_str_radix(&clean[2..4], 16).unwrap_or(255);
        let b = i32::from_str_radix(&clean[4..6], 16).unwrap_or(255);
        LiveMessageColor { r, g, b }
    } else {
        LiveMessageColor {
            r: 255,
            g: 255,
            b: 255,
        }
    }
}

impl From<danmu::DanmakuMessage> for LiveMessage {
    fn from(m: danmu::DanmakuMessage) -> Self {
        Self {
            id: m.id,
            user_id: m.user_id,
            user_name: m.username,
            message: m.content,
            color: m
                .color
                .as_deref()
                .map(parse_hex_color)
                .unwrap_or(LiveMessageColor::white()),
            time_millis: m.timestamp.timestamp_millis(),
            message_type: danmu_type_to_message_type(m.message_type),
            metadata: m.metadata.map(|m| serde_json::to_string(&m).unwrap_or_default()),
        }
    }
}
