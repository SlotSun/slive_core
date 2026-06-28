import 'package:flutter_test/flutter_test.dart';
import 'package:slive_core/slive_core.dart';

void main() {
  setUpAll(() async {
    await RustLib.init();
    CoreLog.startRustLog();
  });

  group('Huya Danmaku Mask', () {
    late LiveHuyaDanmakuProvider danmakuProvider;
    late HuyaSite site;

    setUp(() async {
      danmakuProvider = await LiveHuyaDanmakuProvider.newInstance();
      site = HuyaSite();
    });

    test('extract room id from url', () async {
      final roomId =
          await danmakuProvider.extractRoomId(url: 'https://www.huya.com/222523');
      expect(roomId, isNotNull);
      expect(roomId, '222523');
      print('Extracted room id: $roomId');
    });

    test('connect and receive with mask config', () async {
      // Get room detail first to obtain danmakuData
      final detail = await site.getRoomDetail(roomId: '222523');
      expect(detail, isNotNull);
      print('Room: ${detail.title}');
      print('danmakuData: ${detail.danmakuData}');

      // Connect with mask config: frequency limit + blacklist
      final maskConfig = LiveMaskConfig(
        frequency: const LiveFrequencyConfig(
          baseWindowMs: 10000, // 10 second window
          bucketCount: 5,
          useNormalization: true,
          maxFrequency: 3, // block after 3 duplicates
        ),
        blacklistWords: ['广告', '代练'],
      );

      final conn = await danmakuProvider.connect(
        roomId: '222523',
        danmakuData: detail.danmakuData,
        maskConfig: maskConfig,
      );

      expect(await conn.isConnected(), isTrue);
      print('Connected! id=${await conn.id()}, platform=${await conn.platform()}');

      // Receive messages for 10 seconds
      final deadline = DateTime.now().add(const Duration(seconds: 10));
      int messageCount = 0;
      int controlCount = 0;

      while (DateTime.now().isBefore(deadline)) {
        final item = await danmakuProvider.receive(connection: conn);
        if (item == null) continue;

        switch (item) {
          case LiveDanmuItem_Message(:final field0):
            messageCount++;
            if (messageCount <= 10) {
              print('[${field0.messageType.name}] '
                  '${field0.userName}: ${field0.message}');
            }
          case LiveDanmuItem_Control(:final field0):
            controlCount++;
            print('[control] ${field0.kind}: ${field0.message ?? ""}');
        }
      }

      print('\n--- Summary ---');
      print('Messages received (after mask): $messageCount');
      print('Control events: $controlCount');

      // Get mask stats
      final stats = await danmakuProvider.getMaskStats(connection: conn);
      print('\n--- Mask Stats ---');
      print('Total received (before mask): ${stats.totalReceived}');
      print('Passed: ${stats.passed}');
      print('Blocked: ${stats.blocked}');

      // Verify mask stats are consistent
      expect(stats.totalReceived, greaterThan(0));
      expect(stats.passed, messageCount);
      expect(stats.totalReceived, stats.passed + stats.blocked);

      // Reset stats
      await danmakuProvider.resetMaskStats(connection: conn);
      final statsAfterReset =
          await danmakuProvider.getMaskStats(connection: conn);
      expect(statsAfterReset.totalReceived, 0);
      expect(statsAfterReset.passed, 0);
      expect(statsAfterReset.blocked, 0);
      print('Stats reset OK');

      // Clear mask
      await danmakuProvider.clearMask(connection: conn);
      print('Mask cleared');

      // Disconnect
      await danmakuProvider.disconnect(connection: conn);
      print('Disconnected');
    });

    test('connect without mask', () async {
      // Get room detail first
      final detail = await site.getRoomDetail(roomId: '222523');
      expect(detail, isNotNull);

      final conn = await danmakuProvider.connect(
        roomId: '222523',
        danmakuData: detail.danmakuData,
      );
      expect(await conn.isConnected(), isTrue);

      // Receive a few messages without mask
      int count = 0;
      final deadline = DateTime.now().add(const Duration(seconds: 5));

      while (DateTime.now().isBefore(deadline)) {
        final item = await danmakuProvider.receive(connection: conn);
        if (item == null) continue;
        count++;
        if (count <= 3) {
          if (item case LiveDanmuItem_Message(:final field0)) {
            print('[${field0.messageType.name}] '
                '${field0.userName}: ${field0.message}');
          }
        }
      }

      print('Received $count messages without mask');
      expect(count, greaterThan(0));

      // Stats should show no blocks
      final stats = await danmakuProvider.getMaskStats(connection: conn);
      expect(stats.blocked, 0);
      expect(stats.totalReceived, count);

      await danmakuProvider.disconnect(connection: conn);
    });
  });
}
