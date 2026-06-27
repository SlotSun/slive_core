import 'package:slive_core/src/rust/api/danmaku.dart';
import 'package:slive_core/src/rust/api/models/live_danmu_control_event.dart';
import 'package:slive_core/src/rust/api/models/live_danmu_item.dart';
import 'package:slive_core/src/rust/api/models/live_message.dart';

/// Callback-based danmaku interface.
///
/// All messages (chat/gift/superChat/online) go through [onMessage].
/// Use [LiveMessage.messageType] to distinguish them.
abstract class LiveDanmaku {
  /// Called for all message types. Check [LiveMessage.messageType] to distinguish.
  void Function(LiveMessage msg)? onMessage;

  /// Called when a control event is received (stream closed, room info changed, etc).
  void Function(LiveDanmuControlEvent event)? onControl;

  /// Called when the connection is closed.
  void Function(String msg)? onClose;

  /// Called when the connection is established and ready.
  void Function()? onReady;

  /// Start listening to danmaku for the given room.
  ///
  /// [danmakuData] is an optional platform-specific JSON string from
  /// [LiveRoomDetail.danmakuData]. It is passed through to the Rust layer
  /// where each platform parses it as needed (e.g. Huya uses it for extras).
  Future<void> start(String roomId, {String? cookies, String? danmakuData});

  /// Stop listening and disconnect.
  Future<void> stop();
}

/// Adapter that abstracts over the frb-generated danmaku provider types,
/// since they don't share a common interface despite identical method signatures.
class _DanmakuAdapter {
  final Future<LiveDanmuConnection> Function(
    String roomId,
    String? cookies,
    String? danmakuData,
  ) connect;
  final Future<void> Function(LiveDanmuConnection connection) disconnect;
  final Future<LiveDanmuItem?> Function(
    LiveDanmuConnection connection,
  ) receive;

  _DanmakuAdapter({
    required this.connect,
    required this.disconnect,
    required this.receive,
  });
}

/// Base implementation that handles the receive loop and dispatch.
class _LiveDanmakuBase extends LiveDanmaku {
  final _DanmakuAdapter _adapter;
  final String platformId;
  LiveDanmuConnection? _connection;
  bool _running = false;

  _LiveDanmakuBase(this._adapter, this.platformId);

  @override
  Future<void> start(String roomId, {String? cookies, String? danmakuData}) async {
    _connection = await _adapter.connect(roomId, cookies, danmakuData);
    _running = true;
    onReady?.call();
    _receiveLoop();
  }

  @override
  Future<void> stop() async {
    _running = false;
    if (_connection != null) {
      await _adapter.disconnect(_connection!);
      _connection = null;
    }
  }

  Future<void> _receiveLoop() async {
    while (_running && _connection != null) {
      try {
        final item = await _adapter.receive(_connection!);
        if (item == null) {
          // null = timeout (no message available yet), keep polling.
          continue;
        }
        _dispatch(item);
      } catch (e) {
        if (_running) onClose?.call(e.toString());
        break;
      }
    }
  }

  void _dispatch(LiveDanmuItem item) {
    switch (item) {
      case LiveDanmuItem_Message(:final field0):
        onMessage?.call(field0);
      case LiveDanmuItem_Control(:final field0):
        onControl?.call(field0);
    }
  }
}

// ---------------------------------------------------------------------------
// Platform implementations — each wraps its frb-generated provider
// ---------------------------------------------------------------------------

class LiveBilibiliDanmaku extends _LiveDanmakuBase {
  LiveBilibiliDanmaku(LiveBilibiliDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies, danmakuData) => provider.connect(
                roomId: roomId, cookies: cookies, danmakuData: danmakuData),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
          ),
          'bilibili',
        );
}

class LiveDouyinDanmaku extends _LiveDanmakuBase {
  LiveDouyinDanmaku(LiveDouyinDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies, danmakuData) => provider.connect(
                roomId: roomId, cookies: cookies, danmakuData: danmakuData),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
          ),
          'douyin',
        );
}

class LiveDouyuDanmaku extends _LiveDanmakuBase {
  LiveDouyuDanmaku(LiveDouyuDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies, danmakuData) => provider.connect(
                roomId: roomId, cookies: cookies, danmakuData: danmakuData),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
          ),
          'douyu',
        );
}

class LiveHuyaDanmaku extends _LiveDanmakuBase {
  LiveHuyaDanmaku(LiveHuyaDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies, danmakuData) => provider.connect(
                roomId: roomId, cookies: cookies, danmakuData: danmakuData),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
          ),
          'huya',
        );
}

class LiveTwitchDanmaku extends _LiveDanmakuBase {
  LiveTwitchDanmaku(LiveTwitchDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies, danmakuData) => provider.connect(
                roomId: roomId, cookies: cookies, danmakuData: danmakuData),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
          ),
          'twitch',
        );
}
