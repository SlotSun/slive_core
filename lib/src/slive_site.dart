import 'package:slive_core/src/rust/api/types.dart';
import 'package:slive_core/src/slive_danmaku.dart';

export 'platforms/bilibili/bilibili_site.dart';
export 'platforms/douyin/douyin_site.dart';
export 'platforms/douyu/douyu_site.dart';
export 'platforms/huya/huya_site.dart';
export 'platforms/twitch/twitch_site.dart';

/// Unified site interface matching the original `LiveSite` pattern.
///
/// Each platform provides a concrete implementation that delegates to the
/// frb-generated extractor. Use the platform's `create()` factory to instantiate.
abstract class LiveSite {
  String get id;
  String get name;

  void setCookies(String cookies);
  LiveDanmaku getDanmaku();

  Future<List<LiveCategory>> getCategories();
  Future<LiveSearchRoomResult> searchRooms(String keyword, {int page = 1});
  Future<LiveSearchAnchorResult> searchAnchors(String keyword, {int page = 1});
  Future<LiveCategoryResult> getCategoryRooms(
    LiveSubCategory category, {
    int page = 1,
  });
  Future<LiveCategoryResult> getRecommendRooms({int page = 1});
  Future<LiveRoomDetail> getRoomDetail({required String roomId});
  Future<List<LivePlayQuality>> getPlayQualities({
    required LiveRoomDetail detail,
  });
  Future<LivePlayUrl> getPlayUrls({
    required LiveRoomDetail detail,
    required LivePlayQuality quality,
  });
  Future<bool> getLiveStatus({required String roomId});
  Future<List<LiveSuperChatMessage>> getSuperChatMessages({
    required String roomId,
  });
}
