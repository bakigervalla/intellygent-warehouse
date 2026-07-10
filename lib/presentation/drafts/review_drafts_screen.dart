import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import '../theme/app_theme.dart';
import 'draft_actions_controller.dart';
import 'draft_card.dart';

/// Every proposed change waits here. Approve to mutate live inventory,
/// reject to discard.
class ReviewDraftsScreen extends ConsumerWidget {
  const ReviewDraftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drafts = ref.watch(pendingDraftsProvider);
    final actions = ref.watch(draftActionsControllerProvider);
    final controller = ref.read(draftActionsControllerProvider.notifier);

    ref.listen(draftActionsControllerProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && message != previous?.errorMessage) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review drafts'),
        actions: [
          if ((drafts.value ?? const []).isNotEmpty)
            TextButton(
              onPressed: actions.isBusy
                  ? null
                  : () => controller.approveAll(
                        [for (final d in drafts.value!) d.id!],
                      ),
              child: const Text('Approve all'),
            ),
        ],
      ),
      body: drafts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _CenteredNote(
          icon: Icons.error_outline,
          text: 'Could not load drafts.\n$e',
        ),
        data: (list) => list.isEmpty
            ? const _CenteredNote(
                icon: Icons.fact_check_outlined,
                text: 'No pending drafts.\nScan a space to propose changes.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: list.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final draft = list[index];
                  return DraftCard(
                    draft: draft,
                    enabled: !actions.isBusy,
                    onApprove: () => controller.approve(draft.id!),
                    onReject: () => controller.reject(draft.id!),
                  );
                },
              ),
      ),
    );
  }
}

class _CenteredNote extends StatelessWidget {
  const _CenteredNote({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: AppColors.inkMuted),
          const SizedBox(height: AppSpacing.md),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}
