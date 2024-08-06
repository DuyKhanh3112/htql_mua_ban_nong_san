class Cart {
  String id;
  String product_id;
  String seller_id;
  String quantity;

  Cart({
    required this.id,
    required this.seller_id,
    required this.product_id,
    required this.quantity,
  });

  factory Cart.initCart() {
    return Cart(
      id: '',
      seller_id: '',
      product_id: '',
      quantity: '',
    );
  }
  static Cart fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      seller_id: json['seller_id'],
      product_id: json['product_id'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_id': seller_id,
      'product_id': product_id,
      'quantity': quantity,
    };
  }
}
