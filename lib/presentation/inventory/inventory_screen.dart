import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/item.dart';
import '../providers.dart';
import '../theme/app_theme.dart';
import 'item_detail_screen.dart';

/// Live inventory, grouped by category. Only approved data appears here;
/// a banner links to pending drafts when any exist.
class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key, required this.onOpenDrafts});

  final VoidCallback onOpenDrafts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final items = ref.watch(itemsProvider);
    final pendingCount =
        ref.watch(pendingDraftsProvider).value?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: switch ((categories, items)) {
        (AsyncData(value: final cats), AsyncData(value: final its)) =>
          _InventoryList(
            categories: cats,
            items: its,
            pendingCount: pendingCount,
            onOpenDrafts: onOpenDrafts,
          ),
        (AsyncError(:final error), _) ||
        (_, AsyncError(:final error)) =>
          Center(child: Text('Could not load inventory.\n$error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _InventoryList extends StatelessWidget {
  const _InventoryList({
    required this.categories,
    required this.items,
    required this.pendingCount,
    required this.onOpenDrafts,
  });

  final List<Category> categories;
  final List<Item> items;
  final int pendingCount;
  final VoidCallback onOpenDrafts;

  @override
  Widget build(BuildContext context) {
    final grouped = <int, List<Item>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.categoryId, () => []).add(item);
    }
    final populated =
        categories.where((c) => grouped[c.id]?.isNotEmpty ?? false).toList();

    if (populated.isEmpty && pendingCount == 0) {
      return const Center(
        child: Text(
          'No stock yet.\nScan a space to get started.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.inkMuted),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        if (pendingCount > 0) ...[
          _PendingDraftsBanner(count: pendingCount, onTap: onOpenDrafts),
          const SizedBox(height: AppSpacing.lg),
        ],
        for (final category in populated) ...[
          _CategorySection(category: category, items: grouped[category.id]!),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }
}

class _PendingDraftsBanner extends StatelessWidget {
  const _PendingDraftsBanner({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.draftFill,
      borderRadius: BorderRadius.circular(AppRadii.control),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.control),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Icon(Icons.pending_actions, color: AppColors.draft),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '$count draft(s) awaiting review',
                  style: const TextStyle(
                    color: AppColors.draft,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.draft),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category, required this.items});

  final Category category;
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            category.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: AppColors.inkMuted,
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              for (final (index, item) in items.indexed) ...[
                if (index > 0)
                  const Divider(
                    height: 1,
                    indent: AppSpacing.lg,
                    color: AppColors.outline,
                  ),
                ListTile(
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: _QuantityPill(quantity: item.quantity),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ItemDetailScreen(itemId: item.id!),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _QuantityPill extends StatelessWidget {
  const _QuantityPill({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        '$quantity',
        style: const TextStyle(
          color: AppColors.accent,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
