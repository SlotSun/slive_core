//! Concrete extractor wrappers for each platform.
//!
//! frb cannot bridge `dyn LiveExtractor` directly, so each platform gets a concrete struct.

use crate::api::models::*;
use log::info;
use platforms_parser::extractor::LiveExtractor as _;

/// Generate a concrete extractor wrapper for a platform.
macro_rules! impl_extractor {
    ($name:ident, $inner:ty, $platform_id:expr) => {
        pub struct $name {
            pub(crate) inner: $inner,
        }

        impl $name {
            pub fn new() -> Self {
                Self {
                    inner: <$inner>::new(),
                }
            }

            pub fn set_cookies(&self, cookies: String) {
                self.inner.set_cookies(&cookies);
            }

            pub fn supports_url(&self, url: String) -> bool {
                self.inner.supports_url(&url)
            }

            pub fn extract_room_id(&self, url: String) -> Option<String> {
                self.inner.extract_room_id(&url)
            }

            pub async fn get_categories(&self) -> anyhow::Result<Vec<LiveCategory>> {
                info!("[{}] get_categories called", $platform_id);
                let result = self.inner.get_categories().await?;
                info!("[{}] get_categories returned {} items", $platform_id, result.len());
                Ok(result.into_iter().map(Into::into).collect())
            }

            pub async fn search_rooms(
                &self,
                keyword: String,
                page: i32,
            ) -> anyhow::Result<LiveSearchRoomResult> {
                let result = self.inner.search_rooms(&keyword, page as u32).await?;
                Ok(result.into())
            }

            pub async fn search_anchors(
                &self,
                keyword: String,
                page: i32,
            ) -> anyhow::Result<LiveSearchAnchorResult> {
                let result = self.inner.search_anchors(&keyword, page as u32).await?;
                Ok(result.into())
            }

            pub async fn get_category_rooms(
                &self,
                category: LiveSubCategory,
                page: i32,
            ) -> anyhow::Result<LiveCategoryResult> {
                let cat = platforms_parser::extractor::models::LiveSubCategory::from(category);
                let result = self.inner.get_category_rooms(&cat, page as u32).await?;
                Ok(result.into())
            }

            pub async fn get_recommend_rooms(
                &self,
                page: i32,
            ) -> anyhow::Result<LiveCategoryResult> {
                let result = self.inner.get_recommend_rooms(page as u32).await?;
                Ok(result.into())
            }

            pub async fn get_room_detail(
                &self,
                room_id: String,
            ) -> anyhow::Result<LiveRoomDetail> {
                info!("[{}] get_room_detail called for room_id={}", $platform_id, room_id);
                let detail = self.inner.get_room_detail(&room_id).await?;
                info!("[{}] get_room_detail success: title={}", $platform_id, detail.title);
                Ok(detail.into())
            }

            pub async fn get_live_status(&self, room_id: String) -> anyhow::Result<bool> {
                let status = self.inner.get_live_status(&room_id).await?;
                Ok(status)
            }

            pub async fn get_play_qualities(
                &self,
                detail: LiveRoomDetail,
            ) -> anyhow::Result<Vec<LivePlayQuality>> {
                let inner_detail =
                    platforms_parser::extractor::models::LiveRoomDetail::from(detail);
                let qualities = self.inner.get_play_qualities(&inner_detail).await?;
                Ok(qualities.into_iter().map(Into::into).collect())
            }

            pub async fn get_play_urls(
                &self,
                detail: LiveRoomDetail,
                quality: LivePlayQuality,
            ) -> anyhow::Result<LivePlayUrl> {
                let inner_detail =
                    platforms_parser::extractor::models::LiveRoomDetail::from(detail);
                let inner_quality =
                    platforms_parser::extractor::models::LivePlayQuality::from(quality);
                let play_url = self.inner.get_play_urls(&inner_detail, &inner_quality).await?;
                Ok(play_url.into())
            }

            pub async fn get_super_chat_messages(
                &self,
                room_id: String,
            ) -> anyhow::Result<Vec<LiveSuperChatMessage>> {
                let messages = self.inner.get_super_chat_messages(&room_id).await?;
                Ok(messages.into_iter().map(Into::into).collect())
            }
        }
    };
}

// Concrete implementations for each platform
impl_extractor!(
    LiveBilibiliExtractor,
    platforms_parser::extractor::platforms::bilibili::BilibiliExtractor,
    "bilibili"
);
impl_extractor!(
    LiveDouyinExtractor,
    platforms_parser::extractor::platforms::douyin::DouyinExtractor,
    "douyin"
);
impl_extractor!(
    LiveDouyuExtractor,
    platforms_parser::extractor::platforms::douyu::DouyuExtractor,
    "douyu"
);
impl_extractor!(
    LiveHuyaExtractor,
    platforms_parser::extractor::platforms::huya::HuyaExtractor,
    "huya"
);

impl LiveHuyaExtractor {
    /// Set a custom User-Agent for Huya HTTP requests (e.g. HYSDK_UA).
    pub fn set_sdk_ua(&self, ua: String) {
        self.inner.set_sdk_ua(&ua);
    }
}

impl_extractor!(
    LiveTwitchExtractor,
    platforms_parser::extractor::platforms::twitch::TwitchExtractor,
    "twitch"
);
