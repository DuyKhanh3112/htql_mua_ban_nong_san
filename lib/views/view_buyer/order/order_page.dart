import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/order.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController orderController = Get.find<OrderController>();
    MainController mainController = Get.find<MainController>();

    return Obx(() {
      return mainController.isLoading.value || orderController.isLoading.value
          ? const LoadingPage()
          : DefaultTabController(
              initialIndex: 0,
              length: orderController.listStatus.length,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Đơn Hàng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    labelColor: Colors.yellow,
                    unselectedLabelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    tabs: <Widget>[
                      for (var item in orderController.listStatus)
                        Tab(
                          text:
                              '${item['label']} (${orderController.listOrder.where((p0) => p0.status == item['value']).length})',
                        ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    // ignore: unused_local_variable
                    for (var item in orderController.listStatus)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: orderController.listOrder
                                .where((p0) => p0.status == item['value'])
                                .map(
                              (order) {
                                return orderItem(order, context);
                              },
                            ).toList(),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
    });
  }

  Container orderItem(Orders order, BuildContext context) {
    Seller seller = Get.find<SellerController>()
            .listSeller
            .firstWhereOrNull((element) => element.id == order.seller_id) ??
        Seller.initSeller();
    return Container(
      // height: Get.height * 0.2,
      width: Get.width,
      padding: EdgeInsets.all(Get.width * 0.02),
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * 0.02,
        vertical: Get.height * 0.02,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(4.0, 4.0),
            blurRadius: 10.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: Get.width * 0.15,
                height: Get.width * 0.15,
                // margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  shape: BoxShape.circle,
                  image: seller.avatar == ''
                      ? null
                      : DecorationImage(
                          image: NetworkImage(
                            seller.avatar!,
                          ),
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              SizedBox(
                width: Get.width * 0.05,
              ),
              SizedBox(
                width: Get.width * 0.5,
                child: Text(
                  seller.name,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: Get.width * 0.4,
                child: const Text(
                  'Ngày đặt:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: Get.width * 0.5,
                child: Text(
                  DateFormat('HH:mm dd-MM-yyyy')
                      .format(order.order_date.toDate()),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          order.status == 'cancelled'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: Get.width * 0.4,
                      child: const Text(
                        'Ngày hủy:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: Get.width * 0.5,
                      child: Text(
                        DateFormat('HH:mm dd-MM-yyyy')
                            .format(order.update_at.toDate()),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: Get.width * 0.4,
                child: const Text(
                  'Thanh toán:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: Get.width * 0.5,
                child: Text(
                  NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                      .format(order.order_amount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          SizedBox(
            height: Get.height * 0.01,
          ),
          order.status == 'unconfirm'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    btnViewDetail(order),
                    Container(
                      alignment: Alignment.center,
                      width: Get.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () async {
                          await AwesomeDialog(
                                  titleTextStyle: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                  descTextStyle: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                  context: context,
                                  dialogType: DialogType.question,
                                  animType: AnimType.rightSlide,
                                  title: 'Xác nhận',
                                  desc: 'Bạn có muốn hủy đơn hàng này không',
                                  btnOkText: 'Xác nhận',
                                  btnCancelText: 'Không',
                                  btnOkOnPress: () async {
                                    Orders ord = order;
                                    ord.status = 'cancelled';
                                    await Get.find<OrderController>()
                                        .cancelOrder(ord);
                                  },
                                  btnCancelOnPress: () {})
                              .show();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(),
                          width: Get.width * 0.2,
                          child: const Text(
                            'Hủy đơn',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          order.status == 'delivering'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    btnViewDetail(order),
                    Container(
                      alignment: Alignment.center,
                      width: Get.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () async {
                          await AwesomeDialog(
                                  titleTextStyle: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                  descTextStyle: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                  context: context,
                                  dialogType: DialogType.question,
                                  animType: AnimType.rightSlide,
                                  title: 'Xác nhận',
                                  desc: 'Xác nhận đã nhận đơn hàng này',
                                  btnOkText: 'Xác nhận',
                                  btnCancelText: 'Không',
                                  btnOkOnPress: () async {
                                    Orders ord = order;
                                    ord.status = 'delivered';
                                    await Get.find<OrderController>()
                                        .updateOrder(ord);
                                  },
                                  btnCancelOnPress: () {})
                              .show();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(),
                          width: Get.width * 0.2,
                          child: const Text(
                            'Đã nhận',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          order.status == 'delivered'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    btnViewDetail(order),
                    Container(
                      alignment: Alignment.center,
                      width: Get.width * 0.3,
                      child: ElevatedButton(
                        onPressed: () async {},
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(),
                          width: Get.width * 0.2,
                          child: const Text(
                            'Đánh giá',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: Get.width * 0.3,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Get.find<OrderController>().rebuy(order);
                          Get.toNamed('/cart');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(),
                          width: Get.width * 0.2,
                          child: const Text(
                            'Mua lại',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : const SizedBox(),
          order.status == 'cancelled'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    btnViewDetail(order),
                    ElevatedButton(
                      onPressed: () async {
                        await Get.find<OrderController>().rebuy(order);
                        Get.toNamed('/cart');
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(),
                        width: Get.width * 0.2,
                        child: const Text(
                          'Mua lại',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget btnViewDetail(Orders order) {
    return Container(
      width: Get.width * 0.3,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () async {
          await Get.find<OrderController>().loadOrderDetailByOrder(order);
          Get.find<OrderController>().order.value = order;
          Get.toNamed('order_detail');
        },
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(),
          width: Get.width * 0.2,
          child: const Text(
            'Chi tiết',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
