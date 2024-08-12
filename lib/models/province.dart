class Province {
  String id;
  String name;

  Province({
    required this.id,
    required this.name,
  });

  factory Province.initProvince() {
    return Province(
      id: '',
      name: '',
    );
  }
  static Province fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      'id': id,
      'name': name,
    };
  }
}
