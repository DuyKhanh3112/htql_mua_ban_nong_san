class Admin {
  String id;
  String? avatar;
  String? cover;
  String email;
  String name;
  String phone;
  String username;
  String password;

  Admin({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.name,
    this.avatar,
    this.cover,
  });

  factory Admin.initAdmin() {
    return Admin(
      id: '',
      username: '',
      email: '',
      phone: '',
      password: '',
      name: '',
      avatar: '',
      cover: '',
    );
  }

  static Admin fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      name: json['name'],
      avatar: json['avatar'] ?? '',
      cover: json['cover'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'name': name,
      'avatar': avatar,
      'cover': cover,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'name': name,
      'avatar': avatar,
      'cover': cover,
    };
  }
}
