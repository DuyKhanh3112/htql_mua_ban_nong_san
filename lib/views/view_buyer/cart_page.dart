import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/product_image.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:intl/intl.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    CartController cartController = Get.find<CartController>();

    // ignore: unused_local_variable
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

    return Obx(
      () {
        return mainController.isLoading.value
            ? const LoadingPage()
            : SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.green,
                    title: const Text(
                      'Giỏ hàng',
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
                            Column(
                              children: [
                                for (var item
                                    in cartController.getCartGroupBySeller())
                                  cartSeller(item, context),
                              ],
                            ),
                          ],
                        ),
                      ),
                      cartController.listCartChoose.isNotEmpty
                          ? Container(
                              // height: Get.height * 0.2,
                              padding: EdgeInsets.all(Get.width * 0.05),
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: Get.width * 0.4,
                                        child: const Text(
                                          'Tổng thanh toán:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: Get.width * 0.5,
                                        child: Text(
                                          "${Get.find<CartController>().totalCart.value}",
                                          style: const TextStyle(
                                            fontSize: 18,
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
                                    onPressed: () async {},
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green),
                                      shape: MaterialStatePropertyAll(
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
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget btnCheckout() {
    return Container(
      // height: Get.height * 0.2,
      padding: EdgeInsets.all(Get.width * 0.05),
      decoration: const BoxDecoration(
        color: Colors.amber,
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
                  'Tổng thanh toán:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: Get.width * 0.5,
                child: Text(
                  "${Get.find<CartController>().totalCart.value}",
                  style: const TextStyle(
                    fontSize: 18,
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
            onPressed: () async {},
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.green),
              shape: MaterialStatePropertyAll(
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
    );
  }

  Widget cartSeller(item, context) {
    RxBool isChoose = true.obs;
    for (var element in item[1]) {
      if (!Get.find<CartController>().listCartChoose.contains(element)) {
        isChoose.value = false;
        break;
      }
    }
    return Obx(() {
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
                Checkbox(
                  value: isChoose.value,
                  onChanged: (value) {
                    if (isChoose.value) {
                      for (var element in item[1]) {
                        Get.find<CartController>()
                            .listCartChoose
                            .remove(element);
                      }
                    } else {
                      for (var element in item[1]) {
                        if (!Get.find<CartController>()
                            .listCartChoose
                            .contains(element)) {
                          Get.find<CartController>()
                              .listCartChoose
                              .add(element);
                        }
                      }
                    }
                    Get.find<CartController>().getCountCart();
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723018608/account_default.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  (item[0] as Seller).name,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(),
            Column(
              children: [
                for (var cart in item[1]) cartDetail(cart, context),
              ],
            ),
          ],
        ),
      );
    });
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
    return Obx(() {
      return Container(
        // padding: const EdgeInsets.all(5),
        padding: EdgeInsets.only(
          bottom: Get.width * 0.01,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
              value: Get.find<CartController>().listCartChoose.contains(cart),
              onChanged: (value) {
                if (Get.find<CartController>().listCartChoose.contains(cart)) {
                  Get.find<CartController>().listCartChoose.remove(cart);
                } else {
                  Get.find<CartController>().listCartChoose.add(cart);
                }
                Get.find<CartController>().getCountCart();
              },
            ),
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
                image: DecorationImage(
                  image: NetworkImage(
                    productImage.image,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              width: Get.width * 0.5,
              // height: Get.height * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Get.width * 0.5,
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
                        width: Get.width * 0.25,
                        // alignment: ,
                        child: Text(
                          currencyFormatter.format(product.price),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.remove_circle_outline,
                              size: Get.width * 0.05,
                              color: Colors.green,
                            ),
                            onTap: () async {
                              if (cart.quantity > 1) {
                                cart.quantity -= 1;
                                quantityController.value.text =
                                    NumberFormat.decimalPatternDigits(
                                            decimalDigits: 0)
                                        .format(cart.quantity)
                                        .toString();
                              }
                              if (cart.quantity == 1) {
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
                                        title:
                                            'Bạn có muốn xóa sản phẩm ra khỏi giỏ hàng không?',
                                        btnOkOnPress: () {
                                          Get.find<CartController>()
                                              .listCart
                                              .remove(cart);
                                        },
                                        btnCancelOnPress: () {
                                          // Get.back();
                                        })
                                    .show();
                              }
                              Get.find<CartController>().getCountCart();
                            },
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: Get.width * 0.15,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  cart.quantity = double.parse(value);
                                  quantityController.value.text =
                                      NumberFormat.decimalPatternDigits(
                                              decimalDigits: 0)
                                          .format(cart.quantity)
                                          .toString();
                                  Get.find<CartController>().isChange.value =
                                      true;
                                  Get.find<CartController>().getCountCart();
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Không hợp lệ';
                                } else {
                                  if (double.parse(value) <= 0) {
                                    return 'Không hợp lệ';
                                  }
                                }
                                return null;
                              },
                              controller: quantityController.value,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                errorStyle: TextStyle(
                                  overflow: TextOverflow.clip,
                                  fontSize: 8,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.green),
                            ),
                          ),
                          InkWell(
                            child: Icon(
                              Icons.add_circle_outline,
                              size: Get.width * 0.05,
                              color: Colors.green,
                            ),
                            onTap: () {
                              cart.quantity += 1;
                              quantityController.value.text =
                                  NumberFormat.decimalPatternDigits(
                                          decimalDigits: 0)
                                      .format(cart.quantity)
                                      .toString();
                              Get.find<CartController>().getCountCart();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const Icon(
            //   Icons.delete,
            //   color: Colors.red,
            // ),
          ],
        ),
      );
    });
  }
}
