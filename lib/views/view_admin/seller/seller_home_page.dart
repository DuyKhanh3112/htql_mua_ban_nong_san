import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/seller_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/seller.dart';
import 'package:htql_mua_ban_nong_san/views/view_admin/drawer_admin.dart';

class SellerHomePage extends StatelessWidget {
  const SellerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Get.find<SellerController>().isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  title: const Text(
                    'Người bán',
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
                        children: Get.find<SellerController>()
                            .listSeller
                            .where((p0) =>
                                p0.status ==
                                Get.find<SellerController>().listStatus[
                                    Get.find<SellerController>()
                                        .indexSeller
                                        .value]['value'])
                            .map(
                              (seller) => sellerDetail(seller),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
                drawer: const DrawerAdmin(),
                bottomNavigationBar: BottomNavigationBar(
                  elevation: 15,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 12,
                  unselectedFontSize: 10,
                  selectedIconTheme: const IconThemeData(
                    size: 20,
                  ),
                  unselectedIconTheme: const IconThemeData(
                    size: 15,
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
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.warning_rounded),
                      label:
                          'Chờ duyệt (${Get.find<SellerController>().listSeller.where((p0) => p0.status == 'draft').length})',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.no_accounts_sharp),
                      label:
                          'Hoạt động (${Get.find<SellerController>().listSeller.where((p0) => p0.status == 'active').length})',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.no_accounts_sharp),
                      label:
                          'Cảnh báo (${Get.find<SellerController>().listSeller.where((p0) => p0.status == 'warning').length})',
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.no_accounts_sharp),
                      label:
                          'Khóa (${Get.find<SellerController>().listSeller.where((p0) => p0.status == 'inactive').length})',
                    ),
                  ],
                  onTap: (index) {
                    Get.find<SellerController>().indexSeller.value = index;
                  },
                  currentIndex: Get.find<SellerController>().indexSeller.value,
                ),
              ),
            );
    });
  }

  Container sellerDetail(Seller seller) {
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
      width: Get.width,
      padding: EdgeInsets.all(Get.width * 0.035),
      margin: EdgeInsets.all(Get.height * 0.01),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Get.width * 0.2,
                height: Get.width * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(seller.avatar!),
                  ),
                ),
              ),
              Container(
                width: Get.width * 0.65,
                alignment: Alignment.centerLeft,
                // height: Get.height * 0.2,
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller.username,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      strutStyle: StrutStyle.disabled,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Text(
                      'Email: ${seller.email}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      strutStyle: StrutStyle.disabled,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    Text(
                      'SĐT: ${seller.phone}',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      strutStyle: StrutStyle.disabled,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          seller.status == 'draft'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width * 0.4,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          seller.status = 'active';
                          await Get.find<SellerController>()
                              .updateSeller(seller);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(),
                          width: Get.width * 0.4,
                          child: const Text(
                            'Duyệt tài khoản',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          seller.status == 'warning'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width * 0.4,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          seller.status = 'inactive';
                          await Get.find<SellerController>()
                              .updateSeller(seller);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(),
                          width: Get.width * 0.4,
                          child: const Text(
                            'Khóa tài khoản',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          seller.status == 'inactive'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width * 0.4,
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          seller.status = 'active';
                          await Get.find<SellerController>()
                              .updateSeller(seller);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(),
                          width: Get.width * 0.4,
                          child: const Text(
                            'Mở khóa',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  // Widget buyerDetail(Seller buyer) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey,
  //           offset: Offset(4.0, 4.0),
  //           blurRadius: 10.0,
  //           spreadRadius: 2.0,
  //         ),
  //       ],
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(20),
  //       ),
  //     ),
  //     width: Get.width,
  //     padding: EdgeInsets.all(Get.width * 0.035),
  //     margin: EdgeInsets.all(Get.height * 0.01),
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(
  //               width: Get.width * 0.2,
  //               height: Get.width * 0.2,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 image: DecorationImage(
  //                   image: NetworkImage(buyer.avatar!),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               width: Get.width * 0.65,
  //               alignment: Alignment.centerLeft,
  //               // height: Get.height * 0.2,
  //               decoration: const BoxDecoration(),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     buyer.username,
  //                     overflow: TextOverflow.ellipsis,
  //                     textAlign: TextAlign.left,
  //                     strutStyle: StrutStyle.disabled,
  //                     style: const TextStyle(
  //                       color: Colors.green,
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   const Divider(),
  //                   Text(
  //                     'Email: ${buyer.email}',
  //                     overflow: TextOverflow.ellipsis,
  //                     textAlign: TextAlign.left,
  //                     strutStyle: StrutStyle.disabled,
  //                     style: const TextStyle(
  //                       color: Colors.green,
  //                       fontSize: 16,
  //                       overflow: TextOverflow.clip,
  //                     ),
  //                   ),
  //                   Text(
  //                     'SĐT: ${buyer.phone}',
  //                     overflow: TextOverflow.ellipsis,
  //                     textAlign: TextAlign.left,
  //                     strutStyle: StrutStyle.disabled,
  //                     style: const TextStyle(
  //                       color: Colors.green,
  //                       fontSize: 16,
  //                       overflow: TextOverflow.clip,
  //                     ),
  //                   ),
  //                   Text(
  //                     'Tỉ lệ nhận hàng thành công ${buyer.rate_order}%',
  //                     overflow: TextOverflow.ellipsis,
  //                     textAlign: TextAlign.left,
  //                     strutStyle: StrutStyle.disabled,
  //                     style: TextStyle(
  //                       color:
  //                           buyer.rate_order! >= 80 ? Colors.green : Colors.red,
  //                       fontSize: 14,
  //                       fontStyle: FontStyle.italic,
  //                       overflow: TextOverflow.clip,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //         const Divider(),
  //         buyer.status == 'warning'
  //             ? Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     width: Get.width * 0.4,
  //                     alignment: Alignment.center,
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         buyer.status = 'inactive';
  //                         await Get.find<BuyerController>().updateBuyer(buyer);
  //                       },
  //                       child: Container(
  //                         alignment: Alignment.center,
  //                         decoration: const BoxDecoration(),
  //                         width: Get.width * 0.4,
  //                         child: const Text(
  //                           'Khóa tài khoản',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                             color: Colors.red,
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             : const SizedBox(),
  //         buyer.status == 'inactive'
  //             ? Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     width: Get.width * 0.4,
  //                     alignment: Alignment.center,
  //                     child: ElevatedButton(
  //                       onPressed: () async {
  //                         buyer.status = 'active';
  //                         await Get.find<BuyerController>().updateBuyer(buyer);
  //                       },
  //                       child: Container(
  //                         alignment: Alignment.center,
  //                         decoration: const BoxDecoration(),
  //                         width: Get.width * 0.4,
  //                         child: const Text(
  //                           'Mở khóa',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                             color: Colors.green,
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             : const SizedBox(),
  //       ],
  //     ),
  //   );
  // }
}
