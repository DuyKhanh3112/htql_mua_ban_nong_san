class ProductImage {
  String id;
  String product_id;
  String image;

  ProductImage({
    required this.id,
    required this.product_id,
    required this.image,
  });

  factory ProductImage.initProductImage() {
    return ProductImage(
      id: '',
      product_id: '',
      image: '',
    );
  }
  static ProductImage fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      product_id: json['product_id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': product_id,
      'image': image,
    };
  }
}
