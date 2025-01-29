import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';



class IBDetails {
  final String invoiceNumber;
  final String customerName;
  final String customerEmail;
  final DateTime date;
  final List<InvoiceItem> items;
  final double totalAmount;

  IBDetails({
    required this.invoiceNumber,
    required this.customerName,
    required this.customerEmail,
    required this.date,
    required this.items,
    required this.totalAmount,
  });
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}


class PdfInvoiceGenerator {
  Future<Uint8List> generateInvoice(IBDetails details) async {
    final pdf = pw.Document();

    final logo = await networkImage(
      'https://yourcompany.com/logo.png', // Replace with your logo URL
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Logo and Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    height: 50,
                    width: 50,
                    child: pw.Image(logo),
                  ),
                  pw.Text(
                    "Invoice #${details.invoiceNumber}",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Customer Info
              pw.Text("Bill To:",
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text(details.customerName),
              pw.Text(details.customerEmail),
              pw.SizedBox(height: 20),

              // Invoice Table
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(),
                headers: ['Description', 'Quantity', 'Unit Price', 'Total'],
                data: details.items.map((item) {
                  return [
                    item.description,
                    item.quantity.toString(),
                    "\$${item.unitPrice.toStringAsFixed(2)}",
                    "\$${item.total.toStringAsFixed(2)}",
                  ];
                }).toList(),
              ),

              pw.SizedBox(height: 20),

              // Total Amount
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text("Total: ",
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Text("\$${details.totalAmount.toStringAsFixed(2)}",
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// **Method to Print or Download the PDF**
  Future<void> printOrDownloadInvoice(BuildContext context, IBDetails details) async {
    final pdfData = await generateInvoice(details);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }
}
