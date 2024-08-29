import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
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
  String address_detail;
  String province_id;
  String? tax_code;

  Seller({
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
    required this.address_detail,
    required this.province_id,
    this.tax_code,
  });

  factory Seller.initSeller() {
    return Seller(
      id: '',
      username: '',
      email: '',
      phone: '',
      password: '',
      name: '',
      avatar: '',
      cover: '',
      create_at: Timestamp.now(),
      status: '',
      address_detail: '',
      province_id: 'draft',
      tax_code: '',
    );
  }

  static Seller fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      name: json['name'],
      avatar: json['avatar'] ?? '',
      cover: json['cover'] ?? '',
      create_at: json['create_at'],
      status: json['status'],
      address_detail: json['address_detail'],
      province_id: json['province_id'],
      tax_code: json['tax_code'] ?? '',
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
      'address_detail': address_detail,
      'province_id': province_id,
      'tax_code': tax_code,
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
      'status': status,
      'address_detail': address_detail,
      'province_id': province_id,
      'tax_code': tax_code,
    };
  }
}
