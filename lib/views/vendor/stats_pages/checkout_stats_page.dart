import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ofg_web/utils/constants.dart';
import 'package:ofg_web/utils/tools.dart';

// ignore: must_be_immutable
class CheckoutStatsPage extends StatefulWidget {
  CheckoutStatsPage({super.key, required this.checkouts});
  List checkouts;
  @override
  State<CheckoutStatsPage> createState() => _CheckoutStatsPageState();
}

class _CheckoutStatsPageState extends State<CheckoutStatsPage> {
// the finals
  final Tools _tools = Tools();
  final ColorPalette _palette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    // the dimesnaions
    final double height = MediaQuery.sizeOf(context).height;

    return SizedBox(
      child: ListView.builder(
        itemCount: widget.checkouts.length,
        itemBuilder: (context, index) {
          var item = widget.checkouts[index];
          bool isIndexItemInvoice = item['isInvoice'];

          // the grand total bill/invoice value
          double grandTotal = item['extraCharges'][1] +
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
                    : Icons.check_circle_outline_rounded,
                size: 26,
                color: Colors.white,
                weight: 2.0,
              ),
            ),

            // title
            title: Text(
              item['payee']['name'],
              overflow: TextOverflow.ellipsis,
              style:
                  GoogleFonts.heebo(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            // sub
            subtitle: Text(
              isIndexItemInvoice
                  ? 'Invoiced on: ${_tools.getBilledDate(item['checkoutNo'])}'
                  : 'Billed on : ${_tools.getBilledDate(item['checkoutNo'])}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600),
            ),

            trailing: Text(
              isIndexItemInvoice
                  ? _tools.kmbGenerator(
                      grandTotal, grandTotal > 10000 ? true : false)
                  : '+${_tools.kmbGenerator(grandTotal, grandTotal > 10000 ? true : false)}',
              style: TextStyle(
                  color: isIndexItemInvoice ? Colors.blueAccent : Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
