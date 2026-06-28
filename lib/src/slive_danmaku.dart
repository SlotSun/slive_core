import 'package:slive_core/src/rust/api/danmaku.dart';
import 'package:slive_core/src/rust/api/models/live_danmu_control_event.dart';
import 'package:slive_core/src/rust/api/models/live_danmu_item.dart';
import 'package:slive_core/src/rust/api/models/live_mask_config.dart';
import 'package:slive_core/src/rust/api/models/live_mask_stats.dart';
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
  ///
  /// [maskConfig] is an optional danmaku mask configuration for filtering
  /// duplicate messages and blacklisted words.
  Future<void> start(
    String roomId, {
    String? cookies,
    String? danmakuData,
    LiveMaskConfig? maskConfig,
  });

  /// Stop listening and disconnect.
  Future<void> stop();

  /// Get mask filtering statistics for the current connection.
  Future<LiveMaskStats?> getMaskStats();

  /// Reset mask filtering statistics.
  Future<void> resetMaskStats();

  /// Remove the mask from the current connection.
  Future<void> clearMask();
}

/// Adapter that abstracts over the frb-generated danmaku provider types,
/// since they don't share a common interface despite identical method signatures.
class _DanmakuAdapter {
  final Future<LiveDanmuConnection> Function(
    String roomId,
    String? cookies,
    String? danmakuData,
    LiveMaskConfig? maskConfig,
  ) connect;
  final Future<void> Function(LiveDanmuConnection connection) disconnect;
  final Future<LiveDanmuItem?> Function(
    LiveDanmuConnection connection,
  ) receive;
  final Future<LiveMaskStats> Function(
    LiveDanmuConnection connection,
  ) getMaskStats;
  final Future<void> Function(
    LiveDanmuConnection connection,
  ) resetMaskStats;
  final Future<void> Function(
    LiveDanmuConnection connection,
  ) clearMask;

  _DanmakuAdapter({
    required this.connect,
    required this.disconnect,
    required this.receive,
    required this.getMaskStats,
    required this.resetMaskStats,
    required this.clearMask,
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
  Future<void> start(
    String roomId, {
    String? cookies,
    String? danmakuData,
    LiveMaskConfig? maskConfig,
  }) async {
    _connection =
        await _adapter.connect(roomId, cookies, danmakuData, maskConfig);
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

  @override
  Future<LiveMaskStats?> getMaskStats() async {
    if (_connection == null) return null;
    return _adapter.getMaskStats(_connection!);
  }

  @override
  Future<void> resetMaskStats() async {
    if (_connection == null) return;
    await _adapter.resetMaskStats(_connection!);
  }

  @override
  Future<void> clearMask() async {
    if (_connection == null) return;
    await _adapter.clearMask(_connection!);
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
            connect: (roomId, cookies, danmakuData, maskConfig) =>
                provider.connect(
                    roomId: roomId,
                    cookies: cookies,
                    danmakuData: danmakuData,
                    maskConfig: maskConfig),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
            getMaskStats: (conn) => provider.getMaskStats(connection: conn),
            resetMaskStats: (conn) =>
                provider.resetMaskStats(connection: conn),
            clearMask: (conn) => provider.clearMask(connection: conn),
          ),
          'bilibili',
        );
}

class LiveDouyinDanmaku extends _LiveDanmakuBase {
  LiveDouyinDanmaku(LiveDouyinDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies, danmakuData, maskConfig) =>
                provider.connect(
                    roomId: roomId,
                    cookies: cookies,
                    danmakuData: danmakuData,
                    maskConfig: maskConfig),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
            getMaskStats: (conn) => provider.getMaskStats(connection: conn),
            resetMaskStats: (conn) =>
                provider.resetMaskStats(connection: conn),
            clearMask: (conn) => provider.clearMask(connection: conn),
          ),
          'douyin',
        );
}

class LiveDouyuDanmaku extends _LiveDanmakuBase {
  LiveDouyuDanmaku(LiveDouyuDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies, danmakuData, maskConfig) =>
                provider.connect(
                    roomId: roomId,
                    cookies: cookies,
                    danmakuData: danmakuData,
                    maskConfig: maskConfig),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
            getMaskStats: (conn) => provider.getMaskStats(connection: conn),
            resetMaskStats: (conn) =>
                provider.resetMaskStats(connection: conn),
            clearMask: (conn) => provider.clearMask(connection: conn),
          ),
          'douyu',
        );
}

class LiveHuyaDanmaku extends _LiveDanmakuBase {
  LiveHuyaDanmaku(LiveHuyaDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies, danmakuData, maskConfig) =>
                provider.connect(
                    roomId: roomId,
                    cookies: cookies,
                    danmakuData: danmakuData,
                    maskConfig: maskConfig),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
            getMaskStats: (conn) => provider.getMaskStats(connection: conn),
            resetMaskStats: (conn) =>
                provider.resetMaskStats(connection: conn),
            clearMask: (conn) => provider.clearMask(connection: conn),
          ),
          'huya',
        );
}

class LiveTwitchDanmaku extends _LiveDanmakuBase {
  LiveTwitchDanmaku(LiveTwitchDanmakuProvider provider)
      : super(
          _DanmakuAdapter(
            connect: (roomId, cookies, danmakuData, maskConfig) =>
                provider.connect(
                    roomId: roomId,
                    cookies: cookies,
                    danmakuData: danmakuData,
                    maskConfig: maskConfig),
            disconnect: (conn) => provider.disconnect(connection: conn),
            receive: (conn) => provider.receive(connection: conn),
            getMaskStats: (conn) => provider.getMaskStats(connection: conn),
            resetMaskStats: (conn) =>
                provider.resetMaskStats(connection: conn),
            clearMask: (conn) => provider.clearMask(connection: conn),
          ),
          'twitch',
        );
}
