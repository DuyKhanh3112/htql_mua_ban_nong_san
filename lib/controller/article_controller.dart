import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cloudinary_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/models/article.dart';
import 'package:htql_mua_ban_nong_san/models/article_image.dart';

class ArticleController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt numPage = 0.obs;
  CollectionReference articleCollection =
      FirebaseFirestore.instance.collection('Article');
  CollectionReference articleImageCollection =
      FirebaseFirestore.instance.collection('ArticleImage');

  RxList<Article> listArticle = <Article>[].obs;
  RxList<ArticleImage> listArticleImage = <ArticleImage>[].obs;
  Rx<Article> article = Article.initArticle().obs;
  Rx<DocumentSnapshot>? offset;
  RxInt limit = 10.obs;
  RxBool isContinute = false.obs;

  RxList<dynamic> listStatus = [
    {
      'value': 'draft',
      'label': 'Chưa được duyệt',
    },
    {
      'value': 'active',
      'label': 'Đã duyệt',
    },
  ].obs;

  Future<void> createArticle(List<dynamic> listImage) async {
    isLoading.value = true;
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String newArticleID = articleCollection.doc().id;
    DocumentReference refBuyer = articleCollection.doc(newArticleID);
    batch.set(refBuyer, article.value.toVal());
    // article.value.id = newArticleID;
    // listArticle.add(article.value);
    for (var img in listImage) {
      await createArticleImage(img, newArticleID);
    }

    await batch.commit();
    loadArticleBySeller();
    isLoading.value = false;
  }

  Future<void> deleteArticle() async {
    isLoading.value = true;
    for (var articleImg
        in listArticleImage.where((p0) => p0.article_id == article.value.id)) {
      await CloudinaryController()
          .deleteImage(articleImg.id, 'article/${article.value.id}/');
      await articleImageCollection.doc(articleImg.id).delete();
      listArticleImage.removeWhere((element) => element.id == articleImg.id);
    }
    await articleCollection.doc(article.value.id).delete();
    listArticle.removeWhere((element) => element.id == article.value.id);

    isLoading.value = false;
  }

  Future<void> createArticleImage(img, String newArticleID) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String articleImgID = articleImageCollection.doc().id;
    DocumentReference refImg = articleImageCollection.doc(articleImgID);
    String? url = await CloudinaryController().uploadImage(
        img, articleImageCollection.doc().id, 'article/$newArticleID/');
    if (url != null) {
      ArticleImage articleImage =
          ArticleImage(id: articleImgID, article_id: newArticleID, image: url);
      batch.set(refImg, articleImage.toVal());
    }
    await batch.commit();
  }

  Future<void> updateArticle(
      List<dynamic> listImage, List<ArticleImage> listArticleImg) async {
    isLoading.value = true;
    await articleCollection.doc(article.value.id).update(article.value.toVal());
    for (var img in listArticleImage.where((p0) =>
        p0.article_id == article.value.id &&
        !listArticleImg.map((e) => e.id).toList().contains(p0.id))) {
      await articleImageCollection.doc(img.id).delete();
      CloudinaryController()
          .deleteImage(img.id, 'article/${article.value.id}/');
    }
    for (var img in listImage) {
      await createArticleImage(img, article.value.id);
    }
    loadAllArticle();
    isLoading.value = false;
  }

  Future<void> loadArticleBySeller() async {
    isLoading.value = true;
    listArticle.value = [];
    listArticleImage.value = [];
    var snapshot = await articleCollection
        .where('seller_id',
            isEqualTo: Get.find<MainController>().seller.value.id)
        .get();
    for (var item in snapshot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listArticle.add(Article.fromJson(data));
      await loadArticleImage(data['id']);
    }
    listArticle.sort((b, a) => a.update_at.compareTo(b.update_at));
    isLoading.value = false;
  }

  Future<void> loadAllArticleActive() async {
    isLoading.value = true;
    listArticle.value = [];
    listArticleImage.value = [];
    var snapshot = await articleCollection
        .where('status', isEqualTo: 'active')
        .where('seller_id',
            whereIn: Get.find<SellerController>()
                .listSeller
                .where((p0) => p0.status == 'active')
                .map((e) => e.id)
                .toList())
        .get();
    for (var item in snapshot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listArticle.add(Article.fromJson(data));
      await loadArticleImage(data['id']);
    }
    listArticle.sort((b, a) => a.update_at.compareTo(b.update_at));
    isLoading.value = false;
  }

  Future<void> loadAllArticle() async {
    isLoading.value = true;
    listArticle.value = [];
    listArticleImage.value = [];
    var snapshot = await articleCollection
        .where('seller_id',
            whereIn: Get.find<SellerController>()
                .listSeller
                .where((p0) => p0.status == 'active')
                .map((e) => e.id)
                .toList())
        .get();
    for (var item in snapshot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listArticle.add(Article.fromJson(data));
      await loadArticleImage(data['id']);
    }
    listArticle.sort((b, a) => a.update_at.compareTo(b.update_at));
    isLoading.value = false;
  }

  // Future<void> loadAllArticle() async {
  //   isLoading.value = true;
  //   listArticle.value = [];
  //   listArticleImage.value = [];
  //   await loadArticleLimit();
  //   isLoading.value = false;
  // }

  Future<void> loadArticleLimit() async {
    isLoading.value = true;
    var query = articleCollection.orderBy('update_at');
    if (offset != null) {
      query = query.startAfterDocument(offset!.value).limit(limit.value);
    } else {
      query = query.limit(limit.value);
    }
    var snapshot = await query.get();

    for (var item in snapshot.docs) {
      offset!.value = item;
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listArticle.add(Article.fromJson(data));
      isContinute.value = true;
      if (item == (await articleCollection.get()).docs.last) {
        isContinute.value = false;
        break;
      }
      await loadArticleImage(data['id']);
    }
    isLoading.value = false;
  }

  Future<void> loadArticleImage(String articleID) async {
    var snapshot = await articleImageCollection
        .where('article_id', isEqualTo: articleID)
        .get();
    for (var item in snapshot.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      listArticleImage.add(ArticleImage.fromJson(data));
    }
  }
}
