import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/model/cariModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/pages/CustomAlertDialog.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/siparis/PdfOnizleme.dart';
import 'package:opak_fuar/siparis/bayiSec.dart';
import 'package:opak_fuar/siparis/siparisCariList.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';

class SiparisTamamla extends StatefulWidget {
  const SiparisTamamla({
    super.key,
  });

  @override
  State<SiparisTamamla> createState() => _SiparisTamamlaState();
}

class _SiparisTamamlaState extends State<SiparisTamamla> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(fisEx.fis!.value.ISK1 != 0.0){
      genelIskonto1Controller.text = (fisEx.fis!.value.ISK1!.toInt()).toString();
    }
    aciklamaController.text = fisEx.fis!.value.ACIKLAMA1!;
  }
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
        //height: MediaQuery.of(context).size.height * 0.009,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              altHesapAdi,
              style: TextStyle(
                fontSize: 11,
                color: color,
              ),
            ),
            Text(
              Ctanim.donusturMusteri(altHesapTutari.toString()),
              style: TextStyle(
                fontSize: 11,
                color: color,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
                    height: 3,
                    color: color,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.05,
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
  TextEditingController aciklamaController = TextEditingController();
  TextEditingController genelIskonto1Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    altHesaplar.clear();

    List<Color> colors =
        generateRandomColors(fisEx.fis!.value.altHesapToplamlar.length);
    for (int i = 0; i < fisEx.fis!.value.altHesapToplamlar.length; i++) {
      altHesaplar.add(altHesapWidgetOlustur(
          fisEx.fis!.value.altHesapToplamlar[i].ALTHESAPADI!,
          fisEx.fis!.value.altHesapToplamlar[i].TOPLAM!,
          colors[i]));
    }

    return SafeArea(
      child: Scaffold(
     
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
                  onPressed: () async {
                    if (fisEx.fis!.value.fisStokListesi.length > 0) {
                      fisEx.fis!.value.DURUM = true;
                      final now = DateTime.now();
                      final formatter = DateFormat('HH:mm');
                      String saat = formatter.format(now);
                      fisEx.fis!.value.SAAT = saat;

                      showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              secondButtonText: "Tamam",
                              onSecondPress: () async {
                                 await Fis.empty().fisEkle(
                                    fis: fisEx.fis!.value, belgeTipi: "YOK");
                                fisEx.fis!.value = Fis.empty();

                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              pdfSimgesi: true,
                              align: TextAlign.center,
                              title: 'Kayıt Başarılı',
                              message:
                                  'Fatura Kaydedildi. PDF Dosyasını Görüntülemek İster misiniz?',
                              onPres: () async {
                                String hataTopla = "";
                                List<Fis> pdfeGidecek =  parcalaFis(fisEx.fis!.value);

                                await Fis.empty().fisEkle(
                                    fis: fisEx.fis!.value, belgeTipi: "YOK");
                                fisEx.fis!.value = Fis.empty();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                // ha bura

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => PdfOnizleme(
                                          m: pdfeGidecek,
                                          fastReporttanMiGelsin: false,
                                        )),
                              );
                              
                              },
                              buttonText: 'Pdf\'i\ Gör',
                            );
                          });
                    } else {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              align: TextAlign.left,
                              title: 'Stok Eklemediniz',
                              message: 'Fişe stok eklemeden fiş kaydedilemez.',
                              onPres: () async {
                                Navigator.pop(context);
                              },
                              buttonText: 'Tamam',
                            );
                          });
                    }
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
            height: MediaQuery.of(context).size.height ,
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
                      fisEx.fis!.value.cariKart.ADI!,
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
                                fisEx.fis!.value.TOPLAM.toString(),
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
                                          fisEx.fis!.value.INDIRIM_TOPLAMI
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
                                          fisEx.fis!.value.KDVTUTARI.toString(),
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
                                fisEx.fis!.value.GENELTOPLAM.toString(),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                Ctanim.kullanici!.GISKDEGISTIRILSIN1 == "E" ?  SizedBox(
                   
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                        controller: genelIskonto1Controller,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                              if (value == "") {
                                fisEx.fis!.value.ISK1 = 0.0;
                                Ctanim.genelToplamHesapla(fisEx);
                          
                              }else{
                                 fisEx.fis!.value.ISK1 =
                                  Ctanim.noktadanSonraAlinacak(double.tryParse(
                                      genelIskonto1Controller.text)??0.0);
                              Ctanim.genelToplamHesapla(fisEx);
                              

                              }
                             
                            });
                         
                        },
                        maxLines:1,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                                FilteringTextInputFormatter.digitsOnly
                          ],
                        decoration: InputDecoration(
                          /* contentPadding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * 0.05,
                            ),*/

                          hintText: 'Genel İskonto (ör:50)',
                        
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ):Container(),
               
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
                        controller: aciklamaController,
                        onChanged: (value) {
                          fisEx.fis!.value.ACIKLAMA1 = value;
                        },
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
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .8,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            List<Cari> bayiler = [];
                            for (var element in listeler.listCari) {
                              if (element.TIPI == "Bayi") {
                                bayiler.add(element);
                              }
                            }
                            final value = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BayiSec(
                                        bayiList: bayiler,
                                      )),
                            );
                            setState(() {});
                            /*
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BayiSec(
                                          bayiList: bayiler,
                                        )));*/
                          },
                          child: Text(fisEx.fis!.value.ACIKLAMA4 != "" &&
                                  fisEx.fis!.value.ACIKLAMA5 != ""
                              ? "Bayi : " +
                                  fisEx.fis!.value!.ACIKLAMA4! +
                                  " - " +
                                  fisEx.fis!.value!.ACIKLAMA5!
                              : "Bayi Seç",),
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

  List<Fis> parcalaFis(Fis fisParam){
    List<Fis> parcaliFisler = [];
    if (fisParam.fisStokListesi.length > 0) {
      List<String> althesaplar = [];
      for (int i = 0;
          i < fisParam.fisStokListesi.length;
          i++) {
        if (!althesaplar
            .contains(fisParam.fisStokListesi[i].ALTHESAP)) {
          althesaplar
              .add(fisParam.fisStokListesi[i].ALTHESAP!);
        }
      }
      for (var element in althesaplar) {
        
        Fis fis = Fis.empty();
        fis = Fis.fromFis(fisParam, []);
        fis.USTUUID = fis.UUID;
        //   fis.UUID = neu;
        fis.SIPARISSAYISI = althesaplar.length;
        fis.KALEMSAYISI = 0;
        fis.ALTHESAP = element;


        for (int k = 0;
            k < fisParam.fisStokListesi.length;
            k++) {
          if (fisParam.fisStokListesi[k].ALTHESAP == element) {
            //fis.fisStokListesi[k].UUID = fis.UUID;

            fis.fisStokListesi.add(fisParam.fisStokListesi[k]);
            fis.KALEMSAYISI = fis.KALEMSAYISI! + 1;
          }
        }

        parcaliFisler.add(fis);
      } 
      
    } 

    return parcaliFisler;
  }
}
