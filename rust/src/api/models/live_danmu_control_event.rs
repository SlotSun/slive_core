use platforms_parser::danmaku::event as event;

/// Mirrors `LiveMessage` superChat variant — kept as a separate type because
/// frb does not support `dynamic` fields, so the super-chat payload is typed.
#[derive(Debug, Clone)]
pub struct LiveDanmuControlEvent {
    pub kind: String,
    pub message: Option<String>,
    pub title: Option<String>,
    pub category: Option<String>,
    pub parent_category: Option<String>,
}

impl From<event::DanmuControlEvent> for LiveDanmuControlEvent {
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
