import 'package:flutter_test/flutter_test.dart';
import 'package:slive_core/slive_core.dart';

void main() {
  setUpAll(() async => await RustLib.init());

  group('SliveBilibiliDanmakuProvider', () {
    late SliveBilibiliDanmakuProvider provider;

    setUp(
        () async => provider = await SliveBilibiliDanmakuProvider.newInstance());

    test('supportsUrl returns true for bilibili URLs', () async {
      final result = await provider.supportsUrl(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, true);
    });

    test('supportsUrl returns false for non-bilibili URLs', () async {
      final result = await provider.supportsUrl(
        url: 'https://www.douyu.com/12345',
      );
      expect(result, false);
    });

    test('extractRoomId extracts room ID from URL', () async {
      final result = await provider.extractRoomId(
        url: 'https://live.bilibili.com/21652717',
      );
      expect(result, isNotNull);
      expect(result, isNotEmpty);
    });
  });

  group('SliveDouyinDanmakuProvider', () {
    late SliveDouyinDanmakuProvider provider;

    setUp(
        () async => provider = await SliveDouyinDanmakuProvider.newInstance());

    test('supportsUrl returns true for douyin URLs', () async {
      final result = await provider.supportsUrl(
        url: 'https://live.douyin.com/12345',
      );
      expect(result, true);
    });

    test('supportsUrl returns false for non-douyin URLs', () async {
      final result = await provider.supportsUrl(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, false);
    });
  });

  group('SliveDouyuDanmakuProvider', () {
    late SliveDouyuDanmakuProvider provider;

    setUp(
        () async => provider = await SliveDouyuDanmakuProvider.newInstance());

    test('supportsUrl returns true for douyu URLs', () async {
      final result = await provider.supportsUrl(
        url: 'https://www.douyu.com/12345',
      );
      expect(result, true);
    });

    test('supportsUrl returns false for non-douyu URLs', () async {
      final result = await provider.supportsUrl(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, false);
    });

    test('douyu danmaku diagnostic - end-to-end', () async {
      final log = await douyuDanmakuDiagnostic(roomId: '3168536');
      // ignore: avoid_print
      print(log);
      // Should have received at least 1 message in 5 seconds
      expect(log, contains('messages'));
    }, timeout: const Timeout(Duration(seconds: 30)));

    test('douyu connect + receive via FRB (like app does)', () async {
      final provider = await SliveDouyuDanmakuProvider.newInstance();
      final conn = await provider.connect(roomId: '3168536');
      // ignore: avoid_print
      print('Connected: id=${await conn.roomId()}, platform=${await conn.platform()}');

      int msgCount = 0;
      final deadline = DateTime.now().add(const Duration(seconds: 5));
      while (DateTime.now().isBefore(deadline)) {
        final item = await provider.receive(connection: conn);
        if (item != null) {
          msgCount++;
          if (msgCount <= 3) {
            // ignore: avoid_print
            print('  Message $msgCount: $item');
          }
        }
      }
      // ignore: avoid_print
      print('Total messages received via FRB: $msgCount');
      expect(msgCount, greaterThan(0), reason: 'Should receive danmaku messages');

      await provider.disconnect(connection: conn);
    }, timeout: const Timeout(Duration(seconds: 30)));
  });

  group('SliveHuyaDanmakuProvider', () {
    late SliveHuyaDanmakuProvider provider;

    setUp(() async => provider = await SliveHuyaDanmakuProvider.newInstance());

    test('supportsUrl returns true for huya URLs', () async {
      final result = await provider.supportsUrl(
        url: 'https://www.huya.com/10188',
      );
      expect(result, true);
    });

    test('supportsUrl returns false for non-huya URLs', () async {
      final result = await provider.supportsUrl(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, false);
    });
  });

  group('SliveTwitchDanmakuProvider', () {
    late SliveTwitchDanmakuProvider provider;

    setUp(
        () async => provider = await SliveTwitchDanmakuProvider.newInstance());

    test('supportsUrl returns true for twitch URLs', () async {
      final result = await provider.supportsUrl(
        url: 'https://www.twitch.tv/shroud',
      );
      expect(result, true);
    });

    test('supportsUrl returns false for non-twitch URLs', () async {
      final result = await provider.supportsUrl(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, false);
    });
  });
}
