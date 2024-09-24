import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  String id;
  String buyer_id;
  String seller_id;
  String address_id;
  String status;
  double order_amount;
  Timestamp order_date;
  Timestamp? received_date;
  Timestamp update_at;

  Orders({
    required this.id,
    required this.buyer_id,
    required this.seller_id,
    required this.address_id,
    required this.status,
    required this.order_amount,
    required this.order_date,
    required this.update_at,
    this.received_date,
  });

  factory Orders.initOrder() {
    return Orders(
      id: '',
      buyer_id: '',
      seller_id: '',
      address_id: '',
      status: '',
      order_date: Timestamp.now(),
      update_at: Timestamp.now(),
      order_amount: 0,
    );
  }
  static Orders fromJson(Map<String, dynamic> json) {
    return Orders(
      id: json['id'],
      buyer_id: json['buyer_id'],
      seller_id: json['seller_id'],
      address_id: json['address_id'],
      status: json['status'],
      order_amount: json['order_amount'],
      order_date: json['order_date'],
      update_at: json['update_at'],
      received_date: json['received_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyer_id,
      'seller_id': seller_id,
      'address_id': address_id,
      'status': status,
      'order_amount': order_amount,
      'order_date': order_date,
      'update_at': update_at,
      'received_date': received_date,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'buyer_id': buyer_id,
      'seller_id': seller_id,
      'address_id': address_id,
      'status': status,
      'order_amount': order_amount,
      'order_date': order_date,
      'update_at': update_at,
      'received_date': received_date,
    };
  }
}
