class Transaction {
  final String id;
  final String toAccount;
  final String amount;
  final String timeAgo;

  Transaction({
    required this.id,
    required this.toAccount,
    required this.amount,
    required this.timeAgo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      toAccount: json['toAccount'] ?? '',
      amount: '${json['amount'] ?? '0.00'}',
      timeAgo: json['date'] ?? '',
    );
  }
}

class TransactionsResponse {
  final List<Transaction> transactions;

  TransactionsResponse({required this.transactions});

  factory TransactionsResponse.fromJson(dynamic json) {
    List<Transaction> transactions = [];
    if (json is List) {
      transactions = json
          .map((t) => Transaction.fromJson(t as Map<String, dynamic>))
          .toList();
    }
    return TransactionsResponse(transactions: transactions);
  }
}
