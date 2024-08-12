class OrderDetail {
  String id;
  String order_id;
  String product_id;
  double quantity;
  double sell_price;

  OrderDetail({
    required this.id,
    required this.order_id,
    required this.product_id,
    required this.quantity,
    required this.sell_price,
  });

  factory OrderDetail.initOrderDetail() {
    return OrderDetail(
      id: '',
      order_id: '',
      product_id: '',
      quantity: 0,
      sell_price: 0,
    );
  }
  static OrderDetail fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      order_id: json['order_id'],
      product_id: json['product_id'],
      quantity: json['quantity'],
      sell_price: json['sell_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': order_id,
      'product_id': product_id,
      'quantity': quantity,
      'sell_price': sell_price,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'order_id': order_id,
      'product_id': product_id,
      'quantity': quantity,
      'sell_price': sell_price,
    };
  }
}
