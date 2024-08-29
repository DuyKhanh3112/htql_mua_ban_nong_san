class ProductImage {
  String id;
  String product_id;
  String image;
  bool is_default;

  ProductImage({
    required this.id,
    required this.product_id,
    required this.image,
    required this.is_default,
  });

  factory ProductImage.initProductImage() {
    return ProductImage(
      id: '',
      product_id: '',
      image: '',
      is_default: false,
    );
  }
  static ProductImage fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      product_id: json['product_id'],
      image: json['image'],
      is_default: json['is_default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': product_id,
      'image': image,
      'is_default': is_default,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'product_id': product_id,
      'image': image,
      'is_default': is_default
    };
  }
}
