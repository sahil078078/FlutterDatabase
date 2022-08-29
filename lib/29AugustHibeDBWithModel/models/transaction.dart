import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 0)
class MyTransaction extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late DateTime createdDate;
  @HiveField(2)
  bool isExpense = true;
  @HiveField(3)
  late double amount;
}
