import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/address_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/article_controller.dart';
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

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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

  RxString otpCode = ''.obs;
  RxString typeForgot = ''.obs;
  Future<void> sendOtp(String emailSeller) async {
    // isLoading.value = true;
    otpCode.value = (100000 + Random().nextInt(899999)).toString();

    String htmlTxt =
        "<div align='center'><div style='width: 400px;;border-style:solid;border-width:thin;border-color:#dadce0;"
        "border-radius:8px;padding:40px 20px'  align='center'>  <img   "
        "src='https://res.cloudinary.com/dg3p7nxyp/image/upload/v1722935387/app/logo.jpg' height='100' aria-hidden='true'"
        " style='margin-bottom:16px' alt='Google' class='CToWUd' data-bit='iit'>  <div style='border-bottom:thin solid #dadce0;color:rgba(0,0,0,0.87);"
        "line-height:32px;padding-bottom:24px;text-align:center;word-break:break-word'>    <div style='font-size:24px'>"
        " Xin chào $emailSeller !</div>  </div>  <table align='justify' style='margin-top:8px'>    <tbody>      <tr style='line-height:normal'>        "
        "<td>Bạn vừa thực hiện chức năng <b>quên mật khẩu</b> của ứng dụng <b style='font-size: 16pt;'>Nông sản Việt</b>. Vui lòng lấy OTP để tạo mật khẩu mới.</td>      </tr>      <tr>     "
        "   <td>Mã OTP của bạn:</td>      </tr>      <tr> <td align='center'>"
        "  <h1 style='background-color: #7faf51;color: #ffffff;'>${otpCode.value}</h1>        </td>      </tr>  "
        "    <tr>        <td style='color: red;'>Xin vui lòng không cung cấp OTP cho bất kỳ ai !!!</td>      </tr>    </tbody>  "
        "</table></div></div>";
    await sendMail(emailSeller, '[MÃ OTP] Quên mật khẩu', htmlTxt);
    // isLoading.value = false;
  }

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
      Get.find<AddressController>().loadAddressBuyer();
      Get.find<ProductController>().loadProductBoughtByBuyer();
      await Get.find<CartController>().loadCartByBuyer();
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

  Future<void> loadAll() async {
    isLoading.value = true;
    await Get.find<ProvinceController>().loadProvince();
    await Get.find<CategoryController>().loadCategory();
    await Get.find<SellerController>().loadSeller();
    Get.find<ProductController>().loadProductActive();
    Get.find<ArticleController>().loadAllArticle();
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

  Future<void> sendMail(String emailSeller, String subject, String html) async {
    // Thông tin đăng nhập và cấu hình SMTP (ví dụ sử dụng Gmail SMTP)
    const String username = 'nongsanvietdc2096n1@gmail.com';
    const String password = 'ojte fkaa nega uevj';

    // Cấu hình SMTP cho Gmail (hoặc thay đổi cho các nhà cung cấp khác)
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = const Address(username, 'Nông sản Việt')
      ..recipients.add(emailSeller)
      ..subject = subject
      // ..text = text
      ..html = html;

    try {
      // Gửi email
      await send(message, smtpServer);
    } on MailerException catch (e) {
      for (var p in e.problems) {
        // ignore: avoid_print
        print('Lỗi: ${p.code}: ${p.msg}');
      }
    }
  }
}
