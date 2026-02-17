/// Exception thrown when a server-side error occurs during API communication.
///
/// This is used in the data layer to signal HTTP or parsing failures.
class ServerException implements Exception {
  final String message;

  const ServerException([this.message = 'An unexpected error occurred']);

  @override
  String toString() => 'ServerException: $message';
}
