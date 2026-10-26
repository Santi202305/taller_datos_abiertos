/// Modelo que representa un Plato Típico de Colombia.
class TypicalDish {
  final int id;
  final String? name;
  final String? description;
  final String? ingredients;
  final String? imageUrl;
  final int? departmentId;

  TypicalDish({
    required this.id,
    this.name,
    this.description,
    this.ingredients,
    this.imageUrl,
    this.departmentId,
  });

  factory TypicalDish.fromJson(Map<String, dynamic> json) {
    return TypicalDish(
      id: json['id'] as int,
      name: json['name'] as String?,
      description: json['description'] as String?,
      ingredients: json['ingredients'] as String?,
      imageUrl: json['imageUrl'] as String?,
      departmentId: json['departmentId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'departmentId': departmentId,
    };
  }
}
