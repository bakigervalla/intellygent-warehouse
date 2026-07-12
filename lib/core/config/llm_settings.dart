import 'app_config.dart';

/// LLM vendor the app talks to. The Vercel proxy honours the client's choice
/// (sent as the `x-llm-provider` header) when present, otherwise falls back to
/// its own `LLM_PROVIDER` env default.
enum LlmProvider {
  nvidia('nvidia', 'NVIDIA NIM'),
  openai('openai', 'OpenAI');

  const LlmProvider(this.wireName, this.label);

  /// Value sent to the proxy and persisted to disk.
  final String wireName;

  /// Human-facing name shown in the Setup form.
  final String label;

  static LlmProvider fromWireName(String? value) => values.firstWhere(
        (p) => p.wireName == value,
        orElse: () => LlmProvider.nvidia,
      );
}

/// A selectable model for a provider: the wire id sent upstream plus a short
/// label for the dropdown.
class LlmModel {
  const LlmModel(this.id, this.label);

  final String id;
  final String label;
}

/// Curated vision-capable models offered per provider. Kept short on purpose —
/// these are the ones the scan flow is known to work with.
const Map<LlmProvider, List<LlmModel>> kModelsByProvider = {
  LlmProvider.nvidia: [
    LlmModel('meta/llama-3.2-90b-vision-instruct', 'Llama 3.2 90B Vision'),
    LlmModel('meta/llama-3.2-11b-vision-instruct', 'Llama 3.2 11B Vision'),
    LlmModel('microsoft/phi-3.5-vision-instruct', 'Phi-3.5 Vision'),
  ],
  LlmProvider.openai: [
    LlmModel('gpt-4o', 'GPT-4o'),
    LlmModel('gpt-4o-mini', 'GPT-4o mini'),
    LlmModel('gpt-4.1', 'GPT-4.1'),
    LlmModel('gpt-4.1-mini', 'GPT-4.1 mini'),
  ],
};

/// Default model for a provider (first in its list).
String defaultModelFor(LlmProvider provider) =>
    kModelsByProvider[provider]!.first.id;

/// Immutable pair of the selected provider and its model.
class LlmSettings {
  const LlmSettings({required this.provider, required this.model});

  final LlmProvider provider;
  final String model;

  /// Startup default: NVIDIA is the app's primary provider (mirrors the
  /// proxy's own default). OpenAI's model still honours [AppConfig.openAiModel]
  /// when a build-time override was supplied.
  factory LlmSettings.initial() =>
      const LlmSettings(
        provider: LlmProvider.nvidia,
        model: 'meta/llama-3.2-90b-vision-instruct',
      );

  LlmSettings copyWith({LlmProvider? provider, String? model}) => LlmSettings(
        provider: provider ?? this.provider,
        model: model ?? this.model,
      );
}
