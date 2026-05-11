//! frb-compatible mirror types for platforms-parser models.
//!
//! Field names and shapes match the reference models from `simple_live_core`
//! so that the generated Dart types feel identical to the original package.
//!
//! These types avoid `serde_json::Value`, `DateTime<Utc>`, and `HashMap` in
//! struct fields, which flutter_rust_bridge cannot bridge directly.

use platforms_parser::danmaku::event as event;
use platforms_parser::danmaku::message as danmu;
use platforms_parser::extractor::models as ext;

// ---------------------------------------------------------------------------
// Extractor types
// ---------------------------------------------------------------------------

#[derive(Debug, Clone)]
pub struct SliveCategory {
    pub id: String,
    pub name: String,
    pub children: Vec<SliveSubCategory>,
}

#[derive(Debug, Clone)]
pub struct SliveSubCategory {
    pub id: String,
    pub name: String,
    pub parent_id: String,
    pub pic: Option<String>,
}

#[derive(Debug, Clone)]
pub struct SliveRoomItem {
    pub room_id: String,
    pub title: String,
    pub cover: String,
    pub user_name: String,
    pub online: i64,
}

#[derive(Debug, Clone)]
pub struct SliveAnchorItem {
    pub room_id: String,
    pub avatar: String,
    pub user_name: String,
    pub live_status: bool,
}

#[derive(Debug, Clone)]
pub struct SliveRoomDetail {
    pub room_id: String,
    pub title: String,
    pub cover: String,
    pub user_name: String,
    pub user_avatar: String,
    pub online: i64,
    pub introduction: Option<String>,
    pub notice: Option<String>,
    pub status: bool,
    /// Platform-specific data serialized as JSON string.
    pub data: Option<String>,
    /// Danmaku connection data serialized as JSON string.
    pub danmaku_data: Option<String>,
    pub url: String,
    pub is_record: bool,
}

#[derive(Debug, Clone)]
pub struct SlivePlayQuality {
    pub quality: String,
    pub data: String,
    pub sort: i32,
}

#[derive(Debug, Clone)]
pub struct SlivePlayUrl {
    pub urls: Vec<String>,
    pub headers: Option<Vec<SliveMapEntry>>,
}

/// A single key-value entry for bridging `Map<String, String>`.
#[derive(Debug, Clone)]
pub struct SliveMapEntry {
    pub key: String,
    pub value: String,
}

#[derive(Debug, Clone)]
pub struct SliveCategoryResult {
    pub has_more: bool,
    pub items: Vec<SliveRoomItem>,
}

#[derive(Debug, Clone)]
pub struct SliveSearchRoomResult {
    pub has_more: bool,
    pub items: Vec<SliveRoomItem>,
}

#[derive(Debug, Clone)]
pub struct SliveSearchAnchorResult {
    pub has_more: bool,
    pub items: Vec<SliveAnchorItem>,
}

#[derive(Debug, Clone)]
pub struct SliveSuperChatMessage {
    pub user_name: String,
    pub face: String,
    pub message: String,
    pub price: i32,
    /// Unix timestamp in milliseconds.
    pub start_time: i64,
    /// Unix timestamp in milliseconds.
    pub end_time: i64,
    pub background_color: String,
    pub background_bottom_color: String,
}

// ---------------------------------------------------------------------------
// Danmaku types
// ---------------------------------------------------------------------------

/// Mirrors `LiveMessageType` enum from the reference.
#[derive(Debug, Clone)]
pub enum SliveMessageType {
    Chat,
    Gift,
    Online,
    SuperChat,
}

/// Mirrors `LiveMessageColor` from the reference.
#[derive(Debug, Clone)]
pub struct SliveMessageColor {
    pub r: i32,
    pub g: i32,
    pub b: i32,
}

/// Mirrors `LiveMessage` from the reference.
#[derive(Debug, Clone)]
pub struct SliveMessage {
    pub message_type: SliveMessageType,
    pub user_name: String,
    pub message: String,
    /// JSON-serialized data (e.g. online count as string).
    pub data: Option<String>,
    pub color: SliveMessageColor,
}

/// Mirrors `LiveMessage` superChat variant — kept as a separate type because
/// frb does not support `dynamic` fields, so the super-chat payload is typed.
#[derive(Debug, Clone)]
pub struct SliveDanmuControlEvent {
    pub kind: String,
    pub message: Option<String>,
    pub title: Option<String>,
    pub category: Option<String>,
    pub parent_category: Option<String>,
}

#[derive(Debug, Clone)]
pub enum SliveDanmuItem {
    Message(SliveMessage),
    SuperChat(SliveSuperChatMessage),
    Control(SliveDanmuControlEvent),
}

// ---------------------------------------------------------------------------
// Conversion: frb types → platforms-parser (reverse)
// ---------------------------------------------------------------------------

impl From<SliveSubCategory> for ext::LiveSubCategory {
    fn from(c: SliveSubCategory) -> Self {
        Self {
            id: c.id,
            name: c.name,
            parent_id: Some(c.parent_id),
            pic: c.pic,
        }
    }
}

impl From<SliveRoomDetail> for ext::LiveRoomDetail {
    fn from(d: SliveRoomDetail) -> Self {
        Self {
            room_id: d.room_id,
            title: d.title,
            cover: d.cover,
            online: d.online as u64,
            status: d.status,
            url: d.url,
            user_name: d.user_name,
            user_avatar: d.user_avatar,
            platform: String::new(),
            data: d.data.and_then(|s| serde_json::from_str(&s).ok()),
            danmaku_data: d.danmaku_data.and_then(|s| serde_json::from_str(&s).ok()),
        }
    }
}

impl From<SlivePlayQuality> for ext::LivePlayQuality {
    fn from(q: SlivePlayQuality) -> Self {
        Self {
            quality: q.quality,
            data: q.data,
        }
    }
}

// ---------------------------------------------------------------------------
// Conversion: platforms-parser → frb types
// ---------------------------------------------------------------------------

impl From<ext::LiveCategory> for SliveCategory {
    fn from(c: ext::LiveCategory) -> Self {
        Self {
            id: c.id,
            name: c.name,
            children: c.sub_categories.into_iter().map(Into::into).collect(),
        }
    }
}

impl From<ext::LiveSubCategory> for SliveSubCategory {
    fn from(c: ext::LiveSubCategory) -> Self {
        Self {
            id: c.id,
            name: c.name,
            parent_id: c.parent_id.unwrap_or_default(),
            pic: c.pic,
        }
    }
}

impl From<ext::LiveRoomItem> for SliveRoomItem {
    fn from(r: ext::LiveRoomItem) -> Self {
        Self {
            room_id: r.room_id,
            title: r.title,
            cover: r.cover,
            user_name: r.user_name,
            online: r.online as i64,
        }
    }
}

impl From<ext::LiveAnchorItem> for SliveAnchorItem {
    fn from(a: ext::LiveAnchorItem) -> Self {
        Self {
            room_id: a.room_id.unwrap_or_default(),
            avatar: a.user_avatar,
            user_name: a.user_name,
            live_status: a.is_live,
        }
    }
}

impl From<ext::LiveRoomDetail> for SliveRoomDetail {
    fn from(d: ext::LiveRoomDetail) -> Self {
        Self {
            room_id: d.room_id,
            title: d.title,
            cover: d.cover,
            user_name: d.user_name,
            user_avatar: d.user_avatar,
            online: d.online as i64,
            introduction: None,
            notice: None,
            status: d.status,
            data: d.data.map(|v| v.to_string()),
            danmaku_data: d.danmaku_data.map(|v| v.to_string()),
            url: d.url,
            is_record: false,
        }
    }
}

impl From<ext::LivePlayQuality> for SlivePlayQuality {
    fn from(q: ext::LivePlayQuality) -> Self {
        Self {
            quality: q.quality,
            data: q.data,
            sort: 0,
        }
    }
}

impl From<ext::LivePlayUrl> for SlivePlayUrl {
    fn from(u: ext::LivePlayUrl) -> Self {
        let _ = u.url_type; // not exposed in reference model
        Self {
            urls: u.urls,
            headers: u.headers.map(|h| {
                h.into_iter()
                    .map(|(k, v)| SliveMapEntry { key: k, value: v })
                    .collect()
            }),
        }
    }
}

impl From<ext::LiveCategoryResult> for SliveCategoryResult {
    fn from(r: ext::LiveCategoryResult) -> Self {
        Self {
            has_more: r.has_more,
            items: r.items.into_iter().map(Into::into).collect(),
        }
    }
}

impl From<ext::LiveSearchRoomResult> for SliveSearchRoomResult {
    fn from(r: ext::LiveSearchRoomResult) -> Self {
        Self {
            has_more: r.has_more,
            items: r.items.into_iter().map(Into::into).collect(),
        }
    }
}

impl From<ext::LiveSearchAnchorResult> for SliveSearchAnchorResult {
    fn from(r: ext::LiveSearchAnchorResult) -> Self {
        Self {
            has_more: r.has_more,
            items: r.items.into_iter().map(Into::into).collect(),
        }
    }
}

impl From<ext::LiveSuperChatMessage> for SliveSuperChatMessage {
    fn from(m: ext::LiveSuperChatMessage) -> Self {
        Self {
            user_name: m.user_name,
            face: String::new(),
            message: m.content,
            price: m.price as i32,
            start_time: m.start_time,
            end_time: 0,
            background_color: String::new(),
            background_bottom_color: String::new(),
        }
    }
}

// ---------------------------------------------------------------------------
// Danmaku conversions
// ---------------------------------------------------------------------------

fn danmu_type_to_message_type(t: danmu::DanmuType) -> SliveMessageType {
    match t {
        danmu::DanmuType::Chat => SliveMessageType::Chat,
        danmu::DanmuType::Gift => SliveMessageType::Gift,
        danmu::DanmuType::SuperChat => SliveMessageType::SuperChat,
        danmu::DanmuType::System => SliveMessageType::Chat,
        danmu::DanmuType::UserJoin => SliveMessageType::Chat,
        danmu::DanmuType::Follow => SliveMessageType::Chat,
        danmu::DanmuType::Subscription => SliveMessageType::Chat,
        danmu::DanmuType::Other => SliveMessageType::Chat,
    }
}

fn parse_hex_color(hex: &str) -> SliveMessageColor {
    let clean = hex.trim_start_matches('#');
    if clean.len() >= 6 {
        let r = i32::from_str_radix(&clean[0..2], 16).unwrap_or(255);
        let g = i32::from_str_radix(&clean[2..4], 16).unwrap_or(255);
        let b = i32::from_str_radix(&clean[4..6], 16).unwrap_or(255);
        SliveMessageColor { r, g, b }
    } else {
        SliveMessageColor {
            r: 255,
            g: 255,
            b: 255,
        }
    }
}

impl From<danmu::DanmuMessage> for SliveSuperChatMessage {
    fn from(m: danmu::DanmuMessage) -> Self {
        let meta = m.metadata.as_ref();
        let price = meta
            .and_then(|h| h.get("price"))
            .and_then(|v| v.as_u64())
            .unwrap_or(0) as i32;
        let keep_time = meta
            .and_then(|h| h.get("keep_time"))
            .and_then(|v| v.as_u64())
            .unwrap_or(0);

        // Prefer explicit start_time/end_time from metadata (seconds),
        // fall back to timestamp + keep_time calculation.
        let start_time = meta
            .and_then(|h| h.get("start_time"))
            .and_then(|v| v.as_i64())
            .filter(|&v| v > 0)
            .map(|v| v * 1000)
            .unwrap_or_else(|| m.timestamp.timestamp_millis());
        let end_time = meta
            .and_then(|h| h.get("end_time"))
            .and_then(|v| v.as_i64())
            .filter(|&v| v > 0)
            .map(|v| v * 1000)
            .unwrap_or(start_time + (keep_time as i64 * 1000));

        let face = meta
            .and_then(|h| h.get("face"))
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();
        let background_color = meta
            .and_then(|h| h.get("background_color"))
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();
        let background_bottom_color = meta
            .and_then(|h| h.get("background_bottom_color"))
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();

        Self {
            user_name: m.username,
            face,
            message: m.content,
            price,
            start_time,
            end_time,
            background_color,
            background_bottom_color,
        }
    }
}

impl From<danmu::DanmuMessage> for SliveMessage {
    fn from(m: danmu::DanmuMessage) -> Self {
        Self {
            message_type: danmu_type_to_message_type(m.message_type),
            user_name: m.username,
            message: m.content,
            data: None,
            color: m
                .color
                .as_deref()
                .map(parse_hex_color)
                .unwrap_or(SliveMessageColor {
                    r: 255,
                    g: 255,
                    b: 255,
                }),
        }
    }
}

impl From<event::DanmuControlEvent> for SliveDanmuControlEvent {
    fn from(e: event::DanmuControlEvent) -> Self {
        match e {
            event::DanmuControlEvent::StreamClosed { message, .. } => Self {
                kind: "stream_closed".to_string(),
                message,
                title: None,
                category: None,
                parent_category: None,
            },
            event::DanmuControlEvent::RoomInfoChanged {
                title,
                category,
                parent_category,
            } => Self {
                kind: "room_info_changed".to_string(),
                message: None,
                title,
                category,
                parent_category,
            },
            event::DanmuControlEvent::Other {
                kind, message, ..
            } => Self {
                kind,
                message,
                title: None,
                category: None,
                parent_category: None,
            },
        }
    }
}

impl From<event::DanmuItem> for SliveDanmuItem {
    fn from(item: event::DanmuItem) -> Self {
        match item {
            event::DanmuItem::Message(m) => {
                if m.message_type == danmu::DanmuType::SuperChat {
                    SliveDanmuItem::SuperChat(m.into())
                } else {
                    SliveDanmuItem::Message(m.into())
                }
            }
            event::DanmuItem::Control(e) => SliveDanmuItem::Control(e.into()),
        }
    }
}
