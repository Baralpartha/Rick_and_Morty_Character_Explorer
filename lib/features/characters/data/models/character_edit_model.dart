class CharacterEditModel {
  final int id;
  final String? name;
  final String? status;
  final String? species;
  final String? type;
  final String? gender;
  final String? originName;
  final String? locationName;

  const CharacterEditModel({
    required this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.originName,
    this.locationName,
  });

  factory CharacterEditModel.fromJson(Map<dynamic, dynamic> json) {
    return CharacterEditModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      status: json['status'] as String?,
      species: json['species'] as String?,
      type: json['type'] as String?,
      gender: json['gender'] as String?,
      originName: json['originName'] as String?,
      locationName: json['locationName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'species': species,
        'type': type,
        'gender': gender,
        'originName': originName,
        'locationName': locationName,
      };
}
