import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ofg_web/models/item_model.dart';
import 'package:ofg_web/services/media_services.dart';
import 'package:ofg_web/services/store_services.dart';
import 'package:ofg_web/constants/urls/firebase_endpoints.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';

import '../../utils/tools.dart';

// ignore: must_be_immutable
class ItemAddition extends StatefulWidget {
  String name;
  String unit;
  bool edit;
  List urls;

  String? descritption;
  double? price;
  double? qty;
  double? discount;
  double? tax;
  List? tags;
  bool? allowCustomOrders;
  bool? liveStatus;
  bool? returnable;

  ItemAddition(
      {Key? key,
      required this.edit,
      required this.name,
      required this.urls,
      required this.unit,
      this.descritption,
      this.discount,
      this.liveStatus,
      this.price,
      this.returnable,
      this.allowCustomOrders,
      this.tags,
      this.tax,
      this.qty})
      : super(key: key);

  @override
  State<ItemAddition> createState() => _ItemAdditionState();
}

class _ItemAdditionState extends State<ItemAddition> {
  final FirebaseRoutes _routes = FirebaseRoutes();
  final CustomWidgets cWidgetsInstance = CustomWidgets();

  int currentStep = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController taxController = TextEditingController();

  bool _isLive = true;
  bool returnable = true;
  bool allowCustomOrders = false;
  List tags = [];
  List imageFiles = [];
  List<String> units = [
    'No.',
    'Piece',
    'Pack',
    'Box',
    'Carton',
    'Set',
    'Pair',
    'Dozen',
    'Gram',
    'Kilogram',
    'Milligram',
    'Pound',
    'Ounce',
    'Liter',
    'Milliliter',
    'Gallon',
    'Quart',
    'Pint',
    'Fluid Ounce',
    'Meter',
    'Centimeter',
    'Millimeter',
    'Inch',
    'Foot',
    'Yard',
    'Square Meter',
    'Square Centimeter',
    'Square Millimeter',
    'Square Inch',
    'Square Foot',
    'Square Yard',
    'Cubic Meter',
    'Cubic Centimeter',
    'Cubic Millimeter',
    'Cubic Inch',
    'Cubic Foot',
    'Cubic Yard',
  ];

  bool _isLoading = false;

  String _selectedUnit = 'No.';

  @override
  void initState() {
    _editAddFieldFills(edit: widget.edit);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
    qtyController.dispose();
    discountController.dispose();
    tagsController.dispose();
    taxController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    TopLabelTextField topLabelTextField = TopLabelTextField();

    List<Step> steps = [
// The main image and title step
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        title: const Text('Product and Images'),
        content: Column(
          children: [
            // the text field for name controller.
            topLabelTextField.topLabelTextField(
                borderRadius: 10.0,
                controller: nameController,
                label: 'Item name ',
                hintText: 'Eg. Tomato',
                keyboardType: TextInputType.name,
                obscureText: false,
                requiredField: true),

            SizedBox(
              height: height * 0.02,
            ),

            // the image picker
            InkWell(
              // choose images on tap
              onTap: () async {
                if (imageFiles.length <= 2) {
                  dynamic file = await MediaServices(
                          type: _routes.rootCollection, uid: _routes.fUid)
                      .pickImageFromGallery();
                  if (file != null) {
                    setState(
                      () {
                        imageFiles.add(file!);
                      },
                    );
                  }
                } else {
                  cWidgetsInstance.snackBarWidget(
                      content: 'Cannot select more than 3 images',
                      context: context);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: height * 0.02,
                ),
                height: height * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorPalette().accentBlue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: width * 0.06,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.image,
                        color: ColorPalette().linkBlue,
                      ),
                    ),
                    Text(
                      'Select upto three images.',
                      style: TextStyle(
                          color: ColorPalette().primaryBlue, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

            // The list view of picked images
            SizedBox(
              height: imageFiles.isEmpty
                  ? height * 0.1
                  : height * 0.08 * imageFiles.length,
              child: widget.edit &&
                      imageFiles.isEmpty &&
                      (nameController.text == widget.name)
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          ' If new media is not uploaded, the already present ones will be used.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : imageFiles == []
                      ? null
                      : imageListView(imageFiles),
            ),
          ],
        ),
      ),

// The second item desc and price step
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        title: const Text('Product details'),
        content: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // include the option for unit of the quantity
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              icon: Icon(
                Icons.arrow_drop_down,
                color: ColorPalette().primaryBlue,
              ),
              items: units.map((String unit) {
                return DropdownMenuItem<String>(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (unit) {
                setState(() {
                  _selectedUnit = unit!;
                });
              },
            ),
            SizedBox(
              height: height * 0.03,
            ),
            topLabelTextField.topLabelTextField(
                borderRadius: 10.0,
                controller: qtyController,
                label: 'Quantity ',
                hintText: '$_selectedUnit(s) in stock',
                keyboardType: TextInputType.number,
                obscureText: false,
                requiredField: true),
            SizedBox(
              height: height * 0.03,
            ),
            topLabelTextField.topLabelTextField(
                borderRadius: 10.0,
                controller: priceController,
                label: 'Item Price (Per $_selectedUnit) ',
                hintText: 'Price for each $_selectedUnit.',
                keyboardType: TextInputType.number,
                obscureText: false,
                requiredField: true),
            SizedBox(
              height: height * 0.03,
            ),
            topLabelTextField.topLabelTextField(
                borderRadius: 10.0,
                maxLength: 100,
                controller: descController,
                label: 'Item description ',
                hintText: 'Optional',
                keyboardType: TextInputType.name,
                obscureText: false,
                requiredField: false),

            SizedBox(
              height: height * 0.04,
            )
          ],
        ),
      ),

// The thirf item qty and set to live tab
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        title: const Text('Product status'),
        content: Column(
          children: [
            // the is live tile
            ListTile(
              // tileColor: ColorPalette().accentBlue,
              leading: Icon(
                Icons.paste_rounded,
                color: ColorPalette().inactiveIconGrey,
              ),
              title: Text(
                'Set product to live ',
                style: TextStyle(color: ColorPalette().primaryBlue),
              ),
              trailing: CupertinoSwitch(
                  thumbColor: Colors.white,
                  activeColor: ColorPalette().liveGreen,
                  value: _isLive,
                  onChanged: (value) {
                    setState(() {
                      _isLive = value;
                    });
                  }),
            ),

            //  The discount field
            topLabelTextField.topLabelTextField(
                borderRadius: 10.0,
                controller: discountController,
                label: 'Discount on item ( % )',
                hintText: 'discount on product in percentage',
                keyboardType: TextInputType.number,
                obscureText: false,
                requiredField: true),

            SizedBox(
              height: height * 0.02,
            ),

            // tax on item
            topLabelTextField.topLabelTextField(
                borderRadius: 10.0,
                controller: taxController,
                label: 'Tax on item ( % )',
                hintText: '0% if not entered.',
                keyboardType: TextInputType.number,
                obscureText: false,
                requiredField: false),

            SizedBox(
              height: height * 0.04,
            )
          ],
        ),
      ),

// the forth step returnable and tags
      Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        title: const Text('Visibility'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // the is live tile
            ListTile(
              leading: Icon(
                Icons.history_rounded,
                color: ColorPalette().inactiveIconGrey,
              ),
              title: Text(
                'Is the product returnable in 7 days ',
                style: TextStyle(color: ColorPalette().primaryBlue),
              ),
              trailing: CupertinoSwitch(
                  thumbColor: Colors.white,
                  activeColor: ColorPalette().liveGreen,
                  value: returnable,
                  onChanged: (value) {
                    setState(() {
                      returnable = value;
                    });
                  }),
            ),

            SizedBox(
              height: height * 0.02,
            ),
            // the is allow custom orders tile
            ListTile(
              leading: Icon(
                Icons.history_rounded,
                color: ColorPalette().inactiveIconGrey,
              ),
              title: Text(
                'Allow user to place custom orders.',
                style: TextStyle(color: ColorPalette().primaryBlue),
              ),
              trailing: CupertinoSwitch(
                  thumbColor: Colors.white,
                  activeColor: ColorPalette().liveGreen,
                  value: allowCustomOrders,
                  onChanged: (value) {
                    setState(() {
                      allowCustomOrders = value;
                    });
                  }),
            ),

            SizedBox(
              height: height * 0.02,
            ),
            //  The discount field
            topLabelTextField.topLabelTextField(
                controller: tagsController,
                label: 'Tags ',
                hintText:
                    'comma separated keywords to improve visibility.\nCan add Barcode, Prod ID, etc.',
                keyboardType: TextInputType.text,
                obscureText: false,
                borderRadius: 10.0,
                maxLength: 40,
                maxLines: 3,
                requiredField: true),

            SizedBox(
              height: height * 0.04,
            )
          ],
        ),
      ),

      // The confirmatoin step
      Step(
        title: const Text('Confirm'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // The item name and orice
            const Text(
              'Product name & description',
            ),
            Text(
              '${nameController.text.trim()} , ${descController.text.isNotEmpty ? descController.text : ''}',
              style: TextStyle(
                  color: ColorPalette().secondaryTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: height * 0.03),

            // The product qty and price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // The item descriptoon
                    const Text(
                      'Product price',
                    ),
                    Text(
                      priceController.text.isNotEmpty
                          ? Tools().kmbGenerator(
                              double.parse(priceController.text), true)
                          : '',
                      style: TextStyle(
                          color: ColorPalette().secondaryTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Item status and dicount
                    const Text(
                      'Product quatnity',
                    ),
                    Text(
                      '${qtyController.text} $_selectedUnit ',
                      style: TextStyle(
                          color: ColorPalette().secondaryTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: height * 0.03),

            // the product statys and discount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Item status and dicount
                    const Text(
                      'Product status',
                    ),
                    _isLive
                        ? Text(
                            'Live',
                            style: TextStyle(
                                color: ColorPalette().secondaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          )
                        : Text(
                            'Not live',
                            style: TextStyle(
                                color: ColorPalette().secondaryTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //
                    const Text(
                      'Product discount',
                    ),

                    Text(
                      '${discountController.text} % ',
                      style: TextStyle(
                          color: ColorPalette().secondaryTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: height * 0.02),

            // the returnable and custom orders allowed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // The item name and orice
                    const Text(
                      'Returnable status',
                    ),
                    Text(
                      returnable ? 'Returnable' : 'Not returnable',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: ColorPalette().secondaryTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Column(
                  children: [
                    // The item name and orice
                    const Text(
                      'Custom Orders',
                    ),
                    Text(
                      allowCustomOrders ? 'Allowed' : 'Not allowed',
                      style: TextStyle(
                          color: ColorPalette().secondaryTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    ];

// main body
    return Scaffold(
      // appbar
      appBar: AppBar(
        title: widget.edit
            ? Text(
                'Edit product',
                style: TextStyle(color: ColorPalette().secondaryTextColor),
              )
            : Text('Add Product',
                style: TextStyle(color: ColorPalette().secondaryTextColor)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorPalette().inactiveIconGrey,
          ),
        ),
      ),

      // body a stepper widget
      body: ListView(
        children: [
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  color: ColorPalette().primaryBlue,
                ))
              : Stepper(
                  elevation: 2,
                  physics: const BouncingScrollPhysics(),
                  type: StepperType.vertical,
                  // controls button edits
                  controlsBuilder: (context, details) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // the next button
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ColorPalette().primaryBlue),
                          ),
                          onPressed: () {
                            details.onStepContinue!();
                          },
                          child: Text(
                            currentStep == steps.length - 1
                                ? widget.edit
                                    ? '  Save  '
                                    : '   Add   '
                                : '   Next   ',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // sized box
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.08,
                        ),

                        // the cancel/ back button
                        OutlinedButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.cyan.shade50),
                          ),
                          onPressed: () {
                            details.onStepCancel!();
                          },
                          child: Text(
                            currentStep == steps.length - 1
                                ? ' Edit '
                                : ' Back ',
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorPalette().secondaryTextColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    );
                  },

                  steps: steps,
                  currentStep: currentStep,

                  // on step cancel function
                  onStepCancel: () {
                    if (currentStep > 0) {
                      setState(() {
                        currentStep--;
                      });
                    } else {
                      null;
                    }
                  },

                  // on step continue function
                  onStepContinue: () async {
                    if (currentStep < steps.length) {
                      // if the step is first, the text field and images have to be selecetd
                      if (currentStep == 0) {
                        if (widget.edit) {
                          if (nameController.text.isNotEmpty) {
                            if (widget.name == nameController.text) {
                              setState(() {
                                currentStep++;
                              });
                            } else {
                              // image requirement check should be added here if necessary
                              if (nameController.text.isNotEmpty) {
                                setState(() {
                                  currentStep++;
                                });
                              } else {
                                cWidgetsInstance.snackBarWidget(
                                    content:
                                        'Please complete the required fields',
                                    context: context);
                              }
                            }
                          } else {
                            cWidgetsInstance.snackBarWidget(
                                content: 'Please enter the name of the item.',
                                context: context);
                          }

                          // this is the block for if the item is being added and not edited.
                        } else {
                          // image requirement check should be added here if necessary
                          if (nameController.text.isNotEmpty) {
                            // the fields have been filled , ready to move on
                            setState(() {
                              currentStep++;
                            });
                          } else if (nameController.text.isEmpty) {
                            cWidgetsInstance.snackBarWidget(
                                content: 'Please enter the name of the item.',
                                context: context);
                          }
                          // else {
                          //   cWidgetsInstance.snackBarWidget(
                          //       content: 'Select atleast 1 image of the item.',
                          //       context: context);
                          // }
                        }
                      }

                      // if the step is in the scond field , the descritption and qty and price controller shouldnt be empty
                      else if (currentStep == 1) {
                        if (qtyController.text.isNotEmpty &&
                            priceController.text.isNotEmpty) {
                          // validated and ready to move on
                          setState(() {
                            currentStep++;
                          });
                        } else {
                          cWidgetsInstance.snackBarWidget(
                              content: 'Please fill all the required fileds',
                              context: context);
                        }
                      }

                      // the third step is that of liveness and discounts. chack if the discount is alwauys ledss than 100
                      // show a preview and then on click upload to firebase and move to a dialog, add another or store listing
                      else if (currentStep == 2) {
                        if (discountController.text.isEmpty) {
                          cWidgetsInstance.snackBarWidget(
                              content:
                                  'Discount cannot be empty. Set to 0 if it does not apply.',
                              context: context);
                        } else if (double.parse(discountController.text) >
                            100) {
                          cWidgetsInstance.snackBarWidget(
                              content: 'Discount cannot be over 100 %.',
                              context: context);
                        } else {
                          setState(() {
                            currentStep++;
                          });
                        }

                        //  at this step, you gotta make sure to place atleast five tags,
                      } else if (currentStep == 3) {
                        //
                        if (tagsController.text.isNotEmpty) {
                          setState(() {
                            currentStep++;
                          });
                        } else {
                          cWidgetsInstance.snackBarWidget(
                              content: 'Please add atleast one tag.',
                              context: context);
                        }
                      }

                      // The upload state and stuff goes here
                      // Dont forget to change set state to true
                      // The main step where you've to set state to true;
                      else if (currentStep == 4) {
                        setState(() {
                          _isLoading = true;
                        });

                        dataUploadTask();
                      }
                    }
                  },
                ),
        ],
      ),
    );
  }

  dataUploadTask() async {
    List imageUrlsAfterUpload = [];

    // check if it is an addition or an edit
    // first check for addition
    if (!widget.edit) {
      // create the store item for upload
      // see if there are any images to be uploaded
      if (imageFiles.isNotEmpty) {
        // upload media to url
        imageUrlsAfterUpload = await uploadNewMediaToUrl();
      }

      // upload with the lists if no image files exist
      //  create a store listing item using the data
      StoreItem item = StoreItem(
        itemName: nameController.text,
        itemDescription: descController.text,
        unit: _selectedUnit,
        itemLive: _isLive,
        returnable: returnable,
        allowCustomOrders: allowCustomOrders,
        tags: tagsConvertions(false),
        itemPrice: double.parse(priceController.text),
        itemDiscount: double.parse(discountController.text),
        itemTax: taxController.text.isNotEmpty
            ? double.parse(taxController.text)
            : 0,
        itemQty: double.parse(qtyController.text),
        itemUrls: imageUrlsAfterUpload,
      );

      // Upload the data to firestore.
      String res = await StoreServices()
          .addItemToStoreListings(context: context, item: item);

      // state setting to stop the loading and exit off the screen
      if (res == '1') {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      }
    }

    // if it is an edit of the item
    else {
      // check if the image files have been changed
      // `imageFiles` change on selection of new image, whereas the prev
      // uploaded image urls are stored in the widget.urls list
      if (imageFiles.isEmpty) {
        // there hasnt been an update in the image files.
        // check if there are any updates in the other params
        // ********** requires fix here in version update*************
        // initiate update
        //  create a store listing item using the data
        StoreItem item = StoreItem(
            allowCustomOrders: allowCustomOrders,
            itemName: widget.name,
            itemDescription: descController.text,
            itemLive: _isLive,
            itemPrice: double.parse(priceController.text),
            itemDiscount: double.parse(discountController.text),
            itemTax: taxController.text.isNotEmpty
                ? double.parse(taxController.text)
                : 0,
            itemQty: double.parse(qtyController.text),
            tags: tagsConvertions(false),
            returnable: returnable,
            unit: _selectedUnit,
            itemUrls: widget.urls);

        // Now update the firestore data only
        await StoreServices()
            .updateStoreItemDetails(context: context, item: item);

        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      }

      // there has been an update in the image files.
      else if (imageFiles.isNotEmpty) {
        // delete the exsisting media
        deleteExistingMediaFromUrl(context);
        // upload the new ones.
        imageUrlsAfterUpload = await uploadNewMediaToUrl();

        // check for param updates
        // ********** requires fix here in version update*************
        // initiate update
        //  create a store listing item using the data
        StoreItem item = StoreItem(
            allowCustomOrders: allowCustomOrders,
            itemName: widget.name,
            itemDescription: descController.text,
            itemLive: _isLive,
            itemPrice: double.parse(priceController.text),
            itemDiscount: double.parse(discountController.text),
            itemQty: double.parse(qtyController.text),
            itemTax: taxController.text.isNotEmpty
                ? double.parse(taxController.text)
                : 0,
            tags: tagsConvertions(false),
            returnable: returnable,
            unit: _selectedUnit,
            itemUrls: imageUrlsAfterUpload);

        // Now update the firestore data only
        await StoreServices()
            .updateStoreItemDetails(context: context, item: item);

        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      }
    }
  }

  uploadNewMediaToUrl() async {
    List urls =
        await MediaServices(type: _routes.rootCollection, uid: _routes.fUid)
            .mediaUploadToRoute(
      route: '${_routes.vendorItemStorageRoute}${nameController.text}/',
      context: context,
      files: imageFiles,
    );
    return urls;
  }

  deleteExistingMediaFromUrl(
    BuildContext context,
  ) async {
    await MediaServices(type: _routes.rootCollection, uid: _routes.fUid)
        .mediaDeletionFromStorage(
            context: context,
            route: '${_routes.vendorItemStorageRoute}${widget.name}/');
  }

  tagsConvertions(bool fromTags) {
    String baseString = '';
    if (fromTags) {
      for (int i = 0; i < widget.tags!.length; i++) {
        baseString += '${widget.tags![i]},';
      }

      return baseString;

      //
    } else {
      // convert to tags
      return tagsController.text.split(',').where((element) {
        return element != '';
      }).toList();
    }
  }

  _editAddFieldFills({required bool edit}) {
    if (edit) {
      setState(
        () {
          nameController.text = widget.name;
          descController.text = widget.descritption!;
          priceController.text = widget.price!.toString();
          discountController.text = widget.discount!.toString();
          taxController.text = widget.tax!.toString();
          qtyController.text = widget.qty!.toString();
          _isLive = widget.liveStatus!;
          returnable = widget.returnable!;
          allowCustomOrders = widget.allowCustomOrders!;
          tagsController.text = tagsConvertions(true);
          _selectedUnit = widget.unit;
        },
      );
    }
  }

  imageListView(List imList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          trailing: IconButton(
              onPressed: () {
                setState(() {
                  imageFiles.removeAt(index);
                });
              },
              icon: Icon(
                Icons.delete_outline,
                color: ColorPalette().primaryBlue,
              )),
          leading: Icon(
            Icons.image_outlined,
            color: ColorPalette().primaryBlue,
          ),
          title: Text(
            imList[index].path.split('/').last,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
      itemCount: imList.length,
    );
  }
}
