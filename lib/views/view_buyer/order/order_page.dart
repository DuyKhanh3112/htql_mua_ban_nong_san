import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/review_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/order.dart';
import 'package:htql_mua_ban_nong_san/models/review.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    OrderController orderController = Get.find<OrderController>();

    return Obx(() {
      return orderController.isLoading.value ||
              Get.find<ReviewController>().isLoading.value
          ? const LoadingPage()
          : DefaultTabController(
              // initialIndex: 0,
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
              ? btnUnconfirm(order, context)
              : const SizedBox(),
          order.status == 'delivering'
              ? btnDelivering(order, context)
              : const SizedBox(),
          order.status == 'delivered'
              ? btnDelivered(order, context)
              : const SizedBox(),
          order.status == 'cancelled' ? btnCancel(order) : const SizedBox(),
        ],
      ),
    );
  }

  Row btnCancel(Orders order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        btnViewDetail(order),
        btnRebuy(order),
      ],
    );
  }

  Row btnDelivered(Orders order, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        btnViewDetail(order),
        Container(
          alignment: Alignment.center,
          width: Get.width * 0.3,
          child: ElevatedButton(
            onPressed: () async {
              Rx<TextEditingController> contentController =
                  TextEditingController().obs;
              RxDouble ratting = 5.0.obs;
              Rx<Review> review = (Get.find<ReviewController>()
                          .listReview
                          .firstWhereOrNull((p0) => p0.order_id == order.id) ??
                      Review.initReview())
                  .obs;
              contentController.value.text = review.value.comment;
              ratting.value = review.value.ratting;
              // review.value = (Get.find<ReviewController>()
              //         .listReview
              //         .firstWhereOrNull((p0) => p0.order_id == order.id) ??
              //     Review.initReview());
              Get.dialog(
                Obx(
                  () {
                    // print(ratting.value);
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
                        child: Container(
                          decoration: const BoxDecoration(),
                          width: Get.width * 0.8,
                          child: Form(
                            child: Column(
                              children: [
                                RatingBar.builder(
                                  initialRating: ratting.value,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  // allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.01),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (value) {
                                    ratting.value = value;
                                  },
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                TextFormField(
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                  controller: contentController.value,
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
                                    labelText: 'Nội dung',
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
                              onPressed: () async {
                                Review re = Review(
                                    id: review.value.id,
                                    order_id: order.id,
                                    comment: contentController.value.text,
                                    ratting: ratting.value,
                                    create_at: Timestamp.now(),
                                    update_at: Timestamp.now());
                                Get.back();
                                print(re.toJson());
                                if (re.id == '') {
                                  await Get.find<ReviewController>()
                                      .createReview(re);
                                } else {
                                  await Get.find<ReviewController>()
                                      .updateReview(re);
                                }
                                // ignore: use_build_context_synchronously
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
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title: 'Đánh giá đơn hàng thành công.',
                                  btnOkOnPress: () {},
                                ).show();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(),
                                width: Get.width * 0.35,
                                child: const Text(
                                  'Lưu đánh giá',
                                  textAlign: TextAlign.center,
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
        btnRebuy(order)
      ],
    );
  }

  Container btnRebuy(Orders order) {
    return Container(
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
    );
  }

  Row btnDelivering(Orders order, BuildContext context) {
    return Row(
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
                        ord.received_date = Timestamp.now();
                        await Get.find<OrderController>().updateOrder(ord);
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
    );
  }

  Row btnUnconfirm(Orders order, BuildContext context) {
    return Row(
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
