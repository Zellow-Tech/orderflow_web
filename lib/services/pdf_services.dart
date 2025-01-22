// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfServices {
  PdfServices();
  late File pdfFile;

  final List paymentOptions = [
    "Cash",
    "Card",
    "Debt",
    "Coupons",
    "UPI",
    "Paypal",
    "Invoice",
    "Other"
  ];

  Future<String> renderCheckoutPDF(Map bill) async {
    try {
      double grandTotal = bill['quickAddsTotal'] +
          bill['storeBillTotal'] +
          bill['extraCharges'][0] +
          bill['extraCharges'][1];
      final pdf = pw.Document();

      // Add content to the PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return <pw.Widget>[
              // Title and Invoice Information
              pw.Header(
                level: 0,
                child: pw.Text('Bill/Invoice', textScaleFactor: 2),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: <pw.Widget>[
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text('Doc Number: ${bill['checkoutNo']}'),
                      pw.Text(
                          'Registration Date: ${bill['billedDate'].month} / ${bill['billedDate'].day} / ${bill['billedDate'].year}'),
                      // Add more invoice info as needed
                      // pw.Text('Due Date: ${bill['dueDate']}'),
                    ],
                  ),
                  // pw.Column(
                  //   crossAxisAlignment: pw.CrossAxisAlignment.end,
                  //   children: <pw.Widget>[
                  //     // pw.Text('Payment Method: ${paymentModeParserForRender(bill['paymentMode'])}'),
                  //     // Add more payment info as needed
                  //   ],
                  // ),
                ],
              ),
              // Shop and Customer Details
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text('Shop Details', textScaleFactor: 1.5),
              ),
              pw.Text('Shop Name: ${bill['storeName']}'),
              // Add more shop details as needed
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text('Customer Details', textScaleFactor: 1.5),
              ),

              pw.Text('Customer Name: ${bill['payee']['name']}'),
              pw.Text(bill['payee']['contact'] == ""
                  ? 'Customer Contact: NA'
                  : 'Customer Contact: ${bill['payee']['contact']}'),
              // Add more customer details as needed
              // Invoice Items
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text('Invoice Items', textScaleFactor: 1.5),
              ),

              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  ['Name', 'Quantity', 'Price', 'Total', 'Tax %', 'Discount'],
                  for (var item in bill['storeAddsItems'])
                    [
                      item['name'],
                      item['qty'].toString(),
                      item['price'].toString(),
                      ((item['qty'] * (item['price'] * (item['tax'] / 100)))
                              .round())
                          .toString(),
                      item['tax'].toString(),
                      item['discount'].toString()
                    ],
                ],
              ),

              // Add more styling and customization for the table as needed
              // Quick Add Items

              pw.SizedBox(height: 8),
              pw.Text('Total Store Bill: ${bill['storBillTotal']}',
                  textScaleFactor: 1),

              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text('Quick Add Items', textScaleFactor: 1.5),
              ),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  ['Name', 'Quantity', 'Price'],
                  for (var item in bill['quickAddsItems'])
                    [
                      item['name'],
                      item['qty'].toString(),
                      item['price'].toString()
                    ],
                ],
              ),

              pw.SizedBox(height: 8),
              pw.Text('Total Quick Adds Bill: ${bill['quickAddsTotal']}',
                  textScaleFactor: 1),

              // Add more styling and customization for the table as needed
              // Extra Charges and Discounts
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child:
                    pw.Text('Extra Charges & Discounts', textScaleFactor: 1.5),
              ),
              pw.Text('Extra Charges: ${bill['extraCharges'][0]}'),
              pw.Text('Discount: ${bill['extraCharges'][1]}'),

              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text('Grand Total:  $grandTotal /-',
                    textScaleFactor: 1.5),
              ),

              pw.SizedBox(height: 20),
              pw.Text('Made using OrderFlow'),
            ];
          },
        ),
      );

      // Get the document directory using path_provider package
      final directory = await getDownloadsDirectory();
      final filePath = '${directory!.path}/${bill['checkoutNo']}_bill.pdf';

      // Save the PDF to a file
      final file = File(filePath);
      pdfFile = file;
      await file.writeAsBytes(await pdf.save());
      // Open the PDF using the default PDF viewer
      if (await file.exists()) {
        PermissionStatus storageStatus = await Permission.storage.request();
        // PermissionStatus externalStorageStatus =
        //     await Permission.manageExternalStorage.request();
        if (storageStatus.isGranted) {
          Process.run('open', [file.path]);
        }
      }

      return file.path;
    } catch (error, stackTrace) {
      log("Error while processing Pdf", error: error, stackTrace: stackTrace);
    }
    return "";
  }

  // save the pdf file so that it can be used later on
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  // open the file from device after writing
  openFile(String file, BuildContext context) async {
    try {
      await OpenFile.open(file);
    } catch (error, stackTrace) {
      log("Error While Opening File ", error: error, stackTrace: stackTrace);
    }
  }
}
