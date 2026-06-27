import 'package:flutter_test/flutter_test.dart';
import 'package:slive_core/slive_core.dart';

void testSite(LiveSite site) async {
  var rooms = <LiveRoomItem>[];
  test('getRecommendRooms', () async {
    if (site is TwitchSite) return;
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

  var categories = <LiveCategory>[];
  test('getCategories', () async {
    if (site is TwitchSite) return;
    categories = await site.getCategories();
    expect(categories, isNotEmpty);
    for (var item in categories) {
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
    if (site is TwitchSite) return;
    var result = await site.getCategoryRooms(categories.first.children.first);
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
    if (site is TwitchSite) return;
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
    if (site is DouyinSite || site is TwitchSite) return;
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
    final roomId = site is TwitchSite ? 'valorant_northamerica' : '7777';
    roomDetail = await site.getRoomDetail(roomId: roomId);
    expect(roomDetail, isNotNull);
    expect(roomDetail?.roomId, isNotEmpty);
    print(roomDetail);
  });

  List<LivePlayQuality> playQualities = [];
  test('getPlayQualities', () async {
    playQualities = await site.getPlayQualities(detail: roomDetail!);
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
}

void main() {
  setUpAll(() async {
    await RustLib.init();
    CoreLog.startRustLog();
  });

  group('Bilibili', () {
    testSite(BilibiliSite());
  });

  group('Douyin', () {
    testSite(DouyinSite());
  });

  group('Douyu', () {
    testSite(DouyuSite());
  });

  group('Huya', () {
    testSite(HuyaSite());
  });

  group('Twitch', () {
    testSite(TwitchSite());
  });
}
