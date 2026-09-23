abstract class AppException implements Exception {
  final String message;
  final object? cause;

  const AppException({required this.message, this.cause});

  @override
  String toString() => message;
} 

final class UnexpectedException extends AppException {
  const UnexpectedException({
    super.message = 'Ocorreu um erro inesperado. Por favor, tente novamente mais tarde.',
    super.cause,
  }); 
}

