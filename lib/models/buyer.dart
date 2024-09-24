import 'package:cloud_firestore/cloud_firestore.dart';

class Buyer {
  String id;
  String? avatar;
  String? cover;
  String email;
  String name;
  String phone;
  String username;
  String password;
  String status;
  Timestamp create_at;
  int? rate_order;

  Buyer({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.name,
    required this.create_at,
    required this.status,
    this.avatar,
    this.cover,
    this.rate_order,
  });

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
        create_at: Timestamp.now(),
        status: '');
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
      status: json['status'],
      avatar: json['avatar'] ?? '',
      cover: json['cover'] ?? '',
      rate_order: json['rate_order'],
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
      'status': status,
      'rate_order': rate_order,
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
      'create_at': create_at,
      'status': status
    };
  }
}
