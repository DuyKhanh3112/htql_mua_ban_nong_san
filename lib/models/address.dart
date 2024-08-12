class Address {
  String id;
  String buyer_id;
  String province_id;
  String phone;
  String address_detail;

  Address({
    required this.id,
    required this.buyer_id,
    required this.province_id,
    required this.address_detail,
    required this.phone,
  });

  factory Address.initAddress() {
    return Address(
      id: '',
      buyer_id: '',
      province_id: '',
      address_detail: '',
      phone: '',
    );
  }

  static Address fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      buyer_id: json['buyer_id'],
      province_id: json['province_id'],
      address_detail: json['province_id'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyer_id,
      'province_id': province_id,
      'address_detail': address_detail,
      'phone': phone
    };
  }

  Map<String, dynamic> toVal() {
    return {
      'buyer_id': buyer_id,
      'province_id': province_id,
      'address_detail': address_detail,
      'phone': phone
    };
  }
}
