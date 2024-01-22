import 'dart:ffi';
import 'dart:typed_data';

import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:path/path.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart';

Future<Uint8List> makePdf(List<Fis> gelen, Uint8List imagePath) async {
  final image = pw.MemoryImage(imagePath);
  final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
  final ttfFont = pw.Font.ttf(fontData);

  final boldfontData = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
  final boldttfFont = pw.Font.ttf(boldfontData);

  final pdf = pw.Document();
  String htmlText = Ctanim.kullanici!.PDFACIKLAMA!;
  List<Widget> widgets = await HTMLToPdf().convert(htmlText);

  List<Widget> glen = [];

  for (var m in gelen) {
    glen = [];
    int i = 0;
    while (i < m.fisStokListesi.length) {
      glen.add(pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          i == 0
              ? Padding(
                  padding: EdgeInsets.only(bottom: 1),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text("SATICI SİPARİŞ FORMU",
                          style: pw.TextStyle(
                              fontSize: 22,
                              fontWeight: pw.FontWeight.bold,
                              font: boldttfFont)),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 360,
                            child: pw.Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                pw.Image(image,
                                    width: 150, height: 100), //RESIM

                                SizedBox(
                                    height: 10,
                                    width: 350,
                                    child: Row(children: [
                                      Text(
                                        "Cari Ünvanı: ",
                                        style: pw.TextStyle(
                                            fontSize: 9,
                                            fontWeight: pw.FontWeight.bold,
                                            font: boldttfFont),
                                      ),
                                      Text(m.CARIADI.toString(),
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont)),
                                    ])),
                                SizedBox(
                                    height: 20,
                                    child: Row(children: [
                                      Text("Cari Adresi: ",
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont)),
                                      Text(m.cariKart.ADRES.toString(),
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont)),
                                    ])),
                                SizedBox(
                                    height: 10,
                                    child: Row(children: [
                                      Text("Cari Kodu: ",
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont)),
                                      Text(
                                          m.CARIKOD.toString() +
                                              " (" +
                                              m.ALTHESAP! +
                                              ")",
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont)),
                                    ])),

                                SizedBox(
                                    height: 15,
                                    width: 400,
                                    child: Row(children: [
                                      Text("Mail: ",
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont)),
                                      Text(m.cariKart.EMAIL.toString(),
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont))
                                    ])),
                                SizedBox(
                                    height: 15,
                                    width: 400,
                                    child: Row(children: [
                                      Text("Bayi: ",
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont)),
                                      Text(m.ACIKLAMA5.toString(),
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont))
                                    ])),
                              ],
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: pw.Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 350,
                                    child: Row(children: [
                                      Text(
                                        "Fiş Numarası: ",
                                        style: pw.TextStyle(
                                            fontSize: 9,
                                            fontWeight: pw.FontWeight.bold,
                                            font: boldttfFont),
                                      ),
                                      Text(m.BELGENO.toString(),
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont)),
                                    ])),
                                SizedBox(
                                    height: 10,
                                    width: 350,
                                    child: Row(children: [
                                      Text(
                                        "Fiş Tarihi: ",
                                        style: pw.TextStyle(
                                            fontSize: 9,
                                            fontWeight: pw.FontWeight.bold,
                                            font: boldttfFont),
                                      ),
                                      Text(m.TARIH.toString(),
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont)),
                                    ])),
                                SizedBox(
                                    height: 10,
                                    width: 350,
                                    child: Row(children: [
                                      Text(
                                        "Siparişi Veren: ",
                                        style: pw.TextStyle(
                                            fontSize: 9,
                                            fontWeight: pw.FontWeight.bold,
                                            font: boldttfFont),
                                      ),
                                      Text(Ctanim.kullanici!.KOD!.toString(),
                                          style: pw.TextStyle(
                                              fontSize: 9,
                                              fontWeight: pw.FontWeight.bold,
                                              font: boldttfFont)),
                                    ])),
                              ],
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                            ),
                          ),
                        ])
                  ]))
              : Container(),
          i == 0
              ? pw.Table.fromTextArray(
                  headers: [
                    'Sıra',
                    'Kod',
                    'Adı',
                    'Miktar',
                    Ctanim.kullanici!.MALFAZLASI == "E" ? 'M.Fazlası' : '',
                    'Fiyat',
                    'İsk',
                    'Toplam'
                  ],
                  data: buildTableRows(m, start: i, end: i + 1),
                  cellHeight: 4,
                  cellPadding: EdgeInsets.only(bottom: 2, left: 5, right: 5, top: 1),
                  cellStyle: TextStyle(
                    font: ttfFont,
                    fontSize: 5.5,
                  ),
                  oddCellStyle: TextStyle(
                    font: ttfFont,
                    fontSize: 5.5,
                  ),
                  headerStyle: TextStyle(
                    font: boldttfFont,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 5.5,
                  ),
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.centerLeft,
                    3: pw.Alignment.centerRight,
                    4: pw.Alignment.centerRight,
                    5: pw.Alignment.centerRight,
                    6: pw.Alignment.centerRight,
                    7: pw.Alignment.centerRight,
                  },
                  border: pw.TableBorder.all(color: PdfColors.black),
                  headerDecoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  columnWidths: {
                    0: pw.FractionColumnWidth(0.07),
                    1: pw.FractionColumnWidth(0.15),
                    2: pw.FractionColumnWidth(0.6),
                    3: pw.FractionColumnWidth(0.1),
                    4: Ctanim.kullanici!.MALFAZLASI == "E"
                        ? pw.FractionColumnWidth(0.15)
                        : pw.FractionColumnWidth(0),
                    5: pw.FractionColumnWidth(0.1),
                    6: pw.FractionColumnWidth(0.15),
                    7: pw.FractionColumnWidth(0.15),
                  },
                  headerHeight: 10)
              : pw.Table.fromTextArray(
                  data: buildTableRows(m, start: i, end: i + 1),
                  cellHeight: 4,
                  cellPadding: EdgeInsets.only(bottom: 2, left: 5, right: 5, top: 1),
                  cellStyle: TextStyle(
                    font: ttfFont,
                    fontSize: 5.5,
                  ),
                  oddCellStyle: TextStyle(
                    font: ttfFont,
                    fontSize: 5.5,
                  ),
                  headerStyle: TextStyle(
                    font: ttfFont,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 5.5,
                  ),
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.centerLeft,
                    2: pw.Alignment.centerLeft,
                    3: pw.Alignment.centerRight,
                    4: pw.Alignment.centerRight,
                    5: pw.Alignment.centerRight,
                    6: pw.Alignment.centerRight,
                    7: pw.Alignment.centerRight,
                  },
                  border: pw.TableBorder.all(color: PdfColors.black),
                  columnWidths: {
                    0: pw.FractionColumnWidth(0.07),
                    1: pw.FractionColumnWidth(0.15),
                    2: pw.FractionColumnWidth(0.6),
                    3: pw.FractionColumnWidth(0.1),
                    4: Ctanim.kullanici!.MALFAZLASI == "E"
                        ? pw.FractionColumnWidth(0.15)
                        : pw.FractionColumnWidth(0),
                    5: pw.FractionColumnWidth(0.1),
                    6: pw.FractionColumnWidth(0.15),
                    7: pw.FractionColumnWidth(0.15),
                  },
                ),
          i == m.fisStokListesi.length - 1
              ? Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: buildAdditionalInfo(m, boldttfFont, widgets))
              : Container(),
        ],
      ));
      i++;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: ttfFont)),
        footer: (pw.Context context) {
          if (context.pageNumber == context.pagesCount) {
            return Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 350,
                    child: ListView.builder(
                      itemCount: widgets.length,
                      itemBuilder: (context, index) {
                        return widgets[index];
                      },
                    ),
                  ),
                  pw.Container(
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'Sayfa ${context.pageNumber} / ${context.pagesCount}',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                  )
                ]);
          } else {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Sayfa ${context.pageNumber} / ${context.pagesCount}',
                style: pw.TextStyle(fontSize: 9),
              ),
            );
          }
        },
        build: (context) {
          return glen;
        },
      ),
    );
  }

  // Diğer sayfalarda sadece tablo

  return pdf.save();
}

List<List<String>> buildTableRows(Fis m, {int start = 0, int end = 0}) {
  List<List<String>> rows = [];

  for (var j = start; j < end; j++) {
    List<String> row = [
      "${j + 1}",
      "${m.fisStokListesi[j].STOKKOD}",
      "${m.fisStokListesi[j].STOKADI}",
      "${m.fisStokListesi[j].MIKTAR}",
      Ctanim.kullanici!.MALFAZLASI == "E"
          ? "${Ctanim.donusturMusteri(m.fisStokListesi[j].MALFAZLASI.toString())}"
          : "",
      "${Ctanim.donusturMusteri(m.fisStokListesi[j].BRUTFIYAT.toString())}",
      "${Ctanim.donusturMusteri(m.fisStokListesi[j].ISKONTOTOPLAM.toString())}",
      "${Ctanim.donusturMusteri(m.fisStokListesi[j].NETTOPLAM.toString())}",
    ];
    rows.add(row);
  }

  return rows;
}

List<List<String>> buildTableRowsUst(Fis m, {int start = 0, int end = 0}) {
  List<List<String>> rows = [];

  List<String> row = [
    "İşlem Tarihi",
    m.TARIH.toString(),
  ];
  rows.add(row);

  return rows;
}

pw.Widget buildAdditionalInfo(Fis m, pw.Font boldttfFont, List<Widget> w) {
  return Row(
    mainAxisAlignment: pw.MainAxisAlignment.end,
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      pw.Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 0),
              child: SizedBox(
                width: 330,
                child: m.ACIKLAMA1 == null || m.ACIKLAMA1 == ""
                    ? Text("",
                        style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            font: boldttfFont))
                    : Text("Sipariş Notu : " + m.ACIKLAMA1!.toString(),
                        style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            font: boldttfFont)),
              )),
          SizedBox(
            width: 100,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              pw.Text(
                "Toplam:",
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  font: boldttfFont,
                ),
              ),
              pw.Text(
                "Toplam İndirim:",
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  font: boldttfFont,
                ),
              ),
              pw.Text(
                "Ara Toplam:",
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  font: boldttfFont,
                ),
              ),
              pw.Text(
                "KDV Toplam:",
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  font: boldttfFont,
                ),
              ),
              pw.Text(
                "Genel Toplam:",
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  font: boldttfFont,
                ),
              ),
            ]),
          ),
          Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  Ctanim.donusturMusteri(m.TOPLAM!.toString()) + " " + m.DOVIZ!,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    font: boldttfFont,
                  ),
                ),
                pw.Text(
                  Ctanim.donusturMusteri(m.INDIRIM_TOPLAMI!.toString()) +
                      " " +
                      m.DOVIZ!,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    font: boldttfFont,
                  ),
                ),
                pw.Text(
                  Ctanim.donusturMusteri(m.ARA_TOPLAM!.toString()) +
                      " " +
                      m.DOVIZ!,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    font: boldttfFont,
                  ),
                ),
                pw.Text(
                  Ctanim.donusturMusteri(m.KDVTUTARI!.toString()) +
                      " " +
                      m.DOVIZ!,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    font: boldttfFont,
                  ),
                ),
                pw.Text(
                  Ctanim.donusturMusteri(m.GENELTOPLAM!.toString()) +
                      " " +
                      m.DOVIZ!,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    font: boldttfFont,
                  ),
                ),
              ])
        ],
      ),
    ],
  );
}
/*
  pw.Text(
            "Ürün Toplamı:\t${Ctanim.donusturMusteri(m.TOPLAM!.toString())}",
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              font: boldttfFont,
            ),
          ),
          pw.Text(
            "İndirim Toplamı:\t${Ctanim.donusturMusteri(m.INDIRIM_TOPLAMI!.toString())}",
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              font: boldttfFont,
            ),
          ),
          pw.Text(
            "Ara Toplam:\t${Ctanim.donusturMusteri(m.ARA_TOPLAM!.toString())}",
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              font: boldttfFont,
            ),
          ),
          pw.Text(
            "KDV Tutarı:\t${Ctanim.donusturMusteri(m.KDVTUTARI!.toString())}",
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              font: boldttfFont,
            ),
          ),
          pw.Text(
            "Genel Toplam:\t${Ctanim.donusturMusteri(m.GENELTOPLAM!.toString())}",
            style: pw.TextStyle(
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
              font: boldttfFont,
            ),
          ),
*/