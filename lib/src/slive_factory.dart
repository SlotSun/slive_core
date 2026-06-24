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

  /// Create a [LiveSite] for the given platform ID.
  ///
  /// Throws [ArgumentError] if the platform is not supported.
  static LiveSite create(String platformId) {
    switch (platformId) {
      case 'bilibili':
        return BilibiliSite();
      case 'douyin':
        return DouyinSite();
      case 'douyu':
        return DouyuSite();
      case 'huya':
        return HuyaSite();
      case 'twitch':
        return TwitchSite();
      default:
        throw ArgumentError.value(
          platformId,
          'platformId',
          'Unsupported platform. Supported: ${supportedPlatforms.join(", ")}',
        );
    }
  }
}
