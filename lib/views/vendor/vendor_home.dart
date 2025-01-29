import 'package:flutter/material.dart';
import 'package:ofg_web/services/checkout_service.dart';
import 'package:ofg_web/services/store_services.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';
import 'package:ofg_web/views/vendor/store_listings.dart';
import 'package:ofg_web/views/vendor/store_profile.dart';
import 'package:ofg_web/views/vendor/vendor_dashboard.dart';
import '../../services/profile_services.dart';
// import '../../services/version_services.dart';
import 'billing_pages/new_bill_page.dart';

class VendorHome extends StatefulWidget {
  final Map<String, dynamic>? vendor;
  const VendorHome({Key? key, this.vendor}) : super(key: key);

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  // current page index, default to dashboard.
  int index = 0;

  // pages list for the nav panel to parent
  List pages = [VendorDashboard(), const StoreListing(), const StoreProfile()];

  // items in store call
  List storeListings = [];

  // the last 100 checkouts
  List checkoutsList = [];

  // the map for stoe profile
  Map storeProfileDataMap = {};

  bool isLoading = false;

  // finals instances
  final CustomWidgets cWidgetsInstance = CustomWidgets();
  final Tools _tools = Tools();
  final StoreServices _storeServices = StoreServices();
  final ProfileServices _profileServices = ProfileServices();
  final CheckoutService _checkoutService = CheckoutService();

  @override
  void initState() {
    // inital data setup
    initDataSetUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // floating action button for the new invoice maker
      floatingActionButton: isLoading
          ? null
          : index == 0
              ? FloatingActionButton.extended(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(height * 0.04)),
                  backgroundColor: ColorPalette().primaryBlue,
                  onPressed: () async {
                    // move to the new bill page
                    // var res = await
                    cWidgetsInstance.moveToPage(
                        page: BillingPage(
                          invoiceNumber: _tools.generateInvoiceNumber(),
                          storeListings: storeListings,
                          storeProfileDataMap: storeProfileDataMap,
                        ),
                        context: context,
                        replacement: false);
                  },
                  label: const Text(
                    "New checkout",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.add_box,
                    color: Colors.white,
                  ),
                )
              : null,

      // Bottom nav bar
      bottomNavigationBar: isLoading
          ? null
          : NavigationBarTheme(
              data: NavigationBarThemeData(
                indicatorColor: Colors.white,
                backgroundColor: Colors.white,
                labelTextStyle: MaterialStateProperty.all(
                    TextStyle(fontSize: 12, color: ColorPalette().primaryBlue)),
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
              ),
              child: NavigationBar(
                height: height * 0.08,
                animationDuration: const Duration(seconds: 1),
                selectedIndex: index,
                onDestinationSelected: (value) {
                  // temporary refresh for store listings list so as to change state in new state
                  if (index == 1 && value == 0) {
                    refreshStoreListingsView();
                  }
                  setState(() {
                    index = value;
                  });
                },

                // destinations in nav bar
                destinations: [
                  NavigationDestination(
                      selectedIcon: Icon(
                        Icons.dashboard,
                        color: ColorPalette().primaryBlue,
                      ),
                      icon: Icon(
                        Icons.dashboard_outlined,
                        color: ColorPalette().inactiveIconGrey,
                      ),
                      label: 'Dashboard'),

                  //
                  NavigationDestination(
                      selectedIcon: Icon(Icons.list_alt,
                          color: ColorPalette().primaryBlue),
                      icon: Icon(Icons.list_alt_rounded,
                          color: ColorPalette().inactiveIconGrey),
                      label: 'Listings'),

                  //
                  NavigationDestination(
                      selectedIcon: Icon(
                        Icons.store_mall_directory,
                        color: ColorPalette().primaryBlue,
                      ),
                      icon: Icon(Icons.store_mall_directory_outlined,
                          color: ColorPalette().inactiveIconGrey),
                      label: 'Store'),
                ],
              ),
            ),

      // body that host pages
      body: isLoading
          ? CustomLoaders().dataLoaderAnimation(context)
          : pages[index],
    );
  }

  // Calling for all the data so as to reduce calls to firebase.
  initDataSetUp() async {
    // app update check
    // AppVersionService().appUpdateCheck(context: context);

    setState(() {
      isLoading = true;
    });

    // check if the vendor from widget exists. i.e, the user is new and just came after registration
    // store profile call reduction if data already exists
    if (widget.vendor != null) {
      setState(
        () {
          storeListings = [];
          checkoutsList = [];
          storeProfileDataMap = widget.vendor!;

          // assign the pages with respective data loaded
          pages = [
            VendorDashboard(),
            const StoreListing(),
            StoreProfile(vendorData: widget.vendor!)
          ];

          // stop the load
          isLoading = false;
        },
      );
    }
    // in a case where the user is reopening the app or have already signed/registered into the app
    else {
      // call the store listings
      List? storeItemsList =
          await _storeServices.getStoreListings(context: context);

      // get the store checkouts with a limit
      var checkouts = await _checkoutService.getAllCheckouts(context: context);

      // get the store data using firebase store services
      var vendorProfileMap =
          await _profileServices.getProfileData(context: context);

      // print('\n\n########### sprofile $vendorProfileMap');

      setState(
        () {
          storeListings = storeItemsList ?? [];
          checkoutsList = checkouts ?? [];
          storeProfileDataMap = vendorProfileMap ?? {};

          // assign the pages with data loaded
          pages = [
            VendorDashboard(
                checkoutsList: checkouts ?? [],
                storeListings: storeItemsList ?? []),
            StoreListing(storeItemsList: storeItemsList ?? []),
            StoreProfile(vendorData: vendorProfileMap)
          ];
          // stop the load
          isLoading = false;
        },
      );
    }
  }

  // store items refreshing
  refreshStoreListingsView() async {
    var list = await StoreServices().getStoreListings(context: context);

    setState(() {
      storeListings = list;
      pages[1] = StoreListing(storeItemsList: list);
      pages[0] =
          VendorDashboard(checkoutsList: checkoutsList, storeListings: list);
    });
  }

  // get the bills of the store
  refreshCheckoutView() async {
    var list = await CheckoutService().getAllCheckouts(context: context);

    setState(() {
      checkoutsList = list;
      pages[0] =
          VendorDashboard(checkoutsList: list, storeListings: storeListings);
    });
  }
}
