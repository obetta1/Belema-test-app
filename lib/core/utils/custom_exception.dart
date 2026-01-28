class CustomException implements Exception {
  final String message;
  final int statusCode;
  final String url;
  final Map<String, dynamic>? data;

  CustomException({
    required this.message,
    required this.statusCode,
    this.url = '',
    this.data,
  });

  @override
  String toString() {
    return message;
  }
}