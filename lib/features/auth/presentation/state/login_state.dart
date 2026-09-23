import../

enum LoginStatus { idle, loading, sucess, failure }

final class LoginState {
    final LoginStatus status;
    final AuthSession? session;
    final AppException? error;

    const LoginState. ({required this.status, this.session, this.error});

    const LoginState.idle() : this._(status: LoginStatus.idle);
    const LoginState.loading() : this._(status: LoginStatus.loading);
    const LoginState.sucess(AuthSession session) 
      : this._(status: LoginStatus.sucess, session: session);
    const LoginState.failure(AppException error)
      : this._(status: LoginStatus.failure, error: error);

      bool get isLoading => status == LoginStatus.loading;
}