import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/models/buyer.dart';
import 'package:htql_mua_ban_nong_san/models/order.dart';
import 'package:htql_mua_ban_nong_san/models/order_detail.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';

class ReportController extends GetxController {
  static ReportController get to => Get.find<ReportController>();

  RxBool isLoading = false.obs;

  RxList<OrdinalData> reportOrderStatus = <OrdinalData>[].obs;
  RxList<OrdinalData> reportRevenue = <OrdinalData>[].obs;
  RxList<OrdinalData> reportProduct = <OrdinalData>[].obs;
  RxDouble totalRevenue = 0.0.obs;
  Rx<DateTimeRange> selectedDateRangeOrder =
      DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;

  RxList<OrdinalData> reportProductStatus = <OrdinalData>[].obs;

  //admin
  Rx<DateTimeRange> selectedDateRangeSeller =
      DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;
  Rx<DateTimeRange> selectedDateRangeBuyer =
      DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;

  RxList<OrdinalData> reportBuyer = <OrdinalData>[].obs;
  RxList<OrdinalData> reportSeller = <OrdinalData>[].obs;

  RxInt countBuyer = 0.obs;
  RxInt countSeller = 0.obs;

  Future<void> showReportBuyer() async {
    isLoading.value = true;
    reportBuyer.value = [];
    final snapBuyer = await Get.find<BuyerController>()
        .buyerCollection
        .where('create_at',
            isLessThanOrEqualTo: selectedDateRangeBuyer.value.end)
        .where('create_at',
            isGreaterThanOrEqualTo: selectedDateRangeBuyer.value.start)
        .get();
    List<Buyer> listBuyer = [];
    for (var item in snapBuyer.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      data['rate_order'] =
          await Get.find<OrderController>().getRateSuccessByBuyer(item.id);
      if (data['status'] == 'active' && data['rate_order'] < 80) {
        data['status'] = 'warning';
      }
      listBuyer.add(Buyer.fromJson(data));
    }
    countBuyer.value = listBuyer.length;
    if (countBuyer.value != 0) {
      for (var status in Get.find<BuyerController>().listStatus) {
        var dataBuyer =
            listBuyer.where((element) => element.status == status['value']);
        // if (dataBuyer.isNotEmpty) {
        reportBuyer.add(
          OrdinalData(
              domain: status['label'],
              measure: dataBuyer.length,
              color: status['color'],
              other: {
                'rate': dataBuyer.length / countBuyer.value,
                // 'revenue': total,
              }),
        );
        // }
      }
    }
    isLoading.value = false;
  }

  Future<void> showReportSeller() async {
    isLoading.value = true;
    reportSeller.value = [];
    final snapSeller = await Get.find<SellerController>()
        .sellerCollection
        .where('create_at',
            isLessThanOrEqualTo: selectedDateRangeSeller.value.end)
        .where('create_at',
            isGreaterThanOrEqualTo: selectedDateRangeSeller.value.start)
        .get();
    List<Seller> listSeller = [];
    for (var item in snapSeller.docs) {
      Map<String, dynamic> data = item.data() as Map<String, dynamic>;
      data['id'] = item.id;
      int countLock =
          await Get.find<ProductController>().getProductLock(item.id);
      if (countLock >= 3 && data['status'] != 'inactive') {
        data['status'] = 'warning';
      }
      listSeller.add(Seller.fromJson(data));
    }
    countSeller.value = listSeller.length;
    if (countSeller.value != 0) {
      for (var status in Get.find<SellerController>().listStatus) {
        var dataSeller =
            listSeller.where((element) => element.status == status['value']);
        // if (dataBuyer.isNotEmpty) {
        reportSeller.add(
          OrdinalData(
              domain: status['label'],
              measure: dataSeller.length,
              color: status['color'],
              other: {
                'rate': dataSeller.length / countSeller.value,
                // 'revenue': total,
              }),
        );
        // }
      }
    }
    isLoading.value = false;
  }

  Future<void> showReportOrder() async {
    isLoading.value = true;
    reportOrderStatus.value = [];
    reportProduct.value = [];
    reportRevenue.value = [];
    totalRevenue.value = 0;
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
      // order
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
      }

      //product
      final snapProduct = await Get.find<ProductController>()
          .productCollection
          .where('seller_id',
              isEqualTo: Get.find<MainController>().seller.value.id)
          .get();
      for (var pro in snapProduct.docs) {
        // đã bán
        Map<String, dynamic> product = pro.data() as Map<String, dynamic>;
        product['id'] = pro.id;
        int quantity = 0;

        final snapODD = await Get.find<OrderController>()
            .orderDetailCollection
            .where('product_id', isEqualTo: product['id'])
            .where('order_id',
                whereIn: snapshot.docs
                    .where((element) =>
                        (element.data() as Map<String, dynamic>)['status'] !=
                        'failed')
                    .map((e) => e.id)
                    .toList())
            .get();
        for (var odd in snapODD.docs) {
          quantity +=
              ((odd.data() as Map<String, dynamic>)['quantity'] as num).toInt();
        }

        reportProduct.add(
          OrdinalData(domain: product['name'], measure: quantity),
        );

        // doanh thu

        final snapODDRevenue = await Get.find<OrderController>()
            .orderDetailCollection
            .where('product_id', isEqualTo: product['id'])
            .where('order_id',
                whereIn: snapshot.docs
                    .where((element) =>
                        (element.data() as Map<String, dynamic>)['status'] ==
                        'delivered')
                    .map((e) => e.id)
                    .toList())
            .get();
        double revenue = 0;

        for (var odd in snapODDRevenue.docs) {
          Map<String, dynamic> dataODD = odd.data() as Map<String, dynamic>;
          dataODD['id'] = odd.id;
          revenue += OrderDetail.fromJson(dataODD).quantity *
              OrderDetail.fromJson(dataODD).sell_price;
        }
        totalRevenue.value += revenue;
        reportRevenue.add(
          OrdinalData(domain: product['name'], measure: revenue),
        );
      }
    }
    reportRevenue.sort((b, a) => a.measure.compareTo(b.measure));
    reportProduct.sort((b, a) => a.measure.compareTo(b.measure));

    isLoading.value = false;
  }

  Future<void> showReportProduct() async {
    isLoading.value = true;
    reportProductStatus.value = [];
    await Get.find<ProductController>().loadProductAllBySeller();
    if (Get.find<ProductController>().listProduct.isNotEmpty) {
      for (var status in Get.find<ProductController>().listStatus) {
        if (Get.find<ProductController>()
            .listProduct
            .where((p0) => p0.status == status['value'])
            .isNotEmpty) {
          reportProductStatus.add(OrdinalData(
              domain: status['label'],
              measure: Get.find<ProductController>()
                      .listProduct
                      .where((p0) => p0.status == status['value'])
                      .length /
                  Get.find<ProductController>().listProduct.length,
              color: status['color']));
        }
      }
    }
    isLoading.value = false;
  }
}
