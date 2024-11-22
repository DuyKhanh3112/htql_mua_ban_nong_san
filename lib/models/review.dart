import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String id;
  String order_id;
  String comment;
  double ratting;
  String? response;
  Timestamp create_at;
  Timestamp update_at;

  Review({
    required this.id,
    required this.order_id,
    required this.comment,
    required this.ratting,
    required this.create_at,
    required this.update_at,
    this.response,
  });

  factory Review.initReview() {
    return Review(
      id: '',
      order_id: '',
      comment: '',
      ratting: 5,
      create_at: Timestamp.now(),
      update_at: Timestamp.now(),
      response: '',
    );
  }
  static Review fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      order_id: json['order_id'],
      comment: json['comment'],
      ratting: json['ratting'],
      create_at: json['create_at'],
      update_at: json['update_at'],
      response: json['response'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': order_id,
      'comment': comment,
      'ratting': ratting,
      'create_at': create_at,
      'update_at': update_at,
      'response': response,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'order_id': order_id,
      'comment': comment,
      'ratting': ratting,
      'create_at': create_at,
      'update_at': update_at,
      'response': response,
    };
  }
}
