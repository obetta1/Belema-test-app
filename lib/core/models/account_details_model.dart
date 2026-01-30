class AccountDetailsResponse {
  final int balance;
  final String accountNumber;

  AccountDetailsResponse({
    required this.balance,
    required this.accountNumber,
  });

  factory AccountDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AccountDetailsResponse(
        accountNumber: json['accountNumber'] ?? '',
      balance: json['balance'] ?? 0,
    );
  }
}
