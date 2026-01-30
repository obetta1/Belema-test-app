class TransferResponse {
  final String transactionId;
  final String status;
  final String message;

  TransferResponse({
    required this.transactionId,
    required this.status,
    required this.message,
  });

  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    return TransferResponse(
      transactionId: json['transactionId'] ?? '',
      status: json['status'] ?? 'pending',
      message: json['message'] ?? 'Transfer initiated',
    );
  }
}
