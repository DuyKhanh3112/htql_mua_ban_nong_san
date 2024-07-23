class User {
  String id;
  String username;
  String password;
  User({
    required this.id,
    required this.username,
    required this.password,
  });

  factory User.initUser() {
    return User(
      id: '0',
      username: '',
      password: '',
    );
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}
