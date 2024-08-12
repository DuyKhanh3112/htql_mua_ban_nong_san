import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:htql_mua_ban_nong_san/register_page.dart';
import 'package:htql_mua_ban_nong_san/utils/initial_binding.dart';
import 'package:htql_mua_ban_nong_san/views/home_page.dart';
import 'package:htql_mua_ban_nong_san/login_page.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/home_admin_page.dart';

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

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
      initialRoute: "/login",
      initialBinding: InitialBindings(),
      getPages: [
        GetPage(name: "/", page: () => const HomePage()),
        GetPage(name: "/login", page: () => const LoginPage()),
        GetPage(name: "/register", page: () => const RegisterPage()),
        GetPage(name: "/admin", page: () => const HomeAdminPage()),
      ],
    );
  }
}
