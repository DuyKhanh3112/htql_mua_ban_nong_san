// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/register_page.dart';
import 'package:htql_mua_ban_nong_san/utils/initial_binding.dart';
import 'package:htql_mua_ban_nong_san/views/home_page.dart';
import 'package:htql_mua_ban_nong_san/login_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/admin_home_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/category/category_home_page.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/personal_admin_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/product/product_home_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_buyer/cart_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_buyer/product/product_details_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/home_seller_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/product/product_seller_form_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/product/product_seller_home_page.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBf4T6R7lIPtzjFgbORbqW6QYnJIpqMXpo',
      appId: '1:427833122170:android:8d4307ef57b689e2accac3',
      messagingSenderId: '427833122170',
      projectId: 'htql-mua-ban-nong-san-e57a4',
      storageBucket: 'htql-mua-ban-nong-san-e57a4.appspot.com',
    ),
  );

  // await GetStorage.init();

  Get.config(
    enableLog: false,
    defaultTransition: Transition.native,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      enableLog: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
        Locale('fr'),
      ],
      locale: const Locale('vi'),
      initialRoute: "/",
      initialBinding: InitialBindings(),
      getPages: [
        GetPage(name: "/", page: () => const HomePage()),
        GetPage(name: "/login", page: () => const LoginPage()),
        GetPage(name: "/register", page: () => const RegisterPage()),
        GetPage(name: "/personal_admin", page: () => const PersonalAdminPage()),
        GetPage(name: "/cart", page: () => const CartPage()),
        GetPage(name: "/category", page: () => const CategoryHomePage()),
        GetPage(name: '/product_admin', page: () => const ProductHomePage()),
        GetPage(name: '/admin', page: () => const AdminHomePage()),
        GetPage(name: '/seller', page: () => const HomeSellerPage()),
        GetPage(
            name: '/product_seller', page: () => const ProductSellerHomePage()),
        GetPage(
            name: '/product_form', page: () => const ProductSellerFormPage()),
        GetPage(name: '/product_detail', page: () => ProductDetailPage()),
      ],
    );
  }
}
