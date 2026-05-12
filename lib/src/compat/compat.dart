// Shared types for the compatibility layer.
//
// Provides typedefs, helpers, and base classes used by per-platform files.

import '../rust/api/danmaku.dart' as frb_dan;
import '../rust/api/types.dart' as bridge;
import '../rust/frb_generated.dart' show RustLib;
import '../common/corelog.dart';

export '../common/corelog.dart' show CoreLog, RequestLogType;

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

Future<void> ensureFrbInit() async {
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
// LivePlayUrl — wraps bridge type to convert headers
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
// LiveRoomDetail
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
// LiveDanmaku — callback-based danmaku wrapper
// =============================================================================

class LiveDanmaku {
  void Function(LiveMessage msg)? onMessage;
  void Function(String msg)? onClose;
  void Function()? onReady;

  final Future<DanmakuInner> Function(dynamic args) _initDanmaku;
  DanmakuInner? _inner;

  LiveDanmaku(this._initDanmaku);

  void _attach(DanmakuInner inner) {
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
// Danmaku inner base classes
// =============================================================================

abstract class DanmakuInner {
  void Function(bridge.SliveMessage msg)? onMessage;
  void Function(bridge.SliveSuperChatMessage msg)? onSuperChat;
  void Function(bridge.SliveDanmuControlEvent event)? onControl;
  void Function(String msg)? onClose;
  void Function()? onReady;

  Future<void> start(String roomId);
  Future<void> stop();
}

/// Generic base that handles the receive loop for any danmaku provider.
class DanmakuInnerBase extends DanmakuInner {
  final Future<void> Function(frb_dan.SliveDanmuConnection) _disconnect;
  final Future<bridge.SliveDanmuItem?> Function(frb_dan.SliveDanmuConnection)
      _receive;
  frb_dan.SliveDanmuConnection? _connection;
  bool _running = false;

  DanmakuInnerBase(this._disconnect, this._receive, this._connection);

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
