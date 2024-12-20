import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/review_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/buyer.dart';
import 'package:htql_mua_ban_nong_san/models/order.dart';
import 'package:htql_mua_ban_nong_san/models/review.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/drawer_seller.dart';
import 'package:intl/intl.dart';

class OrderSellerHomePage extends StatelessWidget {
  const OrderSellerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    OrderController orderController = Get.find<OrderController>();

    return Obx(() {
      return mainController.isLoading.value ||
              orderController.isLoading.value ||
              Get.find<ReviewController>().isLoading.value
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
                drawer: const DrawerSeller(),
              ),
            );
    });
  }

  Container orderItem(Orders order, BuildContext context) {
    Buyer buyer = Get.find<OrderController>()
            .listBuyer
            .firstWhereOrNull((p0) => p0.id == order.buyer_id) ??
        Buyer.initBuyer();
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
                  image: buyer.avatar == ''
                      ? null
                      : DecorationImage(
                          image: NetworkImage(
                            buyer.avatar!,
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
                  buyer.name,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: Get.width * 0.9,
                alignment: Alignment.centerRight,
                child: Text(
                  "Tỉ lệ nhận hàng thành công: ${buyer.rate_order ?? 0}%",
                  // textAlign: TextAlign.left,
                  style: TextStyle(
                    color: buyer.rate_order! >= 50 ? Colors.green : Colors.red,
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
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
                  'Mã đơn hàng:',
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
                  order.id.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
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
          order.status == 'delivering'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: Get.width * 0.4,
                      child: const Text(
                        'Ngày giao:',
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
          order.status == 'delivered' && order.received_date != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: Get.width * 0.4,
                      child: const Text(
                        'Ngày nhận:',
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
                            .format(order.received_date!.toDate()),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: Get.width * 0.4,
                child: const Text(
                  'Tiền hàng:',
                  style: TextStyle(
                    fontSize: 14,
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: Get.width * 0.4,
                child: const Text(
                  'Phí vận chuyển:',
                  style: TextStyle(
                    fontSize: 14,
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
                      .format(order.fee ?? 0),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          Container(
            // alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: Get.width * 0.5,
              // right: Get.width * 0.05,
            ),
            width: Get.width,
            child: const Divider(),
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
                      .format(order.order_amount + (order.fee ?? 0)),
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
              ? btnUnconfirm(order, context)
              : const SizedBox(),
          order.status == 'delivering'
              ? btnDelivering(order, context)
              : const SizedBox(),
          order.status == 'delivered'
              ? btnDelivered(order, context)
              : const SizedBox(),
          order.status == 'cancelled' ? btnCancel(order) : const SizedBox(),
          order.status == 'failed' ? btnCancel(order) : const SizedBox(),
        ],
      ),
    );
  }

  Row btnCancel(Orders order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        btnViewDetail(order),
      ],
    );
  }

  Row btnDelivered(Orders order, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        btnViewDetail(order),
        Container(
          width: Get.width * 0.3,
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () async {
              Rx<TextEditingController> contentController =
                  TextEditingController().obs;
              Rx<TextEditingController> responseController =
                  TextEditingController().obs;

              Rx<Review> review = (Get.find<ReviewController>()
                          .listReview
                          .firstWhereOrNull((p0) => p0.order_id == order.id) ??
                      Review.initReview())
                  .obs;
              contentController.value.text = review.value.comment;
              responseController.value.text = review.value.response ?? '';
              final formKey = GlobalKey<FormState>();
              Get.dialog(
                Obx(
                  () {
                    return AlertDialog(
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Đánh giá',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.green,
                                ),
                              )
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                      content: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: review.value.id == ''
                            ? Container(
                                decoration: const BoxDecoration(),
                                width: Get.width * 0.8,
                                child: const Text(
                                  'Khách hàng chưa đánh giá.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              )
                            : Container(
                                decoration: const BoxDecoration(),
                                width: Get.width * 0.8,
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      RatingBarIndicator(
                                        rating: review.value.ratting,
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 30,
                                        direction: Axis.horizontal,
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.01,
                                      ),
                                      review.value.comment == ''
                                          ? const SizedBox()
                                          : TextFormField(
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                              ),
                                              controller:
                                                  contentController.value,
                                              readOnly: true,
                                              minLines: 2,
                                              maxLines: 3,
                                              decoration: const InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.green),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.green),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Colors.green),
                                                ),
                                                labelText: 'Nội dung',
                                                labelStyle: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        height: Get.height * 0.01,
                                      ),
                                      TextFormField(
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                        ),
                                        controller: responseController.value,
                                        // readOnly: true,
                                        minLines: 3,
                                        maxLines: 4,
                                        decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          labelText: 'Phản hồi khách hàng',
                                          labelStyle: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      actions: [
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: review.value.id == ''
                                  ? () {
                                      Get.back();
                                    }
                                  : () async {
                                      if (formKey.currentState!.validate()) {
                                        review.value.update_at =
                                            Timestamp.now();
                                        review.value.response =
                                            responseController.value.text;
                                        Get.back();
                                        await Get.find<ReviewController>()
                                            .updateReview(review.value);

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
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.rightSlide,
                                          title:
                                              'Phản hồi đánh giá của khách hàng thành công!',
                                          btnOkOnPress: () {},
                                        ).show();
                                      }
                                    },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(),
                                width: Get.width * 0.35,
                                child: Text(
                                  review.value.id == '' ? 'Đóng' : 'Phản hồi',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              );
            },
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
      ],
    );
  }

  Row btnDelivering(Orders order, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        btnViewDetail(order),
        Container(
          width: Get.width * 0.3,
          alignment: Alignment.center,
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
                      desc:
                          'Xác nhận khách hàng không nhận hàng, đơn hàng giao thất bại',
                      btnOkText: 'Xác nhận',
                      btnCancelText: 'Không',
                      btnOkOnPress: () async {
                        order.update_at = Timestamp.now();
                        order.status = 'failed';
                        await Get.find<OrderController>().updateOrder(order);
                        Get.find<OrderController>().isLoading.value = true;
                        Buyer? buyer = Get.find<OrderController>()
                            .listBuyer
                            .firstWhereOrNull((p0) => p0.id == order.buyer_id);

                        Get.find<OrderController>().listBuyer.remove(buyer);
                        if (buyer != null) {
                          buyer.rate_order = await Get.find<OrderController>()
                              .getRateSuccessByBuyer(order.buyer_id);

                          Get.find<OrderController>().listBuyer.add(buyer);
                        }
                        Get.find<OrderController>().isLoading.value = false;
                      },
                      btnCancelOnPress: () {})
                  .show();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(),
              width: Get.width * 0.2,
              child: const Text(
                'Không nhận',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row btnUnconfirm(Orders order, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        btnViewDetail(order),
        Container(
          width: Get.width * 0.3,
          alignment: Alignment.center,
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
                      desc: 'Xác nhận nhận và giao đơn hàng này',
                      btnOkText: 'Xác nhận',
                      btnCancelText: 'Không',
                      btnOkOnPress: () async {
                        order.status = 'delivering';
                        await Get.find<OrderController>().updateOrder(order);
                      },
                      btnCancelOnPress: () {})
                  .show();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(),
              width: Get.width * 0.2,
              child: const Text(
                'Nhận đơn',
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
                        await Get.find<OrderController>().cancelOrder(ord);
                      },
                      btnCancelOnPress: () {})
                  .show();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(),
              width: Get.width * 0.2,
              child: const Text(
                'Huỷ đơn',
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
          await Get.find<OrderController>().loadAddressByOrder();
          Get.toNamed('order_seller_detail');
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
