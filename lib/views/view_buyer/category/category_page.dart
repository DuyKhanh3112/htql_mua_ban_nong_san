import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/cart_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';
import 'package:intl/intl.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    RxDouble quantityCart = 0.0.obs;
    // quantityCart.value = Get.find<CartController>().getQuantityCart();
    quantityCart.value = 0;
    RxList<Category> listCategory = <Category>[].obs;
    Rx<TextEditingController> searchController = TextEditingController().obs;

    loadData(listCategory, searchController);
    return Obx(() {
      return mainController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      // height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Icon(Icons.search),
                          Container(
                            margin: EdgeInsets.only(top: Get.width * 0.01),
                            padding: EdgeInsets.only(
                                left: Get.width * 0.02,
                                right: Get.width * 0.02),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                            width: Get.width * 0.5,
                            child: TextFormField(
                              controller: searchController.value,
                              onChanged: (value) {
                                loadData(listCategory, searchController);
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                suffixIcon: searchController.value.text.isEmpty
                                    ? null
                                    : InkWell(
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onTap: () {
                                          searchController.value.clear();
                                          loadData(
                                              listCategory, searchController);
                                        },
                                      ),
                                border: InputBorder.none,
                                hintText: 'Tìm kiếm ...',
                                hintStyle: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                          Get.find<MainController>().buyer.value.id == ''
                              ? const SizedBox()
                              : InkWell(
                                  onTap: () async {
                                    mainController.isLoading.value = true;
                                    await Get.find<CartController>()
                                        .getCartGroupBySeller();
                                    Get.find<CartController>()
                                        .listCartChoose
                                        .value = [];
                                    mainController.isLoading.value = false;
                                    Get.toNamed('/cart');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.1),
                                    child: Get.find<CartController>()
                                                .countCart
                                                .value ==
                                            0
                                        ? const Icon(
                                            Icons.shopping_cart,
                                            color: Colors.white,
                                            size: 35,
                                          )
                                        : Badge(
                                            label: Text(
                                              NumberFormat.decimalPattern()
                                                  .format(
                                                      Get.find<CartController>()
                                                          .countCart
                                                          .value),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            child: const Icon(
                                              Icons.shopping_cart,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: FlexibleGridView(
                        axisCount: GridLayoutEnum.twoElementsInRow,
                        children: listCategory.map((category) {
                          return InkWell(
                            onTap: () {
                              Get.find<ProductController>().category.value =
                                  category;
                              Get.toNamed('search_product');
                            },
                            child: Container(
                              width: Get.width * 0.5,
                              // height: 100,
                              margin: EdgeInsets.all(Get.width * 0.03),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: Get.width * 0.3,
                                    // width: Get.width * 0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      // ignore: unnecessary_null_comparison
                                      image: category.image == null
                                          ? null
                                          : DecorationImage(
                                              image:
                                                  NetworkImage(category.image),
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                  // SizedBox(height: Get.height,),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.02),
                                    margin: EdgeInsets.symmetric(
                                        vertical: Get.width * 0.01),
                                    alignment: Alignment.center,
                                    child: Text(
                                      category.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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

  void loadData(RxList<Category> listCategory,
      Rx<TextEditingController> searchController) {
    listCategory.value = [];
    listCategory.value = Get.find<CategoryController>()
        .listCategory
        .where((p0) =>
            p0.hide == false &&
            (searchController.value.text.isEmpty ||
                removeDiacritics(p0.name.toLowerCase())
                    .contains(searchController.value.text)))
        .toList();
  }
}
