/// Base class for all domain failures in LedgerFlow
abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Database operation failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.code});
}

/// Validation failures (business rule violations)
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code});
}

/// Insufficient balance (wallet cannot go negative)
class InsufficientBalanceFailure extends Failure {
  final double available;
  final double required;

  const InsufficientBalanceFailure({
    required super.message,
    required this.available,
    required this.required,
  });
}

/// Unexpected/unknown failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(
      {super.message = 'An unexpected error occurred', super.code});
}

/// Export failures
class ExportFailure extends Failure {
  const ExportFailure({required super.message, super.code});
}
