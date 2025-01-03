import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/address_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/address.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:htql_mua_ban_nong_san/views/view_buyer/address/address_page.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();

    Get.find<CartController>().address.value = Get.find<AddressController>()
            .listAddress
            .firstWhereOrNull((element) => element.is_default) ??
        Address.initAddress();
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    RxDouble total = 0.0.obs;
    List paymentMethod = ['Thanh toán bằng tiền mặt'];

    return Obx(() {
      total.value = 0;
      return mainController.isLoading.value ||
              Get.find<CartController>().isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  title: const Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  foregroundColor: Colors.white,
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(Get.width * 0.05),
                                // width: Get.width * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Thông tin nhận hàng',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        value: Get.find<AddressController>()
                                            .listAddress
                                            .firstWhereOrNull((p0) =>
                                                p0.id ==
                                                Get.find<CartController>()
                                                    .address
                                                    .value
                                                    .id),
                                        items: Get.find<AddressController>()
                                            .listAddress
                                            .map((add) {
                                          Province province = Get.find<
                                                      ProvinceController>()
                                                  .listProvince
                                                  .firstWhereOrNull((element) =>
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
                                                    alignment:
                                                        Alignment.topLeft,
                                                    height: 40,
                                                    child: Text(
                                                      'Địa chỉ: ${add.address_detail}',
                                                      maxLines: 2,
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
                                        onChanged: (value) {
                                          if (value == null) {
                                            Get.find<CartController>()
                                                .address
                                                .value = Address.initAddress();
                                          } else {
                                            Get.find<CartController>()
                                                .address
                                                .value = value;
                                          }
                                        },
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          height: 130,
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: Get.height * 0.5,
                                          width: Get.width * 0.9,
                                          // padding: EdgeInsets.all(5),
                                        ),
                                        buttonStyleData: ButtonStyleData(
                                          // height: 60,
                                          width: Get.width * 0.7,
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
                                  ],
                                ),
                              ),
                              Container(
                                width: Get.width * 0.2,
                                height: Get.height * 0.11,
                                decoration: const BoxDecoration(
                                    // color: Colors.amber,
                                    ),
                                child: InkWell(
                                  onTap: () {
                                    const AddressPage().createAddress(context);
                                  },
                                  child: Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                    size: Get.width * 0.1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.01,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          for (var item in Get.find<CartController>()
                              .getChooseCartGroupBySeller())
                            cartSeller(item, context, total),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.05,
                              vertical: Get.width * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                overflow: TextOverflow.ellipsis,
                                                strutStyle: StrutStyle.disabled,
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
                                      onChanged: (value) {},
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
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Container(
                      // height: Get.height * 0.2,
                      padding: EdgeInsets.all(Get.width * 0.05),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: Get.width * 0.4,
                                child: const Text(
                                  'Tổng:',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: Get.width * 0.5,
                                child: Text(
                                  currencyFormatter.format(total.value),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (Get.find<AddressController>()
                                      .listAddress
                                      .firstWhereOrNull((element) =>
                                          element.id ==
                                          Get.find<CartController>()
                                              .address
                                              .value
                                              .id) ==
                                  null) {
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
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title:
                                      'Vui lòng chọn hoặc thêm thông tin nhận hàng',
                                  // desc: 'Tên đăng nhập đã tồn tại.',
                                  btnOkOnPress: () {},
                                ).show();
                                return;
                              } else {
                                await Get.find<CartController>().checkout();

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
                                  title: 'Đặt hàng thành công!',
                                  // desc: 'Tên đăng nhập đã tồn tại.',
                                  btnOkOnPress: () {},
                                ).show();
                                Get.back();
                              }
                            },
                            style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.green),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(),
                              height: Get.width * 0.1,
                              width: Get.width * 0.8,
                              child: const Text(
                                'Đặt hàng',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const Divider(),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
    });
  }

  Widget cartSeller(item, context, total) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    Seller seller = item[0] as Seller;
    RxDouble fee = 0.0.obs;
    Province provinceSeller = Get.find<ProvinceController>()
            .listProvince
            .firstWhereOrNull((element) => element.id == seller.province_id) ??
        Province.initProvince();
    if (Get.find<CartController>().address.value.province_id ==
        seller.province_id) {
      fee.value = 15000;
    } else {
      fee.value = 30000;
    }
    total.value += item[2] + fee.value;
    item[3] = fee.value;

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(4.0, 4.0),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (item[0] as Seller).name,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    provinceSeller.name,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Column(
            children: [
              for (var cart in item[1]) cartDetail(cart, context),
              const Divider(),
              Row(
                children: [
                  Container(
                    width: Get.width * 0.4,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Tiền hàng: ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.5,
                    alignment: Alignment.centerRight,
                    child: Text(
                      currencyFormatter.format(item[2]),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: Get.width * 0.4,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Phí vận chuyển: ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.5,
                    alignment: Alignment.centerRight,
                    child: Text(
                      currencyFormatter.format(fee.value),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  left: Get.width * 0.5,
                ),
                width: Get.width,
                child: const Divider(),
              ),
              Row(
                children: [
                  Container(
                    width: Get.width * 0.4,
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Thanh toán: ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.5,
                    alignment: Alignment.centerRight,
                    child: Text(
                      currencyFormatter.format(item[2] + fee.value),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
        ],
      ),
    );
  }

  Widget cartDetail(cart, context) {
    // Cart cartItem = cart as Cart;
    ProductImage productImage = Get.find<ProductController>()
            .listProductImage
            .firstWhereOrNull((p0) => p0.product_id == cart.product_id) ??
        ProductImage.initProductImage();
    Product product = Get.find<ProductController>()
            .listProduct
            .firstWhereOrNull((element) => element.id == cart.product_id) ??
        Product.initProduct();
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

    Rx<TextEditingController> quantityController = TextEditingController().obs;

    quantityController.value.text =
        NumberFormat.decimalPatternDigits(decimalDigits: 0)
            .format(cart.quantity)
            .toString();
    return Container(
      // padding: const EdgeInsets.all(5),
      padding: EdgeInsets.only(
        bottom: Get.width * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Get.width * 0.2,
            height: Get.width * 0.25,
            // margin: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(
              left: 5,
              right: 10,
              bottom: 0,
              top: 0,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              image: DecorationImage(
                image: NetworkImage(
                  productImage.image,
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            width: Get.width * 0.7,
            // height: Get.height * 0.15,
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
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * 0.4,
                      // alignment: ,
                      child: Text(
                        currencyFormatter.format(product.price),
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
                        'x ${NumberFormat.decimalPatternDigits(decimalDigits: 0).format(cart.quantity)} ${product.unit}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
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
