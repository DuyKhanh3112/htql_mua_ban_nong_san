import 'package:cloud_firestore/cloud_firestore.dart';

class BannerApp {
  String id;
  String image;
  Timestamp create_at;

  BannerApp({
    required this.id,
    required this.image,
    required this.create_at,
  });

  factory BannerApp.initBannerApp() {
    return BannerApp(
      id: '',
      image: '',
      create_at: Timestamp.now(),
    );
  }
  static BannerApp fromJson(Map<String, dynamic> json) {
    return BannerApp(
      id: json['id'],
      image: json['image'],
      create_at: json['create_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'create_at': create_at,
    };
  }

  Map<String, dynamic> toVal() {
    return {
      // 'id': id,
      'image': image,
      'create_at': create_at,
    };
  }
}
