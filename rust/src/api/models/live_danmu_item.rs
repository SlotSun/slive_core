use platforms_parser::danmaku::event as event;

use super::{LiveDanmuControlEvent, LiveMessage};

#[derive(Debug, Clone)]
pub enum LiveDanmuItem {
    Message(LiveMessage),
    Control(LiveDanmuControlEvent),
}

impl From<event::DanmuItem> for LiveDanmuItem {
    fn from(item: event::DanmuItem) -> Self {
        match item {
            event::DanmuItem::Message(m) => LiveDanmuItem::Message(m.into()),
            event::DanmuItem::Control(e) => LiveDanmuItem::Control(e.into()),
        }
    }
}
