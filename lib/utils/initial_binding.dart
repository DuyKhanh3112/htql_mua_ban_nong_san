import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
// import 'package:htql_mua_ban_nong_san/controller/user_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() async {
    await mainController();
  }

  Future<void> mainController() async {
    Get.put(MainController(), permanent: true);
  }
}
