class SimplePlace {
  final String name;
  final String url;

  const SimplePlace({required this.name, required this.url});

  factory SimplePlace.fromJson(Map<String, dynamic> json) {
    return SimplePlace(
      name: (json['name'] ?? '') as String,
      url: (json['url'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'url': url};

  SimplePlace copyWith({String? name, String? url}) {
    return SimplePlace(name: name ?? this.name, url: url ?? this.url);
  }
}

class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final SimplePlace origin;
  final SimplePlace location;
  final String image;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      species: (json['species'] ?? '') as String,
      type: (json['type'] ?? '') as String,
      gender: (json['gender'] ?? '') as String,
      origin: SimplePlace.fromJson((json['origin'] ?? {}) as Map<String, dynamic>),
      location: SimplePlace.fromJson((json['location'] ?? {}) as Map<String, dynamic>),
      image: (json['image'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'species': species,
        'type': type,
        'gender': gender,
        'origin': origin.toJson(),
        'location': location.toJson(),
        'image': image,
      };

  CharacterModel copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    SimplePlace? origin,
    SimplePlace? location,
    String? image,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      location: location ?? this.location,
      image: image ?? this.image,
    );
  }
}
