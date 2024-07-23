import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/main_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/widget/header_widget.dart';

class HomeUserPage extends StatelessWidget {
  const HomeUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainController());
    MainController mainController = Get.find<MainController>();

    return Obx(() {
      return mainController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    // const HeaderWidget(),
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Icon(Icons.search),
                              SizedBox(
                                width: Get.width / 2,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Tìm kiếm ...',
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.white,
                                            style: BorderStyle.solid)),
                                    contentPadding: const EdgeInsets.only(
                                      left: 10,
                                      top: 0,
                                      bottom: 0,
                                      right: 10,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.shopping_cart,
                                // size: 35,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Expanded(
                      child: Container(
                        // padding: const EdgeInsets.all(10),
                        // margin: const EdgeInsets.only(bottom: 10, top: 10),
                        child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(100, (index) {
                            return Container(
                              // padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(),
                              child: Card(
                                // margin: const EdgeInsets.all(10),
                                // color: Colors.red,
                                child: InkWell(
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Image(
                                            image: const NetworkImage(
                                                'https://media-cdn-v2.laodong.vn/Storage/NewsPortal/2021/4/6/896286/Qua-Tao-1.jpg'),
                                            width: Get.width,
                                          ),
                                          Container(
                                            color: Colors.green,
                                            width: Get.width / 2,
                                            // height: 20,
                                            child: const Text(
                                              'Ten Shop',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        'Ten san pham',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const Text(
                                        'Gia: 1.000.000 VND',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
    });
  }
}
