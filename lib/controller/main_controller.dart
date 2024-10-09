import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/address_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/models/admin.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:htql_mua_ban_nong_san/models/buyer.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/account/admin_information_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/article/article_admin_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/buyer/buyer_home_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/category/category_home_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/product/product_home_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/report/report_buyer_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/report/report_seller_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/seller/seller_home_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_buyer/account_setting_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_buyer/article/article_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_buyer/category/category_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_buyer/home_buyer_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/account/seller_information_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/article/article_seller_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/order/order_seller_home_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/product/product_seller_home_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/report/report_product_seller_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/report/report_sell_seller_page.dart';

class MainController extends GetxController {
  static MainController get to => Get.find<MainController>();

  Rx<Buyer> buyer = Buyer.initBuyer().obs;
  Rx<Seller> seller = Seller.initSeller().obs;
  Rx<Admin> admin = Admin.initAdmin().obs;

  CollectionReference adminCollection =
      FirebaseFirestore.instance.collection('Admin');
  CollectionReference buyerCollection =
      FirebaseFirestore.instance.collection('Buyer');
  CollectionReference sellerCollection =
      FirebaseFirestore.instance.collection('Seller');
  CollectionReference provinceCollection =
      FirebaseFirestore.instance.collection('Province');

  Future<void> createProvince(String name) async {
    isLoading.value = true;
    Province province = Province(id: '', name: name);
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String newProvinceId = provinceCollection.doc().id;
    DocumentReference refProvince = provinceCollection.doc(newProvinceId);
    batch.set(refProvince, province.toVal());

    await batch.commit();
    isLoading.value = false;
  }

  RxBool isLoading = false.obs;

  List<Widget> page = [
    const HomeUserPage(),
    const CategoryPage(),
    const ArticlePage(),
    const AccountSettingPage(),
  ];
  List<Widget> pageAdmin = [
    const AdminInformationPage(), // personal information 0
    const BuyerHomePage(), //buyer 1
    const SellerHomePage(), //seller 2
    const CategoryHomePage(), //3
    const CategoryHomePage(), //Province 4
    const ProductHomePage(), //5
    const ArticleAdminPage(), //6
    const ReportSellerPage(), //7
    const ReportBuyerPage(), //8
  ];
  RxInt indexAdmin = 0.obs;
  // List<String> titleAdmin = [
  //   'Thông tin cá nhân',
  //   'Người mua',
  //   'Người bán',
  //   'Loại sản phẩm',
  //   'Tỉnh thành phố',
  //   'Sản phẩm',
  // ];

  List<Widget> pageSeller = [
    const SellerInformationPage(), //0
    const ProductSellerHomePage(), //1
    const OrderSellerHomePage(), //2
    const ArticleSellerPage(), //3
    const ReportSellSellerPage(), //4
    const ReportProductSellerPage(), //5
  ];
  RxInt indexSeller = 0.obs;
  List<String> titleSeller = [
    'Thông tin cá nhân',
    'Sản phẩm',
  ];

  List<String> titles = [
    'Home',
    'Danh Muc',
    'Don Hang',
    'San Pham',
    'tai khoan'
  ];

  RxInt numPage = 0.obs;

  RxList<Province> listProvince = <Province>[].obs;

  Future<bool> checkInternet() async {
    isLoading.value = true;
    var connectivityResult = await Connectivity().checkConnectivity();
    isLoading.value = false;
    // ignore: unrelated_type_equality_checks
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> login(String uname, String pword) async {
    isLoading.value = true;

    //login with buyer
    final snapshot = await buyerCollection
        .where('username', isEqualTo: uname)
        .where('password', isEqualTo: pword)
        // .where('status', isNotEqualTo: 'inactive')
        .get();
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshot.docs[0].data() as Map<String, dynamic>;
      data['id'] = snapshot.docs[0].id;

      buyer.value = Buyer.fromJson(data);
      await Get.find<CartController>().loadCartByBuyer();
      await Get.find<AddressController>().loadAddressBuyer();
      await Get.find<ProductController>().loadProductBoughtByBuyer();
      // Get.toNamed('/');
      isLoading.value = false;
      return true;
    }

    //login with seller
    final snapshotSeller = await sellerCollection
        .where('username', isEqualTo: uname)
        .where('password', isEqualTo: pword)
        // .where('status', isNotEqualTo: 'inactive')
        .get();
    if (snapshotSeller.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshotSeller.docs[0].data() as Map<String, dynamic>;
      data['id'] = snapshotSeller.docs[0].id;

      seller.value = Seller.fromJson(data);
      Get.toNamed('/seller');
      isLoading.value = false;
      return true;
    }

    //login Admin
    final snapshotAdmin = await adminCollection
        .where('username', isEqualTo: uname)
        .where('password', isEqualTo: pword)
        .get();
    if (snapshotAdmin.docs.isNotEmpty) {
      Map<String, dynamic> data =
          snapshotAdmin.docs[0].data() as Map<String, dynamic>;
      data['id'] = snapshotAdmin.docs[0].id;
      admin.value = Admin.fromJson(data);
      Get.toNamed('/admin');
      isLoading.value = false;
      return true;
    }
    isLoading.value = false;
    return false;
  }

  // Future<void> logout() async {
  //   buyer.value = Buyer.initBuyer();
  //   admin.value= Admin.initAdmin();
  //   seller.value= Seller.initSeller();

  // }

  Future<void> loadAll() async {
    isLoading.value = true;
    await Get.find<ProvinceController>().loadProvince();
    await Get.find<CategoryController>().loadCategory();
    await Get.find<SellerController>().loadSeller();
    Get.find<ProductController>().loadProductActive();
    // await Get.find<ArticleController>().loadAllArticle();
    isLoading.value = false;
  }

  Future<void> loadProvince() async {
    listProvince.value = [];
    final snapshot = await provinceCollection.get();
    for (var snap in snapshot.docs) {
      Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
      // {'key': value}
      data['id'] = snap.id;
      Province province = Province.fromJson(data);
      // ignore: invalid_use_of_protected_member
      listProvince.value.add(province);
    }
  }
}
