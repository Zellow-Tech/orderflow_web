// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/views/vendor/stats_pages/checkout_stats_page.dart';
import 'package:ofg_web/views/vendor/stats_pages/sales_stats_page.dart';
import 'package:ofg_web/views/vendor/stats_pages/store_stats_page.dart';

class StoreMetricsPage extends StatefulWidget {
  StoreMetricsPage(
      {super.key,
      required this.checkouts,
      required this.storeListings,
      required this.landingIndex});
  List checkouts;
  List storeListings;
  int landingIndex;

  @override
  State<StoreMetricsPage> createState() => _StoreMetricsPageState();
}

class _StoreMetricsPageState extends State<StoreMetricsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          // The nav bar icon
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
              color: ColorPalette().inactiveIconGrey,
            ),
          ),

          title: Text('Store Metrics',
              style: GoogleFonts.montserrat(
                  color: ColorPalette().primaryBlue,
                  fontWeight: FontWeight.w600)),
          centerTitle: true,

          // the tab bar view
          bottom: const TabBar(
            physics: BouncingScrollPhysics(),
            tabs: [
              Tab(
                text: 'Sales Stats',
              ),
              Tab(
                text: 'Store Stats',
              ),
              Tab(
                text: 'Checkouts',
              ),
            ],
          ),
        ),
        // the tab bar view
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: TabBarView(
            children: [
              // the sales stats page
              SalesStatsPage(
                storeListings: widget.storeListings,
                checkouts: widget.checkouts,
              ),

              // the store stats page
              StoreStatsPage(
                storeListings: widget.storeListings,
                checkouts: widget.checkouts,
              ),

              // the checkouts stats page
              CheckoutStatsPage(
                checkouts: widget.checkouts,
              )
            ],
          ),
        ),
      ),
    );
  }
}
