import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:foodbankmanagementsystem/helper/auth_service.dart';
import 'package:foodbankmanagementsystem/helper/pdf_api.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<File> generateReceipt({
  required String itemName,
  required String deliveryOption,
  required String address,
  required String contactInfo,
  required DateTime requestedDate,
  required String additionalNotes,
}) async {
  final pdf = pw.Document();

  final Uint8List data = await yourBackgroundImageFunction();
  final pw.MemoryImage logoImage = pw.MemoryImage(data);
  pw.Widget _buildHeader() {
    return pw.Container(
      child: pw.Column(
        children: [
          pw.Row(
            children: [
              pw.Image(logoImage, width: 50),
              pw.SizedBox(width: 20),
              pw.Text(
                'Receipt for Donation',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              pw.Expanded(child: pw.SizedBox()),
              pw.Text(
                'To : ${AuthService.to.user?.name}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 20),
        ],
      ),
    );
  }

  const double pageWidth = 700;
  const double pageHeight = 300;
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(pageWidth, pageHeight),
      build: (pw.Context context) {
        return pw.Padding(
          padding: pw.EdgeInsets.all(50),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              pw.Text('Requested Date: ${requestedDate.toString()}'),
              pw.SizedBox(height: 10),
              pw.Text('Item Name: $itemName'),
              pw.SizedBox(height: 10),
              pw.Text('Delivery Option: $deliveryOption'),
              address.length > 0 ? pw.SizedBox(height: 10) : pw.SizedBox(),
              address.length > 0 ? pw.Text('Address: $address') : pw.SizedBox(),
              pw.SizedBox(height: 10),
              pw.Text('Contact Info: $contactInfo'),
              pw.SizedBox(height: 10),
              pw.Text('Additional Notes: $additionalNotes'),
            ],
          ),
        );
      },
    ),
  );
  return PdfApi.saveDocument(
      "Receipt${DateFormat('dd-MMM-yyyy-jms').format(DateTime.now())}.pdf",
      pdf);
}

Future<Uint8List> yourBackgroundImageFunction() async {
  ByteData byteData = await rootBundle.load('assets/logo.png');
  return byteData.buffer.asUint8List();
}
