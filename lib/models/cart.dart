import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String id;
  String product_id;
  String buyer_id;
  double quantity;
  Timestamp create_at;

  Cart({
    required this.id,
    required this.buyer_id,
    required this.product_id,
    required this.quantity,
    required this.create_at,
  });

  factory Cart.initCart() {
    return Cart(
      id: '',
      buyer_id: '',
      product_id: '',
      quantity: 0,
      create_at: Timestamp.now(),
    );
  }
  static Cart fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      buyer_id: json['buyer_id'],
      product_id: json['product_id'],
      quantity: double.parse(json['quantity'].toString()),
      create_at: json['create_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyer_id,
      'product_id': product_id,
      'quantity': quantity,
      'create_at': create_at,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'buyer_id': buyer_id,
      'product_id': product_id,
      'quantity': quantity,
      'create_at': create_at,
    };
  }
}
