import 'dart:html' as html;
import 'dart:io';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument(String name, Document pdf) async {
    final bytes = await pdf.save();
    // final dir = await getApplicationDocumentsDirectory();
    //  print(DateFormat('dd-MMM-yyyy-jms').format(DateTime.now()));
    //  print(dir.path);
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, "_blank");
    html.Url.revokeObjectUrl(url);
    final url2 = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url2
      ..style.display = 'none'
      ..download = name;
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url2);

    final file = File(name);

    // file.writeAsBytes(bytes);

    // AnchorElement anchorElement = new AnchorElement(href: name);
    //  anchorElement.download = name;
    // anchorElement.click();
    return file;
  }
}
