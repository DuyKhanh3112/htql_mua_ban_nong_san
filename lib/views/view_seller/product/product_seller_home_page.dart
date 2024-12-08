import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/drawer_seller.dart';
import 'package:intl/intl.dart';

class ProductSellerHomePage extends StatelessWidget {
  const ProductSellerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    SellerController sellerController = Get.find<SellerController>();
    ProductController productController = Get.find<ProductController>();
    Rx<TextEditingController> searchController = TextEditingController().obs;
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    RxBool isSearch = false.obs;
    RxList<Product> listProduct = <Product>[].obs;

    return Obx(() {
      refeshData(searchController, listProduct, productController);
      return mainController.isLoading.value ||
              sellerController.isLoading.value ||
              productController.isLoading.value
          ? const LoadingPage()
          : DefaultTabController(
              initialIndex: 0,
              length: productController.listStatus.length,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  title: const Text(
                    'Sản phẩm',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  foregroundColor: Colors.white,
                  bottom: TabBar(
                    isScrollable: true,
                    labelColor: Colors.yellow,
                    unselectedLabelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    tabs: <Widget>[
                      for (var item in productController.listStatus)
                        Tab(
                          text:
                              '${item['label']} (${listProduct.where((p0) => p0.status == item['value'] && (searchController.value.text.isEmpty || removeDiacritics(p0.name.toLowerCase()).contains(removeDiacritics(searchController.value.text.toLowerCase())))).length})',
                          // icon: Icon(Icons.flight),
                        ),
                    ],
                  ),
                  actions: [
                    isSearch.value
                        ? Row(
                            children: [
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
                                width: Get.width * 0.7,
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Tìm kiếm tên sản phẩm',
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  controller: searchController.value,
                                  onChanged: (value) {
                                    refeshData(searchController, listProduct,
                                        productController);
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  searchController.value.clear();
                                  isSearch.value = false;
                                },
                                icon: const Icon(Icons.arrow_right),
                              )
                            ],
                          )
                        : InkWell(
                            child: const Icon(Icons.search),
                            onTap: () {
                              isSearch.value = true;
                            },
                          ),
                    SizedBox(
                      width: Get.width * 0.025,
                    )
                  ],
                ),
                body: TabBarView(
                  children: <Widget>[
                    // ignore: unused_local_variable
                    for (var item in productController.listStatus)
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
                            children: [
                              for (var product in listProduct
                                  .where((p0) => p0.status == item['value']))
                                productDetail(product, currencyFormatter,
                                    productController, context),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    productController.product.value = Product.initProduct();
                    productController.category.value = Category.initCategory();
                    productController.province.value =
                        Get.find<ProvinceController>()
                                .listProvince
                                .firstWhereOrNull((element) =>
                                    element.id ==
                                    mainController.seller.value.province_id) ??
                            Province.initProvince();
                    Get.toNamed('/product_form');
                  },
                  backgroundColor: Colors.green,
                  elevation: 20,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                drawer: const DrawerSeller(),
              ),
            );
    });
  }

  void refeshData(Rx<TextEditingController> searchController,
      RxList<Product> listProduct, ProductController productController) {
    if (searchController.value.text.isEmpty) {
      listProduct.value = productController.listProduct
          .where(
            (p0) => p0.seller_id == Get.find<MainController>().seller.value.id,
          )
          .toList();
    } else {
      listProduct.value = productController.listProduct
          .where(
            (p0) =>
                p0.seller_id == Get.find<MainController>().seller.value.id &&
                removeDiacritics(p0.name.toLowerCase()).contains(
                    removeDiacritics(
                        searchController.value.text.toLowerCase())),
          )
          .toList();
    }
  }

  Container productDetail(Product product, NumberFormat currencyFormatter,
      ProductController productController, BuildContext context) {
    var imageUrl = productController.listProductImage.firstWhereOrNull(
        (img) => img.product_id == product.id && img.is_default == true);
    return Container(
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
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      // height: Get.height * 0.2,
      width: Get.width,
      padding: EdgeInsets.all(Get.width * 0.035),
      margin: EdgeInsets.all(Get.height * 0.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            // mainAxisAlignment:
            //     MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Get.width * 0.2,
                height: Get.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  image: imageUrl == null
                      ? null
                      : DecorationImage(
                          image: NetworkImage(imageUrl.image),
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              SizedBox(
                width: Get.width * 0.05,
              ),
              Container(
                width: Get.width * 0.6,
                height: Get.width * 0.2,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle.disabled,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Giá: ${currencyFormatter.format(product.price)}',
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle.disabled,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'SL: ${product.quantity}',
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle.disabled,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          product.status == 'draft'
              ? btnDraft(product, productController, context)
              : const SizedBox(),
          product.status == 'active'
              ? btnActive(product, productController, context)
              : const SizedBox(),
          product.status == 'inactive'
              ? btnInactive(product, productController, context)
              : const SizedBox(),
          product.status == 'hide'
              ? btnHide(product, productController, context)
              : const SizedBox(),
          product.status == 'lock'
              ? btnLock(product, productController, context)
              : const SizedBox(),
        ],
      ),
    );
  }

  Row btnDraft(Product product, ProductController productController,
      BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            product.create_at = Timestamp.now();
            productController.product.value = product;
            Get.toNamed('product_form');
          },
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            width: Get.width * 0.15,
            // height: Get.height * 0.05,
            child: const Text(
              'Cập nhật',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // ElevatedButton(
        //   onPressed: () async {
        //     await AwesomeDialog(
        //       titleTextStyle: const TextStyle(
        //         color: Colors.green,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 22,
        //       ),
        //       descTextStyle: const TextStyle(
        //         color: Colors.green,
        //         fontSize: 16,
        //       ),
        //       context: context,
        //       dialogType: DialogType.question,
        //       animType: AnimType.rightSlide,
        //       title: 'Bạn có muốn ẩn sản phẩm này không?',
        //       // desc: 'Bạn có muốn xóa loại sản phẩm này không?',
        //       btnOkText: 'Ẩn',
        //       btnCancelText: 'Không',
        //       btnOkOnPress: () async {
        //         product.status = 'hide';
        //         await productController.updateProduct(product);
        //       },
        //       btnCancelOnPress: () {},
        //     ).show();
        //   },
        //   child: Container(
        //     alignment: Alignment.center,
        //     decoration: const BoxDecoration(),
        //     width: Get.width * 0.15,
        //     child: const Text(
        //       'Ẩn',
        //       style: TextStyle(
        //         color: Colors.green,
        //         fontSize: 13,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Row btnActive(Product product, ProductController productController,
      BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            product.create_at = Timestamp.now();
            productController.product.value = product;
            Get.toNamed('product_form');
          },
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            width: Get.width * 0.15,
            // height: Get.height * 0.05,
            child: const Text(
              'Cập nhật',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ElevatedButton(
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
              title: 'Bạn có muốn ẩn sản phẩm này không?',
              // desc: 'Bạn có muốn xóa loại sản phẩm này không?',
              btnOkText: 'Ẩn',
              btnCancelText: 'Không',
              btnOkOnPress: () async {
                product.status = 'hide';
                await productController.updateProduct(product);
              },
              btnCancelOnPress: () {},
            ).show();
          },
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            width: Get.width * 0.15,
            child: const Text(
              'Ẩn',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ElevatedButton(
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
              title: 'Xác nhận hết hàng',
              desc: 'Nếu hết hàng, số lượng sản phẩm sẽ tự động cập nhật là 0',
              btnOkText: 'Xác nhận',
              btnCancelText: 'Không',
              btnOkOnPress: () async {
                product.status = 'inactive';
                product.quantity = 0;
                await productController.updateProduct(product);
              },
              btnCancelOnPress: () {},
            ).show();
          },
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            width: Get.width * 0.15,
            // height: Get.height * 0.05,
            child: const Text(
              'Hết hàng',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row btnInactive(Product product, ProductController productController,
      BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            product.create_at = Timestamp.now();
            productController.product.value = product;
            Get.toNamed('product_form');
          },
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            width: Get.width * 0.15,
            // height: Get.height * 0.05,
            child: const Text(
              'Cập nhật',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ElevatedButton(
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
              title: 'Bạn có muốn ẩn sản phẩm này không?',
              // desc: 'Bạn có muốn xóa loại sản phẩm này không?',
              btnOkText: 'Ẩn',
              btnCancelText: 'Không',
              btnOkOnPress: () async {
                product.status = 'hide';
                await productController.updateProduct(product);
              },
              btnCancelOnPress: () {},
            ).show();
          },
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            width: Get.width * 0.15,
            child: const Text(
              'Ẩn',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row btnHide(Product product, ProductController productController,
      BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            product.create_at = Timestamp.now();
            productController.product.value = product;
            Get.toNamed('product_form');
          },
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            width: Get.width * 0.15,
            // height: Get.height * 0.05,
            child: const Text(
              'Cập nhật',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ElevatedButton(
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
              title: 'Bạn có muốn hiện sản phẩm này không?',
              // desc: 'Bạn có muốn xóa loại sản phẩm này không?',
              btnOkText: 'Hiện',
              btnCancelText: 'Không',
              btnOkOnPress: () async {
                // if (product.quantity == 0) {
                //   product.status = 'inactive';
                // } else {
                //   product.status = 'active';
                // }
                await productController.updateProduct(product);
              },
              btnCancelOnPress: () {},
            ).show();
          },
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            width: Get.width * 0.15,
            child: const Text(
              'Hiện',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row btnLock(Product product, ProductController productController,
      BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            product.create_at = Timestamp.now();
            productController.product.value = product;
            Get.toNamed('product_form');
          },
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            width: Get.width * 0.15,
            // height: Get.height * 0.05,
            child: const Text(
              'Cập nhật',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
