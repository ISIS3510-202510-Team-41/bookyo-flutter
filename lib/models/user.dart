class User {

  User({required this.email, this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      name: json['name'] as String?,
    );
  }
  final String email;
  final String? name;
}
