import 'package:flutter/material.dart';
import 'package:ofg_web/models/quickadds_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_widgets.dart';

class QuickAdds extends StatefulWidget {
  const QuickAdds({super.key});

  @override
  State<QuickAdds> createState() => _QuickAddsState();
}

class _QuickAddsState extends State<QuickAdds> {
  final ColorPalette _palette = ColorPalette();

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemQtyController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final TextEditingController customPriceController = TextEditingController();

  final CustomWidgets customWidgets = CustomWidgets();

  List quickAddsList = [];

  bool _isCustomPricing = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;

    final TopLabelTextField topLabelTextField = TopLabelTextField();

    return Scaffold(
        // appbar
        appBar: AppBar(
          title: Text('Quick Adds ',
              style: TextStyle(color: ColorPalette().secondaryTextColor)),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, quickAddsList);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _palette.inactiveIconGrey,
            ),
          ),
        ),

        // the fab for addition
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: ButtonBar(
            children: [
              // the confirmation button
              SizedBox(
                  width: width * 0.4,
                  height: height * 0.06,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, quickAddsList);
                    },
                    child: const Text('    Cancel    ',
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                  )),

              // the quick adds item addition button
              SizedBox(
                width: width * 0.4,
                height: height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette().primaryBlue,
                    side: BorderSide(
                      width: 1,
                      color: ColorPalette().inactiveIconGrey,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(height * 0.04)),
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: () {
                    // add the custom item to bill
                    if (itemNameController.text.isNotEmpty &&
                        (itemPriceController.text.isNotEmpty ||
                            customPriceController.text.isNotEmpty) &&
                        itemQtyController.text.isNotEmpty) {
                      setState(
                        () {
                          quickAddsList.add(
                            QuickAddsModel(
                                itemName: itemNameController.text,
                                customPrice: _isCustomPricing,
                                price: _isCustomPricing
                                    ? double.parse(customPriceController.text)
                                    : double.parse(itemPriceController.text),
                                qty: double.parse(itemQtyController.text)),
                          );
                        },
                      );

                      itemNameController.clear();
                      itemPriceController.clear();
                      itemQtyController.clear();
                      Navigator.pop(context, quickAddsList);
                    } else {
                      customWidgets.snackBarWidget(
                          content: 'Please fill all the required fields',
                          context: context);
                    }
                  },
                  child: const Text(
                    'Add Item',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),

        // body
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text for custom price check
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Enable custom pricing',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Checkbox(
                      value: _isCustomPricing,
                      onChanged: (value) {
                        setState(() {
                          _isCustomPricing = !_isCustomPricing;
                        });
                      })
                ],
              ),
              const Text(
                'Click   \'Add Item\'   to add it to the final bill.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),

              const SizedBox(
                height: 30,
              ),

              // item name  field
              topLabelTextField.topLabelTextField(
                  controller: itemNameController,
                  label: 'Item Name ',
                  hintText: '',
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  requiredField: true),

              const SizedBox(
                height: 10,
              ),

              // field for price of product
              _isCustomPricing
                  ? topLabelTextField.topLabelTextField(
                      controller: customPriceController,
                      label: 'Custom Price ',
                      hintText: 'Enter custom price for single unit',
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      requiredField: true)
                  : topLabelTextField.topLabelTextField(
                      controller: itemPriceController,
                      label: 'Item Price ',
                      hintText: 'Price per single unit',
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      requiredField: true),

              const SizedBox(
                height: 10,
              ),
              // the item qty field
              topLabelTextField.topLabelTextField(
                  controller: itemQtyController,
                  label: 'Item Quantity ',
                  hintText: 'Total quantity being sold',
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  requiredField: true),
            ],
          ),
        ));
  }
}
