class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  });

  User.withoutId({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  }) : id = '';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
