class Product {
  String id;
  String category_id;
  String? description;
  double? expripy_date;
  String name;
  double price;
  String province_id;
  double quantity;
  String seller_id;
  String status_id;
  String? unit;

  Product({
    required this.id,
    required this.name,
    required this.category_id,
    required this.seller_id,
    required this.price,
    required this.description,
    required this.province_id,
    required this.quantity,
    required this.status_id,
    this.expripy_date,
    this.unit,
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
      status_id: '',
      expripy_date: 0,
      unit: '',
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
      status_id: json['status_is'],
      expripy_date: json['expripy_date'],
      unit: json['unit'] ?? '',
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
      'status_id': status_id,
      'expripy_date': expripy_date,
      'unit': unit,
    };
  }
}
