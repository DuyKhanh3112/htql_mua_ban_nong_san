import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/category_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/province_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/category.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/main_drawer.dart';
import 'package:intl/intl.dart';

class ProductHomePage extends StatelessWidget {
  const ProductHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductController productController = Get.find<ProductController>();
    MainController mainController = Get.find<MainController>();
    TextEditingController categoryController = TextEditingController();
    TextEditingController provinceController = TextEditingController();
    final currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    List<String> status = ['draft', 'active', 'lock'];
    Rx<Category> category = Category.initCategory().obs;
    Rx<Province> province = Province.initProvince().obs;
    return Obx(() {
      return mainController.isLoading.value || productController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Sản phẩm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    Container(
                      padding: const EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: () async {
                          // widgetCreateCategory(context);
                          productController.loadAllProduct();
                        },
                        child: const Icon(
                          Icons.refresh,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  // padding: const EdgeInsets.all(10),
                  children: [
                    Row(
                      children: [
                        Container(
                          width: Get.width / 2,
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Loại sản phẩm',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  value: Get.find<CategoryController>()
                                      .listCategory
                                      .firstWhereOrNull((element) =>
                                          element.id == category.value.id &&
                                          element.hide == false),
                                  // items: Get.find<CategoryController>()
                                  //     .listCategory.where((p0) => p0.hide==false)
                                  //     .map(
                                  //       (category) => DropdownMenuItem(
                                  //         value: category,
                                  //         child: Text(
                                  //           category.name,
                                  //           overflow: TextOverflow.ellipsis,
                                  //           strutStyle: StrutStyle.disabled,
                                  //         ),
                                  //       ),
                                  //     )
                                  //     .toList(),
                                  items: [
                                    DropdownMenuItem(
                                      value: Category.initCategory(),
                                      child: const Text(
                                        'Tất cả',
                                        overflow: TextOverflow.ellipsis,
                                        strutStyle: StrutStyle.disabled,
                                      ),
                                    ),
                                    for (var category
                                        in Get.find<CategoryController>()
                                            .listCategory
                                            .where((p0) => p0.hide == false))
                                      DropdownMenuItem(
                                        value: category,
                                        child: Text(
                                          category.name,
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle: StrutStyle.disabled,
                                        ),
                                      ),
                                  ],
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                  ),
                                  isExpanded: true,
                                  onChanged: (value) {
                                    category.value = value!;
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: Get.height / 2,
                                    width: Get.width * 0.75,
                                    // padding: EdgeInsets.all(5),
                                  ),
                                  buttonStyleData: ButtonStyleData(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(5),
                                  ),
                                  dropdownSearchData: DropdownSearchData(
                                      searchController: categoryController,
                                      searchInnerWidgetHeight:
                                          Get.height * 0.05,
                                      searchInnerWidget: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
                                        child: TextField(
                                          controller: categoryController,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Colors.red)),
                                              hintText:
                                                  'Tìm kiếm loại sản phẩm theo tên',
                                              contentPadding:
                                                  const EdgeInsets.all(10)),
                                        ),
                                      ),
                                      searchMatchFn:
                                          (DropdownMenuItem<Category> item,
                                              searchValue) {
                                        return removeDiacritics(
                                                item.value!.name.toLowerCase())
                                            .contains(removeDiacritics(
                                                searchValue.toLowerCase()));
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width / 2,
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tỉnh thành',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  value: Get.find<ProvinceController>()
                                      .listProvince
                                      .firstWhereOrNull((element) =>
                                          element.id == province.value.id),
                                  // items: productController.listProvince
                                  //     .map(
                                  //       (province) => DropdownMenuItem(
                                  //         value: province,
                                  //         child: Text(
                                  //           province.name,
                                  //           overflow: TextOverflow.ellipsis,
                                  //           strutStyle: StrutStyle.disabled,
                                  //         ),
                                  //       ),
                                  //     )
                                  //     .toList(),
                                  items: [
                                    DropdownMenuItem(
                                      value: Province.initProvince(),
                                      child: const Text(
                                        'Tất cả',
                                        overflow: TextOverflow.ellipsis,
                                        strutStyle: StrutStyle.disabled,
                                      ),
                                    ),
                                    for (var province
                                        in Get.find<ProvinceController>()
                                            .listProvince)
                                      DropdownMenuItem(
                                        value: province,
                                        child: Text(
                                          province.name,
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle: StrutStyle.disabled,
                                        ),
                                      ),
                                  ],
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                  ),
                                  isExpanded: true,
                                  onChanged: (value) {
                                    province.value = value!;
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: Get.height / 2,
                                    width: Get.width * 0.75,
                                    // padding: EdgeInsets.all(5),
                                  ),
                                  buttonStyleData: ButtonStyleData(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(5),
                                  ),
                                  dropdownSearchData: DropdownSearchData(
                                      searchController: provinceController,
                                      searchInnerWidgetHeight:
                                          Get.height * 0.05,
                                      searchInnerWidget: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
                                        child: TextField(
                                          controller: provinceController,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Colors.red)),
                                              hintText:
                                                  'Tìm kiếm tỉnh thành theo tên',
                                              contentPadding:
                                                  const EdgeInsets.all(10)),
                                        ),
                                      ),
                                      searchMatchFn:
                                          (DropdownMenuItem<Province> item,
                                              searchValue) {
                                        return removeDiacritics(
                                                item.value!.name.toLowerCase())
                                            .contains(removeDiacritics(
                                                searchValue.toLowerCase()));
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                        child: ListView(
                      children: [
                        for (var product in productController.listProduct.where(
                            (p0) =>
                                p0.status ==
                                    status[productController
                                        .indexProductPage.value] &&
                                (category.value.id == '' ||
                                    p0.category_id == category.value.id) &&
                                (province.value.id == '' ||
                                    p0.province_id == province.value.id)))
                          productDetail(product, currencyFormatter,
                              productController, context)
                      ],
                    ))
                  ],
                ),
                drawer: const DrawerAdmin(),
                bottomNavigationBar: BottomNavigationBar(
                  elevation: 15,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 15,
                  unselectedFontSize: 12,
                  selectedIconTheme: const IconThemeData(
                    size: 25,
                  ),
                  unselectedIconTheme: const IconThemeData(
                    size: 20,
                  ),
                  showUnselectedLabels: true,
                  backgroundColor: Colors.green,
                  unselectedItemColor: Colors.white,
                  unselectedLabelStyle: const TextStyle(color: Colors.white),
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  selectedItemColor: Colors.yellowAccent,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.change_circle),
                      label:
                          'Chờ duyệt (${productController.listProduct.where((p0) => p0.status == status[0] && (category.value.id == '' || p0.category_id == category.value.id) && (province.value.id == '' || p0.province_id == province.value.id)).length})',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.check_circle),
                      label:
                          'Đã duyệt(${productController.listProduct.where((p0) => p0.status == status[1] && (category.value.id == '' || p0.category_id == category.value.id) && (province.value.id == '' || p0.province_id == province.value.id)).length})',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.error_sharp),
                      label:
                          'Vi phạm (${productController.listProduct.where((p0) => p0.status == status[2] && (category.value.id == '' || p0.category_id == category.value.id) && (province.value.id == '' || p0.province_id == province.value.id)).length})',
                    ),
                  ],
                  onTap: (index) {
                    productController.indexProductPage.value = index;
                  },
                  currentIndex: productController.indexProductPage.value,
                ),
              ),
            );
    });
  }

  Container productDetail(Product product, NumberFormat currencyFormatter,
      ProductController productController, BuildContext context) {
    var imageUrl = productController.listProductImage.firstWhereOrNull(
        (img) => img.product_id == product.id && img.is_default == true);
    Seller? seller = Get.find<SellerController>()
        .listSeller
        .firstWhereOrNull((p0) => p0.id == product.seller_id);

    Category category = Get.find<CategoryController>()
            .listCategory
            .firstWhereOrNull(
                (c) => c.id == product.category_id && c.hide == false) ??
        Category.initCategory();

    Province province = Get.find<ProvinceController>()
            .listProvince
            .firstWhereOrNull((p) => p.id == product.province_id) ??
        Province.initProvince();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                // height: Get.width * 0.2,
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
                      'Shop: ${seller == null ? '' : seller.name}',
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle.disabled,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Loại: ${category.name}',
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle.disabled,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Tỉnh thành: ${province.name}',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  productController.product.value = product;
                  Get.toNamed('product_form');
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(),
                  width: Get.width * 0.15,
                  // height: Get.height * 0.05,
                  child: const Text(
                    'Chi tiết',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              product.status == 'draft'
                  ? ElevatedButton(
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
                          title: 'Xác nhận sản phẩm được duyệt',
                          // desc: 'Bạn có muốn xóa loại sản phẩm này không?',
                          btnOkText: 'Xác nhận',
                          btnCancelText: 'Không',
                          btnOkOnPress: () async {
                            product.status = 'active';
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
                          'Duyệt',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              product.status != 'lock'
                  ? ElevatedButton(
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
                          title: 'Xác nhận sản phẩm vi phạm',
                          // desc: 'Bạn có muốn xóa loại sản phẩm này không?',
                          btnOkText: 'Xác nhận',
                          btnCancelText: 'Không',
                          btnOkOnPress: () async {
                            product.status = 'lock';
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
                          'Vi phạm',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
