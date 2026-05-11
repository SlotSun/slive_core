import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:slive_core/slive_core.dart';

void main() {
  setUpAll(() async => await RustLib.init());

  group('SliveBilibiliExtractor', () {
    late SliveBilibiliExtractor extractor;

    setUp(() async => extractor = await SliveBilibiliExtractor.newInstance());

    test('supportsUrl returns true for bilibili URLs', () async {
      final result = await extractor.supportsUrl(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, true);
    });

    test('supportsUrl returns false for non-bilibili URLs', () async {
      final result = await extractor.supportsUrl(
        url: 'https://www.douyu.com/12345',
      );
      expect(result, false);
    });

    test('extractRoomId extracts room ID from URL', () async {
      final result = await extractor.extractRoomId(
        url: 'https://live.bilibili.com/21652717',
      );
      expect(result, isNotNull);
      expect(result, isNotEmpty);
    });

    test('getRoomDetail returns valid detail (may fail without cookies)',
        () async {
      try {
        final detail = await extractor.getRoomDetail(roomId: '21652717');
        expect(detail.roomId, isNotEmpty);
        expect(detail.userName, isNotEmpty);
        expect(detail.title, isNotEmpty);
      } on AnyhowException catch (e) {
        // Bilibili returns -352 without cookies — expected in CI
        expect(e.toString(), contains('-352'));
      }
    });

    test('getLiveStatus returns a boolean (may fail without cookies)',
        () async {
      try {
        final status = await extractor.getLiveStatus(roomId: '21652717');
        expect(status, isA<bool>());
      } on AnyhowException catch (e) {
        expect(e.toString(), contains('-352'));
      }
    });
  });

  group('SliveDouyinExtractor', () {
    late SliveDouyinExtractor extractor;

    setUp(() async => extractor = await SliveDouyinExtractor.newInstance());

    test('supportsUrl returns true for douyin URLs', () async {
      final result = await extractor.supportsUrl(
        url: 'https://live.douyin.com/12345',
      );
      expect(result, true);
    });

    test('supportsUrl returns false for non-douyin URLs', () async {
      final result = await extractor.supportsUrl(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, false);
    });
  });

  group('SliveDouyuExtractor', () {
    late SliveDouyuExtractor extractor;

    setUp(() async => extractor = await SliveDouyuExtractor.newInstance());

    test('supportsUrl returns true for douyu URLs', () async {
      final result = await extractor.supportsUrl(
        url: 'https://www.douyu.com/12345',
      );
      expect(result, true);
    });

    test('supportsUrl returns false for non-douyu URLs', () async {
      final result = await extractor.supportsUrl(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, false);
    });
  });

  group('SliveHuyaExtractor', () {
    late SliveHuyaExtractor extractor;

    setUp(() async => extractor = await SliveHuyaExtractor.newInstance());

    test('supportsUrl returns true for huya URLs', () async {
      final result = await extractor.supportsUrl(
        url: 'https://www.huya.com/10188',
      );
      expect(result, true);
    });

    test('supportsUrl returns false for non-huya URLs', () async {
      final result = await extractor.supportsUrl(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, false);
    });
  });

  group('SliveTwitchExtractor', () {
    late SliveTwitchExtractor extractor;

    setUp(() async => extractor = await SliveTwitchExtractor.newInstance());

    test('supportsUrl returns true for twitch URLs', () async {
      final result = await extractor.supportsUrl(
        url: 'https://www.twitch.tv/shroud',
      );
      expect(result, true);
    });

    test('supportsUrl returns false for non-twitch URLs', () async {
      final result = await extractor.supportsUrl(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, false);
    });
  });
}
