import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/address_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/order_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/review_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/address.dart';
import 'package:htql_mua_ban_nong_san/models/order.dart';
import 'package:htql_mua_ban_nong_san/models/order_detail.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/models/review.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:htql_mua_ban_nong_san/views/view_buyer/address/address_page.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool onChange = false.obs;
    Rx<Province> province = Province.initProvince().obs;
    province.value = Get.find<ProvinceController>()
            .listProvince
            .firstWhereOrNull((p0) =>
                p0.id ==
                Get.find<OrderController>().address.value.province_id) ??
        Province.initProvince();
    List paymentMethod = ['Thanh toán bằng tiền mặt'];
    Rx<Seller> seller =
        (Get.find<SellerController>().listSeller.firstWhereOrNull(
                      (element) =>
                          element.id ==
                          Get.find<OrderController>().order.value.seller_id,
                    ) ??
                Seller.initSeller())
            .obs;
    return Obx(() {
      return Get.find<OrderController>().isLoading.value ||
              Get.find<ReviewController>().isLoading.value
          ? const LoadingPage()
          : SafeArea(
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
                  actions: [
                    onChange.value
                        ? InkWell(
                            onTap: () async {
                              onChange.value = false;
                              // print( Get.find<OrderController>()
                              //         .order
                              //         .value.toJson());
                              Get.find<OrderController>()
                                      .order
                                      .value
                                      .address_id =
                                  Get.find<OrderController>().address.value.id;
                              Get.find<OrderController>()
                                  .order
                                  .value
                                  .update_at = Timestamp.now();
                              await Get.find<OrderController>().updateOrder(
                                  Get.find<OrderController>().order.value);
                              await Get.find<OrderController>()
                                  .loadOrderByBuyer();
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: Get.width * 0.02),
                              child: const Icon(Icons.save),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: Get.find<OrderController>()
                                              .order
                                              .value
                                              .status ==
                                          'unconfirm'
                                      ? Get.width * 0.8
                                      : Get.width * 0.9,
                                  margin:
                                      EdgeInsets.only(left: Get.width * 0.02),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      value: Get.find<AddressController>()
                                          .listAddress
                                          .firstWhereOrNull((p0) =>
                                              p0.id ==
                                              Get.find<OrderController>()
                                                  .address
                                                  .value
                                                  .id),
                                      items: Get.find<AddressController>()
                                          .listAddress
                                          .map((Address add) {
                                        Province province =
                                            Get.find<ProvinceController>()
                                                    .listProvince
                                                    .firstWhereOrNull(
                                                        (element) =>
                                                            element.id ==
                                                            add.province_id) ??
                                                Province.initProvince();
                                        return DropdownMenuItem(
                                          value: add,
                                          child: Container(
                                            decoration: const BoxDecoration(),
                                            padding: const EdgeInsets.all(
                                              5,
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 20,
                                                  child: Text(
                                                    'Họ tên: ${add.name}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    strutStyle:
                                                        StrutStyle.disabled,
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 20,
                                                  child: Text(
                                                    'Số điện thoại: ${add.phone}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    strutStyle:
                                                        StrutStyle.disabled,
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 20,
                                                  child: Text(
                                                    'Tỉnh thành: ${province.name}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    strutStyle:
                                                        StrutStyle.disabled,
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  // height: 40,
                                                  child: Text(
                                                    'Địa chỉ: ${add.address_detail}',
                                                    maxLines: 3,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    strutStyle:
                                                        StrutStyle.disabled,
                                                  ),
                                                ),
                                                const Divider(
                                                  height: 1,
                                                  color: Colors.green,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 18,
                                      ),
                                      isExpanded: true,
                                      onChanged: Get.find<OrderController>()
                                                  .order
                                                  .value
                                                  .status !=
                                              'unconfirm'
                                          ? null
                                          : (value) {
                                              onChange.value = true;
                                              if (value == null) {
                                                Get.find<OrderController>()
                                                        .address
                                                        .value =
                                                    Address.initAddress();
                                              } else {
                                                Get.find<OrderController>()
                                                    .address
                                                    .value = value as Address;
                                                if (Get.find<OrderController>()
                                                        .address
                                                        .value
                                                        .province_id ==
                                                    seller.value.province_id) {
                                                  Get.find<OrderController>()
                                                      .order
                                                      .value
                                                      .fee = 15000;
                                                } else {
                                                  Get.find<OrderController>()
                                                      .order
                                                      .value
                                                      .fee = 30000;
                                                }
                                              }
                                            },
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 150,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: Get.height * 0.5,
                                        width: Get.find<OrderController>()
                                                    .order
                                                    .value
                                                    .status ==
                                                'unconfirm'
                                            ? Get.width * 0.8
                                            : Get.width * 0.9,
                                      ),
                                      buttonStyleData: ButtonStyleData(
                                        // height: 60,

                                        width: Get.find<OrderController>()
                                                    .order
                                                    .value
                                                    .status ==
                                                'unconfirm'
                                            ? Get.width * 0.8
                                            : Get.width * 0.9,

                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.green,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.05),
                                      ),
                                    ),
                                  ),
                                ),
                                Get.find<OrderController>()
                                            .order
                                            .value
                                            .status !=
                                        'unconfirm'
                                    ? const SizedBox()
                                    : Container(
                                        width: Get.width * 0.18,
                                        height: Get.height * 0.11,
                                        decoration: const BoxDecoration(
                                            // color: Colors.amber,
                                            ),
                                        child: InkWell(
                                          onTap: () {
                                            const AddressPage()
                                                .createAddress(context);
                                          },
                                          child: Icon(
                                            Icons.add_circle,
                                            color: Colors.green,
                                            size: Get.width * 0.075,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05,
                                vertical: Get.width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: Get.width * 0.4,
                                    child: const Text(
                                      'Mã đơn hàng:',
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
                                      Get.find<OrderController>()
                                          .order
                                          .value
                                          .id
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05,
                                vertical: Get.width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: Get.width * 0.4,
                                    child: const Text(
                                      'Ngày đặt:',
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
                                      DateFormat('HH:mm dd-MM-yyyy').format(
                                          Get.find<OrderController>()
                                              .order
                                              .value
                                              .order_date
                                              .toDate()),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Get.find<OrderController>()
                                        .order
                                        .value
                                        .received_date ==
                                    null
                                ? const SizedBox()
                                : Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.05,
                                      vertical: Get.width * 0.01,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: Get.width * 0.4,
                                          child: const Text(
                                            'Ngày đặt:',
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
                                            DateFormat('HH:mm dd-MM-yyyy')
                                                .format(
                                                    Get.find<OrderController>()
                                                        .order
                                                        .value
                                                        .order_date
                                                        .toDate()),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            for (var odd in Get.find<OrderController>()
                                .listOrderDetail
                                .where((p0) =>
                                    p0.order_id ==
                                    Get.find<OrderController>().order.value.id))
                              orderDetailItem(odd),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05,
                                vertical: Get.width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      NumberFormat.currency(
                                              locale: 'vi_VN', symbol: 'VNĐ')
                                          .format(Get.find<OrderController>()
                                              .order
                                              .value
                                              .order_amount),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05,
                                vertical: Get.width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      NumberFormat.currency(
                                              locale: 'vi_VN', symbol: 'VNĐ')
                                          .format(Get.find<OrderController>()
                                                  .order
                                                  .value
                                                  .fee ??
                                              0),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: Get.width * 0.5,
                                right: Get.width * 0.05,
                              ),
                              width: Get.width,
                              child: const Divider(),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05,
                                vertical: Get.width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      NumberFormat.currency(
                                              locale: 'vi_VN', symbol: 'VNĐ')
                                          .format(Get.find<OrderController>()
                                                  .order
                                                  .value
                                                  .order_amount +
                                              (Get.find<OrderController>()
                                                      .order
                                                      .value
                                                      .fee ??
                                                  0)),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05,
                                vertical: Get.width * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: Get.width * 0.4,
                                    child: const Text(
                                      'Phương thức thanh toán:',
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
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        value: paymentMethod[0],
                                        items: paymentMethod
                                            .map(
                                              (item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  strutStyle:
                                                      StrutStyle.disabled,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        isExpanded: true,
                                        onChanged: Get.find<OrderController>()
                                                    .order
                                                    .value
                                                    .status ==
                                                'unconfirm'
                                            ? (value) {
                                                onChange.value = true;
                                              }
                                            : null,
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: Get.height / 2,
                                          width: Get.width * 0.5,
                                          // padding: EdgeInsets.all(5),
                                        ),
                                        buttonStyleData: ButtonStyleData(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.green,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Get.find<OrderController>().order.value.status ==
                            'unconfirm'
                        ? btnUnconfirm(context)
                        : const SizedBox(),
                    Get.find<OrderController>().order.value.status ==
                            'delivering'
                        ? btnDelivering(context)
                        : const SizedBox(),
                    Get.find<OrderController>().order.value.status ==
                            'delivered'
                        ? btnDelivered(context)
                        : const SizedBox(),
                    Get.find<OrderController>().order.value.status ==
                            'cancelled'
                        ? btnCancel()
                        : const SizedBox(),
                    Get.find<OrderController>().order.value.status == 'failed'
                        ? btnFailed()
                        : const SizedBox(),
                  ],
                ),
              ),
            );
    });
  }

  Row btnCancel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // btnViewDetail(order),
        Container(
          alignment: Alignment.center,
          width: Get.width,
          child: ElevatedButton(
            onPressed: () async {
              await Get.find<OrderController>()
                  .rebuy(Get.find<OrderController>().order.value);
              Get.toNamed('/cart');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(),
              width: Get.width * 0.8,
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
        ),
      ],
    );
  }

  Row btnFailed() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // btnViewDetail(order),
        Container(
          alignment: Alignment.center,
          width: Get.width,
          child: ElevatedButton(
            onPressed: () async {
              await Get.find<OrderController>()
                  .rebuy(Get.find<OrderController>().order.value);
              Get.toNamed('/cart');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(),
              width: Get.width * 0.8,
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
        ),
      ],
    );
  }

  Row btnUnconfirm(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // btnViewDetail(order),
        Container(
          alignment: Alignment.center,
          width: Get.width,
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
                        Get.find<OrderController>().order.value.status =
                            'cancelled';
                        await Get.find<OrderController>().cancelOrder(
                            Get.find<OrderController>().order.value);
                      },
                      btnCancelOnPress: () {})
                  .show();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(),
              width: Get.width * 0.8,
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

  Row btnDelivering(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // btnViewDetail(order),
        Container(
          alignment: Alignment.center,
          width: Get.width,
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
                        Orders ord = Get.find<OrderController>().order.value;
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
              width: Get.width * 0.8,
              child: const Text(
                'Đã nhận được hàng',
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

  Container btnDelivered(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // btnViewDetail(order),
          Container(
            width: Get.width * 0.45,
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () async {
                await Get.find<OrderController>()
                    .rebuy(Get.find<OrderController>().order.value);
                Get.toNamed('/cart');
              },
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(),
                width: Get.width * 0.45,
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
          ),
          Container(
            alignment: Alignment.center,
            width: Get.width * 0.45,
            child: ElevatedButton(
              onPressed: () async {
                Rx<TextEditingController> contentController =
                    TextEditingController().obs;
                Rx<TextEditingController> responseController =
                    TextEditingController().obs;
                RxDouble ratting = 5.0.obs;
                Rx<Review> review = (Get.find<ReviewController>()
                            .listReview
                            .firstWhereOrNull((p0) =>
                                p0.order_id ==
                                Get.find<OrderController>().order.value.id) ??
                        Review.initReview())
                    .obs;
                contentController.value.text = review.value.comment;
                responseController.value.text = review.value.response ?? '';

                ratting.value = review.value.ratting;
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
                                  SizedBox(
                                    height: Get.height * 0.01,
                                  ),
                                  review.value.response == ''
                                      ? const SizedBox()
                                      : TextFormField(
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                          ),
                                          controller: responseController.value,
                                          readOnly: true,
                                          minLines: 2,
                                          maxLines: 3,
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                            ),
                                            labelText: 'Phản hồi của người bán',
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
                                      order_id: Get.find<OrderController>()
                                          .order
                                          .value
                                          .id,
                                      comment: contentController.value.text,
                                      response: responseController.value.text,
                                      ratting: ratting.value,
                                      create_at: Timestamp.now(),
                                      update_at: Timestamp.now());
                                  Get.back();
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
                width: Get.width * 0.45,
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
      ),
    );
  }

  Widget orderDetailItem(OrderDetail odd) {
    Product product = Get.find<OrderController>()
            .listProduct
            .firstWhereOrNull((element) => element.id == odd.product_id) ??
        Product.initProduct();
    ProductImage productImg = Get.find<OrderController>()
            .listProductImage
            .firstWhereOrNull(
                (p0) => p0.product_id == odd.product_id && p0.is_default) ??
        ProductImage.initProductImage();
    return Container(
      width: Get.width,
      // height: Get.height * 0.2,
      // padding: EdgeInsets.all(Get.width * 0.01),
      padding: EdgeInsets.only(
        right: Get.width * 0.03,
      ),
      margin: EdgeInsets.all(Get.width * 0.02),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(4.0, 4.0),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Get.width * 0.2,
            height: Get.width * 0.3,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage(productImg.image),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: Get.width * 0.6,
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.width * 0.7,
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Get.width * 0.3,
                      // alignment: ,
                      child: Text(
                        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                            .format(odd.sell_price),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: Get.width * 0.3,
                      // alignment: ,
                      child: Text(
                        'x ${NumberFormat.decimalPatternDigits(decimalDigits: 0).format(odd.quantity)} ${product.unit}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: Get.width * 0.6,
                      // alignment: ,
                      child: Text(
                        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                            .format(odd.sell_price * odd.quantity),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
