import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:convert_vietnamese/convert_vietnamese.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/address_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/address.dart';
import 'package:htql_mua_ban_nong_san/models/province.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainController mainController = Get.find<MainController>();
    RxDouble quantityCart = 0.0.obs;
    // quantityCart.value = Get.find<CartController>().getQuantityCart();
    quantityCart.value = 0;

    return Obx(() {
      return mainController.isLoading.value ||
              Get.find<AddressController>().isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  title: const Text(
                    'Địa chỉ nhận hàng',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  foregroundColor: Colors.white,
                  actions: [
                    InkWell(
                      onTap: () {
                        createAddress(context);
                      },
                      child: const Icon(
                        Icons.add_circle_outline,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView(
                        children: Get.find<AddressController>()
                            .listAddress
                            .map(
                              (address) => addressDetail(address, context),
                            )
                            .toList(),
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

  Widget addressDetail(Address address, BuildContext context) {
    Province province = Get.find<ProductController>()
            .listProvince
            .firstWhereOrNull((element) => element.id == address.province_id) ??
        Province.initProvince();
    return Row(
      children: [
        InkWell(
          onTap: () async {
            Get.find<AddressController>().address.value = address;
            updateAddress(context);
          },
          child: Row(
            children: [
              Container(
                // height: Get.height * 0.15,
                alignment: Alignment.centerLeft,
                width: Get.width * 0.78,
                margin: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.01,
                  vertical: Get.width * 0.02,
                ),
                padding: EdgeInsets.all(Get.width * 0.05),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // width: Get.width * 0.6,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(),
                      child: Text(
                        'Tên người nhận: ${address.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      // width: Get.width * 0.6,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(),
                      child: Text(
                        'Số điện thoại: ${address.phone}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          overflow: TextOverflow.ellipsis,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      // width: Get.width * 0.6,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(),
                      child: Text(
                        'Địa chỉ: ${address.address_detail}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Container(
                      // width: Get.width * 0.6,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(),
                      child: Text(
                        'Tỉnh thành: ${province.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: Get.width * 0.2,
          padding: EdgeInsets.all(Get.width * 0.05),
          alignment: Alignment.centerRight,
          // height: Get.height * 0.2,
          // decoration: const BoxDecoration(color: Colors.amber),
          child: address.is_default
              ? Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: Get.width * 0.1,
                )
              : InkWell(
                  onTap: () async {
                    await Get.find<AddressController>().setDefault(address);
                  },
                  child: Icon(
                    Icons.circle_outlined,
                    color: Colors.green,
                    size: Get.width * 0.1,
                  ),
                ),
        ),
      ],
    );
  }

  void createAddress(BuildContext context) {
    AddressController addressController = Get.find<AddressController>();
    var formKey = GlobalKey<FormState>();

    TextEditingController nameController = TextEditingController();
    TextEditingController addressDetailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    TextEditingController searchProvinceController = TextEditingController();

    Rx<Province> province = Province.initProvince().obs;

    nameController.text = Get.find<MainController>().buyer.value.name;

    Get.dialog(
      Obx(
        () {
          return AlertDialog(
            title: SizedBox(
              width: Get.width * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Thêm địa chỉ',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
            content: SizedBox(
              height: Get.height * 0.5,
              width: Get.width * 0.8,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          TextFormField(
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                            ),
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty || value.trim() == '') {
                                return 'Hãy nhập tên người nhận';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: 'Tên người nhận',
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          TextFormField(
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                            ),
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty || value.trim() == '') {
                                return 'Hãy nhập số điện thoại';
                              }
                              final RegExp phoneRegExp =
                                  RegExp(r"(84|0[3|5|7|8|9])+([0-9]{8})\b");
                              if (!phoneRegExp.hasMatch(value)) {
                                return 'Số điện thoại không hợp lệ.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: 'Số điện thoại',
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Column(
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
                                  value: Get.find<ProductController>()
                                      .listProvince
                                      .firstWhereOrNull((element) =>
                                          element.id == province.value.id),
                                  items: Get.find<ProductController>()
                                      .listProvince
                                      .map(
                                        (province) => DropdownMenuItem(
                                          value: province,
                                          child: Text(
                                            province.name,
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle: StrutStyle.disabled,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                  ),
                                  isExpanded: true,
                                  onChanged: (value) {
                                    if (value == null) {
                                      province.value = Province.initProvince();
                                    } else {
                                      province.value = value;
                                    }
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: Get.height * 0.4,
                                    width: Get.width * 0.75,
                                    // padding: EdgeInsets.all(5),
                                  ),
                                  buttonStyleData: ButtonStyleData(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.05),
                                  ),
                                  dropdownSearchData: DropdownSearchData(
                                      searchController:
                                          searchProvinceController,
                                      searchInnerWidgetHeight:
                                          Get.height * 0.05,
                                      searchInnerWidget: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
                                        child: TextField(
                                          controller: searchProvinceController,
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
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          TextFormField(
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                            ),
                            controller: addressDetailController,
                            validator: (value) {
                              if (value!.isEmpty || value.trim() == '') {
                                return 'Hãy nhập địa chỉ chi tiết';
                              }
                              return null;
                            },
                            maxLines: 3,
                            minLines: 2,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: 'Địa chỉ chi tiết',
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.05,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (province.value.id == '') {
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
                              title: 'Hãy chọn tỉnh thành!',
                              btnOkOnPress: () {},
                            ).show();
                            return;
                          }
                          Address address = Address(
                              id: '',
                              buyer_id:
                                  Get.find<MainController>().buyer.value.id,
                              name: nameController.text,
                              province_id: province.value.id,
                              address_detail: addressDetailController.text,
                              phone: phoneController.text,
                              is_default:
                                  addressController.listAddress.isEmpty);

                          Get.back();
                          Get.find<MainController>().isLoading.value = true;
                          await addressController.createAddress(address);
                          Get.find<MainController>().isLoading.value = false;
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
                            title: 'Thêm địa chỉ nhận hàng thành công!',
                            btnOkOnPress: () {},
                          ).show();
                        }
                      },
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
                          'Thêm địa chỉ',
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
            ),
          );
        },
      ),
    );
  }

  void updateAddress(BuildContext context) {
    AddressController addressController = Get.find<AddressController>();
    var formKey = GlobalKey<FormState>();

    TextEditingController nameController = TextEditingController();
    TextEditingController addressDetailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    TextEditingController searchProvinceController = TextEditingController();

    Rx<Province> province = Province.initProvince().obs;

    nameController.text = addressController.address.value.name;
    phoneController.text = addressController.address.value.phone;
    province.value = Get.find<ProductController>()
            .listProvince
            .firstWhereOrNull((element) =>
                element.id == addressController.address.value.province_id) ??
        Province.initProvince();
    addressDetailController.text =
        addressController.address.value.address_detail;

    Get.dialog(
      Obx(
        () {
          return AlertDialog(
            title: SizedBox(
              width: Get.width * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cập nhật địa chỉ',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
            content: SizedBox(
              height: Get.height * 0.5,
              width: Get.width * 0.8,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          TextFormField(
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                            ),
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty || value.trim() == '') {
                                return 'Hãy nhập tên người nhận';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: 'Tên người nhận',
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          TextFormField(
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                            ),
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty || value.trim() == '') {
                                return 'Hãy nhập số điện thoại';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: 'Số điện thoại',
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Column(
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
                                  value: Get.find<ProductController>()
                                      .listProvince
                                      .firstWhereOrNull((element) =>
                                          element.id == province.value.id),
                                  items: Get.find<ProductController>()
                                      .listProvince
                                      .map(
                                        (province) => DropdownMenuItem(
                                          value: province,
                                          child: Text(
                                            province.name,
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle: StrutStyle.disabled,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                  ),
                                  isExpanded: true,
                                  onChanged: (value) {
                                    if (value == null) {
                                      province.value = Province.initProvince();
                                    } else {
                                      province.value = value;
                                    }
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: Get.height * 0.4,
                                    width: Get.width * 0.75,
                                    // padding: EdgeInsets.all(5),
                                  ),
                                  buttonStyleData: ButtonStyleData(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.05),
                                  ),
                                  dropdownSearchData: DropdownSearchData(
                                      searchController:
                                          searchProvinceController,
                                      searchInnerWidgetHeight:
                                          Get.height * 0.05,
                                      searchInnerWidget: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 8, 8, 0),
                                        child: TextField(
                                          controller: searchProvinceController,
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
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          TextFormField(
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                            ),
                            controller: addressDetailController,
                            validator: (value) {
                              if (value!.isEmpty || value.trim() == '') {
                                return 'Hãy nhập địa chỉ chi tiết';
                              }
                              return null;
                            },
                            maxLines: 3,
                            minLines: 2,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: 'Địa chỉ chi tiết',
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.05,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (province.value.id == '') {
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
                              title: 'Hãy chọn tỉnh thành!',
                              btnOkOnPress: () {},
                            ).show();
                            return;
                          }
                          Address address = Address(
                              id: addressController.address.value.id,
                              buyer_id:
                                  Get.find<MainController>().buyer.value.id,
                              name: nameController.text,
                              province_id: province.value.id,
                              address_detail: addressDetailController.text,
                              phone: phoneController.text,
                              is_default:
                                  addressController.listAddress.isEmpty);

                          Get.back();
                          await addressController.updateAddress(address);
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
                            title: 'Cập nhật địa chỉ nhận hàng thành công!',
                            btnOkOnPress: () {},
                          ).show();
                        }
                      },
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
                          'Cập nhật địa chỉ',
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
            ),
          );
        },
      ),
    );
  }
}
