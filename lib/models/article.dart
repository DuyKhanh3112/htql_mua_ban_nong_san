import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String id;
  String admin_id;
  String seller_id;
  String status;
  String? content;
  String? title;
  Timestamp create_at;

  Article({
    required this.id,
    required this.admin_id,
    required this.seller_id,
    required this.status,
    required this.create_at,
    this.content,
    this.title,
  });

  factory Article.initArticle() {
    return Article(
      id: '',
      admin_id: '',
      seller_id: '',
      status: '',
      create_at: Timestamp.now(),
      title: '',
      content: '',
    );
  }
  static Article fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      admin_id: json['admin_id'],
      seller_id: json['seller_id'],
      status: json['status'],
      create_at: json['create_at'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': admin_id,
      'seller_id': seller_id,
      'status': status,
      'create_at': create_at,
      'title': title,
      'content': content
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'admin_id': admin_id,
      'seller_id': seller_id,
      'status': status,
      'create_at': create_at,
      'title': title,
      'content': content
    };
  }
}
