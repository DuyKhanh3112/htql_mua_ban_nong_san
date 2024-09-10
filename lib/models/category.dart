class Category {
  String id;
  String name;
  String image;
  bool hide;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.hide,
  });

  factory Category.initCategory() {
    return Category(
      id: '',
      name: '',
      image: '',
      hide: false,
    );
  }
  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      hide: json['hide'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'hide': hide,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'name': name,
      'image': image,
      'hide': hide,
    };
  }
}
