import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/config/llm_settings.dart';
import '../../core/errors/app_exception.dart';
import '../../domain/entities/recognized_item.dart';
import '../../domain/entities/scan_image.dart';
import '../../domain/services/ai_recognition_service.dart';
import 'openai_response_parser.dart';

/// OpenAI vision implementation of [AiRecognitionService].
///
/// Sends the captured photos as data-URI image parts to the chat completions
/// endpoint and expects a strict JSON object back (see
/// [OpenAiResponseParser] for the contract).
class OpenAiRecognitionService implements AiRecognitionService {
  OpenAiRecognitionService({
    Dio? dio,
    OpenAiResponseParser? parser,
    LlmSettings? settings,
  })  : _parser = parser ?? const OpenAiResponseParser(),
        _settings = settings ?? LlmSettings.initial(),
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.openAiBaseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 90),
              ),
            ) {
    // Seam for future auth flows: token refresh, tenant headers etc. plug in
    // here as interceptors without touching callers.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Behind a proxy the key stays server-side; send no header.
          if (AppConfig.hasApiKey) {
            options.headers['Authorization'] =
                'Bearer ${AppConfig.openAiApiKey}';
          }
          // Tell the proxy which vendor to route to. Direct-to-OpenAI calls
          // ignore this unknown header harmlessly.
          options.headers['x-llm-provider'] = _settings.provider.wireName;
          handler.next(options);
        },
      ),
    );
  }

  static const String _systemPrompt =
      'You are an inventory scanner. You receive one or more photos of a '
      'physical space (warehouse, garage, market...). Identify every '
      'distinct physical item type you can see across ALL photos combined '
      'and estimate the total count of each. Group similar products under a '
      'short, generic category name (e.g. "Tools", "Beverages", '
      '"Electronics"). Respond ONLY with a JSON object of this exact shape: '
      '{"items": [{"itemName": string, "category": string, '
      '"estimatedCount": integer, "confidence": number between 0 and 1}]} '
      'Use singular item names. If you see nothing recognisable, return '
      '{"items": []}.';

  final Dio _dio;
  final OpenAiResponseParser _parser;
  final LlmSettings _settings;

  @override
  Future<List<RecognizedItem>> recognizeItems(List<ScanImage> images) async {
    if (!AppConfig.isAiConfigured) {
      throw const AiAuthException(
        'Neither OPENAI_API_KEY nor a proxy OPENAI_BASE_URL is configured',
      );
    }
    if (images.isEmpty) {
      return const [];
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/chat/completions',
        data: _buildRequestBody(images),
      );
      return _parser.parse(_extractContent(response.data));
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Map<String, dynamic> _buildRequestBody(List<ScanImage> images) => {
        'model': _settings.model,
        'response_format': {'type': 'json_object'},
        'messages': [
          {'role': 'system', 'content': _systemPrompt},
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': 'Identify and count the items in these '
                    '${images.length} photo(s).',
              },
              for (final image in images)
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:${image.mimeType};base64,'
                        '${base64Encode(image.bytes)}',
                  },
                },
            ],
          },
        ],
      };

  String _extractContent(Map<String, dynamic>? data) {
    final choices = data?['choices'];
    if (choices is! List || choices.isEmpty) {
      throw const AiResponseFormatException('Response has no choices');
    }
    final first = choices.first;
    Object? content;
    if (first is Map<String, dynamic>) {
      final message = first['message'];
      if (message is Map<String, dynamic>) {
        content = message['content'];
      }
    }
    if (content is! String || content.isEmpty) {
      throw const AiResponseFormatException('Response has no text content');
    }
    return content;
  }

  AppException _mapDioException(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401 || status == 403) {
      return AiAuthException('OpenAI rejected the API key (HTTP $status)');
    }
    if (status != null) {
      return AiServiceException(
        'OpenAI error HTTP $status: ${e.response?.data}',
      );
    }
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        AiNetworkException('Network failure: ${e.message}'),
      _ => AiServiceException('Unexpected transport error: ${e.message}'),
    };
  }
}
