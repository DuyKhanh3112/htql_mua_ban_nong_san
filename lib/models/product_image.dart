class ProductImage {
  String id;
  String product_id;
  String image;
  bool isDefault;

  ProductImage({
    required this.id,
    required this.product_id,
    required this.image,
    required this.isDefault,
  });

  factory ProductImage.initProductImage() {
    return ProductImage(
      id: '',
      product_id: '',
      image: '',
      isDefault: false,
    );
  }
  static ProductImage fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      product_id: json['product_id'],
      image: json['image'],
      isDefault: json['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': product_id,
      'image': image,
      'isDefault': isDefault,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'product_id': product_id,
      'image': image,
      'isDefault': isDefault
    };
  }
}
