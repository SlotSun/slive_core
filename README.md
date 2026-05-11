# slive_core

A Flutter plugin for multi-platform live streaming aggregation, powered by Rust via [flutter_rust_bridge](https://github.com/aspect-build/aspect-flutter-rust-bridge).

Wraps [slive-core-api-rust](https://github.com/SlotSun/slive-core-api-rust) to provide stream extraction and real-time danmaku (chat) for 5 platforms.

## Supported Platforms

| Platform | Stream Extraction | Danmaku (Chat) |
|----------|:-----------------:|:--------------:|
| Bilibili (哔哩哔哩) |         ✓         |       ✓        |
| Douyin (抖音) |         ✓         |       ✓        |
| Douyu (斗鱼) |         ✓         |       ✓        |
| Huya (虎牙) |         ✓         |       ✓        |
| Twitch |         x         |       x        |

## Installation

```yaml
dependencies:
  slive_core:
    git:
      url: https://github.com/SlotSun/slive_core.git
      path: .
```

## Quick Start

### Initialize Rust Bridge

```dart
import 'package:slive_core/slive_core.dart';

await RustLib.init();
```

### Create a Platform Site

```dart
final site = await SliveFactory.create('bilibili');
// Supported: 'bilibili', 'douyin', 'douyu', 'huya', 'twitch'
```

### Get Room Detail

```dart
final detail = await site.getRoomDetail(roomId: '6');
print('${detail.userName}: ${detail.title}');
print('Status: ${detail.status ? "Live" : "Offline"}');
```

### Get Play URLs

```dart
final qualities = await site.getPlayQualities(detail: detail);
final playUrl = await site.getPlayUrls(detail: detail, quality: qualities.first);
print('Stream URL: ${playUrl.urls.first}');
```

### Search Rooms & Anchors

```dart
final rooms = await site.searchRooms('keyword', page: 1);
for (final room in rooms.items) {
  print('${room.userName}: ${room.title}');
}

final anchors = await site.searchAnchors('keyword', page: 1);
for (final anchor in anchors.items) {
  print('${anchor.userName} - Live: ${anchor.isLive}');
}
```

### Browse Categories

```dart
final categories = await site.getCategories();
final result = await site.getCategoryRooms(
  categories.first.subCategories.first,
  page: 1,
);
```

### Real-time Danmaku (Chat)

```dart
final danmaku = site.getDanmaku();

danmaku.onMessage = (msg) {
  print('${msg.username}: ${msg.content}');
};

danmaku.onSuperChat = (sc) {
  print('SC from ${sc.userName}: ${sc.content}');
};

danmaku.onControl = (event) {
  // StreamClosed, RoomInfoChanged, etc.
};

danmaku.onClose = (msg) => print('Disconnected: $msg');

await danmaku.start('12345', cookies: 'SESSDATA=...');

// Later:
await danmaku.stop();
```

## Tech Stack

| Layer | Technology |
|-------|------------|
| Dart API | Flutter + flutter_rust_bridge 2.11.1 |
| Native Core | Rust (tokio async runtime) |
| FFI Bridge | flutter_rust_bridge codegen |
| Data Models | freezed + json_annotation |
| HTTP | reqwest (Rust) with cookie/retry support |
| WebSocket | tokio-tungstenite (Rust) |
| Binary Protocols | Tars (Huya), Protobuf (Bilibili/Douyin) |

## Architecture

```
┌──────────────────────────────────────────┐
│              Flutter / Dart              │
│                                          │
│   SliveFactory → SliveSite → SliveDanmaku│
│        │              │           │       │
│   SliveBilibiliSite   getDanmaku()       │
│   SliveDouyinSite     onMessage callback  │
│   SliveDouyuSite      onSuperChat        │
│   SliveHuyaSite       onControl          │
│   SliveTwitchSite                        │
└────────────────┬─────────────────────────┘
                 │ flutter_rust_bridge (FFI)
┌────────────────┴─────────────────────────┐
│              Rust Core                   │
│                                          │
│   platforms-parser                       │
│   ├── LiveExtractor (trait)              │
│   ├── DanmuProvider (trait)              │
│   ├── Bilibili / Douyin / Douyu /        │
│   │   Huya / Twitch                      │
│   └── HttpClient / WebSocket framework   │
└──────────────────────────────────────────┘
```

## API Reference

### SliveSite

| Method | Description |
|--------|-------------|
| `getCategories()` | Get all platform categories |
| `searchRooms(keyword, page)` | Search live rooms |
| `searchAnchors(keyword, page)` | Search anchors (not supported on Douyin) |
| `getCategoryRooms(category, page)` | Get rooms in a category |
| `getRecommendRooms(page)` | Get recommended rooms |
| `getRoomDetail(roomId)` | Get full room info |
| `getPlayQualities(detail)` | Get available quality levels |
| `getPlayUrls(detail, quality)` | Get stream URLs |
| `getLiveStatus(roomId)` | Check if room is live |
| `getSuperChatMessages(roomId)` | Get super chat messages |
| `getDanmaku()` | Get danmaku handler for this platform |

### SliveDanmaku

| Property/Method | Description |
|-----------------|-------------|
| `onMessage` | Callback for chat messages |
| `onSuperChat` | Callback for super chat messages |
| `onControl` | Callback for control events (stream close, etc.) |
| `onClose` | Callback for disconnection |
| `onReady` | Callback when connection is ready |
| `start(roomId, {cookies})` | Start listening to danmaku |
| `stop()` | Stop and disconnect |

## License

[MIT](LICENSE)
