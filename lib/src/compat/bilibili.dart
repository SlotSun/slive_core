import 'dart:convert';

import '../rust/api/extractor.dart' as frb;
import '../rust/api/danmaku.dart' as frb_dan;
import 'compat.dart';

// =============================================================================
// Bilibili danmaku args
// =============================================================================

class BiliBiliDanmakuArgs {
  final int roomId;
  final String token;
  final String buvid;
  final String serverHost;
  final int uid;
  final String cookie;

  BiliBiliDanmakuArgs({
    required this.roomId,
    required this.token,
    required this.buvid,
    required this.serverHost,
    required this.uid,
    required this.cookie,
  });

  factory BiliBiliDanmakuArgs.fromJson(Map<String, dynamic> json) =>
      BiliBiliDanmakuArgs(
        roomId: json['roomId'] ?? 0,
        token: json['token'] ?? '',
        buvid: json['buvid'] ?? '',
        serverHost: json['serverHost'] ?? '',
        uid: json['uid'] ?? 0,
        cookie: json['cookie'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'roomId': roomId,
        'token': token,
        'buvid': buvid,
        'serverHost': serverHost,
        'uid': uid,
        'cookie': cookie,
      };

  @override
  String toString() => jsonEncode(toJson());
}

// =============================================================================
// BiliBiliSite
// =============================================================================

class BiliBiliSite extends LiveSite {
  frb.SliveBilibiliExtractor? _extractor;
  frb_dan.SliveBilibiliDanmakuProvider? _danmakuProvider;

  String cookie = "";
  int userId = 0;
  bool cookieSet = false;

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await ensureFrbInit();
      _extractor = await frb.SliveBilibiliExtractor.newInstance();
      _danmakuProvider =
          await frb_dan.SliveBilibiliDanmakuProvider.newInstance();
    }
    // make cookie was set
    if (cookieSet == false && _extractor != null) {
      _extractor!.setCookies(cookies: cookie);
      cookieSet = true;
    }
  }

  @override
  LiveDanmaku getDanmaku() => LiveDanmaku((args) async {
        await _ensureInit();
        String roomId;
        String? cookies;
        if (args is BiliBiliDanmakuArgs) {
          roomId = args.roomId.toString();
          cookies = args.cookie.isNotEmpty ? args.cookie : null;
        } else {
          roomId = args?.toString() ?? '';
          cookies = cookie.isNotEmpty ? cookie : null;
        }
        final conn = await _danmakuProvider!.connect(
          roomId: roomId,
          cookies: cookies,
        );
        return _BilibiliDanmakuInner(_danmakuProvider!, conn);
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
    var res = await _extractor!.getCategoryRooms(category: category, page: page);
    return res;
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
        final hosts = (map['host_list'] as List?) ?? [];
        final serverHost = hosts.isNotEmpty
            ? (hosts.first['host'] as String? ?? '')
            : 'broadcastlv.chat.bilibili.com';
        final buvid3 = cookie.split(';').firstWhere(
              (p) => p.trim().startsWith('buvid3='),
              orElse: () => '',
            ).replaceFirst('buvid3=', '').trim();
        final danmakuArgs = BiliBiliDanmakuArgs(
          roomId: map['room_id'] ?? 0,
          token: map['token'] ?? '',
          serverHost: serverHost,
          buvid: buvid3,
          uid: userId,
          cookie: cookie,
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
// _BilibiliDanmakuInner
// =============================================================================

class _BilibiliDanmakuInner extends DanmakuInnerBase {
  _BilibiliDanmakuInner(frb_dan.SliveBilibiliDanmakuProvider provider,
      frb_dan.SliveDanmuConnection conn)
      : super(
          (c) => provider.disconnect(connection: c),
          (c) => provider.receive(connection: c),
          conn,
        );
}
