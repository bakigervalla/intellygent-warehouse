import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/draft_enums.dart';
import '../../domain/entities/item.dart';
import '../providers.dart';
import '../theme/app_theme.dart';
import '../widgets/draft_badge.dart';

/// Live details of one item plus any pending drafts targeting it.
class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.itemId});

  final int itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsProvider).value ?? const <Item>[];
    final item = items.where((i) => i.id == itemId).firstOrNull;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Item')),
        body: const Center(child: Text('This item no longer exists.')),
      );
    }

    final categories = ref.watch(categoriesProvider).value ?? const [];
    final categoryName = categories
            .where((c) => c.id == item.categoryId)
            .firstOrNull
            ?.name ??
        'Uncategorized';

    final pendingForItem = (ref.watch(pendingDraftsProvider).value ??
            const [])
        .where(
          (d) => d.type == DraftType.stockUpdate && d.itemId == item.id,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(label: 'Category', value: categoryName),
                  const SizedBox(height: AppSpacing.md),
                  _DetailRow(label: 'In stock', value: '${item.quantity}'),
                  const SizedBox(height: AppSpacing.md),
                  _DetailRow(
                    label: 'Last updated',
                    value: _formatDate(item.updatedAt),
                  ),
                ],
              ),
            ),
          ),
          if (pendingForItem.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'PENDING CHANGES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final draft in pendingForItem)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.sync_alt,
                      color: AppColors.draft,
                    ),
                    title: Text(
                      'Stock ${draft.previousCount ?? '?'} → '
                      '${draft.proposedCount ?? '?'}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const DraftBadge(),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}
