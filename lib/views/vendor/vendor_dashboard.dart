// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ofg_web/services/checkout_service.dart';
import 'package:ofg_web/services/store_services.dart';
import 'package:ofg_web/services/store_stats_service.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';
import 'package:ofg_web/views/vendor/stats_page.dart';

class VendorDashboard extends StatefulWidget {
  VendorDashboard({super.key, this.checkoutsList, this.storeListings});

  List? checkoutsList;
  List? storeListings;

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final CustomWidgets cWidgetsInstance = CustomWidgets();
  final ColorPalette _palette = ColorPalette();
  final Tools _tools = Tools();
  final StatsService _statsService = StatsService();

  bool isAdLoaded = false;
  bool isLoading = false;

  int orderLifeCycleIndex = 0;

  List checkoutList = [];
  List storeListings = [];

  @override
  void initState() {
    setState(() {
      checkoutList = widget.checkoutsList ?? [];
      storeListings = widget.storeListings ?? [];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldStateKey,

      // drawer
      drawer: cWidgetsInstance.navDrawer(
          context,
          'Dashboard',
          Icon(
            Icons.dashboard_outlined,
            color: ColorPalette().secondaryTextColor,
          )),

      // Appbar
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        // The nav bar icon
        leading: Platform.isAndroid
            ? IconButton(
                onPressed: () {
                  // open nav drawer
                  _scaffoldStateKey.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: ColorPalette().inactiveIconGrey,
                ))
            : null,
        title: Text('Dashboard',
            style: GoogleFonts.montserrat(
                color: ColorPalette().primaryBlue,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),

      // body
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade900,
              ),
            )
          : RefreshIndicator(
              onRefresh: () => refreshCheckoutView(),
              child: ListView(
                children: [
                  // the main list view
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: SizedBox(
                      height: height * 0.8,
                      child: checkoutList.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // the key stats text
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Key Stats',
                                      style: GoogleFonts.heebo(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          color: _palette.secondaryTextColor),
                                    ),

                                    // the see more button for checkouts
                                    TextButton(
                                        onPressed: () {
                                          // move to the all checkouts page
                                          cWidgetsInstance.moveToPage(
                                              page: StoreMetricsPage(
                                                  checkouts: checkoutList,
                                                  storeListings: storeListings,
                                                  landingIndex: 0),
                                              context: context,
                                              replacement: false);
                                        },
                                        child: Text(
                                          'View Stats >',
                                          selectionColor: _palette.linkBlue,
                                        ))
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // the container the holds the keu stats
                                Container(
                                  height: height * 0.2,
                                  decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/illustrations/card-bg.jpg',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      color: _palette.accentBlue,
                                      borderRadius:
                                          BorderRadius.circular(height * 0.02)),
                                  child: // the main content row
                                      Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // the distinct users count
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${_statsService.totalUniqueUsers(checkoutList).length}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                          const Text(
                                            'Unique Users',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),

                                      // the total lifetime sales
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            _tools.kmbGenerator(
                                                _statsService
                                                    .totalLifetimeSales(
                                                        checkoutList),
                                                _statsService
                                                            .totalLifetimeSales(
                                                                checkoutList) >
                                                        10000
                                                    ? true
                                                    : false),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24),
                                          ),
                                          const Text(
                                            'Lifetime Sales',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 26),

                                // the recent checkouts part main title row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Recent Checkouts',
                                      style: GoogleFonts.heebo(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                          color: _palette.secondaryTextColor),
                                    ),

                                    // the see more button for checkouts
                                    TextButton(
                                      onPressed: () {
                                        // move to the all checkouts page
                                        cWidgetsInstance.moveToPage(
                                            page: StoreMetricsPage(
                                                checkouts: checkoutList,
                                                storeListings: storeListings,
                                                landingIndex: 1),
                                            context: context,
                                            replacement: false);
                                      },
                                      child: Text(
                                        'View all >',
                                        selectionColor: _palette.linkBlue,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                // The check for five recents and if not the others
                                // the main list view inside the conainter
                                SizedBox(
                                  height: height * 0.42,
                                  child: ListView.builder(
                                    itemCount: checkoutList.length < 6
                                        ? checkoutList.length
                                        : 6,
                                    itemBuilder: (context, index) {
                                      var item = checkoutList[index];
                                      bool isIndexItemInvoice =
                                          item['isInvoice'];

                                      // the grand total bill/invoice value
                                      double grandTotal = item['extraCharges']
                                              [1] +
                                          item['extraCharges'][0] +
                                          item['storeBillTotal'] +
                                          item['quickAddsTotal'];

                                      return ListTile(
                                        leading: CircleAvatar(
                                          radius: height * 0.035,
                                          backgroundColor: isIndexItemInvoice
                                              ? _palette.accentBlue
                                              : Colors.green.shade100,
                                          child: Icon(
                                            isIndexItemInvoice
                                                ? CupertinoIcons.doc
                                                : Icons
                                                    .check_circle_outline_rounded,
                                            size: 26,
                                            color: Colors.white,
                                            weight: 2.0,
                                          ),
                                        ),

                                        // title
                                        title: Text(
                                          item['payee']['name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.heebo(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),

                                        // sub
                                        subtitle: Text(
                                          isIndexItemInvoice
                                              ? 'Invoiced on: ${_tools.getBilledDate(item['checkoutNo'])}'
                                              : 'Billed on : ${_tools.getBilledDate(item['checkoutNo'])}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey.shade600),
                                        ),

                                        trailing: Text(
                                          isIndexItemInvoice
                                              ? _tools.kmbGenerator(
                                                  grandTotal,
                                                  grandTotal > 10000
                                                      ? true
                                                      : false)
                                              : '+${_tools.kmbGenerator(grandTotal, grandTotal > 10000 ? true : false)}',
                                          style: TextStyle(
                                              color: isIndexItemInvoice
                                                  ? Colors.blueAccent
                                                  : Colors.green,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          :

                          // the display when there is no checkout
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height * 0.3,
                                  child: Image.asset(
                                      'assets/illustrations/emtylist.png'),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Text(
                                  'Create a new checkout and refresh the page to view it here.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.heebo(
                                      color: Colors.grey.shade800,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: height * 0.1,
                                )
                              ],
                            ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  // refresh the sstore listings
  refreshStoreListings() async {
    setState(() {
      isLoading = true;
    });
    var list = await StoreServices().getStoreListings(context: context);
    setState(() {
      storeListings = list;
      isLoading = false;
    });
  }

// get the bills of the store
  refreshCheckoutView() async {
    setState(() {
      isLoading = true;
    });
    var list = await CheckoutService().getAllCheckouts(context: context);
    setState(() {
      checkoutList = list;
      isLoading = false;
    });
  }
}
