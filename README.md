# slive_core

> ⚠️ WIP - 开发中

多平台直播聚合 Flutter 插件，Rust 内核驱动。

## 支持平台

| 平台 | 流提取 | 弹幕 |
|------|:---:|:--:|
| 哔哩哔哩 |  ✓  | ✓  |
| 抖音 |  ✓  | ✓  |
| 斗鱼 |  ✓  | ✓  |
| 虎牙 |  ✓  | ✓  |
| Twitch |  x  | x  |

## 安装

```yaml
dependencies:
  slive_core:
    git:
      url: https://github.com/SlotSun/slive_core.git
```

## 使用

```dart
import 'package:slive_core/slive_core.dart' as anyName;

// 初始化
await anyName.RustLib.init(); // must

// 创建平台站点
final site = BilibiliSite(); 

// 获取房间信息
final detail = await site.getRoomDetail(roomId: '6');

// 获取播放链接
final qualities = await site.getPlayQualities(detail: detail);
final playUrl = await site.getPlayUrls(detail: detail, quality: qualities.first);

// 搜索
final rooms = await site.searchRooms('keyword');
final anchors = await site.searchAnchors('keyword');

// 分类
final categories = await site.getCategories();
final result = await site.getCategoryRooms(categories.first.children.first);

// 弹幕
final danmaku = site.getDanmaku();

danmaku.onMessage = (msg) {
  // msg.messageType: slive.LiveMessageType.chat / gift / online / superChat
  print('${msg.userName}: ${msg.message}');
};

danmaku.onControl = (event) {
  // stream_closed / room_info_changed
};

danmaku.onClose = (msg) => print('断开: $msg');
danmaku.onReady = () => print('已连接');

await danmaku.start(detail.roomId, cookies: '...', danmakuData: detail.danmakuData);

// 断开
await danmaku.stop();
```

## License

[MIT](LICENSE)
