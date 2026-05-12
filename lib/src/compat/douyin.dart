import 'dart:convert';

import '../rust/api/extractor.dart' as frb;
import '../rust/api/danmaku.dart' as frb_dan;
import 'compat.dart';

// =============================================================================
// DouyinDanmakuArgs
// =============================================================================

class DouyinDanmakuArgs {
  final String webRid;
  final String roomId;
  final String userId;
  final String cookie;

  DouyinDanmakuArgs({
    required this.webRid,
    required this.roomId,
    required this.userId,
    required this.cookie,
  });

  factory DouyinDanmakuArgs.fromJson(Map<String, dynamic> json) =>
      DouyinDanmakuArgs(
        webRid: json['webRid'] ?? '',
        roomId: json['roomId'] ?? '',
        userId: json['userId'] ?? '',
        cookie: json['cookie'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'webRid': webRid,
        'roomId': roomId,
        'userId': userId,
        'cookie': cookie,
      };

  @override
  String toString() => jsonEncode(toJson());
}

// =============================================================================
// DouyinSite
// =============================================================================

class DouyinSite extends LiveSite {
  frb.SliveDouyinExtractor? _extractor;
  frb_dan.SliveDouyinDanmakuProvider? _danmakuProvider;

  bool hlsFirst = false;
  Map<String, String> headers = {};

  DouyinSite();

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await ensureFrbInit();
      _extractor = await frb.SliveDouyinExtractor.newInstance();
      _danmakuProvider =
          await frb_dan.SliveDouyinDanmakuProvider.newInstance();
    }
  }

  Future<Map<String, dynamic>> getUserInfoByCookie(String cookie) async {
    await _ensureInit();
    return {};
  }

  @override
  LiveDanmaku getDanmaku() => LiveDanmaku((args) async {
        await _ensureInit();
        String roomId;
        String? cookies;
        if (args is DouyinDanmakuArgs) {
          roomId = args.roomId;
          cookies = args.cookie.isNotEmpty ? args.cookie : null;
        } else {
          roomId = args?.toString() ?? '';
        }
        final conn = await _danmakuProvider!.connect(
          roomId: roomId,
          cookies: cookies,
        );
        return _DouyinDanmakuInner(_danmakuProvider!, conn);
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
    final raw = detail.danmakuData;
    if (raw is String && raw.isNotEmpty) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final danmakuArgs = DouyinDanmakuArgs(
          webRid: map['web_rid'] ?? '',
          roomId: map['room_id'] ?? '',
          userId: '',
          cookie: '',
        );
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
          danmakuData: danmakuArgs,
          url: detail.url,
          isRecord: detail.isRecord,
        );
      } catch (_) {
        // Leave danmakuData as-is on parse failure.
      }
    }
    return detail;
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
// _DouyinDanmakuInner
// =============================================================================

class _DouyinDanmakuInner extends DanmakuInnerBase {
  _DouyinDanmakuInner(
      frb_dan.SliveDouyinDanmakuProvider provider, frb_dan.SliveDanmuConnection conn)
      : super(
          (c) => provider.disconnect(connection: c),
          (c) => provider.receive(connection: c),
          conn,
        );
}
