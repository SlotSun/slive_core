import '../rust/api/extractor.dart' as frb;
import '../rust/api/danmaku.dart' as frb_dan;
import 'compat.dart';

// =============================================================================
// DouyuSite
// =============================================================================

class DouyuSite extends LiveSite {
  frb.SliveDouyuExtractor? _extractor;
  frb_dan.SliveDouyuDanmakuProvider? _danmakuProvider;

  DouyuSite();

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await ensureFrbInit();
      _extractor = await frb.SliveDouyuExtractor.newInstance();
      _danmakuProvider =
          await frb_dan.SliveDouyuDanmakuProvider.newInstance();
    }
  }

  @override
  LiveDanmaku getDanmaku() => LiveDanmaku((args) async {
        await _ensureInit();
        final roomId = args?.toString() ?? '';
        CoreLog.d('[Douyu] connecting to room $roomId ...');
        final conn = await _danmakuProvider!.connect(roomId: roomId);
        CoreLog.d('[Douyu] connected, roomId=${await conn.roomId()}');
        return _DouyuDanmakuInner(_danmakuProvider!, conn);
      });

  @override
  Future<List<LiveCategory>> getCategores() async {
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
    final detail = LiveRoomDetail.fromBridge(
        await _extractor!.getRoomDetail(roomId: roomId));
    return LiveRoomDetail(
      roomId: detail.roomId,
      title: detail.title,
      cover: detail.cover,
      userName: detail.userName,
      userAvatar: detail.userAvatar,
      online: detail.online,
      introduction: detail.introduction,
      notice: detail.notice,
      status: detail.status,
      data: detail.data,
      danmakuData: detail.roomId,
      url: detail.url,
      isRecord: detail.isRecord,
    );
  }

  @override
  Future<List<LivePlayQuality>> getPlayQualites(
      {required LiveRoomDetail detail}) async {
    await _ensureInit();
    return _extractor!.getPlayQualities(detail: detail.toBridge());
  }

  @override
  Future<LivePlayUrl> getPlayUrls({
    required LiveRoomDetail detail,
    required LivePlayQuality quality,
  }) async {
    await _ensureInit();
    return LivePlayUrl.fromBridge(
        await _extractor!.getPlayUrls(
            detail: detail.toBridge(), quality: quality));
  }

  @override
  Future<bool> getLiveStatus({required String roomId}) async {
    await _ensureInit();
    return _extractor!.getLiveStatus(roomId: roomId);
  }

  @override
  Future<List<LiveSuperChatMessage>> getSuperChatMessage(
      {required String roomId}) async {
    await _ensureInit();
    return (await _extractor!.getSuperChatMessages(roomId: roomId))
        .map(LiveSuperChatMessage.fromBridge)
        .toList();
  }
}

// =============================================================================
// _DouyuDanmakuInner
// =============================================================================

class _DouyuDanmakuInner extends DanmakuInnerBase {
  _DouyuDanmakuInner(
      frb_dan.SliveDouyuDanmakuProvider provider, frb_dan.SliveDanmuConnection conn)
      : super(
          (c) => provider.disconnect(connection: c),
          (c) => provider.receive(connection: c),
          conn,
        );
}
