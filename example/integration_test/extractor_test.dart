import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slive_core/slive_core.dart';
import 'package:slive_core/slive_core_compat.dart';

void testSite(LiveSite site) async {
  var rooms = <LiveRoomItem>[];
  test('getRecommendRooms', () async {
    if (site is TwitchSite) {
      return;
    }
    final result = await site.getRecommendRooms();
    expect(result, isNotNull);
    expect(result.items, isNotEmpty);
    rooms = result.items;
    for (var item in rooms) {
      expect(item.roomId, isNotEmpty);
      expect(item.title, isNotEmpty);
      expect(item.cover, isNotEmpty);
      expect(item.userName, isNotEmpty);
      print(item);
    }
  });

  var categores = <LiveCategory>[];
  test('getCategores', () async {
    if (site is TwitchSite) {
      return;
    }
    categores = await site.getCategores();
    expect(categores, isNotEmpty);
    for (var item in categores) {
      expect(item.name, isNotEmpty);
      for (var subItem in item.children) {
        expect(subItem.name, isNotEmpty);
        expect(subItem.id, isNotEmpty);
        expect(subItem.parentId, isNotEmpty);
      }
      print('${item.name}\n${item.children}');
    }
  });

  test('getCategoryRooms', () async {
    if (site is TwitchSite) {
      return;
    }
    var result = await site.getCategoryRooms(categores.first.children.first);
    expect(result, isNotNull);
    expect(result.items, isNotEmpty);
    for (var item in result.items) {
      expect(item.roomId, isNotEmpty);
      expect(item.title, isNotEmpty);
      expect(item.cover, isNotEmpty);
      expect(item.userName, isNotEmpty);
      print(item);
    }
  });

  test('searchRooms', () async {
    if (site is TwitchSite) {
      return;
    }
    var result = await site.searchRooms('LOL');
    expect(result, isNotNull);
    expect(result.items, isNotEmpty);
    for (var item in result.items) {
      expect(item.roomId, isNotEmpty);
      expect(item.title, isNotEmpty);
      expect(item.cover, isNotEmpty);
      expect(item.userName, isNotEmpty);
      print(item);
    }
  });

  test('searchAnchors', () async {
    // 跳过抖音测试此项
    if (site is DouyinSite) {
      return;
    }
    if (site is TwitchSite) {
      return;
    }
    var result = await site.searchAnchors('联盟');
    expect(result, isNotNull);
    expect(result.items, isNotEmpty);
    for (var item in result.items) {
      expect(item.roomId, isNotEmpty);
      expect(item.userName, isNotEmpty);
      print(item);
    }
  });

  LiveRoomDetail? roomDetail;
  test('getRoomDetail', () async {
    roomDetail = await site.getRoomDetail(roomId: "7777");
    expect(roomDetail, isNotNull);
    expect(roomDetail?.roomId, isNotEmpty);
    // expect(roomDetail?.danmakuData, isNotNull);
    print(roomDetail);
  });

  List<LivePlayQuality> playQualities = [];
  test('getPlayQuality', () async {
    playQualities = await site.getPlayQualites(detail: roomDetail!);
    expect(playQualities, isNotEmpty);
    for (var item in playQualities) {
      expect(item.quality, isNotEmpty);
      expect(item.data, isNotNull);
      print(item);
    }
  });

  test('getPlayUrls', () async {
    var url = await site.getPlayUrls(
        detail: roomDetail!, quality: playQualities.first);
    expect(url, isNotNull);
    expect(url.urls, isNotEmpty);
    print(url.urls.join('\n\n'));
  });

  test('getDanmaku', () async {
    if (site is TwitchSite) {
      return;
    }
    var danmaku = site.getDanmaku();
    expect(danmaku, isNotNull);
    expect(danmaku, isA<LiveDanmaku>());
    var closed = false;
    var ready = false;
    danmaku.onReady = () {
      print('ready');
      ready = true;
    };
    danmaku.onClose = (msg) {
      print('onClose $msg');
      closed = true;
    };
    var msgCount = 0;
    danmaku.onMessage = (LiveMessage msg) {
      print('onMessage ${msg.type} ${msg.message}');
      msgCount++;
    };
    await danmaku.start(roomDetail!.danmakuData);
    // 接收30秒的弹幕
    await Future.delayed(const Duration(seconds: 30));
    expect(ready, isTrue);
    expect(closed, isFalse);
    expect(msgCount, greaterThan(0));
    await danmaku.stop();
  }, timeout: const Timeout(Duration(seconds: 40)));
}

void main() {
  CoreLog.requestLogType = RequestLogType.short;

  group('bili tests', () {
    var site = BiliBiliSite();
    site.cookie = "";
    testSite(site);
  });
}




void main1() {
  setUpAll(() async => await RustLib.init());

  group('SliveBilibiliExtractor', () {
    late SliveBilibiliExtractor extractor;

    setUp(() async {
      extractor = await SliveBilibiliExtractor.newInstance();
      extractor.setCookies(cookies: ""
          "");
    });

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
        url: 'https://live.bilibili.com/7777',
      );
      expect(result, isNotNull);
      expect(result, isNotEmpty);
    });

    test(
      'getRoomDetail returns valid detail (may fail without cookies)',
      () async {
        try {
          final detail = await extractor.getRoomDetail(roomId: "7777");
          expect(detail.roomId, isNotEmpty);
          expect(detail.userName, isNotEmpty);
          expect(detail.title, isNotEmpty);
        } on AnyhowException catch (e) {
          // Bilibili returns -352 without cookies — expected in CI
          expect(e.toString(), contains('-352'));
        }
      },
    );

    test(
      'getLiveStatus returns a boolean (may fail without cookies)',
      () async {
        try {
          final status = await extractor.getLiveStatus(roomId: '7777');
          expect(status, isA<bool>());
        } on AnyhowException catch (e) {
          expect(e.toString(), contains('-352'));
        }
      },
    );
    test(
      'getRecommend',
          () async {
        try {
          final rec = await extractor.getRecommendRooms(page: 1);
          expect(rec.items, isNotEmpty);
        } on AnyhowException catch (e) {
          expect(e.toString(), contains('-352'));
        }
      },
    );
    test(
      'getSub',
          () async {
        try {
          final rec = await extractor.getCategoryRooms(category: SliveSubCategory(id: "86", name: "英雄联盟", parentId: "2"), page: 1);
          expect(rec.items, isNotEmpty);
        } on AnyhowException catch (e) {
          expect(e.toString(), contains('-352'));
        }
      },
    );
  });
  
  
}
