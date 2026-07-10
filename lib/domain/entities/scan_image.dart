import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_image.freezed.dart';

/// A captured photo handed to the AI service. Kept as raw bytes so the
/// domain stays free of any camera / file-system types.
@freezed
abstract class ScanImage with _$ScanImage {
  const factory ScanImage({
    required Uint8List bytes,

    /// e.g. `image/jpeg`.
    required String mimeType,
  }) = _ScanImage;
}
