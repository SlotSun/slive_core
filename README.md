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

## 弹幕过滤 (Danmaku Mask)

支持两种过滤策略，可组合使用：

### 频控过滤 (Frequency)

相同内容的弹幕在时间窗口内超过 `maxFrequency` 次后自动拦截，支持归一化（忽略大小写、空格、标点）。

### 黑名单过滤 (Word Blacklist)

包含指定关键词的弹幕会被拦截，支持普通文本和正则表达式（用 `/pattern/` 包裹）。

### 使用

```dart
final danmaku = site.getDanmaku();

// 连接时传入 mask 配置
await danmaku.start(
  detail.roomId,
  danmakuData: detail.danmakuData,
  maskConfig: LiveMaskConfig(
    frequency: const LiveFrequencyConfig(
      baseWindowMs: 10000,   // 时间窗口 10 秒
      bucketCount: 5,        // 滑动窗口桶数
      useNormalization: true,// 归一化（忽略大小写/空格/标点）
      maxFrequency: 3,       // 同一条弹幕最多出现 3 次
    ),
    blacklistWords: [
      '广告',            // 普通文本匹配
      '代练',
      '/加[微V]信/',     // 正则表达式
    ],
  ),
);

// 获取过滤统计
final stats = await danmaku.getMaskStats();
print('总接收: ${stats.totalReceived}');  // 过滤前总数
print('已放行: ${stats.passed}');
print('已拦截: ${stats.blocked}');

// 运行时清除/重置
await danmaku.clearMask();       // 移除过滤
await danmaku.resetMaskStats();  // 重置统计数据
```

## License

[MIT](LICENSE)
