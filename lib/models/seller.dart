class Seller {
  String id;
  String? avatar;
  String? cover;
  String? email;
  String name;
  String phone;
  String username;
  String password;
  String status_id;
  DateTime create_at;
  String address_detail;
  String province_id;
  double? ratting;
  String? tax_code;

  Seller({
    required this.id,
    required this.username,
    this.email,
    required this.phone,
    required this.password,
    required this.name,
    required this.create_at,
    required this.status_id,
    this.avatar,
    this.cover,
    required this.address_detail,
    required this.province_id,
    this.ratting,
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
      create_at: DateTime.now(),
      status_id: '',
      address_detail: '',
      province_id: '',
      ratting: 0,
      tax_code: '',
    );
  }

  static Seller fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['mail'],
      password: json['password'],
      name: json['name'],
      avatar: json['avatar'] ?? '',
      cover: json['cover'] ?? '',
      create_at: json['create_at'],
      status_id: json['status_id'],
      address_detail: json['addredd_id'],
      province_id: json['province_id'],
      ratting: json['ratting'],
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
      'status_id': status_id,
      'address_detail': address_detail,
      'province_id': province_id,
      'ratting': ratting,
      'tax_code': tax_code,
    };
  }
}
