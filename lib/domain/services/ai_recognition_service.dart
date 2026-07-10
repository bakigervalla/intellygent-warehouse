import '../entities/recognized_item.dart';
import '../entities/scan_image.dart';

/// Turns captured photos into a validated list of recognised items.
/// Implemented in the data layer (OpenAI today, anything else later).
abstract interface class AiRecognitionService {
  /// Throws an [AppException] subtype on auth, network, service or
  /// response-format failures.
  Future<List<RecognizedItem>> recognizeItems(List<ScanImage> images);
}
