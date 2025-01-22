import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofg_web/services/store_stats_service.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/tools.dart';

// ignore: must_be_immutable
class SalesStatsPage extends StatefulWidget {
  SalesStatsPage(
      {super.key, required this.checkouts, required this.storeListings});
  List checkouts;
  List storeListings;

  @override
  State<SalesStatsPage> createState() => _SalesStatsPageState();
}

class _SalesStatsPageState extends State<SalesStatsPage> {
  // the finals
  final ColorPalette _palette = ColorPalette();
  final Tools _tools = Tools();

  // stat doubles
  double billVal = 0.0;
  double invVal = 0.0;
  double lifetimeStockVal = 0.0;
  double stockValueAtm = 0.0;

  @override
  Widget build(BuildContext context) {
    // dimension finals
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width - 30;

    //  stats rendered
    final StatsService storeStatsServices = StatsService(
        storeListings: widget.storeListings, checkouts: widget.checkouts);

    // get the percentages for the chart
    calcSalesPercentage(storeStatsServices, widget.checkouts);

    // set the stock values
    calcStockValues(storeStatsServices, widget.checkouts, widget.storeListings);

    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          // the main text that says
          const Text(
            'Genreal Overview',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const Text(
            'Total Bills & Invoices',
            style: TextStyle(color: Colors.grey),
          ),

          SizedBox(
            height: height * 0.02,
          ),

          // the sized box holding the visualization of the
          Row(
            children: [
              Container(
                height: height * 0.06,
                width: width * billVal / 100,
                decoration: BoxDecoration(
                    color: _palette.purpleLight,
                    borderRadius: BorderRadius.circular(height * 0.04)),
                child: Center(
                  child: Text(
                    '$billVal %',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: height * 0.06,
                width: width * invVal / 100,
                decoration: BoxDecoration(
                    color: _palette.primaryBlue,
                    borderRadius: BorderRadius.circular(height * 0.04)),
                child: Center(
                  child: Text(
                    '$invVal %',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: height * 0.02,
          ),

          // the legend section for bill and invoice value
          Row(
            children: [
              Container(
                height: height * 0.04,
                width: 20,
                decoration: BoxDecoration(
                    color: _palette.purpleLight,
                    borderRadius: BorderRadius.circular(height * 0.04)),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('Bill Value'),
              SizedBox(
                width: width * 0.1,
              ),
              Container(
                height: height * 0.04,
                width: 20,
                decoration: BoxDecoration(
                    color: _palette.primaryBlue,
                    borderRadius: BorderRadius.circular(height * 0.04)),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('Invoice Value'),
            ],
          ),

          SizedBox(
            height: height * 0.02,
          ),

          // the texts saying operating account details
          const Text(
            'Operating Account',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          const Text(
            'Details',
            style: TextStyle(color: Colors.grey),
          ),

          SizedBox(
            height: height * 0.02,
          ),

          // the total store before and after sales
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // stock value atm
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                height: height * 0.12,
                width: width * 0.48,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(height * 0.02)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // the text
                    const Text(
                      'Stock Value (Lifetime)',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      _tools.kmbGenerator(lifetimeStockVal,
                          lifetimeStockVal > 10000 ? true : false),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.heebo(
                          color: const Color(0xff25DA6A),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),

              // stock value lifetime
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                height: height * 0.12,
                width: width * 0.48,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(height * 0.02)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // the text
                    const Text(
                      'Stock Value (ATM)',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      _tools.kmbGenerator(
                          stockValueAtm, stockValueAtm > 10000 ? true : false),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.heebo(
                          color: const Color(0xff4355F6),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              )
            ],
          ),

          SizedBox(
            height: height * 0.02,
          ),

          // the total unique users expansion
          ListTile(
            onTap: () {
              // show the list of users in a bottom sheet
              customerListBottomSheetMenu(height,
                  storeStatsServices.totalUniqueUsers(widget.checkouts));
            },
            leading: const Icon(CupertinoIcons.person_2_fill,
                color: Colors.amber, size: 28),
            trailing: const Icon(Icons.arrow_right_rounded),
            title: Text(
              '  ${storeStatsServices.totalUniqueUsers(widget.checkouts).length} Customers',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            subtitle: const Text(
              '  Total Unique Customers',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ),

          // the total sales val
          ListTile(
            onTap: () => Tooltip(
              message:
                  '${storeStatsServices.totalLifetimeSales(widget.checkouts)}',
              child: Text(
                  '${storeStatsServices.totalLifetimeSales(widget.checkouts)} in sales'),
            ),
            leading: const Icon(CupertinoIcons.chart_bar_circle_fill,
                color: Colors.green, size: 32),
            title: Text(
              ' ${_tools.kmbGenerator(
                storeStatsServices.totalLifetimeSales(widget.checkouts),
                storeStatsServices.totalLifetimeSales(widget.checkouts) > 10000
                    ? true
                    : false,
              )}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            subtitle: const Text(
              '  Net Sales Value',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ),

          // The values of bill
          ListTile(
            onTap: () {
              // show the list of users in a bottom sheet
              // customerListBottomSheetMenu(height,
              //     storeStatsServices.totalUniqueUsers(widget.checkouts));
            },
            leading: Icon(CupertinoIcons.money_dollar_circle_fill,
                color: Colors.purple.shade200, size: 32),
            title: Text(
              '  ${_tools.kmbGenerator(
                storeStatsServices.totalBillInvValues(widget.checkouts)[0],
                storeStatsServices.totalBillInvValues(widget.checkouts)[0] >
                        10000
                    ? true
                    : false,
              )}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            subtitle: const Text(
              '  Total Bill Value',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ),

          // the invoice value total
          ListTile(
            onTap: () {
              // show the list of users in a bottom sheet
              // customerListBottomSheetMenu(height,
              //     storeStatsServices.totalUniqueUsers(widget.checkouts));
            },
            leading: const Icon(CupertinoIcons.doc_chart_fill,
                color: Color(0xff4355F6), size: 32),
            title: Text(
              '  ${_tools.kmbGenerator(
                storeStatsServices.totalBillInvValues(widget.checkouts)[1],
                storeStatsServices.totalBillInvValues(widget.checkouts)[1] >
                        10000
                    ? true
                    : false,
              )}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            subtitle: const Text(
              '  Total Invoice Value',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

// users bottom sheet
  customerListBottomSheetMenu(double height, List customers) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(height * 0.04),
            topRight: Radius.circular(height * 0.04)),
      ),
      context: context,
      builder: (context) {
        return SizedBox(
          height: height * 0.6,
          child: ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  Icons.person_2_rounded,
                  color: _palette.primaryBlue,
                ),
                title: Text(customers[index]),
              );
            },
          ),
        );
      },
    );
  }

// get the current and lifetime stock value
  calcStockValues(
      StatsService statsService, List checkouts, List storeListings) {
    var val = statsService.totalStockValueBASales(checkouts, storeListings);

    // sets the value percentages in list format <lifetime stock value., istock value atm.>
    setState(() {
      stockValueAtm = val[1];
      lifetimeStockVal = val[0];
    });
  }

// calculate total percentage for bars
  calcSalesPercentage(StatsService statsService, List checkouts) {
    var val = statsService.totalBillInvValues(checkouts);
    double hundredPercent = val[0] + val[1];
    // sets the value percentages in list format <bill val perc., inv val perc.>
    setState(() {
      billVal = _tools.roundDouble(val[0] * 100 / hundredPercent, 2);
      invVal = _tools.roundDouble(val[1] * 100 / hundredPercent, 2);
    });
  }
}
