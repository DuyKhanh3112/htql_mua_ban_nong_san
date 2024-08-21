import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String buyer_id;
  String seller_id;
  String order_status_id;
  double order_amount;
  Timestamp order_date;
  Timestamp? received_date;

  Order({
    required this.id,
    required this.buyer_id,
    required this.seller_id,
    required this.order_status_id,
    required this.order_amount,
    required this.order_date,
    this.received_date,
  });

  factory Order.initOrder() {
    return Order(
      id: '',
      buyer_id: '',
      seller_id: '',
      order_status_id: '',
      order_date: Timestamp.now(),
      order_amount: 0,
    );
  }
  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      buyer_id: json['buyer_id'],
      seller_id: json['seller_id'],
      order_status_id: json['order_status_id'],
      order_amount: json['order_amount'],
      order_date: json['order_date'],
      received_date: json['received_date'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer_id': buyer_id,
      'seller_id': seller_id,
      'order_status_id': order_status_id,
      'order_amount': order_amount,
      'order_date': order_date,
      'received_date': received_date,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'buyer_id': buyer_id,
      'seller_id': seller_id,
      'order_status_id': order_status_id,
      'order_amount': order_amount,
      'order_date': order_date,
      'received_date': received_date,
    };
  }
}
