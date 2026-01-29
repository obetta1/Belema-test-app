class LoginResponse {
  final String accessToken;
  final bool hasPin;

  LoginResponse({
    required this.accessToken,
    required this.hasPin,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      hasPin: json['hasPin'] ?? false,
    );
  }
}