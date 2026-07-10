import '../entities/recognized_item.dart';
import '../entities/scan_image.dart';
import '../services/ai_recognition_service.dart';

/// Thin seam over the AI service so presentation depends on a use-case,
/// not on the service interface directly.
class RecognizeScan {
  const RecognizeScan(this._service);

  final AiRecognitionService _service;

  Future<List<RecognizedItem>> call(List<ScanImage> images) =>
      _service.recognizeItems(images);
}
