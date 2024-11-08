class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  User.withoutId({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  }) : id = '';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
