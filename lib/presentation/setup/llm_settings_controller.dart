import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/llm_settings.dart';

/// SharedPreferences keys for the persisted LLM choice.
const String _providerKey = 'llm_provider';
const String _modelKey = 'llm_model';

/// Loads, persists, and exposes the user's LLM provider/model choice. The scan
/// pipeline reads the current value via [aiRecognitionServiceProvider], which
/// rebuilds whenever this changes.
class LlmSettingsController extends AsyncNotifier<LlmSettings> {
  @override
  Future<LlmSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final provider = LlmProvider.fromWireName(prefs.getString(_providerKey));
    final stored = prefs.getString(_modelKey);
    // Guard against a stored model that no longer belongs to the provider
    // (e.g. after switching providers on an older build).
    final valid = kModelsByProvider[provider]!.any((m) => m.id == stored);
    return LlmSettings(
      provider: provider,
      model: valid ? stored! : defaultModelFor(provider),
    );
  }

  /// Switches provider and resets the model to that provider's default.
  Future<void> selectProvider(LlmProvider provider) => _persist(
        LlmSettings(provider: provider, model: defaultModelFor(provider)),
      );

  /// Selects a model within the current provider.
  Future<void> selectModel(String model) async {
    final current = state.value ?? LlmSettings.initial();
    await _persist(current.copyWith(model: model));
  }

  Future<void> _persist(LlmSettings settings) async {
    state = AsyncData(settings);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_providerKey, settings.provider.wireName);
    await prefs.setString(_modelKey, settings.model);
  }
}

final llmSettingsProvider =
    AsyncNotifierProvider<LlmSettingsController, LlmSettings>(
  LlmSettingsController.new,
);
