use platforms_parser::danmaku::event as event;

use super::{LiveDanmuControlEvent, LiveMessage};

#[derive(Debug, Clone)]
pub enum LiveDanmuItem {
    Message(LiveMessage),
    Control(LiveDanmuControlEvent),
}

impl From<event::DanmakuItem> for LiveDanmuItem {
    fn from(item: event::DanmakuItem) -> Self {
        match item {
            event::DanmakuItem::Message(m) => LiveDanmuItem::Message(m.into()),
            event::DanmakuItem::Control(e) => LiveDanmuItem::Control(e.into()),
        }
    }
}
