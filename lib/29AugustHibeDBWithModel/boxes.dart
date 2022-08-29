import 'package:hive/hive.dart';
import 'models/transaction.dart';

class Boxes {
  static Box<MyTransaction> getTransactions() =>
      Hive.box<MyTransaction>('transactions');
}
