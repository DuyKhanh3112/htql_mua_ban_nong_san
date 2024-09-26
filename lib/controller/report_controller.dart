// import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  static ReportController get to => Get.find<ReportController>();

  RxBool isLoading = false.obs;

  // Rx<DateRange> selectedDateRange =
  //     DateRange(DateTime.now(), DateTime.now()).obs;
}
