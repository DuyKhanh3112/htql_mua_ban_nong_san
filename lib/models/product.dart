import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String category_id;
  String? description;
  double? expripy_date;
  String name;
  dynamic price;
  String province_id;
  dynamic quantity;
  String seller_id;
  String status;
  String unit;
  Timestamp create_at;
  double? sale_num;
  double? ratting;

  Product({
    required this.id,
    required this.name,
    required this.category_id,
    required this.seller_id,
    required this.price,
    this.description,
    required this.province_id,
    required this.quantity,
    required this.status,
    this.expripy_date,
    required this.unit,
    required this.create_at,
    this.sale_num,
    this.ratting,
  });

  factory Product.initProduct() {
    return Product(
      id: '',
      name: '',
      category_id: '',
      seller_id: '',
      price: 0,
      description: '',
      province_id: '',
      quantity: 0,
      status: '',
      expripy_date: 0,
      unit: '',
      create_at: Timestamp.now(),
    );
  }

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category_id: json['category_id'],
      seller_id: json['seller_id'],
      price: json['price'],
      description: json['description'],
      province_id: json['province_id'],
      quantity: json['quantity'],
      status: json['status'],
      expripy_date: json['expripy_date'],
      unit: json['unit'] ?? '',
      create_at: json['create_at'],
      sale_num: json['sale_num'],
      ratting: json['ratting'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': category_id,
      'seller_id': seller_id,
      'price': price,
      'description': description,
      'province_id': province_id,
      'quantity': quantity,
      'status': status,
      'expripy_date': expripy_date,
      'unit': unit,
      'create_at': create_at,
      'sale_num': sale_num,
      'ratting': ratting,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'name': name,
      'category_id': category_id,
      'seller_id': seller_id,
      'price': price,
      'description': description,
      'province_id': province_id,
      'quantity': quantity,
      'status': status,
      'expripy_date': expripy_date,
      'unit': unit, 'create_at': create_at,
    };
  }
}
