class SetPinResponse {
  final bool success;
  final String message;

  SetPinResponse({
    required this.success,
    required this.message,
  });

  factory SetPinResponse.fromJson(Map<String, dynamic> json) {
    return SetPinResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'PIN setting failed',
    );
  }
}
