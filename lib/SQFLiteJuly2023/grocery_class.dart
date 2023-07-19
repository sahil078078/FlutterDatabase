class GroceryClass {
  final int? id;
  final String name;

  GroceryClass({this.id, required this.name});

  factory GroceryClass.fromJson(Map<String, dynamic> json) => GroceryClass(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
