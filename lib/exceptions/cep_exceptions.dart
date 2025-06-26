/// Defines the exception hierarchy for the `cep_fetcher` package.
///
/// All exceptions thrown by this package extend [CepFetcherException],
/// allowing consumers to catch both specific and general errors.
///
/// Base class for all exceptions thrown by the `cep_fetcher` package.
///
/// Contains a human-readable [message] describing the failure.
class CepFetcherException implements Exception {
  /// A human-readable description of the exception.
  final String message;

  /// Creates a new [CepFetcherException] with the provided [message].
  CepFetcherException(this.message);

  @override
  String toString() => 'CepFetcherException: $message';
}

/// Thrown when the input CEP has an invalid format.
///
/// This exception is triggered by the `fetchCepData` function when the
/// provided [cep] does not conform to the expected format after normalization.
///
/// The normalization process removes all non-numeric characters
/// (such as dots or dashes), and the resulting string must contain exactly 8 digits.
class InvalidCepFormatException extends CepFetcherException {
  /// The original, unformatted CEP string provided by the user.
  final String cep;

  /// Creates an [InvalidCepFormatException] when the provided [cep]
  /// is invalid after removing formatting (must have exactly 8 digits).
  InvalidCepFormatException(this.cep)
    : super(
        'The CEP "$cep" is invalid. After removing formatting, it must contain exactly 8 numeric digits.',
      );
}

/// Thrown when the specified timeout is outside the allowed range.
///
/// Valid timeout values are between 1 and 10 seconds (inclusive).
class TimeoutOutOfRangeException extends CepFetcherException {
  /// The invalid timeout duration provided.
  final Duration duration;

  /// Creates a [TimeoutOutOfRangeException] when [duration] is
  /// shorter than 1 second or longer than 10 seconds.
  TimeoutOutOfRangeException(this.duration)
    : super('Timeout $duration is out of valid range (1-10 seconds).');
}

/// Thrown when no data could be retrieved for the given CEP.
///
/// This occurs when all providers (ViaCEP, AwesomeAPI, OpenCEP) fail
/// to return valid address data for the given [cep].
class CepNotFoundException extends CepFetcherException {
  /// The sanitized CEP string for which data could not be found.
  final String cep;

  /// Creates a [CepNotFoundException] when all providers fail to return
  /// data for the given [cep].
  CepNotFoundException(this.cep)
    : super('No address data found for CEP $cep using any provider.');
}
