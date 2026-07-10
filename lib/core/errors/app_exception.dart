/// Base class for all domain-visible failures.
///
/// Every exception carries a [userMessage] safe to render in the UI and a
/// technical [message] for logging.
sealed class AppException implements Exception {
  const AppException(this.message, this.userMessage);

  /// Technical detail, for logs.
  final String message;

  /// Human-readable, safe for the UI.
  final String userMessage;

  @override
  String toString() => '$runtimeType: $message';
}

/// API key missing or rejected by the AI provider.
class AiAuthException extends AppException {
  const AiAuthException(String message)
      : super(
          message,
          'AI service is not configured correctly. '
          'Check your OpenAI API key.',
        );
}

/// Network-level failure talking to the AI provider.
class AiNetworkException extends AppException {
  const AiNetworkException(String message)
      : super(message, 'Could not reach the AI service. Check your connection.');
}

/// The AI provider answered, but not with valid recognisable JSON.
class AiResponseFormatException extends AppException {
  const AiResponseFormatException(String message)
      : super(message, 'The AI returned an unexpected answer. Try scanning again.');
}

/// The AI provider returned an error status (rate limit, server error...).
class AiServiceException extends AppException {
  const AiServiceException(String message)
      : super(message, 'The AI service failed to process the scan. Try again later.');
}

/// Local persistence failure.
class StorageException extends AppException {
  const StorageException(String message)
      : super(message, 'Could not save data locally. Please try again.');
}

/// A domain rule was violated (e.g. approving an already-resolved draft).
class DomainRuleException extends AppException {
  const DomainRuleException(super.message, super.userMessage);
}
