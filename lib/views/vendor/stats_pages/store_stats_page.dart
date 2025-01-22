import 'package:flutter/material.dart';
import 'package:ofg_web/services/store_stats_service.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class StoreStatsPage extends StatefulWidget {
  StoreStatsPage(
      {super.key, required this.checkouts, required this.storeListings});
  List checkouts;
  List storeListings;

  @override
  State<StoreStatsPage> createState() => _StoreStatsPageState();
}

class _StoreStatsPageState extends State<StoreStatsPage> {
// the finals
  final StatsService storeStatsService = StatsService();
  final ColorPalette _palette = ColorPalette();

  // the payment count list
  List<int> paymentModeCount = [];
  final List paymentOptions = [
    "Cash",
    "Card",
    "Debt",
    "Coupons",
    "UPI",
    "Paypal",
    "Other"
  ];

  // the data source for the payment mode chart. populated on initstate
  List<PaymentChartData> paymentChartData = [];

  // the top movers lists
  List topMovers = [];

  // the data source for the top movers chart, populated on initstate
  List<TopMoversChartData> topMoversChartData = [];

  @override
  void initState() {
    // set the payment mode count for chart rendering
    paymentModeCountSetter();
    topMoversSetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // dimensions
    final double height = MediaQuery.sizeOf(context).height;

    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          // the most interacted item from store details
          // the main text that says
          const Text(
            'Top Movers',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const Text(
            'General stats from your store items',
            style: TextStyle(color: Colors.grey),
          ),

          SizedBox(
            height: height * 0.02,
          ),

          // top movers chart
          SizedBox(
            height: height * 0.26,
            child: SfCartesianChart(
              title: ChartTitle(
                text: 'Most checked out items',
                textStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              enableMultiSelection: true,
              primaryXAxis:
                  CategoryAxis(name: 'Items from Store', isVisible: true),
              primaryYAxis: NumericAxis(
                majorTickLines:
                    const MajorTickLines(size: 6, width: 2, color: Colors.red),
                minorTickLines: MinorTickLines(
                    size: 4, width: 2, color: _palette.primaryBlue),
                minorTicksPerInterval: 2,
              ),
              enableAxisAnimation: true,
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                ColumnSeries<TopMoversChartData, dynamic>(
                  dataSource: topMoversChartData,
                  xValueMapper: (TopMoversChartData data, _) => data.itemName,
                  yValueMapper: (TopMoversChartData data, _) => data.qtySold,
                  name: 'Top Movers',
                  color: const Color.fromARGB(255, 249, 145, 149),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ],
            ),
          ),

          // top movers total sales chart
          // the main container to show the payment mode chart
          SizedBox(
            height: height * 0.24,
            child: SfCartesianChart(
              title: ChartTitle(
                text: 'Total Sales Value per Item',
                textStyle: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              enableMultiSelection: true,
              primaryXAxis:
                  CategoryAxis(name: 'Items from Store', isVisible: true),
              primaryYAxis: NumericAxis(
                majorTickLines:
                    const MajorTickLines(size: 6, width: 2, color: Colors.red),
                minorTickLines: MinorTickLines(
                    size: 4, width: 2, color: _palette.primaryBlue),
                minorTicksPerInterval: 2,
              ),
              enableAxisAnimation: true,
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                ColumnSeries<TopMoversChartData, dynamic>(
                  dataSource: topMoversChartData,
                  xValueMapper: (TopMoversChartData data, _) => data.itemName,
                  yValueMapper: (TopMoversChartData data, _) =>
                      data.totalSalesValue,
                  name: 'Top Movers (sales val)',
                  color: _palette.purpleLight,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ],
            ),
          ),

          // the main text that says
          const Text(
            'Payment Mode Usage',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const Text(
            'the most used payment methods',
            style: TextStyle(color: Colors.grey),
          ),

          SizedBox(
            height: height * 0.02,
          ),

          // the main container to show the payment mode chart
          SizedBox(
            height: height * 0.26,
            child: SfCartesianChart(
              enableMultiSelection: true,
              primaryXAxis: CategoryAxis(labelRotation: 30),
              primaryYAxis: NumericAxis(),
              enableAxisAnimation: true,
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                ColumnSeries<PaymentChartData, dynamic>(
                  dataSource: paymentChartData,
                  xValueMapper: (PaymentChartData data, _) =>
                      data.paymentMethod,
                  yValueMapper: (PaymentChartData data, _) =>
                      data.paymentMethodCount,
                  name: 'Times used',
                  color: const Color.fromARGB(255, 50, 141, 214),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: height * 0.01,
          ),
        ],
      ),
    );
  }

// set payment mode count
  paymentModeCountSetter() {
    setState(
      () {
        paymentModeCount =
            storeStatsService.paymentMethodsStats(widget.checkouts);

        // mapping the payment mode count to the category
        for (int i = 0; i < 7; i++) {
          paymentChartData.add(
            PaymentChartData(
              paymentOptions[i],
              paymentModeCount[i],
            ),
          );
        }
      },
    );
  }

// set top movers
  topMoversSetter() {
    setState(
      () {
        topMovers = storeStatsService.topMoversFromStore(widget.checkouts);

        // mapping the top movers and setting them to category
        for (int i = 0; i < topMovers.length; i++) {
          topMoversChartData.add(
            TopMoversChartData(
              topMovers[i]['name'],
              topMovers[i]['qtySold'],
              topMovers[i]['totalSalesValue'],
            ),
          );
        }
      },
    );
  }
}

// the class for payment mode count
class PaymentChartData {
  PaymentChartData(this.paymentMethod, this.paymentMethodCount);
  final String paymentMethod;
  final int paymentMethodCount;
}

// class for the best sellers and most interacted
class TopMoversChartData {
  TopMoversChartData(this.itemName, this.qtySold, this.totalSalesValue);
  final String itemName;
  final double qtySold;
  final double totalSalesValue;
}
