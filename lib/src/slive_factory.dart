import 'slive_site.dart';

/// Factory for creating [SliveSite] instances by platform ID.
class SliveFactory {
  SliveFactory._();

  /// All supported platform IDs.
  static const List<String> supportedPlatforms = [
    'bilibili',
    'douyin',
    'douyu',
    'huya',
    'twitch',
  ];

  /// Create a [SliveSite] for the given platform ID.
  ///
  /// Throws [ArgumentError] if the platform is not supported.
  static Future<SliveSite> create(String platformId) {
    switch (platformId) {
      case 'bilibili':
        return SliveBilibiliSite.create();
      case 'douyin':
        return SliveDouyinSite.create();
      case 'douyu':
        return SliveDouyuSite.create();
      case 'huya':
        return SliveHuyaSite.create();
      case 'twitch':
        return SliveTwitchSite.create();
      default:
        throw ArgumentError.value(
          platformId,
          'platformId',
          'Unsupported platform. Supported: ${supportedPlatforms.join(", ")}',
        );
    }
  }
}
