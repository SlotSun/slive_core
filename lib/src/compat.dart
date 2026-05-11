// Compatibility layer: exports types matching the original simple_live_core API.
//
// Types that are structurally identical use typedefs.
// Types that differ (LiveMessage, LiveSuperChatMessage, LiveRoomDetail, LiveSite, LiveDanmaku)
// have wrapper classes.

import 'dart:convert';

import 'rust/api/extractor.dart' as frb;
import 'rust/api/danmaku.dart' as frb_dan;
import 'rust/api/types.dart' as bridge;
import 'rust/frb_generated.dart' show RustLib;
import 'common/corelog.dart';

export 'common/corelog.dart' show CoreLog, RequestLogType;

// =============================================================================
// Helpers
// =============================================================================

Map<String, String>? _entriesToMap(List<bridge.SliveMapEntry>? entries) {
  if (entries == null || entries.isEmpty) return null;
  return {for (final e in entries) e.key: e.value};
}

List<bridge.SliveMapEntry> _mapToEntries(Map<String, String>? map) {
  if (map == null) return [];
  return map.entries
      .map((e) => bridge.SliveMapEntry(key: e.key, value: e.value))
      .toList();
}

// =============================================================================
// frb initialization guard
// =============================================================================

bool _frbInitialized = false;

Future<void> _ensureFrbInit() async {
  if (_frbInitialized) return;
  await RustLib.init();
  _frbInitialized = true;
}

// =============================================================================
// Typedefs — types with identical field names and shapes
// =============================================================================

typedef LiveCategory = bridge.SliveCategory;
typedef LiveSubCategory = bridge.SliveSubCategory;
typedef LiveRoomItem = bridge.SliveRoomItem;
typedef LiveAnchorItem = bridge.SliveAnchorItem;
typedef LiveCategoryResult = bridge.SliveCategoryResult;
typedef LiveSearchRoomResult = bridge.SliveSearchRoomResult;
typedef LiveSearchAnchorResult = bridge.SliveSearchAnchorResult;
typedef LivePlayQuality = bridge.SlivePlayQuality;
typedef LiveMessageType = bridge.SliveMessageType;

// =============================================================================
// LivePlayUrl — wraps bridge type to convert headers from List<SliveMapEntry>
// to Map<String, String>
// =============================================================================

class LivePlayUrl {
  final List<String> urls;
  final Map<String, String>? headers;

  LivePlayUrl({required this.urls, this.headers});

  factory LivePlayUrl.fromBridge(bridge.SlivePlayUrl u) => LivePlayUrl(
        urls: u.urls,
        headers: _entriesToMap(u.headers),
      );

  bridge.SlivePlayUrl toBridge() => bridge.SlivePlayUrl(
        urls: urls,
        headers: _mapToEntries(headers),
      );
}

// =============================================================================
// LiveMessageColor
// =============================================================================

class LiveMessageColor {
  final int r, g, b;
  LiveMessageColor(this.r, this.g, this.b);
  static LiveMessageColor get white => LiveMessageColor(255, 255, 255);

  factory LiveMessageColor.fromBridge(bridge.SliveMessageColor c) =>
      LiveMessageColor(c.r, c.g, c.b);

  bridge.SliveMessageColor toBridge() =>
      bridge.SliveMessageColor(r: r, g: g, b: b);
}

// =============================================================================
// LiveMessage
// =============================================================================

class LiveMessage {
  final LiveMessageType type;
  final String userName;
  final String message;
  final dynamic data;
  final LiveMessageColor color;

  LiveMessage({
    required this.type,
    required this.userName,
    required this.message,
    this.data,
    required this.color,
  });

  factory LiveMessage.fromBridge(bridge.SliveMessage m) => LiveMessage(
        type: m.messageType,
        userName: m.userName,
        message: m.message,
        data: m.data,
        color: LiveMessageColor.fromBridge(m.color),
      );
}

// =============================================================================
// LiveSuperChatMessage
// =============================================================================

class LiveSuperChatMessage {
  final String userName;
  final String face;
  final String message;
  final int price;
  final DateTime startTime;
  final DateTime endTime;
  final String backgroundColor;
  final String backgroundBottomColor;

  LiveSuperChatMessage({
    required this.userName,
    required this.face,
    required this.message,
    required this.price,
    required this.startTime,
    required this.endTime,
    required this.backgroundColor,
    required this.backgroundBottomColor,
  });

  factory LiveSuperChatMessage.fromBridge(bridge.SliveSuperChatMessage m) =>
      LiveSuperChatMessage(
        userName: m.userName,
        face: m.face,
        message: m.message,
        price: m.price,
        startTime: DateTime.fromMillisecondsSinceEpoch(m.startTime.toInt()),
        endTime: DateTime.fromMillisecondsSinceEpoch(m.endTime.toInt()),
        backgroundColor: m.backgroundColor,
        backgroundBottomColor: m.backgroundBottomColor,
      );
}

// =============================================================================
// LiveRoomDetail — adds platform for round-trip, danmakuData as dynamic
// =============================================================================

class LiveRoomDetail {
  final String roomId;
  final String title;
  final String cover;
  final String userName;
  final String userAvatar;
  final int online;
  final String? introduction;
  final String? notice;
  final bool status;
  final dynamic data;
  final dynamic danmakuData;
  final String url;
  final bool isRecord;

  LiveRoomDetail({
    required this.roomId,
    required this.title,
    required this.cover,
    required this.userName,
    required this.userAvatar,
    required this.online,
    this.introduction,
    this.notice,
    required this.status,
    this.data,
    this.danmakuData,
    required this.url,
    this.isRecord = false,
  });

  factory LiveRoomDetail.fromBridge(bridge.SliveRoomDetail d) =>
      LiveRoomDetail(
        roomId: d.roomId,
        title: d.title,
        cover: d.cover,
        userName: d.userName,
        userAvatar: d.userAvatar,
        online: d.online.toInt(),
        introduction: d.introduction,
        notice: d.notice,
        status: d.status,
        data: d.data,
        danmakuData: d.danmakuData,
        url: d.url,
        isRecord: d.isRecord,
      );

  /// Convert back to bridge type for passing to extractor methods.
  bridge.SliveRoomDetail toBridge() => bridge.SliveRoomDetail(
        roomId: roomId,
        title: title,
        cover: cover,
        userName: userName,
        userAvatar: userAvatar,
        online: online,
        introduction: introduction,
        notice: notice,
        status: status,
        data: data?.toString(),
        danmakuData: danmakuData?.toString(),
        url: url,
        isRecord: isRecord,
      );
}

// =============================================================================
// DanmakuArgs — platform-specific args passed to LiveDanmaku.start()
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

class HuyaDanmakuArgs {
  final int ayyuid;
  final int topSid;
  final int subSid;

  HuyaDanmakuArgs({
    required this.ayyuid,
    required this.topSid,
    required this.subSid,
  });

  factory HuyaDanmakuArgs.fromJson(Map<String, dynamic> json) =>
      HuyaDanmakuArgs(
        ayyuid: json['ayyuid'] ?? 0,
        topSid: json['top_sid'] ?? 0,
        subSid: json['sub_sid'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'ayyuid': ayyuid,
        'top_sid': topSid,
        'sub_sid': subSid,
      };

  @override
  String toString() => jsonEncode(toJson());
}

// =============================================================================
// LiveDanmaku — wraps SliveDanmaku with callback-based API
// =============================================================================

class LiveDanmaku {
  void Function(LiveMessage msg)? onMessage;
  void Function(String msg)? onClose;
  void Function()? onReady;

  final Future<_DanmakuInner> Function(dynamic args) _initDanmaku;
  _DanmakuInner? _inner;

  LiveDanmaku(this._initDanmaku);

  void _attach(_DanmakuInner inner) {
    _inner = inner;
    inner.onMessage = (msg) => onMessage?.call(LiveMessage.fromBridge(msg));
    inner.onSuperChat = (sc) {
      onMessage?.call(LiveMessage(
        type: LiveMessageType.superChat,
        userName: sc.userName,
        message: sc.message,
        data: LiveSuperChatMessage.fromBridge(sc),
        color: LiveMessageColor.white,
      ));
    };
    inner.onControl = (event) {
      if (event.kind == 'stream_closed') {
        onClose?.call(event.message ?? 'stream closed');
      }
    };
    inner.onClose = (msg) => onClose?.call(msg);
    inner.onReady = () => onReady?.call();
  }

  /// Start danmaku connection.
  /// [args] is the roomId (String) or a platform-specific DanmakuArgs object.
  Future<void> start(dynamic args) async {
    final inner = await _initDanmaku(args);
    _attach(inner);
    await inner.start(args?.toString() ?? '');
  }

  Future<void> stop() async {
    await _inner?.stop();
    _inner = null;
  }
}

// =============================================================================
// LiveSite — abstract base matching original API
// =============================================================================

abstract class LiveSite {
  Future<List<LiveCategory>> getCategores();
  Future<LiveSearchRoomResult> searchRooms(String keyword, {int page = 1});
  Future<LiveSearchAnchorResult> searchAnchors(String keyword, {int page = 1});
  Future<LiveCategoryResult> getCategoryRooms(LiveSubCategory category,
      {int page = 1});
  Future<LiveCategoryResult> getRecommendRooms({int page = 1});
  Future<LiveRoomDetail> getRoomDetail({required String roomId});
  Future<List<LivePlayQuality>> getPlayQualites(
      {required LiveRoomDetail detail});
  Future<LivePlayUrl> getPlayUrls({
    required LiveRoomDetail detail,
    required LivePlayQuality quality,
  });
  Future<bool> getLiveStatus({required String roomId});
  Future<List<LiveSuperChatMessage>> getSuperChatMessage(
      {required String roomId});
  LiveDanmaku getDanmaku();
}

// =============================================================================
// Platform site implementations
// =============================================================================
//
// Each site wraps the frb-generated extractor + danmaku provider directly.
// The extractor handles all data-fetching methods; the provider is captured
// in the factory closure passed to LiveDanmaku so it can connect on start().

// --- Bilibili ---

class BiliBiliSite extends LiveSite {
  frb.SliveBilibiliExtractor? _extractor;
  frb_dan.SliveBilibiliDanmakuProvider? _danmakuProvider;

  String cookie = "";
  int userId = 0;

  BiliBiliSite();

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await _ensureFrbInit();
      _extractor = await frb.SliveBilibiliExtractor.newInstance();
      _danmakuProvider =
          await frb_dan.SliveBilibiliDanmakuProvider.newInstance();
    }
  }

  @override
  LiveDanmaku getDanmaku() => LiveDanmaku((args) async {
        await _ensureInit();
        // args is BiliBiliDanmakuArgs (constructed in getRoomDetail)
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
    // Parse danmakuData JSON into BiliBiliDanmakuArgs,
    // matching simple_live_core's BiliBiliSite.getRoomDetail construction.
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

// --- Douyu ---

class DouyuSite extends LiveSite {
  frb.SliveDouyuExtractor? _extractor;
  frb_dan.SliveDouyuDanmakuProvider? _danmakuProvider;

  DouyuSite();

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await _ensureFrbInit();
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
    // Douyu only needs roomId for danmaku connection.
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

// --- Huya ---

class HuyaSite extends LiveSite {
  frb.SliveHuyaExtractor? _extractor;
  frb_dan.SliveHuyaDanmakuProvider? _danmakuProvider;

  static String HYSDK_UA = "";

  /// Stored from the last getRoomDetail() call — contains ayyuid/top_sid/sub_sid.
  HuyaDanmakuArgs? _lastDanmakuArgs;

  HuyaSite();

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await _ensureFrbInit();
      _extractor = await frb.SliveHuyaExtractor.newInstance();
      _danmakuProvider =
          await frb_dan.SliveHuyaDanmakuProvider.newInstance();
      if (HYSDK_UA.isNotEmpty) {
        await _extractor!.setSdkUa(ua: HYSDK_UA);
      }
    }
  }

  @override
  LiveDanmaku getDanmaku() => LiveDanmaku((args) async {
        await _ensureInit();
        String roomId;
        HuyaDanmakuArgs? huyaArgs;
        if (args is HuyaDanmakuArgs) {
          roomId = ''; // Huya uses ayyuid/topSid/subSid, not roomId
          huyaArgs = args;
        } else {
          roomId = args?.toString() ?? '';
          huyaArgs = _lastDanmakuArgs;
        }
        final frb_dan.SliveDanmuConnection conn;
        if (huyaArgs != null) {
          conn = await _danmakuProvider!.connectWithExtras(
            roomId: roomId,
            ayyuid: huyaArgs.ayyuid,
            topSid: huyaArgs.topSid,
            subSid: huyaArgs.subSid,
          );
        } else {
          conn = await _danmakuProvider!.connect(roomId: roomId);
        }
        return _HuyaDanmakuInner(_danmakuProvider!, conn);
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
    // Parse danmakuData for Huya-specific connection params (ayyuid/top_sid/sub_sid).
    final raw = detail.danmakuData;
    if (raw is String && raw.isNotEmpty) {
      try {
        _lastDanmakuArgs =
            HuyaDanmakuArgs.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        // Leave _lastDanmakuArgs as null — connect() will fall back.
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

// --- Douyin ---

class DouyinSite extends LiveSite {
  frb.SliveDouyinExtractor? _extractor;
  frb_dan.SliveDouyinDanmakuProvider? _danmakuProvider;

  bool hlsFirst = false;
  Map<String, String> headers = {};

  DouyinSite();

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await _ensureFrbInit();
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
    // Parse danmakuData JSON into DouyinDanmakuArgs,
    // matching simple_live_core's DouyinSite.getRoomDetail construction.
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

// --- Twitch ---

class TwitchSite extends LiveSite {
  frb.SliveTwitchExtractor? _extractor;
  frb_dan.SliveTwitchDanmakuProvider? _danmakuProvider;

  TwitchSite();

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await _ensureFrbInit();
      _extractor = await frb.SliveTwitchExtractor.newInstance();
      _danmakuProvider =
          await frb_dan.SliveTwitchDanmakuProvider.newInstance();
    }
  }

  @override
  LiveDanmaku getDanmaku() => LiveDanmaku((args) async {
        await _ensureInit();
        final roomId = args?.toString() ?? '';
        final conn = await _danmakuProvider!.connect(roomId: roomId);
        return _TwitchDanmakuInner(_danmakuProvider!, conn);
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
    return LiveRoomDetail.fromBridge(
        await _extractor!.getRoomDetail(roomId: roomId));
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
// Danmaku inner wrappers — bridge the frb provider's connect/receive/disconnect
// to the SliveDanmaku-style start/stop interface expected by LiveDanmaku.
// =============================================================================

abstract class _DanmakuInner {
  void Function(bridge.SliveMessage msg)? onMessage;
  void Function(bridge.SliveSuperChatMessage msg)? onSuperChat;
  void Function(bridge.SliveDanmuControlEvent event)? onControl;
  void Function(String msg)? onClose;
  void Function()? onReady;

  Future<void> start(String roomId);
  Future<void> stop();
}

/// Generic base that handles the receive loop for any danmaku provider.
/// Subclasses supply the disconnect/receive closures since the frb-generated
/// provider types don't share a common interface.
class _DanmakuInnerBase extends _DanmakuInner {
  final Future<void> Function(frb_dan.SliveDanmuConnection) _disconnect;
  final Future<bridge.SliveDanmuItem?> Function(frb_dan.SliveDanmuConnection)
      _receive;
  frb_dan.SliveDanmuConnection? _connection;
  bool _running = false;

  _DanmakuInnerBase(this._disconnect, this._receive, this._connection);

  @override
  Future<void> start(String roomId) async {
    CoreLog.d('[Danmaku] start(), roomId=$roomId');
    _running = true;
    onReady?.call();
    _receiveLoop();
  }

  @override
  Future<void> stop() async {
    CoreLog.d('[Danmaku] stop()');
    _running = false;
    if (_connection != null) {
      await _disconnect(_connection!);
      _connection = null;
    }
  }

  Future<void> _receiveLoop() async {
    CoreLog.d('[Danmaku] _receiveLoop started');
    int timeoutCount = 0;
    int msgCount = 0;
    while (_running && _connection != null) {
      try {
        final item = await _receive(_connection!);
        if (item == null) {
          timeoutCount++;
          if (timeoutCount == 1 || timeoutCount % 200 == 0) {
            CoreLog.d('[Danmaku] timeout #$timeoutCount');
          }
          continue;
        }
        timeoutCount = 0;
        msgCount++;
        if (msgCount <= 5) {
          CoreLog.d('[Danmaku] msg #$msgCount: $item');
        }
        switch (item) {
          case bridge.SliveDanmuItem_Message(:final field0):
            onMessage?.call(field0);
          case bridge.SliveDanmuItem_SuperChat(:final field0):
            onSuperChat?.call(field0);
          case bridge.SliveDanmuItem_Control(:final field0):
            onControl?.call(field0);
        }
      } catch (e) {
        CoreLog.e('[Danmaku] receive error: $e', StackTrace.current);
        if (_running) onClose?.call(e.toString());
        break;
      }
    }
    CoreLog.d('[Danmaku] _receiveLoop ended, msgs=$msgCount, running=$_running, conn=${_connection != null}');
  }
}

class _BilibiliDanmakuInner extends _DanmakuInnerBase {
  _BilibiliDanmakuInner(frb_dan.SliveBilibiliDanmakuProvider provider,
      frb_dan.SliveDanmuConnection conn)
      : super(
          (c) => provider.disconnect(connection: c),
          (c) => provider.receive(connection: c),
          conn,
        );
}

class _DouyuDanmakuInner extends _DanmakuInnerBase {
  _DouyuDanmakuInner(
      frb_dan.SliveDouyuDanmakuProvider provider, frb_dan.SliveDanmuConnection conn)
      : super(
          (c) => provider.disconnect(connection: c),
          (c) => provider.receive(connection: c),
          conn,
        );
}

class _HuyaDanmakuInner extends _DanmakuInnerBase {
  _HuyaDanmakuInner(
      frb_dan.SliveHuyaDanmakuProvider provider, frb_dan.SliveDanmuConnection conn)
      : super(
          (c) => provider.disconnect(connection: c),
          (c) => provider.receive(connection: c),
          conn,
        );
}

class _DouyinDanmakuInner extends _DanmakuInnerBase {
  _DouyinDanmakuInner(
      frb_dan.SliveDouyinDanmakuProvider provider, frb_dan.SliveDanmuConnection conn)
      : super(
          (c) => provider.disconnect(connection: c),
          (c) => provider.receive(connection: c),
          conn,
        );
}

class _TwitchDanmakuInner extends _DanmakuInnerBase {
  _TwitchDanmakuInner(
      frb_dan.SliveTwitchDanmakuProvider provider, frb_dan.SliveDanmuConnection conn)
      : super(
          (c) => provider.disconnect(connection: c),
          (c) => provider.receive(connection: c),
          conn,
        );
}
