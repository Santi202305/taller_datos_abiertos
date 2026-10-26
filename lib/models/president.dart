/// Modelo que representa un Presidente de Colombia.
class President {
  final int id;
  final String? image;
  final String? name;
  final String? lastName;
  final String? startPeriodDate;
  final String? endPeriodDate;
  final String? politicalParty;
  final String? description;
  final int? cityId;

  President({
    required this.id,
    this.image,
    this.name,
    this.lastName,
    this.startPeriodDate,
    this.endPeriodDate,
    this.politicalParty,
    this.description,
    this.cityId,
  });

  factory President.fromJson(Map<String, dynamic> json) {
    return President(
      id: json['id'] as int,
      image: json['image'] as String?,
      name: json['name'] as String?,
      lastName: json['lastName'] as String?,
      startPeriodDate: json['startPeriodDate'] as String?,
      endPeriodDate: json['endPeriodDate'] as String?,
      politicalParty: json['politicalParty'] as String?,
      description: json['description'] as String?,
      cityId: json['cityId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'lastName': lastName,
      'startPeriodDate': startPeriodDate,
      'endPeriodDate': endPeriodDate,
      'politicalParty': politicalParty,
      'description': description,
      'cityId': cityId,
    };
  }
}
