class Address {
  String id;
  String buyer_id;
  String province_id;
  String name;
  String phone;
  String address_detail;
  bool is_default;

  Address({
    required this.id,
    required this.name,
    required this.buyer_id,
    required this.province_id,
    required this.address_detail,
    required this.phone,
    required this.is_default,
  });

  factory Address.initAddress() {
    return Address(
      id: '',
      buyer_id: '',
      name: '',
      province_id: '',
      address_detail: '',
      phone: '',
      is_default: false,
    );
  }

  static Address fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      buyer_id: json['buyer_id'],
      province_id: json['province_id'],
      address_detail: json['address_detail'],
      phone: json['phone'],
      is_default: json['is_default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyer_id,
      'name': name,
      'province_id': province_id,
      'address_detail': address_detail,
      'phone': phone,
      'is_default': is_default,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      'buyer_id': buyer_id,
      'name': name,
      'province_id': province_id,
      'address_detail': address_detail,
      'phone': phone,
      'is_default': is_default,
    };
  }
}
