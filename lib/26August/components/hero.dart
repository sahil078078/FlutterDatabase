class SuperHero {
  final int id;
  final String name;
  final int age;
  final String ability;

  SuperHero({
    required this.id,
    required this.name,
    required this.age,
    required this.ability,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'ability': ability,
    };
  }

  @override
  String toString() {
    return "SuperHero{\n id:$id name:$name age:$age ability:$ability}";
  }
}
