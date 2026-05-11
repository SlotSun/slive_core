import 'rust/api/danmaku.dart' as frb;
import 'rust/api/types.dart' as frb_types;

/// Callback-based danmaku interface matching the original `LiveDanmaku` pattern.
abstract class SliveDanmaku {
  /// Called when a chat message is received.
  void Function(frb_types.SliveMessage msg)? onMessage;

  /// Called when a super chat message is received.
  void Function(frb_types.SliveSuperChatMessage msg)? onSuperChat;

  /// Called when a control event is received (stream closed, room info changed, etc).
  void Function(frb_types.SliveDanmuControlEvent event)? onControl;

  /// Called when the connection is closed.
  void Function(String msg)? onClose;

  /// Called when the connection is established and ready.
  void Function()? onReady;

  /// Start listening to danmaku for the given room.
  Future<void> start(String roomId, {String? cookies});

  /// Stop listening and disconnect.
  Future<void> stop();
}

/// Adapter that abstracts over the frb-generated danmaku provider types,
/// since they don't share a common interface despite identical method signatures.
class _DanmakuAdapter {
  final Future<frb.SliveDanmuConnection> Function(
    String roomId,
    String? cookies,
  ) connect;
  final Future<void> Function(frb.SliveDanmuConnection connection) disconnect;
  final Future<frb_types.SliveDanmuItem?> Function(
    frb.SliveDanmuConnection connection,
  ) receive;

  _DanmakuAdapter({
    required this.connect,
    required this.disconnect,
    required this.receive,
  });
}

/// Base implementation that handles the receive loop and dispatch.
class _SliveDanmakuBase extends SliveDanmaku {
  final _DanmakuAdapter _adapter;
  final String platformId;
  frb.SliveDanmuConnection? _connection;
  bool _running = false;

  _SliveDanmakuBase(this._adapter, this.platformId);

  @override
  Future<void> start(String roomId, {String? cookies}) async {
    _connection = await _adapter.connect(roomId, cookies);
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

  void _dispatch(frb_types.SliveDanmuItem item) {
    switch (item) {
      case frb_types.SliveDanmuItem_Message(:final field0):
        onMessage?.call(field0);
      case frb_types.SliveDanmuItem_SuperChat(:final field0):
        onSuperChat?.call(field0);
      case frb_types.SliveDanmuItem_Control(:final field0):
        onControl?.call(field0);
    }
  }
}

// ---------------------------------------------------------------------------
// Platform implementations — each wraps its frb-generated provider
// ---------------------------------------------------------------------------

class SliveBilibiliDanmaku extends _SliveDanmakuBase {
  SliveBilibiliDanmaku(frb.SliveBilibiliDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies) =>
                provider.connect(roomId: roomId, cookies: cookies),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
          ),
          'bilibili',
        );
}

class SliveDouyinDanmaku extends _SliveDanmakuBase {
  SliveDouyinDanmaku(frb.SliveDouyinDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies) =>
                provider.connect(roomId: roomId, cookies: cookies),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
          ),
          'douyin',
        );
}

class SliveDouyuDanmaku extends _SliveDanmakuBase {
  SliveDouyuDanmaku(frb.SliveDouyuDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies) =>
                provider.connect(roomId: roomId, cookies: cookies),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
          ),
          'douyu',
        );
}

class SliveHuyaDanmaku extends _SliveDanmakuBase {
  SliveHuyaDanmaku(frb.SliveHuyaDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies) =>
                provider.connect(roomId: roomId, cookies: cookies),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
          ),
          'huya',
        );
}

class SliveTwitchDanmaku extends _SliveDanmakuBase {
  SliveTwitchDanmaku(frb.SliveTwitchDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies) =>
                provider.connect(roomId: roomId, cookies: cookies),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
          ),
          'twitch',
        );
}
