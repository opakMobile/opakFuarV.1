import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/model/KurModel.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';
import 'package:opak_fuar/sabitler/listeler.dart';

class fisHareketDuzenle extends StatefulWidget {
  fisHareketDuzenle({
    super.key,
    required this.gelenStokKart,
    required this.gelenMiktar,
  });
  final StokKart gelenStokKart;
  final double gelenMiktar;

  @override
  State<fisHareketDuzenle> createState() => _fisHareketDuzenleState();
}

class _fisHareketDuzenleState extends State<fisHareketDuzenle> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    miktarController.text = widget.gelenMiktar.toString();
    fiyatController.text = widget.gelenStokKart.SFIYAT1.toString();
    isk1Controller.text = widget.gelenStokKart.SATISISK.toString();
    isk2Controller.text = "0";
    isk3Controller.text = "0";
    malFazlasiController.text = "0";
    print("Miktar ${miktarController.text}");
  }

  final TextEditingController miktarController =
      TextEditingController(text: "1");

  final TextEditingController isk1Controller = TextEditingController(text: "0");

  final TextEditingController isk2Controller = TextEditingController(text: "0");

  final TextEditingController isk3Controller = TextEditingController(text: "0");

  final TextEditingController malFazlasiController =
      TextEditingController(text: "0");

  final TextEditingController fiyatController =
      TextEditingController(text: "0");

  void sepeteEkle(StokKart stokKart, KurModel stokKartKur, double miktar,
      {double iskonto1 = 0,
      double iskonto2 = 0,
      double iskonto3 = 0,
      double malFazlasi = 0,
      double fiyat = 0}) {
    int birimID = -1;

    for (var element in listeler.listOlcuBirim) {
      if (stokKart.OLCUBIRIM1 == element.ACIKLAMA) {
        birimID = element.ID!;
      }
    }
    double tempFiyat = 0;
    double tempIskonto1 = 0;
    if (fiyat != 0) {
      tempFiyat = fiyat;
    } else {
      tempFiyat = stokKart.SFIYAT1!;
    }
    if (iskonto1 != 0) {
      tempIskonto1 = iskonto1;
    } else {
      tempIskonto1 = stokKart.SATISISK!;
    }

    listeler.listKur.forEach((element) {
      if (element.ANABIRIM == "E") {
        if (stokKartKur.ACIKLAMA != element.ACIKLAMA) {
          tempFiyat = tempFiyat * stokKartKur.KUR!;
        }
      }
    });

    double KDVTUtarTemp =
        stokKart.guncelDegerler!.fiyat! * (1 + (stokKart.SATIS_KDV!));
    {
      fisEx.fiseStokEkle(
        // belgeTipi: widget.belgeTipi,
        urunListedenMiGeldin: false,
        stokAdi: stokKart.ADI!,
        KDVOrani: double.parse(stokKart.SATIS_KDV.toString()),
        birim: stokKart.OLCUBIRIM1!,
        birimID: birimID,
        dovizAdi: stokKartKur.ACIKLAMA!,
        dovizId: stokKartKur.ID!,
        burutFiyat: tempFiyat!,
        iskonto: tempIskonto1,
        iskonto2: 0.0,
        miktar: (miktar).toInt(),
        stokKodu: stokKart.KOD!,
        Aciklama1: '',
        KUR: stokKartKur.KUR!,
        TARIH: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        UUID: fisEx.fis!.value.UUID!,
      );
      setState(() {
        Ctanim.genelToplamHesapla(fisEx);
      });

      // miktar = stokKart.guncelDegerler!.carpan!;
    }
  }

  void showSnackBar(BuildContext context, double miktar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Stok eklendi " + miktar.toString() + " adet ürün sepete eklendi ! ",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        duration: Duration(milliseconds: 700),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Material(
                  child: Row(
                    children: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.close,color: Colors.red,)),
                    
                    ],
                  ),
                ),
                Text(
                  "Miktar",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: IconButton(
                          onPressed: () {
                            if (double.parse(miktarController.text) > 0) {
                              miktarController.text =
                                  (double.parse(miktarController.text) - 1)
                                      .toString();
                            }
                          },
                          icon: Icon(
                            Icons.remove_circle,
                            size: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.red,
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextFormField(
                              controller: miktarController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "1",
                                hintStyle:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            )),
                      ),
                    ),
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: IconButton(
                          onPressed: () {
                            miktarController.text =
                                (double.parse(miktarController.text) + 1)
                                    .toString();
                          },
                          icon: Icon(
                            Icons.add_circle,
                            size: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.green,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  thickness: 1,
                  color: Colors.black45,
                ),
                // !
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  "İskonto",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "İskonto 1",
                          style: TextStyle(fontSize: 14),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  enabled:
                                      Ctanim.kullanici!.GISKDEGISTIRILSIN1 == "E"
                                          ? true
                                          : false,
                                  controller: isk1Controller,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "1",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "İskonto 2",
                          style: TextStyle(fontSize: 14),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  enabled:
                                      Ctanim.kullanici!.GISKDEGISTIRILSIN1 == "E"
                                          ? true
                                          : false,
                                  controller: isk2Controller,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "1",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "İskonto 3",
                          style: TextStyle(fontSize: 14),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextFormField(
                                  enabled:
                                      Ctanim.kullanici!.GISKDEGISTIRILSIN1 == "E"
                                          ? true
                                          : false,
                                  controller: isk3Controller,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "1",
                                    hintStyle: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  thickness: 1,
                  color: Colors.black45,
                ),
                // !
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  "Mal Fazlası",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "1",
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  thickness: 1,
                  color: Colors.black87,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  "Fiyat",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          enabled: Ctanim.kullanici!.FIYATDEGISTIRILSIN == "E"
                              ? true
                              : false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "1",
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  thickness: 1,
                  color: Colors.black45,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(
                        MediaQuery.of(context).size.width * 0.3,
                        MediaQuery.of(context).size.height * 0.05)),
                  ),
                  onPressed: () {
                    KurModel kur =
                        KurModel(ID: 1, ACIKLAMA: "USD", KUR: 30, ANABIRIM: "H");
                    double miktar = double.parse(miktarController.text);
                    print("turan" + miktar.toString());
                    sepeteEkle(widget.gelenStokKart, kur, miktar,
                        iskonto1: double.parse(isk1Controller.text) ?? 0,
                        iskonto2: double.parse(isk2Controller.text) ?? 0,
                        iskonto3: double.parse(isk3Controller.text) ?? 0,
                        malFazlasi: double.parse(malFazlasiController.text) ?? 0,
                        fiyat: double.parse(fiyatController.text));
    
                    Navigator.pop(context);
                    showSnackBar(context, miktar);
                  },
                  child: Text("Uygula"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
