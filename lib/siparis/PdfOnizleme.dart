
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:opak_fuar/db/veriTabaniIslemleri.dart';
import 'package:opak_fuar/model/ShataModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/siparis/makePdf.dart';
import 'package:opak_fuar/webServis/base.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:printing/printing.dart';


class PdfOnizleme extends StatefulWidget {
  final List<Fis> m;
  final bool fastReporttanMiGelsin;
  const PdfOnizleme(
      {Key? key, required this.m, required this.fastReporttanMiGelsin})
      : super(key: key);

  @override
  State<PdfOnizleme> createState() => _PdfOnizlemeState();
}

class _PdfOnizlemeState extends State<PdfOnizleme> {
  Uint8List? _imageData;
  String link = "";
  
  String cleanPhoneNumber(String phoneNumber) {
  phoneNumber = phoneNumber.replaceAll(' ', '').replaceAll('-', '');
  phoneNumber = phoneNumber.replaceAll('+', '');
  
  if (phoneNumber.length < 10) {
    return '+90' + phoneNumber;
  }
  else if (phoneNumber.startsWith('+90') && phoneNumber.length == 12) {
    return phoneNumber;
  }
 else  if (phoneNumber.startsWith('0')) {
    phoneNumber = "+9" + phoneNumber;
    return phoneNumber;
  }
else   if (phoneNumber.length == 10) {
    return '+90' + phoneNumber;
  }
  return phoneNumber;
}
  sendPDFViaWhatsApp(Uint8List doc) async { 
     String phoneNumber = cleanPhoneNumber(widget.m[0].cariKart.TELEFON!);
     print(phoneNumber);

      String whatsappURL =
          "https://wa.me/$phoneNumber?text=Siparişin PDF Dosyası Linktedir \n: ${link}";

      // URL'yi başlatma
      if (await canLaunch(whatsappURL)) {
        await launch(whatsappURL);
      } else {
        throw 'WhatsApp başlatılamadı: $whatsappURL';
      }
    
  }

  Future<void> _loadImage() async {
    String? imagePath = await VeriIslemleri().getFirstImage();
    if (imagePath != "") {
      final File imageFile = File(imagePath!);
      final Uint8List imageData = await imageFile.readAsBytes();
      setState(() {
        _imageData = imageData;
      });
    } else {
      final ByteData assetData = await rootBundle.load('assets/beyaz.jpg');
      _imageData = assetData.buffer.asUint8List();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<Uint8List> pdfGetirFastReport() async {
    BaseService bs = BaseService();
    List<Map<String, dynamic>> listeFisler = [];
    for (var element in widget.m) {
      listeFisler.add(element.toJson2());
    }
    SHataModel gelenHata = await bs.ekleSiparisFuar(
        sirket: Ctanim.sirket!,
        jsonDataList: listeFisler,
        UstUuid: listeFisler[0]["USTUUID"],
        pdfMi: "E");

    if (gelenHata.Hata == "false") {
      var donecek;
      // https://apkwebservis.nativeb4b.com/DIZAYNLAR/099e42b0-83b5-11ee-82a7-23141fef2870.pdf
      String url = Ctanim.IP.replaceAll("/MobilService.asmx", "") +
          "/DIZAYNLAR/" +
          widget.m[0].USTUUID! +
          ".pdf";
      print(url);
      Uri uri = Uri.parse(url);
      http.Response response = await http.get(uri);
      var pdfData = response.bodyBytes;
      donecek = pdfData;
      if (response.statusCode != 200) {
        await _loadImage(); 
        return makePdf(widget.m, _imageData!);
      }
      link = url;
      return donecek;
    } else {
      print(gelenHata.HataMesaj);
      await _loadImage(); // olmazsa then koy
      // if (widget.fastReporttanMiGelsin == false) {
      return makePdf(widget.m, _imageData!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? pdfData;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 80, 79, 79),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Önizleme'),
          backgroundColor: const Color.fromARGB(255, 80, 79, 79),
        ),
        backgroundColor: const Color.fromARGB(255, 80, 79, 79),
        floatingActionButton: 
        widget.fastReporttanMiGelsin == true ?
        FloatingActionButton(
          onPressed: () async {
           sendPDFViaWhatsApp(pdfData!);
          },
          child: Icon(Icons.send),
        ):Container(),
        body: PdfPreview(
          build: (context) async {
            if (widget.fastReporttanMiGelsin == false) {
              await _loadImage();
              pdfData = await makePdf(widget.m, _imageData!);
              return pdfData!;
            } else {
              pdfData = await pdfGetirFastReport();
              return pdfData!;
            }
          },
        ),
      ),
    );
  }
}
