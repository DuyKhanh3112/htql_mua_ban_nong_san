import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/buyer_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/cart.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:intl/intl.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    BuyerController buyerController = Get.find<BuyerController>();
    MainController mainController = Get.find<MainController>();
    CartController cartController = Get.find<CartController>();
    RxInt num = 1000000.obs;

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
                                // for (var i = 1; i < 10; i++)
                                //   cart_by_seller(i, currencyFormatter, num,
                                //       buyerController)
                                for (var item
                                    in cartController.getCartGroupBySeller())
                                  cartSeller(item),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // ignore: invalid_use_of_protected_member
                    ],
                  ),
                ),
              );
      },
    );
  }

  Container cartSeller(item) {
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
              Checkbox(value: false, onChanged: (value) {}),
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
                      offset: const Offset(0, 3), // changes position of shadow
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
              for (var cart in item[1]) cartDetail(cart),
              // for (var a = 0; a < 3; a++)
              //   cart_details(currencyFormatter, num, buyerController),
            ],
          ),
        ],
      ),
    );
  }

  Container cartDetail(cart) {
    return Container(
      // padding: const EdgeInsets.all(5),
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(value: false, onChanged: (value) {}),
          Container(
            width: Get.width * 0.2,
            height: Get.height * 0.15,
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
              image: const DecorationImage(
                image: NetworkImage(
                  'https://res.cloudinary.com/dg3p7nxyp/image/upload/v1723623724/bymax.png',
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
                Text(
                  (cart as Cart).product_id,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: const Icon(
                            Icons.remove_circle_outline,
                            size: 16,
                            color: Colors.green,
                          ),
                          onTap: () {},
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 40,
                          child: TextFormField(
                            onChanged: (value) {},
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.green),
                          ),
                        ),
                        InkWell(
                          child: const Icon(
                            Icons.add_circle_outline,
                            size: 16,
                            color: Colors.green,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
