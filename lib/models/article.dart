class Article {
  String id;
  String admin_id;
  String seller_id;
  String status_id;
  String? content;
  String? title;
  DateTime create_at;

  Article({
    required this.id,
    required this.admin_id,
    required this.seller_id,
    required this.status_id,
    required this.create_at,
    this.content,
    this.title,
  });

  factory Article.initArticle() {
    return Article(
      id: '',
      admin_id: '',
      seller_id: '',
      status_id: '',
      create_at: DateTime.now(),
      title: '',
      content: '',
    );
  }
  static Article fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      admin_id: json['admin_id'],
      seller_id: json['seller_id'],
      status_id: json['status_id'],
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
      'status_id': status_id,
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
      'status_id': status_id,
      'create_at': create_at,
      'title': title,
      'content': content
    };
  }
}
