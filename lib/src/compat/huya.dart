import 'dart:convert';

import '../rust/api/extractor.dart' as frb;
import '../rust/api/danmaku.dart' as frb_dan;
import 'compat.dart';

// =============================================================================
// HuyaDanmakuArgs
// =============================================================================

class HuyaDanmakuArgs {
  final int ayyuid;
  final int topSid;
  final int subSid;

  HuyaDanmakuArgs({
    required this.ayyuid,
    required this.topSid,
    required this.subSid,
  });

  factory HuyaDanmakuArgs.fromJson(Map<String, dynamic> json) =>
      HuyaDanmakuArgs(
        ayyuid: json['ayyuid'] ?? 0,
        topSid: json['top_sid'] ?? 0,
        subSid: json['sub_sid'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'ayyuid': ayyuid,
        'top_sid': topSid,
        'sub_sid': subSid,
      };

  @override
  String toString() => jsonEncode(toJson());
}

// =============================================================================
// HuyaSite
// =============================================================================

class HuyaSite extends LiveSite {
  frb.SliveHuyaExtractor? _extractor;
  frb_dan.SliveHuyaDanmakuProvider? _danmakuProvider;

  static String HYSDK_UA = "";

  HuyaDanmakuArgs? _lastDanmakuArgs;

  Future<void> _ensureInit() async {
    if (_extractor == null) {
      await ensureFrbInit();
      _extractor = await frb.SliveHuyaExtractor.newInstance();
      _danmakuProvider =
          await frb_dan.SliveHuyaDanmakuProvider.newInstance();
      if (HYSDK_UA.isNotEmpty) {
        await _extractor!.setSdkUa(ua: HYSDK_UA);
      }
    }
  }

  @override
  LiveDanmaku getDanmaku() => LiveDanmaku((args) async {
        await _ensureInit();
        String roomId;
        HuyaDanmakuArgs? huyaArgs;
        if (args is HuyaDanmakuArgs) {
          roomId = '';
          huyaArgs = args;
        } else {
          roomId = args?.toString() ?? '';
          huyaArgs = _lastDanmakuArgs;
        }
        final frb_dan.SliveDanmuConnection conn;
        if (huyaArgs != null) {
          conn = await _danmakuProvider!.connectWithExtras(
            roomId: roomId,
            ayyuid: huyaArgs.ayyuid,
            topSid: huyaArgs.topSid,
            subSid: huyaArgs.subSid,
          );
        } else {
          conn = await _danmakuProvider!.connect(roomId: roomId);
        }
        return _HuyaDanmakuInner(_danmakuProvider!, conn);
      });

  @override
  Future<List<LiveCategory>> getCategores() async {
    await _ensureInit();
    return _extractor!.getCategories();
  }

  @override
  Future<LiveSearchRoomResult> searchRooms(String keyword,
      {int page = 1}) async {
    await _ensureInit();
    return _extractor!.searchRooms(keyword: keyword, page: page);
  }

  @override
  Future<LiveSearchAnchorResult> searchAnchors(String keyword,
      {int page = 1}) async {
    await _ensureInit();
    return _extractor!.searchAnchors(keyword: keyword, page: page);
  }

  @override
  Future<LiveCategoryResult> getCategoryRooms(LiveSubCategory category,
      {int page = 1}) async {
    await _ensureInit();
    return _extractor!.getCategoryRooms(category: category, page: page);
  }

  @override
  Future<LiveCategoryResult> getRecommendRooms({int page = 1}) async {
    await _ensureInit();
    return _extractor!.getRecommendRooms(page: page);
  }

  @override
  Future<LiveRoomDetail> getRoomDetail({required String roomId}) async {
    await _ensureInit();
    final detail = LiveRoomDetail.fromBridge(
        await _extractor!.getRoomDetail(roomId: roomId));
    final raw = detail.danmakuData;
    if (raw is String && raw.isNotEmpty) {
      try {
        _lastDanmakuArgs =
            HuyaDanmakuArgs.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        // Leave _lastDanmakuArgs as null — connect() will fall back.
      }
    }
    return detail;
  }

  @override
  Future<List<LivePlayQuality>> getPlayQualites(
      {required LiveRoomDetail detail}) async {
    await _ensureInit();
    return _extractor!.getPlayQualities(detail: detail.toBridge());
  }

  @override
  Future<LivePlayUrl> getPlayUrls({
    required LiveRoomDetail detail,
    required LivePlayQuality quality,
  }) async {
    await _ensureInit();
    return LivePlayUrl.fromBridge(
        await _extractor!.getPlayUrls(
            detail: detail.toBridge(), quality: quality));
  }

  @override
  Future<bool> getLiveStatus({required String roomId}) async {
    await _ensureInit();
    return _extractor!.getLiveStatus(roomId: roomId);
  }

  @override
  Future<List<LiveSuperChatMessage>> getSuperChatMessage(
      {required String roomId}) async {
    await _ensureInit();
    return (await _extractor!.getSuperChatMessages(roomId: roomId))
        .map(LiveSuperChatMessage.fromBridge)
        .toList();
  }
}

// =============================================================================
// _HuyaDanmakuInner
// =============================================================================

class _HuyaDanmakuInner extends DanmakuInnerBase {
  _HuyaDanmakuInner(
      frb_dan.SliveHuyaDanmakuProvider provider, frb_dan.SliveDanmuConnection conn)
      : super(
          (c) => provider.disconnect(connection: c),
          (c) => provider.receive(connection: c),
          conn,
        );
}
