import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cloudinary_controller.dart';
import 'package:htql_mua_ban_nong_san/models/banner.dart';

class BannerController extends GetxController {
  RxBool isLoading = false.obs;

  CollectionReference bannerCollection =
      FirebaseFirestore.instance.collection('Banner');
  RxList<BannerApp> listBanner = <BannerApp>[].obs;

  Future<void> loadBanner() async {
    isLoading.value = true;
    listBanner.value = [];
    final snapshoot = await bannerCollection.get();
    for (var item in snapshoot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listBanner.add(BannerApp.fromJson(data));
    }
    listBanner.sort(
      (a, b) => b.create_at.compareTo(a.create_at),
    );
    isLoading.value = false;
  }

  Future<void> deleteBanner(BannerApp banner) async {
    isLoading.value = true;
    await bannerCollection.doc(banner.id).delete();
    await CloudinaryController().deleteImage(banner.id, 'banner/');
    listBanner.remove(banner);
    isLoading.value = false;
  }

  Future<void> createBanner(List listFilePath) async {
    // isLoading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var filePath in listFilePath) {
      String id = bannerCollection.doc().id;

      String? url =
          await CloudinaryController().uploadImage(filePath, id, 'banner/');
      if (url != null) {
        DocumentReference refBanner = bannerCollection.doc(id);
        batch.set(refBanner,
            BannerApp(id: id, image: url, create_at: Timestamp.now()).toVal());
      }
    }

    await batch.commit();

    isLoading.value = false;
  }

  Future<void> saveBanner(List<BannerApp> banners, List listFilePath) async {
    isLoading.value = true;
    for (var item in listBanner.where(
      (p0) => !(banners
          .map(
            (e) => e.id,
          )
          .toList()
          .contains(p0.id)),
    )) {
      await CloudinaryController().deleteImage(item.id, 'banner');
      await bannerCollection.doc(item.id).delete();
    }
    await createBanner(listFilePath);
    await loadBanner();
    isLoading.value = false;
  }
}
