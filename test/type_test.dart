import 'package:flutter_test/flutter_test.dart';
import 'package:slive_core/src/rust/api/models/live_anchor_item.dart';
import 'package:slive_core/src/rust/api/models/live_category.dart';
import 'package:slive_core/src/rust/api/models/live_category_result.dart';
import 'package:slive_core/src/rust/api/models/live_danmu_control_event.dart';
import 'package:slive_core/src/rust/api/models/live_message.dart';
import 'package:slive_core/src/rust/api/models/live_message_color.dart';
import 'package:slive_core/src/rust/api/models/live_message_type.dart';
import 'package:slive_core/src/rust/api/models/live_play_quality.dart';
import 'package:slive_core/src/rust/api/models/live_play_url.dart';
import 'package:slive_core/src/rust/api/models/live_room_detail.dart';
import 'package:slive_core/src/rust/api/models/live_room_item.dart';
import 'package:slive_core/src/rust/api/models/live_sub_category.dart';
import 'package:slive_core/src/rust/api/models/live_super_chat_message.dart';

void main() {
  group('LiveRoomDetail', () {


    test('constructs with nullable fields as null', () {
      const detail = LiveRoomDetail(
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
      const a = LiveRoomDetail(
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
      const b = LiveRoomDetail(
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

  group('LiveSubCategory', () {
    test('constructs with parent_id', () {
      const cat = LiveSubCategory(
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
      const cat = LiveSubCategory(
        id: '1',
        name: 'Games',
        parentId: '0',
        pic: 'https://example.com/pic.jpg',
      );

      expect(cat.pic, 'https://example.com/pic.jpg');
    });
  });

  group('LivePlayQuality', () {
    test('constructs correctly', () {
      const q = LivePlayQuality(
        quality: '原画',
        data: 'best',
        sort: 0,
      );

      expect(q.quality, '原画');
      expect(q.data, 'best');
      expect(q.sort, 0);
    });
  });

  group('LivePlayUrl', () {
    test('constructs with urls', () {
      const pu = LivePlayUrl(
        urls: ['https://example.com/stream.flv'],
      );

      expect(pu.urls, hasLength(1));
      expect(pu.urls.first, 'https://example.com/stream.flv');
      expect(pu.headers, isNull);
    });

    test('constructs with headers', () {
      const pu = LivePlayUrl(
        urls: ['https://example.com/stream.flv'],
        headers: {'User-Agent': 'Mozilla/5.0'},
      );

      expect(pu.headers, isNotNull);
      expect(pu.headers!['User-Agent'], 'Mozilla/5.0');
    });
  });

  group('LiveRoomItem', () {
    test('constructs correctly', () {
      const item = LiveRoomItem(
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

  group('LiveAnchorItem', () {
    test('constructs correctly', () {
      const anchor = LiveAnchorItem(
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

  group('LiveCategory', () {
    test('constructs with children', () {
      const cat = LiveCategory(
        id: '1',
        name: 'Games',
        children: [
          LiveSubCategory(id: '10', name: 'FPS', parentId: '1'),
          LiveSubCategory(id: '11', name: 'MOBA', parentId: '1'),
        ],
      );

      expect(cat.id, '1');
      expect(cat.name, 'Games');
      expect(cat.children, hasLength(2));
      expect(cat.children[0].name, 'FPS');
    });
  });

  group('LiveCategoryResult', () {
    test('constructs correctly', () {
      const result = LiveCategoryResult(
        hasMore: true,
        items: [
          LiveRoomItem(
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

  group('LiveSuperChatMessage', () {
    test('constructs correctly', () {
      const sc = LiveSuperChatMessage(
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

  group('LiveMessage', () {
    test('constructs chat message', () {
      const msg = LiveMessage(
        id: 'msg-1',
        userId: 'user-1',
        userName: 'Chatter',
        message: 'Hello!',
        color: LiveMessageColor(r: 255, g: 255, b: 255),
        timeMillis: 1700000000000,
        messageType: LiveMessageType.chat,
      );

      expect(msg.id, 'msg-1');
      expect(msg.userId, 'user-1');
      expect(msg.messageType, LiveMessageType.chat);
      expect(msg.userName, 'Chatter');
      expect(msg.message, 'Hello!');
      expect(msg.metadata, isNull);
      expect(msg.color.r, 255);
      expect(msg.color.g, 255);
      expect(msg.color.b, 255);
    });

    test('constructs with metadata', () {
      const msg = LiveMessage(
        id: 'msg-2',
        userId: '',
        userName: '',
        message: '',
        color: LiveMessageColor(r: 0, g: 0, b: 0),
        timeMillis: 1700000000000,
        messageType: LiveMessageType.online,
        metadata: '{"count": 12345}',
      );

      expect(msg.metadata, '{"count": 12345}');
    });
  });

  group('LiveMessageColor', () {
    test('constructs correctly', () {
      const color = LiveMessageColor(r: 255, g: 0, b: 128);

      expect(color.r, 255);
      expect(color.g, 0);
      expect(color.b, 128);
    });
  });

  group('LiveDanmuControlEvent', () {
    test('constructs stream_closed', () {
      const event = LiveDanmuControlEvent(
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
      const event = LiveDanmuControlEvent(
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

  group('LiveMessageType', () {
    test('has correct values', () {
      expect(LiveMessageType.values, hasLength(4));
      expect(LiveMessageType.chat.name, 'chat');
      expect(LiveMessageType.gift.name, 'gift');
      expect(LiveMessageType.online.name, 'online');
      expect(LiveMessageType.superChat.name, 'superChat');
    });
  });
}
