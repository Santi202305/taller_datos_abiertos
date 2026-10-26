/// Modelo que representa un Departamento de Colombia.
class Department {
  final int id;
  final String? name;
  final String? description;
  final int? cityCapitalId;
  final int? municipalities;
  final int? surface;
  final int? population;
  final String? phonePrefix;
  final int? countryId;
  final int? regionId;

  Department({
    required this.id,
    this.name,
    this.description,
    this.cityCapitalId,
    this.municipalities,
    this.surface,
    this.population,
    this.phonePrefix,
    this.countryId,
    this.regionId,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as int,
      name: json['name'] as String?,
      description: json['description'] as String?,
      cityCapitalId: json['cityCapitalId'] as int?,
      municipalities: json['municipalities'] as int?,
      surface: json['surface'] as int?,
      population: json['population'] as int?,
      phonePrefix: json['phonePrefix'] as String?,
      countryId: json['countryId'] as int?,
      regionId: json['regionId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cityCapitalId': cityCapitalId,
      'municipalities': municipalities,
      'surface': surface,
      'population': population,
      'phonePrefix': phonePrefix,
      'countryId': countryId,
      'regionId': regionId,
    };
  }
}
