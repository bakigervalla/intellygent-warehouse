import 'package:flutter/material.dart';

import '../../domain/entities/draft_enums.dart';
import '../theme/app_theme.dart';

/// The amber "DRAFT" pill — the one visual marker for anything not yet live.
class DraftBadge extends StatelessWidget {
  const DraftBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.draftFill,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: const Text(
        'DRAFT',
        style: TextStyle(
          color: AppColors.draft,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

/// Small label describing what kind of change a draft proposes.
class DraftTypeChip extends StatelessWidget {
  const DraftTypeChip({super.key, required this.type});

  final DraftType type;

  @override
  Widget build(BuildContext context) {
    final label = switch (type) {
      DraftType.newItem => 'New item',
      DraftType.stockUpdate => 'Stock update',
      DraftType.newCategory => 'New category',
    };
    final icon = switch (type) {
      DraftType.newItem => Icons.add_box_outlined,
      DraftType.stockUpdate => Icons.sync_alt,
      DraftType.newCategory => Icons.create_new_folder_outlined,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.inkMuted),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Confidence indicator, e.g. "87%".
class ConfidenceLabel extends StatelessWidget {
  const ConfidenceLabel({super.key, required this.confidence});

  final double confidence;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${(confidence * 100).round()}% sure',
      style: const TextStyle(
        color: AppColors.inkMuted,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
