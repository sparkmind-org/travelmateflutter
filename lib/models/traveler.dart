class Traveler {
  final String name;
  final String gender;
  final String? passport;
  final String? visa;

  Traveler({
    required this.name,
    required this.gender,
    this.passport,
    this.visa,
  });

  factory Traveler.fromJson(Map<String, dynamic> json) {
    return Traveler(
      name: json['name'],
      gender: json['gender'],
      passport: json['passport'],
      visa: json['visa'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender,
    'passport': passport,
    'visa': visa,
  };
}