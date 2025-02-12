class Result<T> {
  final bool success;
  final String message;
  final T? data;

  Result({required this.success, required this.message, this.data});
}