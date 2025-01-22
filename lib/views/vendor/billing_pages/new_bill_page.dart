import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofg_web/models/Invoice_PDF/invoice_pdf_model.dart';
import 'package:ofg_web/models/payee_model.dart';
import 'package:ofg_web/utils/custom_widgets.dart';
import 'package:ofg_web/utils/tools.dart';
import 'package:ofg_web/views/vendor/billing_pages/bill_checkout_page.dart';
import 'package:ofg_web/views/vendor/billing_pages/quick_add_page.dart';
import '../../../utils/constants.dart';

class BillingPage extends StatefulWidget {
  const BillingPage(
      {super.key,
      required this.invoiceNumber,
      required this.storeListings,
      required this.storeProfileDataMap});

  final Map storeProfileDataMap;
  final String invoiceNumber;
  final List storeListings;
  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final ColorPalette palette = ColorPalette();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();
  final TextEditingController billDescController = TextEditingController();
  final TextEditingController extraChargesController = TextEditingController();

  final PageController pageController = PageController(initialPage: 0);
  final CustomWidgets customWidgets = CustomWidgets();
  final Tools _tools = Tools();

  double indicatorValue = 0.0;
  int pageIndex = 0;

  List quickAddsItemsList = [];
  List billItemsList = [];
  List textEditingControllersForItem = [];
  List storeBillFinalDraft = [];

  // This is in the format [extra change, extra discount]
  List extraCharges = [0, 0];

  @override
  void initState() {
    // setting the billitems list for addition of items

    setState(() {
      billItemsList = widget.storeListings.map((e) {
        return {
          "customOrders": e['customOrders'],
          'urls': e['urls'],
          'unit': e['unit'],
          'returnable': e['returnable'],
          'price': e['price'],
          'qty': 0.0,
          'storeQty': e['qty'],
          'name': e['name'],
          'discount': e['discount'],
          'tax': e['tax'],
          'live': e['live'],
          'tags': e['tags'],
          'desc': e['desc']
        };
      }).toList();

      textEditingControllersForItem = widget.storeListings
          .map((e) => TextEditingController(text: '0'))
          .toList();
    });

    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    userPhoneController.dispose();
    billDescController.dispose();
    extraChargesController.dispose();
    textEditingControllersForItem.map((e) => e.dispose());

    super.dispose();
  }

  late List<InvoiceItem> invoiceItemList;
  // late List<QuickAddItem>? quickAddedItemsList = [];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;

    // the instance for all the main textfields
    final TopLabelTextField topLabelTextField = TopLabelTextField();

    return PopScope(
      canPop: pageIndex <= 0 ? true : false,
      child: Scaffold(
        // appbar
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Checkout ',
                  style: TextStyle(color: palette.secondaryTextColor)),
              Text(
                '#Nc${widget.invoiceNumber}',
                overflow: TextOverflow.fade,
                style: TextStyle(color: palette.linkBlue),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          leading: pageIndex == 0
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: palette.inactiveIconGrey,
                  ),
                )
              : null,
        ),

        // body
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              // the text that says progress status
              SizedBox(
                height: height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.doc_append,
                      color: palette.primaryBlue,
                      size: 30,
                    ),
                    Text(
                      pageIndex == 0
                          ? '  Checkout Details '
                          : pageIndex == 1
                              ? '  Checked Items  '
                              : pageIndex == 2
                                  ? '  Quick Adds  '
                                  : '  Checkout  ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: height * 0.02),
                    )
                  ],
                ),
              ),

              // the progess viewer using linear progress indicator
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 250),
                curve: Curves.decelerate,
                tween: Tween<double>(begin: 0, end: indicatorValue),
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  valueColor: const AlwaysStoppedAnimation(Color(0xff69BB94)),
                  backgroundColor: palette.containerGrey,
                ),
              ),

              // the pageview container where the details are help
              Container(
                height: height * 0.7,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    setState(() {
                      pageIndex = value;
                      indicatorValue = value * 0.33;
                    });
                  },
                  children: [
                    // the first details page
                    // this page holds the main bill payee info
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.02),

                        // the text stating the billing date
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Item status and dicount
                                Text(
                                  'Issued on',
                                  style: TextStyle(color: palette.textGrey),
                                ),
                                Text(
                                  _tools.getDate(),
                                  style: TextStyle(
                                      color: palette.secondaryTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Item status and dicount
                                Text(
                                  'Issued at',
                                  style: TextStyle(color: palette.textGrey),
                                ),
                                Text(
                                  _tools.getTime(),
                                  style: TextStyle(
                                      color: palette.secondaryTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.04),

                        // the payee name
                        topLabelTextField.topLabelTextField(
                            controller: userNameController,
                            requiredField: true,
                            label: 'Checkout To ',
                            hintText: 'Enter payee\'s name',
                            keyboardType: TextInputType.name,
                            obscureText: false,
                            borderRadius: 10.0),

                        SizedBox(height: height * 0.02),

                        // the phone number field
                        topLabelTextField.topLabelTextField(
                            controller: userPhoneController,
                            requiredField: false,
                            label: 'Contact',
                            hintText: 'Payee\'s contact (Email or Phone)',
                            keyboardType: TextInputType.name,
                            obscureText: false,
                            borderRadius: 10.0,
                            maxLength: 10),

                        // the bill desc or comments part
                        topLabelTextField.topLabelTextField(
                            controller: billDescController,
                            requiredField: false,
                            label: 'Checkout Description ',
                            hintText: 'Or any other comments.',
                            keyboardType: TextInputType.name,
                            obscureText: false,
                            borderRadius: 10.0,
                            maxLines: 3,
                            maxLength: 50),

                        // the date title
                      ],
                    ),

                    // the second item addition from store page
                    // the item from store selection
                    widget.storeListings.isEmpty
                        ? const Center(
                            child: Text(
                              'No items in store to add to the bill.',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        :
                        // the main listview
                        ListView.builder(
                            itemCount: widget.storeListings.length,
                            itemBuilder: (context, index) {
                              var item = widget.storeListings[index];

                              return ExpansionTile(
                                // the leading image in list item
                                leading: item['urls'].isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          width: height * 0.06,
                                          height: height * 0.08,
                                          child: Image.network(
                                            item['urls'][0],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : const CircleAvatar(
                                        child: Icon(CupertinoIcons.photo_fill),
                                      ),

                                //  the main name of the item
                                title: Text(
                                  '${item['name']}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                    'Qty: ${item['qty']}    (Unit: ${item['unit']})',
                                    overflow: TextOverflow.ellipsis),
                                trailing: const Icon(
                                    CupertinoIcons.arrowtriangle_down_circle),
                                children: [
                                  // this is where the content fgoes
                                  SizedBox(
                                    height: height * 0.42,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // the price section
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Price per unit:',
                                                    style: TextStyle(
                                                        color:
                                                            palette.textGrey),
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                Text(
                                                  '${_tools.kmbGenerator(item['price'], true)} per ${item['unit']}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: palette
                                                          .secondaryTextColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Total stock value:',
                                                    style: TextStyle(
                                                        color:
                                                            palette.textGrey),
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                Text(
                                                  _tools.kmbGenerator(
                                                      item['price'] *
                                                          item['qty'],
                                                      true),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.yellow[800],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: height * 0.02),

                                        // the item wty and stock details
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // item discount
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Item in stock:',
                                                  style: TextStyle(
                                                      color: palette.textGrey),
                                                ),
                                                Text(
                                                  '${item['qty']}',
                                                  style: TextStyle(
                                                      color: palette
                                                          .secondaryTextColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            // item discount
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Live status:',
                                                  style: TextStyle(
                                                      color: palette.textGrey),
                                                ),
                                                Text(
                                                  item['live']
                                                      ? 'Live                 '
                                                      : 'Not Live             ',
                                                  style: TextStyle(
                                                      color: item['live']
                                                          ? Colors.green
                                                          : palette
                                                              .secondaryTextColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: height * 0.02),

                                        // the details on discount and tax
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // item discount
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Discount per unit:',
                                                  style: TextStyle(
                                                      color: palette.textGrey),
                                                ),
                                                Text(
                                                  '${item['discount']}%  per ${item['unit']}',
                                                  style: TextStyle(
                                                      color: palette
                                                          .secondaryTextColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                            // item discount
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Tax:',
                                                  style: TextStyle(
                                                      color: palette.textGrey),
                                                ),
                                                Text(
                                                  '${item['tax']}%     ',
                                                  style: TextStyle(
                                                      color: palette
                                                          .secondaryTextColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: height * 0.02),

                                        // bill value and text edit for custom orders
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // item bill value
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Total Bill Value:',
                                                  style: TextStyle(
                                                      color: palette.textGrey),
                                                ),
                                                Text(
                                                  _tools.kmbGenerator(
                                                      billItemsList[index]
                                                              ['qty'] *
                                                          item['price'],
                                                      true),
                                                  style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),

                                            // the custom button bar for adding or removing items to cart
                                            ButtonBar(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                // the minus button
                                                !item['customOrders']
                                                    ? IconButton(
                                                        icon: const Icon(
                                                            CupertinoIcons
                                                                .minus),
                                                        onPressed: () {
                                                          double val =
                                                              billItemsList[
                                                                  index]['qty'];
                                                          // only icnrease the value of the counter if val is lower than qty
                                                          if (val > 0) {
                                                            setState(() {
                                                              billItemsList[
                                                                          index]
                                                                      ['qty'] =
                                                                  billItemsList[
                                                                              index]
                                                                          [
                                                                          'qty'] -
                                                                      1.0;
                                                            });
                                                          }
                                                        },
                                                      )
                                                    : const SizedBox(),

                                                !item['customOrders']
                                                    ? Text(_tools.kmbGenerator(
                                                        double.parse(
                                                            billItemsList[index]
                                                                    ['qty']
                                                                .toString()),
                                                        true))
                                                    :
                                                    // the custom order text field
                                                    SizedBox(
                                                        width: width * 0.3,
                                                        height: height * 0.05,
                                                        child: TextField(
                                                          onChanged: (value) {
                                                            if (value
                                                                .isNotEmpty) {
                                                              if (double.parse(
                                                                      value) >
                                                                  0) {
                                                                if (double.parse(
                                                                        value) >
                                                                    item[
                                                                        'qty']) {
                                                                  textEditingControllersForItem[
                                                                          index]
                                                                      .clear();
                                                                } else {
                                                                  setState(() {
                                                                    billItemsList[
                                                                            index]
                                                                        [
                                                                        'qty'] = double.parse(textEditingControllersForItem[
                                                                            index]
                                                                        .text);
                                                                  });
                                                                }
                                                              }
                                                            }
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          obscureText: false,
                                                          cursorColor:
                                                              ColorPalette()
                                                                  .primaryBlue,
                                                          autocorrect: true,
                                                          autofocus: true,
                                                          controller:
                                                              textEditingControllersForItem[
                                                                  index],
                                                          decoration: InputDecoration(
                                                              focusedBorder: const OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .blue)),
                                                              enabledBorder: const OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                              disabledBorder: const OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .grey)),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color: Colors
                                                                              .blue
                                                                              .shade900))),
                                                        ),
                                                      ),

                                                // the add button
                                                !item['customOrders']
                                                    ? IconButton(
                                                        icon: const Icon(
                                                            CupertinoIcons.add),
                                                        onPressed: () {
                                                          double val =
                                                              billItemsList[
                                                                  index]['qty'];

                                                          // only icnrease the value of the counter if val is lower than qty
                                                          if (val <
                                                              item['qty']) {
                                                            setState(
                                                              () {
                                                                billItemsList[
                                                                        index][
                                                                    'qty'] = billItemsList[
                                                                            index]
                                                                        [
                                                                        'qty'] +
                                                                    1.0;
                                                              },
                                                            );
                                                          }
                                                        },
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ],
                                        ),

                                        // the reset button
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  billItemsList[index]['qty'] =
                                                      0;
                                                });
                                              },
                                              icon: const Icon(
                                                CupertinoIcons.refresh_thick,
                                                color: Colors.red,
                                              ),
                                            ),
                                            const Text(
                                              'Reset bill',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),

                    // the quickadds section for, well, quick item addition without much detail
                    quickAddsItemsList.isEmpty
                        ? Center(
                            child: SizedBox(
                              height: height * 0.3,
                              width: width * 0.7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Add other items using QuickAdds.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async {
                                      // move to quickads page
                                      var res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const QuickAdds();
                                          },
                                        ),
                                      );

                                      if (res != null) {
                                        setState(() {
                                          quickAddsItemsList = res;
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                    label: Text(
                                      'Add via QuickAdds.',
                                      style: TextStyle(color: palette.linkBlue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * 0.08,
                                child: TextButton.icon(
                                  onPressed: () async {
                                    // move to quickads page
                                    var res = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const QuickAdds();
                                        },
                                      ),
                                    );

                                    if (res != null) {
                                      setState(() {
                                        quickAddsItemsList.addAll(res);
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                  label: Text(
                                    'Add via QuickAdds.',
                                    style: TextStyle(color: palette.linkBlue),
                                  ),
                                ),
                              ),

                              // the main list view
                              SizedBox(
                                height: height * 0.6,
                                child: ListView.builder(
                                  clipBehavior: Clip.antiAlias,
                                  shrinkWrap: true,
                                  itemCount: quickAddsItemsList.length,
                                  itemBuilder: (context, index) {
                                    var item = quickAddsItemsList[index];
                                    return Tooltip(
                                      showDuration: const Duration(seconds: 2),
                                      message:
                                          'Total = ${Tools().kmbGenerator(item.qty * item.price, true)},   ${item.qty} Units    ${item.price} / Unit',
                                      child: ListTile(
                                        isThreeLine: true,
                                        leading: Icon(
                                          CupertinoIcons.app_badge,
                                          color: palette.accentGreen,
                                          size: 30,
                                        ),
                                        title: Text(
                                          '${item.itemName}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          'Total = ${Tools().kmbGenerator(item.qty * item.price, true)},   ${item.qty} Units    ${item.price} / Unit',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            // remove item from list
                                            setState(() {
                                              quickAddsItemsList
                                                  .removeAt(index);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: palette.deletionRed,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                    // the final page
                    // the preview page
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // the items preview
                        // the pageview of bill adds
                        Container(
                          height:
                              storeBillFinalDraft.isEmpty ? 0 : height * 0.4,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: PageView.builder(
                            pageSnapping: true,
                            itemCount: storeBillFinalDraft.length,
                            itemBuilder: (context, index) {
                              // var item = widget.storeListings[index];

                              var item = storeBillFinalDraft[index];

                              // store item final draft container
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Widget Container
                                    SizedBox(
                                      height: height * 0.22,
                                      width: width,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                        child: item['urls'].isNotEmpty
                                            ? Image.network(
                                                '${item['urls'][0]}',
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/illustrations/cartnbags.png',
                                                fit: BoxFit.fitHeight,
                                              ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    // The main text
                                    Text(
                                      '${item['name']}',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.heebo(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.black87),
                                    ),

                                    // Text of the item qty and total
                                    Text(
                                      'Qty sold = ${item['qty']}    ${item['price']} per ${item['unit']}    Tval = ${item['qty'] * item['price']}',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.heebo(
                                          color: palette.textGrey),
                                    ),
                                    Text(
                                      'Discount = ${item['discount']}%      Tax = ${item['tax']}%',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.heebo(
                                          color: palette.deletionRed),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    // the main total price
                                    Text(
                                      '${calculateFinalPriceForEachProduct(item)}',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.heebo(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: palette.mainGreen),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        // THe quick addsitem list pageview
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          height: height * 0.14,
                          child: PageView.builder(
                              itemCount: quickAddsItemsList.length,
                              itemBuilder: (context, index) {
                                var item = quickAddsItemsList[index];
                                return SizedBox(
                                  height: height * 0.3,
                                  width: width * 0.5,
                                  child: Row(
                                    children: [
                                      // the main image looking widget
                                      SizedBox(
                                        height: height * 0.24,
                                        width: width * 0.2,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomLeft: Radius.circular(12)),
                                          child: Image.asset(
                                              'assets/illustrations/cart.png',
                                              fit: BoxFit.cover),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 10,
                                      ),

                                      // The text about the item
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // The main text
                                            Text(
                                              '${item.itemName}',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.heebo(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.black87),
                                            ),
                                        
                                            // Text of the item qty and total
                                            Text(
                                              'Qty sold = ${item.qty}   ${_tools.kmbGenerator(item.price, true)} per Unit.',
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.heebo(
                                                  color: palette.textGrey),
                                            ),
                                        
                                            const SizedBox(
                                              height: 10,
                                            ),
                                        
                                            // the main total price
                                            Text(
                                              '${item.qty * item.price}',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.heebo(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: palette.mainGreen),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),

                        SizedBox(
                          height:
                              storeBillFinalDraft.isEmpty ? height * 0.42 : 16,
                        ),

                        // This is the extra buttons' button bar
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // the extra addition
                            // the buttonfor adding extra charges
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    extraChargesDialogue(false);
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    size: 24.0,
                                  ),
                                  label: const Text(
                                    'Extra Fees',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('${extraCharges[0]}      ',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),

                            // // the extra discount button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    extraChargesDialogue(true);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  icon: const Icon(
                                    CupertinoIcons.minus,
                                    size: 24.0,
                                  ),
                                  label: const Text(
                                    'Extra Discounts',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('${extraCharges[1]}     ',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // the buttonbar
              ButtonBar(
                mainAxisSize: MainAxisSize.max,
                alignment: MainAxisAlignment.spaceAround,
                children: [
                  // the back button
                  SizedBox(
                    width: width * 0.4,
                    height: height * 0.06,
                    child: pageIndex == 0
                        ? OutlinedButton(
                            onPressed: () {},
                            child: const Text('    Back    ',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey)),
                          )
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black38,
                            ),
                            onPressed: () {
                              pageController.animateToPage(pageIndex - 1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            },
                            child: const Text(
                              '    Back    ',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black87),
                            ),
                          ),
                  ),

                  // the continue button
                  SizedBox(
                    width: width * 0.4,
                    height: height * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.primaryBlue,
                        side: BorderSide(
                          width: 1,
                          color: palette.inactiveIconGrey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(height * 0.035),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: () {
                        // check if the first page is valid
                        // Continue to the bill items list add from info add
                        if (pageIndex == 0 &&
                            userNameController.text.isNotEmpty) {
                          pageController.animateToPage(1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }
                        // check for page 2 where the items should be added
                        // continue to quick adds page from bill items list add
                        else if (pageIndex == 1) {
                          finalBillDraft();
                          pageController.animateToPage(2,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        }
                        // check for final status and proceed to upload bill
                        // continue to final check out page from quick adds page
                        else if (pageIndex == 2) {
                          // check if the bill is an empty bill. In that case snack bar the user
                          if (quickAddsItemsList.isNotEmpty ||
                              storeBillFinalDraft.isNotEmpty) {
                            pageController.animateToPage(3,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut);
                          } else {
                            customWidgets.snackBarWidget(
                                content: 'Yowza! Bill is empty. Add items.',
                                context: context);
                          }
                          // render the bill preview and go to billing
                          // no further checks needed as it is already done.
                        } else if (pageIndex == 3) {
                          checkoutPreviewDialogue(width);
                        }

                        // the snack bar to show some fields haven't been filled
                        else {
                          customWidgets.snackBarWidget(
                              content: 'Please fill all the required fields.',
                              context: context);
                        }
                      },
                      child: const Text(
                        'Continue',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkoutPreviewDialogue(width) {
    double storeTotal = calculateStoreBillTotal();
    double qaTotal = calcQuickAddsTotal();

    showDialog(
      barrierColor: Colors.grey,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Checkout Confirmation',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // the main total in the dialogue
                const Text(
                  'Total (Items from store)',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '$storeTotal \n',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: palette.mainGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4.0),

                const Text(
                  'Total (Items from QuickAdds)',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '$qaTotal \n',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: palette.mainGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Extra Fees',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${extraCharges[0]}\n',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: palette.mainGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Extra Discount',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
                const SizedBox(height: 6.0),
                Text(
                  '${extraCharges[1]} \n\n',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: palette.deletionRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6.0),
                const Text(
                  'Final Bill Value',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${extraCharges[1] + extraCharges[0] + storeTotal + qaTotal} \n',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // the close button
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),

            // Elevated button to invoice
            // ElevatedButton.icon(
            //     onPressed: () {
            //       Navigator.pop(context);

            //       Map<String, dynamic> invoiceMap = {
            //         'checkoutNo': widget.invoiceNumber,
            //         'storeName': widget.storeProfileDataMap['storeName'],
            //         'extraCharges': extraCharges, // Fixed the field name
            //         'isInvoice': true,
            //         'storeAddsItems': storeBillFinalDraft,
            //         'quickAddsItems':
            //             quickAddsItemsList.map((e) => e.toJson()).toList(),
            //         'paymentMode': [],
            //         'billedDate': DateTime.now(),
            //         'payee': Payee(
            //                 name: userNameController.text,
            //                 contact: userPhoneController.text,
            //                 desc: billDescController.text,
            //                 premium: false)
            //             .toJson(),
            //         'dueDate': '',
            //         'storBillTotal': storeTotal,
            //         'quickAddsTotal': qaTotal
            //       };

            //       customWidgets.moveToPage(
            //           page: InvoiceCheckout(
            //             invMap: invoiceMap,
            //           ),
            //           context: context,
            //           replacement: false);
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.amberAccent, // background
            //     ),
            //     icon: const Icon(CupertinoIcons.doc_plaintext),
            //     label: const Text(
            //       "Invoice",
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     )),

            // the bill button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);

                /*
                Turn the checkout model form in a map form then transfer the
                mao to the other screen from where the function is going to be called.
                */

                Map<String, dynamic> billMap = {
                  'checkoutNo': widget.invoiceNumber,
                  'storeName': widget.storeProfileDataMap['storeName'],
                  'extraCharges': extraCharges, // Fixed the field name
                  'isInvoice': false,
                  'storeAddsItems': storeBillFinalDraft,
                  'quickAddsItems':
                      quickAddsItemsList.map((e) => e.toJson()).toList(),
                  'paymentMode': [],
                  'billedDate': DateTime.now(),
                  'payee': Payee(
                          name: userNameController.text,
                          contact: userPhoneController.text,
                          desc: billDescController.text,
                          premium: false)
                      .toJson(),
                  'dueDate': '',
                  'storeBillTotal': storeTotal,
                  'quickAddsTotal': qaTotal
                };

                // navigator
                customWidgets.moveToPage(
                    page: BillCheckoutPage(
                      dataMap: billMap,
                    ),
                    context: context,
                    replacement: false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.primaryBlue,
              ),
              icon: const Icon(CupertinoIcons.money_dollar_circle,
                  color: Colors.white),
              label: const Text(
                "  Bill / Invoice  ",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  extraChargesDialogue(bool discount) {
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
                  "Extra Charges/Discounts",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  controller: extraChargesController,
                  decoration: const InputDecoration(
                    hintText: "Enter the amount",
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        extraChargesController.clear();
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
                    ElevatedButton(
                      onPressed: () {
                        if (extraChargesController.text.isNotEmpty) {
                          if (discount) {
                            setState(() {
                              extraCharges[1] = -1 *
                                  double.parse(extraChargesController.text);
                            });
                          } else {
                            setState(() {
                              extraCharges[0] =
                                  double.parse(extraChargesController.text);
                            });
                          }
                        }
                        extraChargesController.clear();
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text("Charge"),
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

  calculateFinalPriceForEachProduct(Map item) {
    double finalPrice = item['qty'] *
        item['price'] *
        ((1 + (item['tax'] / 100)) - (item['discount'] / 100));

    return finalPrice.roundToDouble();
  }

  finalBillDraft() {
    List storeBill = [];
    for (int i = 0; i < billItemsList.length; i++) {
      if (billItemsList[i]['qty'] != 0) {
        storeBill.add(billItemsList[i]);
      }
    }

    setState(() {
      storeBillFinalDraft = storeBill;
    });
  }

  calculateStoreBillTotal() {
    double total = 0.0;
    for (int index = 0; index < storeBillFinalDraft.length; index++) {
      total += calculateFinalPriceForEachProduct(storeBillFinalDraft[index]);
    }
    return total;
  }

  calcQuickAddsTotal() {
    return quickAddsItemsList.isNotEmpty
        ? quickAddsItemsList
            .map((e) => e.price * e.qty)
            .toList()
            .reduce((value, element) => value + element)
        : 0.0;
  }
}
