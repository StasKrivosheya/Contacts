enum AuthStatus {
  normal,
  loading,
  success,
  error,
}

extension AuthStatusExtention on AuthStatus {
  bool get isNormal => this == AuthStatus.normal;
  bool get isLoading => this == AuthStatus.loading;
  bool get isSuccess => this == AuthStatus.success;
  bool get isError => this == AuthStatus.error;
}