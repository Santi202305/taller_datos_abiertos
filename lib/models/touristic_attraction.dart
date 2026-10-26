/// Modelo que representa una Atracción Turística de Colombia.
class TouristicAttraction {
  final int id;
  final String? name;
  final String? description;
  final List<String>? images;
  final String? latitude;
  final String? longitude;
  final int? cityId;

  TouristicAttraction({
    required this.id,
    this.name,
    this.description,
    this.images,
    this.latitude,
    this.longitude,
    this.cityId,
  });

  factory TouristicAttraction.fromJson(Map<String, dynamic> json) {
    return TouristicAttraction(
      id: json['id'] as int,
      name: json['name'] as String?,
      description: json['description'] as String?,
      images: json['images'] != null
          ? List<String>.from(json['images'] as List<dynamic>)
          : null,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      cityId: json['cityId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'cityId': cityId,
    };
  }
}
