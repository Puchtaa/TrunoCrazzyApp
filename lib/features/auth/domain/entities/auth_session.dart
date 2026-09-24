final class AuthSession {
  final String? accessToken;
  final String? refreshToken;

  const AuthSession({
    this.accessToken,
    this.refreshToken,
  });
}

final class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}