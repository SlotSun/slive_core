//! frb-compatible mirror types for platforms-parser models.
//!
//! Field names and shapes match the reference models from `simple_live_core`
//! so that the generated Dart types feel identical to the original package.
//!
//! These types avoid `serde_json::Value`, `DateTime<Utc>`, and `HashMap` in
//! struct fields, which flutter_rust_bridge cannot bridge directly.

pub mod live_anchor_item;
pub mod live_category;
pub mod live_category_result;
pub mod live_danmu_control_event;
pub mod live_danmu_item;
pub mod live_message;
pub mod live_message_color;
pub mod live_message_type;
pub mod live_play_quality;
pub mod live_play_url;
pub mod live_room_detail;
pub mod live_room_item;
pub mod live_search_anchor_result;
pub mod live_search_room_result;
pub mod live_sub_category;
pub mod live_super_chat_message;

pub use live_anchor_item::*;
pub use live_category::*;
pub use live_category_result::*;
pub use live_danmu_control_event::*;
pub use live_danmu_item::*;
pub use live_message::*;
pub use live_message_color::*;
pub use live_message_type::*;
pub use live_play_quality::*;
pub use live_play_url::*;
pub use live_room_detail::*;
pub use live_room_item::*;
pub use live_search_anchor_result::*;
pub use live_search_room_result::*;
pub use live_sub_category::*;
pub use live_super_chat_message::*;
