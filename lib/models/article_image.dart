class ArticleImage {
  String id;
  String article_id;
  String image;

  ArticleImage({
    required this.id,
    required this.article_id,
    required this.image,
  });

  factory ArticleImage.initArticleImage() {
    return ArticleImage(
      id: '',
      article_id: '',
      image: '',
    );
  }
  static ArticleImage fromJson(Map<String, dynamic> json) {
    return ArticleImage(
      id: json['id'],
      article_id: json['article_id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'article_id': article_id,
      'image': image,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'article_id': article_id,
      'image': image,
    };
  }
}
