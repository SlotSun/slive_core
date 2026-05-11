import 'slive_danmaku.dart';
import 'rust/api/extractor.dart' as frb;
import 'rust/api/danmaku.dart' as frb_danmaku;
import 'rust/api/types.dart';

/// Unified site interface matching the original `LiveSite` pattern.
///
/// Each platform provides a concrete implementation that delegates to the
/// frb-generated extractor. Use [SliveFactory.create] to instantiate.
abstract class SliveSite {
  String get id;
  String get name;

  void setCookies(String cookies);
  SliveDanmaku getDanmaku();

  Future<List<SliveCategory>> getCategories();
  Future<SliveSearchRoomResult> searchRooms(String keyword, {int page = 1});
  Future<SliveSearchAnchorResult> searchAnchors(String keyword, {int page = 1});
  Future<SliveCategoryResult> getCategoryRooms(
    SliveSubCategory category, {
    int page = 1,
  });
  Future<SliveCategoryResult> getRecommendRooms({int page = 1});
  Future<SliveRoomDetail> getRoomDetail({required String roomId});
  Future<List<SlivePlayQuality>> getPlayQualities({
    required SliveRoomDetail detail,
  });
  Future<SlivePlayUrl> getPlayUrls({
    required SliveRoomDetail detail,
    required SlivePlayQuality quality,
  });
  Future<bool> getLiveStatus({required String roomId});
  Future<List<SliveSuperChatMessage>> getSuperChatMessages({
    required String roomId,
  });
}

// ---------------------------------------------------------------------------
// Bilibili
// ---------------------------------------------------------------------------

class SliveBilibiliSite implements SliveSite {
  final frb.SliveBilibiliExtractor _extractor;
  final frb_danmaku.SliveBilibiliDanmakuProvider _danmakuProvider;

  SliveBilibiliSite(this._extractor, this._danmakuProvider);

  static Future<SliveBilibiliSite> create() async {
    final extractor = await frb.SliveBilibiliExtractor.newInstance();
    final danmaku = await frb_danmaku.SliveBilibiliDanmakuProvider.newInstance();
    return SliveBilibiliSite(extractor, danmaku);
  }

  @override
  String get id => 'bilibili';
  @override
  String get name => '哔哩哔哩直播';
  @override
  void setCookies(String cookies) => _extractor.setCookies(cookies: cookies);
  @override
  SliveDanmaku getDanmaku() => SliveBilibiliDanmaku(_danmakuProvider);
  @override
  Future<List<SliveCategory>> getCategories() => _extractor.getCategories();
  @override
  Future<SliveSearchRoomResult> searchRooms(String keyword, {int page = 1}) =>
      _extractor.searchRooms(keyword: keyword, page: page);
  @override
  Future<SliveSearchAnchorResult> searchAnchors(
    String keyword, {
    int page = 1,
  }) =>
      _extractor.searchAnchors(keyword: keyword, page: page);
  @override
  Future<SliveCategoryResult> getCategoryRooms(
    SliveSubCategory category, {
    int page = 1,
  }) =>
      _extractor.getCategoryRooms(category: category, page: page);
  @override
  Future<SliveCategoryResult> getRecommendRooms({int page = 1}) =>
      _extractor.getRecommendRooms(page: page);
  @override
  Future<SliveRoomDetail> getRoomDetail({required String roomId}) =>
      _extractor.getRoomDetail(roomId: roomId);
  @override
  Future<List<SlivePlayQuality>> getPlayQualities({
    required SliveRoomDetail detail,
  }) =>
      _extractor.getPlayQualities(detail: detail);
  @override
  Future<SlivePlayUrl> getPlayUrls({
    required SliveRoomDetail detail,
    required SlivePlayQuality quality,
  }) =>
      _extractor.getPlayUrls(detail: detail, quality: quality);
  @override
  Future<bool> getLiveStatus({required String roomId}) =>
      _extractor.getLiveStatus(roomId: roomId);
  @override
  Future<List<SliveSuperChatMessage>> getSuperChatMessages({
    required String roomId,
  }) =>
      _extractor.getSuperChatMessages(roomId: roomId);
}

// ---------------------------------------------------------------------------
// Douyin
// ---------------------------------------------------------------------------

class SliveDouyinSite implements SliveSite {
  final frb.SliveDouyinExtractor _extractor;
  final frb_danmaku.SliveDouyinDanmakuProvider _danmakuProvider;

  SliveDouyinSite(this._extractor, this._danmakuProvider);

  static Future<SliveDouyinSite> create() async {
    final extractor = await frb.SliveDouyinExtractor.newInstance();
    final danmaku = await frb_danmaku.SliveDouyinDanmakuProvider.newInstance();
    return SliveDouyinSite(extractor, danmaku);
  }

  @override
  String get id => 'douyin';
  @override
  String get name => '抖音直播';
  @override
  void setCookies(String cookies) => _extractor.setCookies(cookies: cookies);
  @override
  SliveDanmaku getDanmaku() => SliveDouyinDanmaku(_danmakuProvider);
  @override
  Future<List<SliveCategory>> getCategories() => _extractor.getCategories();
  @override
  Future<SliveSearchRoomResult> searchRooms(String keyword, {int page = 1}) =>
      _extractor.searchRooms(keyword: keyword, page: page);
  @override
  Future<SliveSearchAnchorResult> searchAnchors(
    String keyword, {
    int page = 1,
  }) =>
      _extractor.searchAnchors(keyword: keyword, page: page);
  @override
  Future<SliveCategoryResult> getCategoryRooms(
    SliveSubCategory category, {
    int page = 1,
  }) =>
      _extractor.getCategoryRooms(category: category, page: page);
  @override
  Future<SliveCategoryResult> getRecommendRooms({int page = 1}) =>
      _extractor.getRecommendRooms(page: page);
  @override
  Future<SliveRoomDetail> getRoomDetail({required String roomId}) =>
      _extractor.getRoomDetail(roomId: roomId);
  @override
  Future<List<SlivePlayQuality>> getPlayQualities({
    required SliveRoomDetail detail,
  }) =>
      _extractor.getPlayQualities(detail: detail);
  @override
  Future<SlivePlayUrl> getPlayUrls({
    required SliveRoomDetail detail,
    required SlivePlayQuality quality,
  }) =>
      _extractor.getPlayUrls(detail: detail, quality: quality);
  @override
  Future<bool> getLiveStatus({required String roomId}) =>
      _extractor.getLiveStatus(roomId: roomId);
  @override
  Future<List<SliveSuperChatMessage>> getSuperChatMessages({
    required String roomId,
  }) =>
      _extractor.getSuperChatMessages(roomId: roomId);
}

// ---------------------------------------------------------------------------
// Douyu
// ---------------------------------------------------------------------------

class SliveDouyuSite implements SliveSite {
  final frb.SliveDouyuExtractor _extractor;
  final frb_danmaku.SliveDouyuDanmakuProvider _danmakuProvider;

  SliveDouyuSite(this._extractor, this._danmakuProvider);

  static Future<SliveDouyuSite> create() async {
    final extractor = await frb.SliveDouyuExtractor.newInstance();
    final danmaku = await frb_danmaku.SliveDouyuDanmakuProvider.newInstance();
    return SliveDouyuSite(extractor, danmaku);
  }

  @override
  String get id => 'douyu';
  @override
  String get name => '斗鱼直播';
  @override
  void setCookies(String cookies) {}
  @override
  SliveDanmaku getDanmaku() => SliveDouyuDanmaku(_danmakuProvider);
  @override
  Future<List<SliveCategory>> getCategories() => _extractor.getCategories();
  @override
  Future<SliveSearchRoomResult> searchRooms(String keyword, {int page = 1}) =>
      _extractor.searchRooms(keyword: keyword, page: page);
  @override
  Future<SliveSearchAnchorResult> searchAnchors(
    String keyword, {
    int page = 1,
  }) =>
      _extractor.searchAnchors(keyword: keyword, page: page);
  @override
  Future<SliveCategoryResult> getCategoryRooms(
    SliveSubCategory category, {
    int page = 1,
  }) =>
      _extractor.getCategoryRooms(category: category, page: page);
  @override
  Future<SliveCategoryResult> getRecommendRooms({int page = 1}) =>
      _extractor.getRecommendRooms(page: page);
  @override
  Future<SliveRoomDetail> getRoomDetail({required String roomId}) =>
      _extractor.getRoomDetail(roomId: roomId);
  @override
  Future<List<SlivePlayQuality>> getPlayQualities({
    required SliveRoomDetail detail,
  }) =>
      _extractor.getPlayQualities(detail: detail);
  @override
  Future<SlivePlayUrl> getPlayUrls({
    required SliveRoomDetail detail,
    required SlivePlayQuality quality,
  }) =>
      _extractor.getPlayUrls(detail: detail, quality: quality);
  @override
  Future<bool> getLiveStatus({required String roomId}) =>
      _extractor.getLiveStatus(roomId: roomId);
  @override
  Future<List<SliveSuperChatMessage>> getSuperChatMessages({
    required String roomId,
  }) =>
      _extractor.getSuperChatMessages(roomId: roomId);
}

// ---------------------------------------------------------------------------
// Huya
// ---------------------------------------------------------------------------

class SliveHuyaSite implements SliveSite {
  final frb.SliveHuyaExtractor _extractor;
  final frb_danmaku.SliveHuyaDanmakuProvider _danmakuProvider;

  SliveHuyaSite(this._extractor, this._danmakuProvider);

  static Future<SliveHuyaSite> create() async {
    final extractor = await frb.SliveHuyaExtractor.newInstance();
    final danmaku = await frb_danmaku.SliveHuyaDanmakuProvider.newInstance();
    return SliveHuyaSite(extractor, danmaku);
  }

  @override
  String get id => 'huya';
  @override
  String get name => '虎牙直播';
  @override
  void setCookies(String cookies) {}
  @override
  SliveDanmaku getDanmaku() => SliveHuyaDanmaku(_danmakuProvider);
  @override
  Future<List<SliveCategory>> getCategories() => _extractor.getCategories();
  @override
  Future<SliveSearchRoomResult> searchRooms(String keyword, {int page = 1}) =>
      _extractor.searchRooms(keyword: keyword, page: page);
  @override
  Future<SliveSearchAnchorResult> searchAnchors(
    String keyword, {
    int page = 1,
  }) =>
      _extractor.searchAnchors(keyword: keyword, page: page);
  @override
  Future<SliveCategoryResult> getCategoryRooms(
    SliveSubCategory category, {
    int page = 1,
  }) =>
      _extractor.getCategoryRooms(category: category, page: page);
  @override
  Future<SliveCategoryResult> getRecommendRooms({int page = 1}) =>
      _extractor.getRecommendRooms(page: page);
  @override
  Future<SliveRoomDetail> getRoomDetail({required String roomId}) =>
      _extractor.getRoomDetail(roomId: roomId);
  @override
  Future<List<SlivePlayQuality>> getPlayQualities({
    required SliveRoomDetail detail,
  }) =>
      _extractor.getPlayQualities(detail: detail);
  @override
  Future<SlivePlayUrl> getPlayUrls({
    required SliveRoomDetail detail,
    required SlivePlayQuality quality,
  }) =>
      _extractor.getPlayUrls(detail: detail, quality: quality);
  @override
  Future<bool> getLiveStatus({required String roomId}) =>
      _extractor.getLiveStatus(roomId: roomId);
  @override
  Future<List<SliveSuperChatMessage>> getSuperChatMessages({
    required String roomId,
  }) =>
      _extractor.getSuperChatMessages(roomId: roomId);
}

// ---------------------------------------------------------------------------
// Twitch
// ---------------------------------------------------------------------------

class SliveTwitchSite implements SliveSite {
  final frb.SliveTwitchExtractor _extractor;
  final frb_danmaku.SliveTwitchDanmakuProvider _danmakuProvider;

  SliveTwitchSite(this._extractor, this._danmakuProvider);

  static Future<SliveTwitchSite> create() async {
    final extractor = await frb.SliveTwitchExtractor.newInstance();
    final danmaku = await frb_danmaku.SliveTwitchDanmakuProvider.newInstance();
    return SliveTwitchSite(extractor, danmaku);
  }

  @override
  String get id => 'twitch';
  @override
  String get name => 'Twitch';
  @override
  void setCookies(String cookies) {}
  @override
  SliveDanmaku getDanmaku() => SliveTwitchDanmaku(_danmakuProvider);
  @override
  Future<List<SliveCategory>> getCategories() => _extractor.getCategories();
  @override
  Future<SliveSearchRoomResult> searchRooms(String keyword, {int page = 1}) =>
      _extractor.searchRooms(keyword: keyword, page: page);
  @override
  Future<SliveSearchAnchorResult> searchAnchors(
    String keyword, {
    int page = 1,
  }) =>
      _extractor.searchAnchors(keyword: keyword, page: page);
  @override
  Future<SliveCategoryResult> getCategoryRooms(
    SliveSubCategory category, {
    int page = 1,
  }) =>
      _extractor.getCategoryRooms(category: category, page: page);
  @override
  Future<SliveCategoryResult> getRecommendRooms({int page = 1}) =>
      _extractor.getRecommendRooms(page: page);
  @override
  Future<SliveRoomDetail> getRoomDetail({required String roomId}) =>
      _extractor.getRoomDetail(roomId: roomId);
  @override
  Future<List<SlivePlayQuality>> getPlayQualities({
    required SliveRoomDetail detail,
  }) =>
      _extractor.getPlayQualities(detail: detail);
  @override
  Future<SlivePlayUrl> getPlayUrls({
    required SliveRoomDetail detail,
    required SlivePlayQuality quality,
  }) =>
      _extractor.getPlayUrls(detail: detail, quality: quality);
  @override
  Future<bool> getLiveStatus({required String roomId}) =>
      _extractor.getLiveStatus(roomId: roomId);
  @override
  Future<List<SliveSuperChatMessage>> getSuperChatMessages({
    required String roomId,
  }) =>
      _extractor.getSuperChatMessages(roomId: roomId);
}
