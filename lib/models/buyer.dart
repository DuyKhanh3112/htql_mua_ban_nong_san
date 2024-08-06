class Buyer {
  String id;
  String? avatar;
  String? cover;
  String email;
  String name;
  String phone;
  String username;
  String password;
  String status_id;
  DateTime create_at;

  Buyer(
      {required this.id,
      required this.username,
      required this.email,
      required this.phone,
      required this.password,
      required this.name,
      required this.create_at,
      required this.status_id,
      this.avatar,
      this.cover});

  factory Buyer.initBuyer() {
    return Buyer(
        id: '',
        username: '',
        email: '',
        phone: '',
        password: '',
        name: '',
        avatar: '',
        cover: '',
        create_at: DateTime.now(),
        status_id: '');
  }

  static Buyer fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      name: json['name'],
      create_at: json['create_at'],
      status_id: json['status_id'],
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
      'create_at': create_at,
      'status_id': status_id
    };
  }
}
