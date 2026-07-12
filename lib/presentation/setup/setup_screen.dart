import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/llm_settings.dart';
import 'llm_settings_controller.dart';

/// AI provider configuration. Switch the LLM vendor (NVIDIA / OpenAI) and pick
/// one of that vendor's vision models. The choice is persisted and used by the
/// next scan.
class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(llmSettingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Setup')),
      body: switch (settings) {
        AsyncData(value: final value) => _SetupForm(settings: value),
        AsyncError(:final error) =>
          Center(child: Text('Could not load settings.\n$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _SetupForm extends ConsumerWidget {
  const _SetupForm({required this.settings});

  final LlmSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(llmSettingsProvider.notifier);
    final models = kModelsByProvider[settings.provider]!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('AI provider', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<LlmProvider>(
          segments: [
            for (final provider in LlmProvider.values)
              ButtonSegment(value: provider, label: Text(provider.label)),
          ],
          selected: {settings.provider},
          onSelectionChanged: (selection) =>
              controller.selectProvider(selection.first),
        ),
        const SizedBox(height: 24),
        Text('Model', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: settings.model,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: [
            for (final model in models)
              DropdownMenuItem(value: model.id, child: Text(model.label)),
          ],
          onChanged: (model) {
            if (model != null) controller.selectModel(model);
          },
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Scans use ${settings.provider.label} · ${_modelLabel(models, settings.model)}. '
                    'Changes apply to the next scan.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _modelLabel(List<LlmModel> models, String id) => models
      .firstWhere((m) => m.id == id, orElse: () => LlmModel(id, id))
      .label;
}
