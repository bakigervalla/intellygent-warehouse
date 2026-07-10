import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/scan_image.dart';
import '../providers.dart';
import 'scan_state.dart';

final scanControllerProvider =
    NotifierProvider<ScanController, ScanState>(ScanController.new);

/// Drives the scan flow: capture photos -> AI recognition -> drafts.
/// The AI result NEVER touches live inventory here; it only becomes
/// pending drafts.
class ScanController extends Notifier<ScanState> {
  static const int _maxImageWidth = 1600;
  static const int _imageQuality = 80;

  final ImagePicker _picker = ImagePicker();

  @override
  ScanState build() => const ScanState();

  Future<void> addPhoto(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: _maxImageWidth.toDouble(),
      imageQuality: _imageQuality,
    );
    if (file == null) return; // user cancelled

    final bytes = await file.readAsBytes();
    state = state.copyWith(
      phase: ScanPhase.idle,
      images: [
        ...state.images,
        ScanImage(bytes: bytes, mimeType: file.mimeType ?? 'image/jpeg'),
      ],
      clearError: true,
    );
  }

  void removePhoto(int index) {
    if (index < 0 || index >= state.images.length) return;
    final images = [...state.images]..removeAt(index);
    state = state.copyWith(images: images);
  }

  Future<void> analyze() async {
    if (!state.canAnalyze) return;
    state = state.copyWith(phase: ScanPhase.analyzing, clearError: true);

    try {
      final recognized =
          await ref.read(recognizeScanProvider).call(state.images);
      final drafts =
          await ref.read(createDraftsFromScanProvider).call(recognized);
      state = state.copyWith(
        phase: ScanPhase.success,
        createdDraftCount: drafts.length,
        images: const [],
      );
    } on AppException catch (e) {
      state = state.copyWith(
        phase: ScanPhase.failure,
        errorMessage: e.userMessage,
      );
    } catch (e) {
      state = state.copyWith(
        phase: ScanPhase.failure,
        errorMessage: 'Something went wrong during the scan.',
      );
    }
  }

  void reset() => state = const ScanState();
}
