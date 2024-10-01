import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/models/order.dart';

class ReportController extends GetxController {
  static ReportController get to => Get.find<ReportController>();

  RxBool isLoading = false.obs;
  RxList<OrdinalData> reportOrderStatus = <OrdinalData>[].obs;
  Rx<DateTimeRange> selectedDateRangeOrder =
      DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;

  Future<void> showReportOrder() async {
    isLoading.value = true;
    reportOrderStatus.value = [];
    final snapshot = await Get.find<OrderController>()
        .orderCollection
        .where('seller_id',
            isEqualTo: Get.find<MainController>().seller.value.id)
        .where('order_date',
            isLessThanOrEqualTo: selectedDateRangeOrder.value.end)
        .where('order_date',
            isGreaterThanOrEqualTo: selectedDateRangeOrder.value.start)
        .get();
    if (snapshot.docs.isNotEmpty) {
      for (var item in Get.find<OrderController>().listStatus) {
        final order = await Get.find<OrderController>()
            .orderCollection
            .where('status', isEqualTo: item['value'])
            .where('seller_id',
                isEqualTo: Get.find<MainController>().seller.value.id)
            .where('order_date',
                isLessThanOrEqualTo: selectedDateRangeOrder.value.end)
            .where('order_date',
                isGreaterThanOrEqualTo: selectedDateRangeOrder.value.start)
            .get();
        double total = 0;

        for (var o in order.docs) {
          Map<String, dynamic> val = o.data() as Map<String, dynamic>;
          val['id'] = o.id;
          total += Orders.fromJson(val).order_amount;
        }
        reportOrderStatus.add(
          OrdinalData(
              domain: item['label'],
              measure: order.docs.length,
              color: item['color'],
              other: {
                'rate': order.docs.length / snapshot.docs.length,
                'revenue': total,
              }),
        );

        // reportOrderStatusBarCustom.add(
        //   DChartBarDataCustom(
        //     value: order.docs.length.toDouble(),
        //     label: item['label'],
        //     showValue: true,
        //     valueTooltip: '${order.docs.length} đơn hàng',
        //     color: (item['color'] as Color).withOpacity(1),
        //     valueStyle: const TextStyle(color: Colors.white),
        //   ),
        // );
      }
    }

    isLoading.value = false;
  }
}
