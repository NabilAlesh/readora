class AuthorModel {
  final int id;
  final String name;
  final String? bio; // نبذة عن المؤلف

  AuthorModel({required this.id, required this.name, this.bio});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(id: json['id'], name: json['name'], bio: json['bio']);
  }
}
