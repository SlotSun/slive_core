import 'package:slive_core/src/rust/api/danmaku.dart' as frb_danmaku;
import 'package:slive_core/src/rust/api/extractor.dart' as frb;
import 'package:slive_core/src/rust/api/types.dart';
import 'package:slive_core/src/slive_danmaku.dart';
import 'package:slive_core/src/slive_site.dart';
import 'package:slive_core/src/platforms/platform_common.dart';

class HuyaSite implements LiveSite {
  frb.LiveHuyaExtractor? _extractor;
  frb_danmaku.LiveHuyaDanmakuProvider? _danmakuProvider;

  HuyaSite();

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await ensureFrbInit();
      _extractor = await frb.LiveHuyaExtractor.newInstance();
      _danmakuProvider =
          await frb_danmaku.LiveHuyaDanmakuProvider.newInstance();
    }
  }

  @override
  String get id => 'huya';
  @override
  String get name => '虎牙直播';
  @override
  void setCookies(String cookies) {}

  /// 设置虎牙自定义 User-Agent（如 HYSDK_UA）
  Future<void> setSdkUa(String ua) async {
    await _ensureInit();
    return _extractor!.setSdkUa(ua: ua);
  }
  @override
  LiveHuyaDanmaku getDanmaku()=>LiveHuyaDanmaku(_danmakuProvider!);
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
