/// Modelo que representa una Región natural de Colombia.
class Region {
  final int id;
  final String? name;
  final String? description;

  Region({required this.id, this.name, this.description});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] as int,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}
