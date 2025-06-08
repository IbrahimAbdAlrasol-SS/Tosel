
import 'package:Tosell/Features/profile/models/transaction.dart';
import 'package:Tosell/core/Client/BaseClient.dart';

class TransactionService {
  final BaseClient<Transaction> baseClient;

  TransactionService()
      : baseClient = BaseClient<Transaction>(fromJson: (json) => Transaction.fromJson(json));

  Future<List<Transaction>> getAllTransactions() async {
    try {
      var result = await baseClient.getAll(endpoint: '/wallet/my-transactions');
      if (result.data == null) return [];
      return result.data!;
    } catch (e) {
      rethrow;
    }
  }
}
