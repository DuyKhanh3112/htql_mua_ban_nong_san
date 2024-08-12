class Review {
  String id;
  String order_detail_id;
  String comment;
  double ratting;
  DateTime create_at;

  Review({
    required this.id,
    required this.order_detail_id,
    required this.comment,
    required this.ratting,
    required this.create_at,
  });

  factory Review.initReview() {
    return Review(
      id: '',
      order_detail_id: '',
      comment: '',
      ratting: 0,
      create_at: DateTime.now(),
    );
  }
  static Review fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      order_detail_id: json['order_detail_id'],
      comment: json['comment'],
      ratting: json['ratting'],
      create_at: json['create_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_detail_id': order_detail_id,
      'comment': comment,
      'ratting': ratting,
      'create_at': create_at,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'order_detail_id': order_detail_id,
      'comment': comment,
      'ratting': ratting,
      'create_at': create_at,
    };
  }
}
