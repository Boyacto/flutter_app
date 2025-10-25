/// Feature flags for enabling/disabling features
class FeatureFlags {
  FeatureFlags._();

  /// Show manual reset button for game attempts (for demo purposes)
  static const bool showManualResetButton = true;

  /// Enable Korean language (disabled for hackathon - English only)
  static const bool enableKoreanLanguage = false;

  /// Enable deep links (disabled for hackathon)
  static const bool enableDeepLinks = false;

  /// Use real Unity integration (disabled - using mock for hackathon)
  static const bool useRealUnity = false;

  /// Enable debug logging
  static const bool enableDebugLogging = true;
}
