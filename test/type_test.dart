import 'package:flutter_test/flutter_test.dart';
import 'package:slive_core/src/rust/api/types.dart';

void main() {
  group('SliveRoomDetail', () {
    test('constructs with all fields', () {
      const detail = SliveRoomDetail(
        roomId: '12345',
        title: 'Test Room',
        cover: 'https://example.com/cover.jpg',
        userName: 'TestUser',
        userAvatar: 'https://example.com/avatar.jpg',
        online: 1000,
        introduction: 'Hello',
        notice: 'Welcome',
        status: true,
        data: '{"key":"value"}',
        danmakuData: '{"ws":"wss://example.com"}',
        url: 'https://live.bilibili.com/12345',
        isRecord: false,
      );

      expect(detail.roomId, '12345');
      expect(detail.title, 'Test Room');
      expect(detail.cover, 'https://example.com/cover.jpg');
      expect(detail.userName, 'TestUser');
      expect(detail.userAvatar, 'https://example.com/avatar.jpg');
      expect(detail.online, 1000);
      expect(detail.introduction, 'Hello');
      expect(detail.notice, 'Welcome');
      expect(detail.status, true);
      expect(detail.data, '{"key":"value"}');
      expect(detail.danmakuData, '{"ws":"wss://example.com"}');
      expect(detail.url, 'https://live.bilibili.com/12345');
      expect(detail.isRecord, false);
    });

    test('constructs with nullable fields as null', () {
      const detail = SliveRoomDetail(
        roomId: '12345',
        title: 'Test Room',
        cover: '',
        userName: '',
        userAvatar: '',
        online: 0,
        status: false,
        url: '',
        isRecord: false,
      );

      expect(detail.introduction, isNull);
      expect(detail.notice, isNull);
      expect(detail.data, isNull);
      expect(detail.danmakuData, isNull);
    });

    test('equality works', () {
      const a = SliveRoomDetail(
        roomId: '12345',
        title: 'Test',
        cover: '',
        userName: '',
        userAvatar: '',
        online: 0,
        status: false,
        url: '',
        isRecord: false,
      );
      const b = SliveRoomDetail(
        roomId: '12345',
        title: 'Test',
        cover: '',
        userName: '',
        userAvatar: '',
        online: 0,
        status: false,
        url: '',
        isRecord: false,
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('SliveSubCategory', () {
    test('constructs with parent_id', () {
      const cat = SliveSubCategory(
        id: '100',
        name: 'FPS',
        parentId: '1',
      );

      expect(cat.id, '100');
      expect(cat.name, 'FPS');
      expect(cat.parentId, '1');
      expect(cat.pic, isNull);
    });

    test('constructs with pic', () {
      const cat = SliveSubCategory(
        id: '1',
        name: 'Games',
        parentId: '0',
        pic: 'https://example.com/pic.jpg',
      );

      expect(cat.pic, 'https://example.com/pic.jpg');
    });
  });

  group('SlivePlayQuality', () {
    test('constructs correctly', () {
      const q = SlivePlayQuality(
        quality: '原画',
        data: 'best',
        sort: 0,
      );

      expect(q.quality, '原画');
      expect(q.data, 'best');
      expect(q.sort, 0);
    });
  });

  group('SlivePlayUrl', () {
    test('constructs with urls', () {
      const pu = SlivePlayUrl(
        urls: ['https://example.com/stream.flv'],
      );

      expect(pu.urls, hasLength(1));
      expect(pu.urls.first, 'https://example.com/stream.flv');
      expect(pu.headers, isNull);
    });

    test('constructs with headers', () {
      const pu = SlivePlayUrl(
        urls: ['https://example.com/stream.flv'],
        headers: [
          SliveMapEntry(key: 'User-Agent', value: 'Mozilla/5.0'),
        ],
      );

      expect(pu.headers, hasLength(1));
      expect(pu.headers!.first.key, 'User-Agent');
    });
  });

  group('SliveRoomItem', () {
    test('constructs correctly', () {
      const item = SliveRoomItem(
        roomId: '12345',
        title: 'Test Stream',
        cover: 'https://example.com/cover.jpg',
        userName: 'Streamer',
        online: 5000,
      );

      expect(item.roomId, '12345');
      expect(item.title, 'Test Stream');
      expect(item.userName, 'Streamer');
      expect(item.online, 5000);
    });
  });

  group('SliveAnchorItem', () {
    test('constructs correctly', () {
      const anchor = SliveAnchorItem(
        roomId: '12345',
        avatar: 'https://example.com/avatar.jpg',
        userName: 'TestAnchor',
        liveStatus: true,
      );

      expect(anchor.roomId, '12345');
      expect(anchor.avatar, 'https://example.com/avatar.jpg');
      expect(anchor.userName, 'TestAnchor');
      expect(anchor.liveStatus, true);
    });
  });

  group('SliveCategory', () {
    test('constructs with children', () {
      const cat = SliveCategory(
        id: '1',
        name: 'Games',
        children: [
          SliveSubCategory(id: '10', name: 'FPS', parentId: '1'),
          SliveSubCategory(id: '11', name: 'MOBA', parentId: '1'),
        ],
      );

      expect(cat.id, '1');
      expect(cat.name, 'Games');
      expect(cat.children, hasLength(2));
      expect(cat.children[0].name, 'FPS');
    });
  });

  group('SliveCategoryResult', () {
    test('constructs correctly', () {
      const result = SliveCategoryResult(
        hasMore: true,
        items: [
          SliveRoomItem(
            roomId: '1',
            title: 'Room 1',
            cover: '',
            userName: 'User1',
            online: 100,
          ),
        ],
      );

      expect(result.hasMore, true);
      expect(result.items, hasLength(1));
    });
  });

  group('SliveSuperChatMessage', () {
    test('constructs correctly', () {
      const sc = SliveSuperChatMessage(
        userName: 'Donor',
        face: 'https://example.com/face.jpg',
        message: 'Great stream!',
        price: 50,
        startTime: 1700000000000,
        endTime: 1700000060000,
        backgroundColor: '#FFD700',
        backgroundBottomColor: '#FFA500',
      );

      expect(sc.userName, 'Donor');
      expect(sc.face, 'https://example.com/face.jpg');
      expect(sc.message, 'Great stream!');
      expect(sc.price, 50);
      expect(sc.startTime, 1700000000000);
      expect(sc.endTime, 1700000060000);
      expect(sc.backgroundColor, '#FFD700');
      expect(sc.backgroundBottomColor, '#FFA500');
    });
  });

  group('SliveMessage', () {
    test('constructs chat message', () {
      const msg = SliveMessage(
        messageType: SliveMessageType.chat,
        userName: 'Chatter',
        message: 'Hello!',
        color: SliveMessageColor(r: 255, g: 255, b: 255),
      );

      expect(msg.messageType, SliveMessageType.chat);
      expect(msg.userName, 'Chatter');
      expect(msg.message, 'Hello!');
      expect(msg.data, isNull);
      expect(msg.color.r, 255);
      expect(msg.color.g, 255);
      expect(msg.color.b, 255);
    });

    test('constructs with data', () {
      const msg = SliveMessage(
        messageType: SliveMessageType.online,
        userName: '',
        message: '',
        data: '12345',
        color: SliveMessageColor(r: 0, g: 0, b: 0),
      );

      expect(msg.data, '12345');
    });
  });

  group('SliveMessageColor', () {
    test('constructs correctly', () {
      const color = SliveMessageColor(r: 255, g: 0, b: 128);

      expect(color.r, 255);
      expect(color.g, 0);
      expect(color.b, 128);
    });
  });

  group('SliveDanmuControlEvent', () {
    test('constructs stream_closed', () {
      const event = SliveDanmuControlEvent(
        kind: 'stream_closed',
        message: 'Stream has ended',
      );

      expect(event.kind, 'stream_closed');
      expect(event.message, 'Stream has ended');
      expect(event.title, isNull);
      expect(event.category, isNull);
      expect(event.parentCategory, isNull);
    });

    test('constructs room_info_changed', () {
      const event = SliveDanmuControlEvent(
        kind: 'room_info_changed',
        title: 'New Title',
        category: 'FPS',
        parentCategory: 'Games',
      );

      expect(event.kind, 'room_info_changed');
      expect(event.title, 'New Title');
      expect(event.category, 'FPS');
      expect(event.parentCategory, 'Games');
    });
  });

  group('SliveMessageType', () {
    test('has correct values', () {
      expect(SliveMessageType.values, hasLength(4));
      expect(SliveMessageType.chat.name, 'chat');
      expect(SliveMessageType.gift.name, 'gift');
      expect(SliveMessageType.online.name, 'online');
      expect(SliveMessageType.superChat.name, 'superChat');
    });
  });

  group('SliveMapEntry', () {
    test('constructs correctly', () {
      const entry = SliveMapEntry(key: 'Cookie', value: 'abc123');

      expect(entry.key, 'Cookie');
      expect(entry.value, 'abc123');
    });
  });
}
