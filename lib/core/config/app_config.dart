/// Compile-time configuration.
///
/// Values are injected with `--dart-define` so no secret ever lives in
/// source control, e.g.:
/// `flutter run --dart-define=OPENAI_API_KEY=sk-... --dart-define=OPENAI_MODEL=gpt-4o`
abstract final class AppConfig {
  static const String openAiApiKey = String.fromEnvironment('OPENAI_API_KEY');

  static const String openAiModel =
      String.fromEnvironment('OPENAI_MODEL', defaultValue: 'gpt-4o');

  static const String _defaultBaseUrl = 'https://api.openai.com/v1';

  static const String openAiBaseUrl = String.fromEnvironment(
    'OPENAI_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static bool get hasApiKey => openAiApiKey.isNotEmpty;

  /// True when calls go through a server-side proxy that injects the key
  /// itself (e.g. the Vercel function) — the client then needs no key.
  static bool get usesProxy => openAiBaseUrl != _defaultBaseUrl;

  /// AI is usable either with a local key or via a key-holding proxy.
  static bool get isAiConfigured => hasApiKey || usesProxy;
}
