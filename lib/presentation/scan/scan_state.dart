import '../../domain/entities/scan_image.dart';

enum ScanPhase { idle, analyzing, success, failure }

/// Immutable state of the scan flow.
class ScanState {
  const ScanState({
    this.phase = ScanPhase.idle,
    this.images = const [],
    this.createdDraftCount = 0,
    this.errorMessage,
  });

  final ScanPhase phase;
  final List<ScanImage> images;
  final int createdDraftCount;
  final String? errorMessage;

  bool get canAnalyze => images.isNotEmpty && phase != ScanPhase.analyzing;

  ScanState copyWith({
    ScanPhase? phase,
    List<ScanImage>? images,
    int? createdDraftCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ScanState(
      phase: phase ?? this.phase,
      images: images ?? this.images,
      createdDraftCount: createdDraftCount ?? this.createdDraftCount,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
