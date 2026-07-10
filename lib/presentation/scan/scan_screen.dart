import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_theme.dart';
import 'scan_controller.dart';
import 'scan_state.dart';

/// Capture one or more photos of a space, then hand them to the AI.
/// On success the user is invited to review the created drafts.
class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key, required this.onDraftsCreated});

  /// Called after a successful scan so the shell can jump to Review.
  final VoidCallback onDraftsCreated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanControllerProvider);
    final controller = ref.read(scanControllerProvider.notifier);

    ref.listen(scanControllerProvider, (previous, next) {
      if (previous?.phase != ScanPhase.success &&
          next.phase == ScanPhase.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.createdDraftCount == 0
                  ? 'Scan finished — nothing recognised.'
                  : '${next.createdDraftCount} draft(s) created. '
                      'Review them before they go live.',
            ),
          ),
        );
        if (next.createdDraftCount > 0) onDraftsCreated();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Scan a space')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: state.images.isEmpty
                  ? const _EmptyScanHint()
                  : _PhotoGrid(state: state, controller: controller),
            ),
            if (state.errorMessage != null) ...[
              _ErrorBanner(message: state.errorMessage!),
              const SizedBox(height: AppSpacing.md),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: state.phase == ScanPhase.analyzing
                        ? null
                        : () => controller.addPhoto(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: state.phase == ScanPhase.analyzing
                        ? null
                        : () => controller.addPhoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: state.canAnalyze ? controller.analyze : null,
              icon: state.phase == ScanPhase.analyzing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                state.phase == ScanPhase.analyzing
                    ? 'Analyzing…'
                    : 'Identify items',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyScanHint extends StatelessWidget {
  const _EmptyScanHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: AppColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warehouse_outlined,
              size: 44,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'Point your camera at shelves,\nboxes or piles of stuff.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'The AI proposes items and counts.\nNothing changes until you approve.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({required this.state, required this.controller});

  final ScanState state;
  final ScanController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
      ),
      itemCount: state.images.length,
      itemBuilder: (context, index) {
        final image = state.images[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.card),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(image.bytes, fit: BoxFit.cover),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                  ),
                  iconSize: 18,
                  onPressed: () => controller.removePhoto(index),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEA),
        borderRadius: BorderRadius.circular(AppRadii.control),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.danger, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
