import '../../error/app_exception.dart';

enum ViewState<T> {
  ViewStatus status = ViewStatus.idle,
  T? data,
  AppException? error,

  ViewState();

  void setIdle() {
    status = ViewStatus.idle;
  }

  void setLoading([T? data]) {
    status = ViewStatus.loading;
    if (data != null) this.data = data;
  }

  void setSuccess(T data) {
    status = ViewStatus.success;
    this.data = data;
    error = null;
  }

  void setFailure(AppException error, [T? data]) {
    status = ViewStatus.failure;
    this.error = error;
    if (data != null) this.data = data;
  }

  bool get isIdle => status == ViewStatus.idle;
  bool get isLoading => status == ViewStatus.loading;
  bool get isSuccess => status == ViewStatus.success; 
  bool get isFailure => status == ViewStatus.failure; 
}

