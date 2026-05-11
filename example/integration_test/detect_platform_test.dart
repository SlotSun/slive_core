import 'package:flutter_test/flutter_test.dart';
import 'package:slive_core/slive_core.dart';

void main() {
  setUpAll(() async => await RustLib.init());

  group('detectPlatform', () {
    test('returns bilibili for bilibili URL', () async {
      final result = await detectPlatform(
        url: 'https://live.bilibili.com/12345',
      );
      expect(result, 'bilibili');
    });

    test('returns douyin for douyin URL', () async {
      final result = await detectPlatform(
        url: 'https://live.douyin.com/67890',
      );
      expect(result, 'douyin');
    });

    test('returns douyu for douyu URL', () async {
      final result = await detectPlatform(
        url: 'https://www.douyu.com/12345',
      );
      expect(result, 'douyu');
    });

    test('returns huya for huya URL', () async {
      final result = await detectPlatform(
        url: 'https://www.huya.com/10188',
      );
      expect(result, 'huya');
    });

    test('returns twitch for twitch URL', () async {
      final result = await detectPlatform(
        url: 'https://www.twitch.tv/shroud',
      );
      expect(result, 'twitch');
    });

    test('returns null for unknown URL', () async {
      final result = await detectPlatform(
        url: 'https://www.example.com/stream',
      );
      expect(result, isNull);
    });

    test('returns null when platform name is only in path', () async {
      final result = await detectPlatform(
        url: 'https://example.com/bilibili/room',
      );
      expect(result, isNull);
    });
  });
}
