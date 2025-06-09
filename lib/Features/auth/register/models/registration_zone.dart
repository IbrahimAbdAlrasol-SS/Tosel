class RegistrationZone {
  final int? id;
  final String? name;
  final int? type;
  final RegistrationGovernorate? governorate;

  RegistrationZone({
    this.id,
    this.name,
    this.type,
    this.governorate,
  });

  factory RegistrationZone.fromJson(Map<String, dynamic> json) {
    return RegistrationZone(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      governorate: json['governorate'] != null 
          ? RegistrationGovernorate.fromJson(json['governorate']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'governorate': governorate?.toJson(),
    };
  }

  @override
  String toString() {
    return name ?? '';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegistrationZone && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class RegistrationGovernorate {
  final int? id;
  final String? name;

  RegistrationGovernorate({
    this.id,
    this.name,
  });

  factory RegistrationGovernorate.fromJson(Map<String, dynamic> json) {
    return RegistrationGovernorate(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return name ?? '';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegistrationGovernorate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}