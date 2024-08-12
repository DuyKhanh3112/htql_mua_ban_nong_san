class OrderStatus {
  String id;
  String name;

  OrderStatus({
    required this.id,
    required this.name,
  });

  factory OrderStatus.initOrderStatus() {
    return OrderStatus(
      id: '',
      name: '',
    );
  }
  static OrderStatus fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'name': name,
    };
  }
}
