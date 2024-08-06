class Status {
  String id;
  String name;

  Status({
    required this.id,
    required this.name,
  });

  factory Status.initStatus() {
    return Status(
      id: '',
      name: '',
    );
  }
  static Status fromJson(Map<String, dynamic> json) {
    return Status(
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
}
