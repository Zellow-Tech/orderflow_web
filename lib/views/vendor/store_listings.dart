import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofg_web/services/media_services.dart';
import 'package:ofg_web/services/store_services.dart';
import 'package:ofg_web/constants/urls/firebase_endpoints.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';
import 'package:ofg_web/views/vendor/add_items.dart';
import 'package:ofg_web/views/vendor/search_items.dart';

class StoreListing extends StatefulWidget {
  final List? storeItemsList;
  const StoreListing({Key? key, this.storeItemsList}) : super(key: key);

  @override
  State<StoreListing> createState() => _StoreListingState();
}

class _StoreListingState extends State<StoreListing> {
  final GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey<ScaffoldState>();
  final CustomWidgets cWidgetsInstance = CustomWidgets();
  List parsedList = [];
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      parsedList = widget.storeItemsList ?? parsedList;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        key: _scaffoldStateKey,

        // fab
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: ColorPalette().primaryBlue,
          onPressed: () async {
            // move to add ing page
            bool? refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) {
                  return ItemAddition(
                    name: '',
                    urls: const [],
                    unit: 'Kg',
                    edit: false,
                  );
                }),
              ),
            );

            // the result when an item is added
            if (refresh != null && refresh) {
              refreshListView(itemRemovalIndex: null);
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),

        // drawer
        drawer: cWidgetsInstance.navDrawer(
            context,
            'Store Listing',
            Icon(
              Icons.list_alt_outlined,
              color: ColorPalette().secondaryTextColor,
            )),
        // Appbar
        appBar: AppBar(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
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
          title: Text('Store Listings',
              style: GoogleFonts.montserrat(
                  color: ColorPalette().primaryBlue,
                  fontWeight: FontWeight.w600)),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  // go to search delegate
                  var resultFromSearch = await showSearch(
                      context: context,
                      delegate: ItemSearch(itemsList: parsedList));
                  if (resultFromSearch != null) {
                    refreshListView(itemNameFromSearch: resultFromSearch);
                  }
                },
                icon: Icon(
                  Icons.search,
                  color: ColorPalette().inactiveIconGrey,
                ))
          ],
        ),

        //  body
        body: RefreshIndicator(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: ColorPalette().primaryBlue,
                  ),
                )
              : _makeListView(parsedList, height),
          onRefresh: () async {
            refreshListView();
          },
          color: ColorPalette().primaryBlue,
          backgroundColor: Colors.white,
        ));
  }

  refreshListView({int? itemRemovalIndex, dynamic itemNameFromSearch}) async {
    // itemRemovalIndex is passed in case of deletion of an item.
    // This enables the list to reflect changes locally.
    if (itemRemovalIndex == null && itemNameFromSearch == null) {
      setState(() {
        _isLoading = true;
      });

      var list = await StoreServices().getStoreListings(context: context);

      setState(() {
        parsedList = list;
        _isLoading = false;
      });
    }
    // see if the reload is from search delegate or index and then reload on that
    else {
      if (itemNameFromSearch != null && itemRemovalIndex == null) {
        try {
          setState(() {
            parsedList.removeWhere(
                (element) => element['name'] == itemNameFromSearch);
          });
        } catch (e) {
          cWidgetsInstance.snackBarWidget(
              content: Tools().errorTextHandling(e.toString()),
              context: context);
        }
      } else {
        setState(() {
          parsedList.removeAt(itemRemovalIndex!);
        });
      }
    }
  }

  // list view renderer
  _makeListView(List parsedList, double height) {
    if (parsedList.isNotEmpty) {
      return ListView.builder(
        itemCount: parsedList.length,
        itemBuilder: (context, index) {
          // expansion tile that holds the details
          return ExpansionTile(
            // The image that represents the product
            leading: Container(
              width: height * 0.06,
              height: height * 0.06,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorPalette().containerGrey),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: parsedList[index]['urls'].length == 0
                    ? const Icon(CupertinoIcons.photo_fill)
                    : Image.network(
                        parsedList[index]['urls'][0].toString(),
                        height: height * 0.06,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.error_outline_rounded,
                            color: Colors.red[600],
                          );
                        },
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // name of the product as a title
            title: Text(
              parsedList[index]['name'],
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette().primaryBlue),
              overflow: TextOverflow.ellipsis,
            ),

            // the text saying if the product is out of stock or not
            subtitle: Text(
              parsedList[index]['qty'] == 0.0 || parsedList[index]['qty'] == 0
                  ? 'Out of stock'
                  : 'In stock',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: parsedList[index]['qty'] == 0.0 ||
                          parsedList[index]['qty'] == 0
                      ? ColorPalette().deletionRed
                      : ColorPalette().mainGreen),
            ),

            // change the status of the product here
            trailing: CupertinoSwitch(
              value: parsedList[index]['live'],
              onChanged: ((value) {
                // updating the live status of the product here
                StoreServices().updateLiveStatus(
                    context: context,
                    productName: parsedList[index]['name'],
                    status: value);
                refreshListView();
              }),
            ),

            // expanded area
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: height * 0.02, vertical: 5),
                padding: EdgeInsets.symmetric(
                    horizontal: height * 0.02, vertical: 10),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // The row that contains the description and qty details

                    // The text saying desc
                    Text(
                      'Description',
                      style: TextStyle(
                          color: ColorPalette().secondaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),

                    // The description
                    Text(parsedList[index]['desc']),

                    SizedBox(
                      height: height * 0.04,
                    ),

                    // The row that contains price and discount details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // The price text
                            Text(
                              'Price',
                              style: TextStyle(
                                  color: ColorPalette().secondaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(Tools().kmbGenerator(
                                parsedList[index]['price'], true)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // The discount text
                            Text(
                              'Discount',
                              style: TextStyle(
                                  color: ColorPalette().secondaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(parsedList[index]['discount'].toString()),
                          ],
                        )
                      ],
                    ),

                    SizedBox(
                      height: height * 0.04,
                    ),

                    // the row for qty and unit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // says qty and its thing
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // The qty text
                            Text(
                              'Quantity',
                              style: TextStyle(
                                  color: ColorPalette().secondaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),

                            // LitTile that hold the live button
                            Text(Tools()
                                .kmbGenerator(parsedList[index]['qty'], false)),
                          ],
                        ),

                        // says unit and its thing
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // The qty text
                            Text(
                              'Unit',
                              style: TextStyle(
                                  color: ColorPalette().secondaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),

                            // LitTile that hold the live button
                            Text(parsedList[index]['unit']),
                          ],
                        ),

                        // THE allow cusotm orders
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // The qty text
                            Text(
                              'Custom Orders',
                              style: TextStyle(
                                  color: ColorPalette().secondaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),

                            // LitTile that hold the live button
                            Text(
                              parsedList[index]['customOrders']
                                  ? 'Allowed'
                                  : 'Not allowed',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),

                    SizedBox(
                      height: height * 0.04,
                    ),

                    // the Column that contains the returnable status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // The discount text
                        Text(
                          'Product returnable',
                          style: TextStyle(
                              color: ColorPalette().secondaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          parsedList[index]['returnable']
                              ? 'Returnable in seven days'
                              : 'Not returnable',
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),

                    SizedBox(
                      height: height * 0.04,
                    ),

                    // Button Bar that holds delete and edit buttons
                    Row(
                      children: [
                        // delete option
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette().deletionRed),
                          onPressed: () {
                            // alert the user about potential deletion
                            deleteUserAfterAlert(index);
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Delete',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),

                        SizedBox(width: height * 0.04),

                        // the edit item button
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 1.0,
                                color: ColorPalette().secondaryTextColor,
                              ),
                            ),
                            onPressed: () async {
                              // move to the edit product page
                              bool? refresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) {
                                    return ItemAddition(
                                      urls: parsedList[index]['urls'],
                                      unit: parsedList[index]['unit'],
                                      edit: true,
                                      descritption: parsedList[index]['desc'],
                                      discount: parsedList[index]['discount'],
                                      tax: parsedList[index]['tax'],
                                      liveStatus: parsedList[index]['live'],
                                      name: parsedList[index]['name'],
                                      price: parsedList[index]['price'],
                                      qty: parsedList[index]['qty'],
                                      returnable: parsedList[index]
                                          ['returnable'],
                                      allowCustomOrders: parsedList[index]
                                          ['customOrders'],
                                      tags: parsedList[index]['tags'],
                                    );
                                  }),
                                ),
                              );

                              if (refresh != null && refresh == true) {
                                refreshListView(itemRemovalIndex: null);
                              }
                            },
                            icon: Icon(
                              Icons.edit,
                              color: ColorPalette().inactiveIconGrey,
                            ),
                            label: Text(
                              'Edit Product ',
                              style: TextStyle(
                                  color: ColorPalette().secondaryTextColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );

      // the render when parse list (AKA items list) is empty.
    } else {
      return const Center(
        child: Text('No Items added to store yet'),
      );
    }
  }

  // item deletion function
  deleteUserAfterAlert(int index) {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text(
              'Are you sure you want to delete this product from the store items list?'),
          actions: [
            // the cancel button
            OutlinedButton(
              child: Text(
                'cancel',
                style: TextStyle(color: ColorPalette().primaryBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            // the delete item button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette().deletionRed,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                shadowColor: Colors.transparent,
              ),
              onPressed: () {
                String name1 = parsedList[index]['name'];

                // delete the storage media
                if (parsedList[index]['urls'].isNotEmpty) {
                  MediaServices(type: 'Vendor', uid: FirebaseRoutes().fUid)
                      .mediaDeletionFromStorage(
                    context: context,
                    route: FirebaseRoutes().vendorItemStorageRoute + name1,
                  );
                }

                // delete the storage info
                StoreServices()
                    .deleteItemFromStore(context: context, productName: name1);
                Navigator.pop(context);
                cWidgetsInstance.snackBarWidget(
                    content: 'Item deleted successfully', context: context);
                refreshListView(itemRemovalIndex: index);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      }),
    );
  }
}
