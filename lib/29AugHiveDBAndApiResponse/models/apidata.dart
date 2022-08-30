import 'package:hive/hive.dart';
part 'apidata.g.dart';

@HiveType(typeId: 2)
class ApiData {
  @HiveField(0)
  int userId;
  @HiveField(1)
  int id;
  @HiveField(2)
  String title;
  @HiveField(3)
  String body;

  ApiData({
    required this.userId,
    required this.id,
    required this.body,
    required this.title,
  });

  factory ApiData.fromJson(Map<String, dynamic> json) {
    return ApiData(
      userId: json['userId'],
      id: json['id'],
      body: json['body'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
