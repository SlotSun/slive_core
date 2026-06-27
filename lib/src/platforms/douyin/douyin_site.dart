import 'package:slive_core/src/rust/api/danmaku.dart' as frb_danmaku;
import 'package:slive_core/src/rust/api/extractor.dart' as frb;
import 'package:slive_core/src/rust/api/models/live_category.dart';
import 'package:slive_core/src/rust/api/models/live_category_result.dart';
import 'package:slive_core/src/rust/api/models/live_play_quality.dart';
import 'package:slive_core/src/rust/api/models/live_play_url.dart';
import 'package:slive_core/src/rust/api/models/live_room_detail.dart';
import 'package:slive_core/src/rust/api/models/live_search_anchor_result.dart';
import 'package:slive_core/src/rust/api/models/live_search_room_result.dart';
import 'package:slive_core/src/rust/api/models/live_sub_category.dart';
import 'package:slive_core/src/rust/api/models/live_super_chat_message.dart';
import 'package:slive_core/src/slive_danmaku.dart';
import 'package:slive_core/src/slive_site.dart';
import 'package:slive_core/src/platforms/platform_common.dart';

class DouyinSite implements LiveSite {
  frb.LiveDouyinExtractor? _extractor;
  frb_danmaku.LiveDouyinDanmakuProvider? _danmakuProvider;

  DouyinSite();

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await ensureFrbInit();
      _extractor = await frb.LiveDouyinExtractor.newInstance();
      _danmakuProvider =
          await frb_danmaku.LiveDouyinDanmakuProvider.newInstance();
    }
  }

  @override
  String get id => 'douyin';
  @override
  String get name => '抖音直播';
  @override
  void setCookies(String cookies) => _extractor?.setCookies(cookies: cookies);
  @override
  LiveDanmaku getDanmaku() => LiveDouyinDanmaku(_danmakuProvider!);
  @override
  Future<List<LiveCategory>> getCategories() async {
    await _ensureInit();
    return _extractor!.getCategories();
  }

  @override
  Future<LiveSearchRoomResult> searchRooms(String keyword,
      {int page = 1}) async {
    await _ensureInit();
    return _extractor!.searchRooms(keyword: keyword, page: page);
  }

  @override
  Future<LiveSearchAnchorResult> searchAnchors(String keyword,
      {int page = 1}) async {
    await _ensureInit();
    return _extractor!.searchAnchors(keyword: keyword, page: page);
  }

  @override
  Future<LiveCategoryResult> getCategoryRooms(LiveSubCategory category,
      {int page = 1}) async {
    await _ensureInit();
    return _extractor!.getCategoryRooms(category: category, page: page);
  }

  @override
  Future<LiveCategoryResult> getRecommendRooms({int page = 1}) async {
    await _ensureInit();
    return _extractor!.getRecommendRooms(page: page);
  }

  @override
  Future<LiveRoomDetail> getRoomDetail({required String roomId}) async {
    await _ensureInit();
    return _extractor!.getRoomDetail(roomId: roomId);
  }

  @override
  Future<List<LivePlayQuality>> getPlayQualities({
    required LiveRoomDetail detail,
  }) async {
    await _ensureInit();
    return _extractor!.getPlayQualities(detail: detail);
  }

  @override
  Future<LivePlayUrl> getPlayUrls({
    required LiveRoomDetail detail,
    required LivePlayQuality quality,
  }) async {
    await _ensureInit();
    return _extractor!.getPlayUrls(detail: detail, quality: quality);
  }

  @override
  Future<bool> getLiveStatus({required String roomId}) async {
    await _ensureInit();
    return _extractor!.getLiveStatus(roomId: roomId);
  }

  @override
  Future<List<LiveSuperChatMessage>> getSuperChatMessages({
    required String roomId,
  }) async {
    await _ensureInit();
    return _extractor!.getSuperChatMessages(roomId: roomId);
  }
}
