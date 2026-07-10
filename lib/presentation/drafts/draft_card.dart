import 'package:flutter/material.dart';

import '../../domain/entities/draft.dart';
import '../../domain/entities/draft_enums.dart';
import '../theme/app_theme.dart';
import '../widgets/draft_badge.dart';

/// One pending draft with approve / reject actions.
class DraftCard extends StatelessWidget {
  const DraftCard({
    super.key,
    required this.draft,
    required this.onApprove,
    required this.onReject,
    this.enabled = true,
  });

  final Draft draft;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DraftTypeChip(type: draft.type),
                const Spacer(),
                const DraftBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _subtitle,
              style: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
            ),
            if (draft.confidence != null) ...[
              const SizedBox(height: AppSpacing.xs),
              ConfidenceLabel(confidence: draft.confidence!),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: enabled ? onReject : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                    ),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: enabled ? onApprove : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String get _title => switch (draft.type) {
        DraftType.newCategory => draft.categoryName ?? 'Unnamed category',
        _ => draft.itemName ?? 'Unnamed item',
      };

  String get _subtitle => switch (draft.type) {
        DraftType.newCategory =>
          'Create this category. Items assigned to it stay drafts until '
              'approved.',
        DraftType.newItem =>
          'Add ${draft.proposedCount ?? 0} to "${draft.categoryName ?? 'Uncategorized'}"'
              '${draft.categoryId == null && draft.newCategoryDraftId != null ? ' (new category, draft)' : ''}',
        DraftType.stockUpdate =>
          'Stock ${draft.previousCount ?? '?'} → ${draft.proposedCount ?? '?'}',
      };
}
