import 'package:d_chart/d_chart.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:htql_mua_ban_nong_san/controller/product_controller.dart';
import 'package:htql_mua_ban_nong_san/controller/report_controller.dart';
import 'package:htql_mua_ban_nong_san/loading.dart';
import 'package:htql_mua_ban_nong_san/models/product.dart';
import 'package:htql_mua_ban_nong_san/views/view_seller/drawer_seller.dart';
import 'package:intl/intl.dart';

class ReportProductSellerPage extends StatelessWidget {
  const ReportProductSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    ReportController reportController = Get.find<ReportController>();
    ProductController productController = Get.find<ProductController>();

    RxList<Product> topProductSell = <Product>[].obs;
    RxList<Product> topProductRatting = <Product>[].obs;
    RxList<Product> topProductInventory = <Product>[].obs;
    RxInt i = 0.obs;

    return Obx(() {
      topProductSell.value = productController.listProduct
          .where((p0) =>
              p0.sale_num! > 0 && !['lock', 'draft'].contains(p0.status))
          .toList();
      topProductSell.sort((a, b) => b.sale_num!.compareTo(a.sale_num!));
      topProductSell.value = topProductSell.sublist(
          0, topProductSell.length < 5 ? topProductSell.length : 5);

      topProductRatting.value = productController.listProduct
          .where(
              (p0) => p0.ratting! > 0 && !['lock', 'draft'].contains(p0.status))
          .toList();
      topProductRatting.sort((a, b) => b.ratting!.compareTo(a.ratting!));
      topProductRatting.value = topProductRatting.sublist(
          0, topProductRatting.length < 5 ? topProductRatting.length : 5);

      topProductInventory.value = productController.listProduct;
      topProductInventory
          .sort((a, b) => (b.quantity as num).compareTo((a.quantity as num)));

      return reportController.isLoading.value
          ? const LoadingPage()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.green,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Thống kê sản phẩm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    topProductSell.isEmpty &&
                            topProductRatting.isEmpty &&
                            topProductInventory.isEmpty &&
                            reportController.reportProductStatus.isEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width * 0.8,
                                // padding: EdgeInsets.all(Get.width * 0.02),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Không có dữ liệu',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            ],
                          )
                        : Expanded(
                            child: ListView(
                              children: [
                                reportController.reportProductStatus.isEmpty
                                    ? const SizedBox()
                                    : productStatusChartPie(i),
                                topProductSell.isEmpty
                                    ? const SizedBox()
                                    : topSellerChartBar(topProductSell),
                                topProductRatting.isEmpty
                                    ? const SizedBox()
                                    : topRattingChartBar(topProductRatting),
                                topProductInventory.isEmpty
                                    ? const SizedBox()
                                    : inventoryChartBar(topProductInventory),
                              ],
                            ),
                          ),
                  ],
                ),
                drawer: const DrawerSeller(),
              ),
            );
    });
  }

  Container productStatusChartPie(RxInt i) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.05),
      margin: EdgeInsets.all(Get.width * 0.02),
      decoration: const BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
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
          const Text(
            'Tỉ lệ sản phẩm theo trạng thái',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: DChartPieO(
              data: Get.find<ReportController>().reportProductStatus,
              animate: true,
              customLabel: (ordinalData, index) {
                return NumberFormat.decimalPercentPattern(decimalDigits: 2)
                    .format(ordinalData.measure);
              },
              configRenderPie: ConfigRenderPie(
                arcLabelDecorator: ArcLabelDecorator(
                  insideLabelStyle: const LabelStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  outsideLabelStyle: const LabelStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                  showLeaderLines: true,
                  leaderLineStyle: const ArcLabelLeaderLineStyle(
                    color: Colors.black,
                    length: 20,
                    thickness: 1,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: Get.width * 0.8,
            height: Get.width * 0.2,
            alignment: Alignment.center,
            child: FlexibleGridView(
              axisCount: GridLayoutEnum.twoElementsInRow,
              children: Get.find<ProductController>().listStatus.map(
                (item) {
                  i++;
                  return Row(
                    children: [
                      i % 2 == 0
                          ? const SizedBox()
                          : Container(
                              width: Get.width * 0.05,
                              height: Get.width * 0.05,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item['color'],
                              ),
                            ),
                      Container(
                        width: Get.width * 0.3,
                        padding: EdgeInsets.only(
                          left: Get.width * 0.02,
                          right: Get.width * 0.02,
                        ),
                        alignment: i % 2 == 0
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          item['label'],
                          style: const TextStyle(
                            fontSize: 14,
                            // fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      i % 2 != 0
                          ? const SizedBox()
                          : Container(
                              width: Get.width * 0.05,
                              height: Get.width * 0.05,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: item['color'],
                              ),
                            ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Container inventoryChartBar(RxList<Product> topProductInventory) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.05),
      margin: EdgeInsets.all(Get.width * 0.02),
      decoration: const BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
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
          const Text(
            'Số lượng sản phẩm tồn kho',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: DChartBarO(
              allowSliding: true,
              groupList: [
                OrdinalGroup(
                  id: 'id',
                  data: topProductInventory
                      .map((element) => OrdinalData(
                          domain: element.name, measure: element.quantity))
                      .toList(),
                ),
              ],
              domainAxis: DomainAxis(
                ordinalViewport: OrdinalViewport('1', 3),
                gapAxisToLabel: 10,
                labelAnchor: LabelAnchor.centered,
                // thickLength: 5,
                labelRotation: 0,
                labelStyle: const LabelStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),

                lineStyle: const LineStyle(
                  color: Colors.green,
                  thickness: 1,
                  dashPattern: [],
                ),
                showLine: true,
              ),
              barLabelValue: (group, ordinalData, index) {
                return NumberFormat.decimalPatternDigits(decimalDigits: 0)
                    .format(ordinalData.measure);
              },
              outsideBarLabelStyle: (group, ordinalData, index) {
                return LabelStyle(
                  color: ordinalData.measure <= 10 ? Colors.red : Colors.green,
                  fontSize: 14,
                );
              },
              insideBarLabelStyle: (group, ordinalData, index) {
                return LabelStyle(
                  color: ordinalData.measure <= 10 ? Colors.red : Colors.white,
                  fontSize: 14,
                );
              },
              barLabelDecorator: BarLabelDecorator(
                barLabelPosition: BarLabelPosition.auto,
                labelAnchor: BarLabelAnchor.start,
                labelPadding: 10,
              ),
              configRenderBar: ConfigRenderBar(
                barGroupInnerPaddingPx: 2,
                barGroupingType: BarGroupingType.grouped,
                fillPattern: FillPattern.solid,
                maxBarWidthPx: 60,
                radius: 30,
                stackedBarPaddingPx: 1,
                strokeWidthPx: 0,
              ),
              measureAxis: MeasureAxis(
                numericViewport: NumericViewport(
                    0,
                    maxMeasure(topProductInventory
                        .map((element) => element.quantity as num)
                        .toList())),
                desiredTickCount: 5,
                showLine: true,
                labelAnchor: LabelAnchor.centered,
                labelFormat: (measure) {
                  return NumberFormat.decimalPatternDigits(decimalDigits: 0)
                      .format(measure);
                },
                labelStyle: const LabelStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
                lineStyle: const LineStyle(
                  color: Colors.green,
                  thickness: 1,
                  dashPattern: [],
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
        ],
      ),
    );
  }

  Container topRattingChartBar(RxList<Product> topProductRatting) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.05),
      margin: EdgeInsets.all(Get.width * 0.02),
      decoration: const BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
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
          Text(
            'TOP ${topProductRatting.length} sản phẩm có lượt đánh giá cao nhất',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: DChartBarO(
              allowSliding: true,
              groupList: [
                OrdinalGroup(
                  id: 'id',
                  data: topProductRatting
                      .map((element) => OrdinalData(
                          domain: element.name, measure: element.ratting ?? 0))
                      .toList(),
                ),
              ],
              domainAxis: DomainAxis(
                ordinalViewport: OrdinalViewport('1', 3),
                gapAxisToLabel: 10,
                labelAnchor: LabelAnchor.centered,
                // thickLength: 5,
                labelRotation: 0,
                labelStyle: const LabelStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),

                lineStyle: const LineStyle(
                  color: Colors.green,
                  thickness: 1,
                  dashPattern: [],
                ),
                showLine: true,
              ),
              barLabelValue: (group, ordinalData, index) {
                // String domain = ordinalData.domain;

                return NumberFormat.decimalPatternDigits(decimalDigits: 0)
                    .format(ordinalData.measure);
              },
              outsideBarLabelStyle: (group, ordinalData, index) {
                return const LabelStyle(
                  color: Colors.green,
                  fontSize: 14,
                );
              },
              insideBarLabelStyle: (group, ordinalData, index) {
                return const LabelStyle(
                  color: Colors.white,
                  fontSize: 14,
                );
              },
              barLabelDecorator: BarLabelDecorator(
                barLabelPosition: BarLabelPosition.auto,
                labelAnchor: BarLabelAnchor.start,
                labelPadding: 10,
              ),
              configRenderBar: ConfigRenderBar(
                barGroupInnerPaddingPx: 2,
                barGroupingType: BarGroupingType.grouped,
                fillPattern: FillPattern.solid,
                maxBarWidthPx: 60,
                radius: 30,
                stackedBarPaddingPx: 1,
                strokeWidthPx: 0,
              ),
              measureAxis: MeasureAxis(
                numericViewport: const NumericViewport(0, 5),
                desiredTickCount: 6,
                showLine: true,
                labelAnchor: LabelAnchor.centered,
                labelFormat: (measure) {
                  return NumberFormat.decimalPatternDigits(decimalDigits: 0)
                      .format(measure);
                },
                labelStyle: const LabelStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
                lineStyle: const LineStyle(
                  color: Colors.green,
                  thickness: 1,
                  dashPattern: [],
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
        ],
      ),
    );
  }

  Container topSellerChartBar(RxList<Product> topProductSell) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.05),
      margin: EdgeInsets.all(Get.width * 0.02),
      decoration: const BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
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
          Text(
            'TOP ${topProductSell.length} sản phẩm bán chạy',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          AspectRatio(
            aspectRatio: 1.5,
            child: DChartBarO(
              allowSliding: true,
              groupList: [
                OrdinalGroup(
                  id: 'id',
                  data: topProductSell
                      .map((element) => OrdinalData(
                          domain: element.name, measure: element.sale_num ?? 0))
                      .toList(),
                ),
              ],
              domainAxis: DomainAxis(
                ordinalViewport: OrdinalViewport('1', 3),
                gapAxisToLabel: 10,
                labelAnchor: LabelAnchor.centered,
                // thickLength: 5,
                labelRotation: 0,
                labelStyle: const LabelStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),

                lineStyle: const LineStyle(
                  color: Colors.green,
                  thickness: 1,
                  dashPattern: [],
                ),
                showLine: true,
              ),
              barLabelValue: (group, ordinalData, index) {
                // String domain = ordinalData.domain;

                return NumberFormat.decimalPatternDigits(decimalDigits: 0)
                    .format(ordinalData.measure);
              },
              outsideBarLabelStyle: (group, ordinalData, index) {
                return const LabelStyle(
                  color: Colors.green,
                  fontSize: 14,
                );
              },
              insideBarLabelStyle: (group, ordinalData, index) {
                return const LabelStyle(
                  color: Colors.white,
                  fontSize: 14,
                );
              },
              barLabelDecorator: BarLabelDecorator(
                barLabelPosition: BarLabelPosition.auto,
                labelAnchor: BarLabelAnchor.start,
                labelPadding: 10,
              ),
              configRenderBar: ConfigRenderBar(
                barGroupInnerPaddingPx: 2,
                barGroupingType: BarGroupingType.grouped,
                fillPattern: FillPattern.solid,
                maxBarWidthPx: 60,
                radius: 30,
                stackedBarPaddingPx: 1,
                strokeWidthPx: 0,
              ),
              measureAxis: MeasureAxis(
                numericViewport: NumericViewport(
                    0,
                    maxMeasure(topProductSell
                        .map((element) => element.sale_num ?? 0)
                        .toList())),
                desiredTickCount: 5,
                showLine: true,
                labelAnchor: LabelAnchor.centered,
                labelFormat: (measure) {
                  return NumberFormat.decimalPatternDigits(decimalDigits: 0)
                      .format(measure);
                },
                labelStyle: const LabelStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
                lineStyle: const LineStyle(
                  color: Colors.green,
                  thickness: 1,
                  dashPattern: [],
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
        ],
      ),
    );
  }

  num maxMeasure(List<num> measure) {
    num max = 0;
    for (var item in measure) {
      if (item > max) {
        max = item;
      }
    }
    return max;
  }
}
