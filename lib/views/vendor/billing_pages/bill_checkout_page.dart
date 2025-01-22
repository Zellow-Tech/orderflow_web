// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofg_web/services/checkout_service.dart';
import 'package:ofg_web/services/pdf_services.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/custom_widgets.dart';

class BillCheckoutPage extends StatefulWidget {
  const BillCheckoutPage({super.key, required this.dataMap});
  // Pdf Data Model to generate Model
  final Map<String, dynamic> dataMap;
  @override
  State<BillCheckoutPage> createState() => _BillCheckoutPageState();
}

class _BillCheckoutPageState extends State<BillCheckoutPage> {
// the invoice variables
  bool isInvoice = false;
  bool isCheckoutComplete = false;
  String invoiceDueDate = '';
  final TextEditingController invoiceDeadlineController =
      TextEditingController();

// one time instances
  final CheckoutService _checkoutService = CheckoutService();
  final CustomWidgets _customWidgets = CustomWidgets();
  final ColorPalette _palette = ColorPalette();
  final PdfServices _pdfServices = PdfServices();

// cash, card, debt, Upi, coupons, paypal, other,
  List checkedOptions = [false, false, false, false, false, false, false];
  final List paymentOptions = [
    "Cash 💵",
    "Card 💳",
    "Debt 🤷",
    "Coupons 🎟️",
    "UPI 📱",
    "Paypal 🖥️",
    "Other 📚"
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    invoiceDeadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      // appbar
      appBar: isLoading || isCheckoutComplete
          ? null
          : AppBar(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    isCheckoutComplete = false;
                    isLoading = false;
                  });
                  Navigator.pop(context, false);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ColorPalette().inactiveIconGrey,
                ),
              ),
              centerTitle: true,
              elevation: 4,
            ),

      //  the floating action buttons that hold the continue and back buttons
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoading || isCheckoutComplete
          ? null
          : ButtonBar(
              mainAxisSize: MainAxisSize.max,
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                // the back button
                SizedBox(
                  width: width * 0.4,
                  height: height * 0.06,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black38,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Back',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17, color: Colors.black87),
                    ),
                  ),
                ),

                // the continue button
                SizedBox(
                  width: width * 0.4,
                  height: height * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _palette.primaryBlue,
                      side: BorderSide(
                        width: 1,
                        color: _palette.inactiveIconGrey,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(height * 0.04)),
                      elevation: 0,
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      // update the dataMap
                      widget.dataMap['paymentMode'] = checkedOptions;
                      // update invoice data
                      widget.dataMap['isInvoice'] = isInvoice;

                      // register data in the backend and update item counts of item
                      var res1 = await _checkoutService.registerCheckoutToStore(
                          context: context, dataMap: widget.dataMap);

                      var res2 = await _checkoutService
                          .updateStoreItemQtyAfterCheckout(
                              context: context, dataMap: widget.dataMap);

                      // the data dialogue for successful registration
                      if (res1 == '1' && res2 == '1') {
                        setState(() {
                          isCheckoutComplete = true;
                        });
                      } else {
                        _customWidgets.snackBarWidget(
                            content: res1.toString(), context: context);
                      }

                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: const Text(
                      'Register',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

      // the body
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: _palette.primaryBlue,
              ),
            )
          : isCheckoutComplete
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // the main icon after success
                      Icon(
                        Icons.check,
                        color: _palette.primaryBlue,
                        size: 80.0,
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // the title text and subtext
                      Text('Checkout Complete!',
                          style: GoogleFonts.heebo(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600)),
                      const Text(
                          'Your bill/invoice was recorded successfully.'),

                      const SizedBox(
                        height: 36,
                      ),

                      // the button bar for share and cancel
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          // the cancel button that takes us back to the dash
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop(true);
                            },
                            child: const Text(
                              'Dashboard',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),

                          // the share button the should render the pdf for bill/invoice sharing
                          ElevatedButton(
                            onPressed: () async {
                              // open pdf after render
                              await renderPdfSharing(widget.dataMap);
                              Navigator.pop(context);
                              Navigator.pop(context, true);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder()),
                            child: const Text(
                              'Share',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              :

              // the main payment mode view
              ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.0),
                      child: Text('Payment Method',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 22)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 14.0, bottom: 20),
                      child: Text('Select one or multiple',
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ),
                    SizedBox(
                      height: height * 0.5,
                      child: ListView.builder(
                          itemCount: paymentOptions.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile.adaptive(
                              value: checkedOptions[index],
                              onChanged: (newValue) async {
                                setState(() {
                                  checkedOptions[index] = newValue;
                                });
                              },
                              title: Text(
                                paymentOptions[index],
                              ),
                              dense: false,
                              controlAffinity: ListTileControlAffinity.trailing,
                            );
                          }),
                    ),

                    // divider for invoice
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                      child: Divider(),
                    ),

                    // invoice tab
                    CheckboxListTile.adaptive(
                      value: isInvoice,
                      onChanged: (newValue) async {
                        // call the invoice due dialogue
                        if (isInvoice == false) {
                          invoiceDeadlineDialogue();
                          // change the datamap variable to invoice
                          setState(
                            () {
                              isInvoice = true;
                            },
                          );
                        } else {
                          setState(() {
                            isInvoice = false;
                          });
                        }
                      },
                      title: const Text(
                        'Register as Invoice',
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: invoiceDueDate == ''
                          ? const Text('No due date')
                          : Text('Invoice is due on $invoiceDueDate'),
                      isThreeLine: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ],
                ),
    );
  }

// render the pdf for sharing
  renderPdfSharing(Map dataMap) async {
    // generate pdf for checkout
    var file = await _pdfServices.renderCheckoutPDF(dataMap);
    // for the share button.
    _pdfServices.openFile(file, context);
  }

// invoice deadline dialogue
  invoiceDeadlineDialogue() async {
    showDialog(
      barrierColor: Colors.grey,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Invoice Deadline",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  keyboardType: TextInputType.datetime,
                  autofocus: false,
                  controller: invoiceDeadlineController,
                  decoration: const InputDecoration(
                    hintText: "Enter the due date",
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    // the add date button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.dataMap['dueDate'] =
                              invoiceDeadlineController.text;
                          invoiceDueDate = invoiceDeadlineController.text;
                          Navigator.of(context).pop(); //
                        });
                      },
                      child: const Text("Add to doc"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
