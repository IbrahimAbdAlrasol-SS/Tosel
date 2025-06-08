import 'package:Tosell/Features/profile/models/transaction.dart';
import 'package:Tosell/Features/profile/services/transaction_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_provider.g.dart';

@riverpod
class transactionNotifier extends _$transactionNotifier {
  TransactionService service = TransactionService();

  @override
  FutureOr<List<Transaction>> build() async {
    return await service.getAllTransactions();
  }
}
