import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/constants/urls/firebase_endpoints.dart';
import 'package:ofg_web/services/media_services.dart';
import 'package:ofg_web/services/store_services.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/views/vendor/add_items.dart';

import '../../utils/tools.dart';

class ItemSearch extends SearchDelegate {
  List itemsList;
  final FirebaseRoutes _routes = FirebaseRoutes();
  Map<String, dynamic> indexedItem = {};

  ItemSearch({required this.itemsList});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: Icon(
            Icons.clear,
            color: ColorPalette().inactiveIconGrey,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, 'back'),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: ColorPalette().inactiveIconGrey,
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? itemsList
        : itemsList.where(
            (element) {
              return element['name']
                  .toLowerCase()
                  .contains(query.toLowerCase());
            },
          ).toList();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // navigator closes and the index is returned
              query = suggestionList[index]['name'];
              indexedItem = suggestionList[index];
              showResults(context);
            },
            leading: suggestionList[index]['urls'].isEmpty
                ? const Icon(CupertinoIcons.photo_fill)
                : ClipOval(
                    child: Image.network(
                      suggestionList[index]['urls'][0],
                      height: MediaQuery.of(context).size.height * 0.06,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red[600],
                        );
                      },
                      width: MediaQuery.of(context).size.height * 0.06,
                      fit: BoxFit.cover,
                    ),
                  ),
            title: Text(suggestionList[index]['name']),
          );
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    return ExpansionTile(
      leading: indexedItem['urls'].isEmpty
          ? const Icon(CupertinoIcons.photo_fill)
          : ClipOval(
              child: Image.network(
                indexedItem['urls'][0],
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.height * 0.06,
                fit: BoxFit.cover,
              ),
            ),

      // Title of the image
      title: Text(
        indexedItem['name'],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // details
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
              Text(indexedItem['desc']),

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
                      Text(Tools().kmbGenerator(indexedItem['price'], true)),
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
                      Text(indexedItem['discount'].toString()),
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
                      Text(Tools().kmbGenerator(indexedItem['qty'], false)),
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
                      Text(indexedItem['unit']),
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
                        indexedItem['customOrders'] ? 'Allowed' : 'Not allowed',
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
                    indexedItem['returnable']
                        ? 'Returnable in seven days'
                        : 'Not returnable',
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),

              SizedBox(
                height: height * 0.04,
              ),

              // the button row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // delete option
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette().deletionRed),
                    onPressed: () {
                      // alert the user about potential deletion
                      deleteItemFromStore(context);
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Delete',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),

                  // the edit item button
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 1.0,
                        color: ColorPalette().secondaryTextColor,
                      ),
                    ),
                    onPressed: () {
                      // move to the edit product page
                      close(context, 'edit');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return ItemAddition(
                              urls: indexedItem['urls'],
                              edit: true,
                              unit: indexedItem['unit'],
                              descritption: indexedItem['desc'],
                              discount: indexedItem['discount'],
                              liveStatus: indexedItem['live'],
                              name: indexedItem['name'],
                              price: indexedItem['price'],
                              qty: indexedItem['qty'],
                              returnable: indexedItem['returnable'],
                              allowCustomOrders: indexedItem['customOrders'],
                              tags: indexedItem['tags'],
                            );
                          }),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: ColorPalette().inactiveIconGrey,
                    ),
                    label: Text(
                      'Edit Product',
                      style: TextStyle(
                          color: ColorPalette().secondaryTextColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  deleteItemFromStore(BuildContext context) async {
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
                String name1 = indexedItem['name'];

                // delete the storage media
                if (indexedItem['urls'].isNotEmpty) {
                  MediaServices(type: 'Vendor', uid: _routes.fUid)
                      .mediaDeletionFromStorage(
                    context: context,
                    route: '${_routes.vendorItemStorageRoute}$name1/',
                  );
                }
                // delete the storage info
                StoreServices()
                    .deleteItemFromStore(context: context, productName: name1);

                // return the name so as to remove the item and then refresh the store list.
                close(context, name1);
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
