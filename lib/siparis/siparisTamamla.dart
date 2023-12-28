import 'dart:math';

import 'package:flutter/material.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/pages/CustomAlertDialog.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/siparis/PdfOnizleme.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';

class SiparisTamamla extends StatefulWidget {
  const SiparisTamamla({super.key, required this.fiss});
  final Fis fiss;

  @override
  State<SiparisTamamla> createState() => _SiparisTamamlaState();
}

class _SiparisTamamlaState extends State<SiparisTamamla> {
  Color getRandomColor() {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.amber,
      Colors.green,
      Colors.purple,
      Colors.grey,
    ];

    return colors[Random().nextInt(colors.length)];
  }

  List<Color> generateRandomColors(int itemCount) {
    List<Color> randomColors = [];

    // Her bir eleman için random renk ekleme
    for (int i = 0; i < itemCount; i++) {
      Color randomColor = getRandomColor();
      if (!randomColors.contains(randomColor)) {
        randomColors.add(randomColor);
      } else {
        while (randomColors.contains(randomColor)) {
          randomColor = getRandomColor();
        }
        randomColors.add(randomColor);
      }
    }
    return randomColors;
  }

  Widget altHesapWidgetOlustur(
      String altHesapAdi, double altHesapTutari, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              altHesapAdi,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
            Text(
              Ctanim.donusturMusteri(altHesapTutari.toString()),
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: 3,
                    color: color,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.08,
                    height: 3,
                    color: Colors.grey,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> altHesaplar = [];

  @override
  Widget build(BuildContext context) {
    altHesaplar.clear();

         List<Color> colors = generateRandomColors(widget.fiss.altHesapToplamlar.length);
    for (int i = 0 ; i < widget.fiss.altHesapToplamlar.length; i++) {
      altHesaplar.add(altHesapWidgetOlustur(
          widget.fiss.altHesapToplamlar[i].ALTHESAPADI!,  widget.fiss.altHesapToplamlar[i].TOPLAM!, colors[i]));
    }


    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
        bottomNavigationBar: bottombarDizayn(context,
            button: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    fisEx.fis!.value = Fis.empty();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            secondButtonText: "Tamam",
                            onSecondPress: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            pdfSimgesi: true,
                            align: TextAlign.center,
                            title: 'Kayıt Başarılı',
                            message:
                                'Fatura Kaydedildi. PDF Dosyasını Görüntülemek İster misiniz?',
                            onPres: () async {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => PdfOnizleme(
                                          m: widget.fiss,
                                          fastReporttanMiGelsin: false,
                                        )),
                              );
                            },
                            buttonText: 'Pdf\'i\ Gör',
                          );
                        });
                  },
                  child: Text(
                    "Siparişi Yazdır",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  )),
            ),
            buttonVarMi: true),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.78,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return altHesaplar[index];
                      },
                      itemCount: altHesaplar.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.fiss.cariKart.ADI!,
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text("Satış Toplamı"),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                                child: Text(
                              Ctanim.donusturMusteri(
                                widget.fiss.ARA_TOPLAM.toString(),
                              ),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text("İskonto Toplamı"),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text(
                                        Ctanim.donusturMusteri(
                                          widget.fiss.INDIRIM_TOPLAMI
                                              .toString(),
                                        ),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("KDV Toplamı"),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text(
                                        Ctanim.donusturMusteri(
                                          widget.fiss.KDVTUTARI.toString(),
                                        ),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text("Sipariş Toplamı"),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                                child: Text(
                              Ctanim.donusturMusteri(
                                widget.fiss.GENELTOPLAM.toString(),
                              ),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ! sipariş açıklaması
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.17,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: TextFormField(
                        maxLines: 8,
                        decoration: InputDecoration(
                          /* contentPadding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * 0.05,
                            ),*/

                          hintText: 'Sipariş Açıklaması',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: TextFormField(
                        maxLines: 8,
                        decoration: InputDecoration(
                          /* contentPadding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * 0.05,
                            ),*/

                          hintText: 'Bayi Seçimi',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
