import 'package:equatable/equatable.dart';

/// A sealed union type for representing the outcome of an operation.
///
/// Use [Success] for successful results carrying data of type [T],
/// and [Failure] for error results carrying a message string.
/// The [fold] method provides exhaustive pattern matching.
sealed class Result<T> extends Equatable {
  const Result();

  /// Pattern-matches on the result, calling [onSuccess] with the data
  /// if successful, or [onError] with the error message if failed.
  R fold<R>(R Function(T data) onSuccess, R Function(String error) onError);
}

/// Represents a successful result containing a [value] of type [T].
final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);

  @override
  R fold<R>(R Function(T data) onSuccess, R Function(String error) onError) {
    return onSuccess(value);
  }

  @override
  List<Object?> get props => [value];
}

/// Represents a failed result containing an error [message].
final class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);

  @override
  R fold<R>(R Function(T data) onSuccess, R Function(String error) onError) {
    return onError(message);
  }

  @override
  List<Object?> get props => [message];
}
