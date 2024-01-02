import 'dart:ui';

import 'package:flutter/gestures.dart';
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
    required this.altHesap,

    this.isk1 = -1,
    this.isk2 = -1,
    this.isk3 = -1,
    this.isk4 = -1,
    this.isk5 = -1,
    this.isk6 = -1,


    this.malFazlasi = -1,
    this.fiyat = -1,
  });
  final StokKart gelenStokKart;
  final double gelenMiktar;
  final String altHesap;
  

  double isk1;
  double isk2;
  double isk3;
  double isk4;
  double isk5;
  double isk6;
  double malFazlasi;
  double fiyat;

  @override
  State<fisHareketDuzenle> createState() => _fisHareketDuzenleState();
}

class _fisHareketDuzenleState extends State<fisHareketDuzenle> {
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    miktarController.text = widget.gelenMiktar != -1
        ? widget.gelenMiktar.toStringAsFixed(2).toString()
        : widget.gelenStokKart.guncelDegerler!.carpan!.toString();
    fiyatController.text = widget.fiyat != -1
        ? widget.fiyat.toString()
        : widget.gelenStokKart.guncelDegerler!.fiyat!.toString();

    isk1Controller.text = widget.isk1 != -1
        ? widget.isk1.toString()
        : widget.gelenStokKart.guncelDegerler!.iskonto1!.toString();

            isk2Controller.text = widget.isk2 != -1
        ? widget.isk2.toString()
        : widget.gelenStokKart.guncelDegerler!.iskonto2!.toString();

            isk3Controller.text = widget.isk3 != -1
        ? widget.isk3.toString()
        : widget.gelenStokKart.guncelDegerler!.iskonto3!.toString();

            isk4Controller.text = widget.isk4 != -1
        ? widget.isk4.toString()
        : widget.gelenStokKart.guncelDegerler!.iskonto4!.toString();

            isk5Controller.text = widget.isk5 != -1
        ? widget.isk5.toString()
        : widget.gelenStokKart.guncelDegerler!.iskonto5!.toString();

        isk6Controller.text = widget.isk6 != -1
        ? widget.isk6.toString()
        : widget.gelenStokKart.guncelDegerler!.iskonto6!.toString();
   
    malFazlasiController.text = "0";
    print("Miktar ${miktarController.text}");
  }

  final TextEditingController miktarController =
      TextEditingController(text: "0");

  final TextEditingController isk1Controller = TextEditingController(text: "0");

  final TextEditingController isk2Controller = TextEditingController(text: "0");

  final TextEditingController isk3Controller = TextEditingController(text: "0");

    final TextEditingController isk4Controller = TextEditingController(text: "0");

  final TextEditingController isk5Controller = TextEditingController(text: "0");

  final TextEditingController isk6Controller = TextEditingController(text: "0");

  final TextEditingController malFazlasiController =
      TextEditingController(text: "0");

  final TextEditingController fiyatController =
      TextEditingController(text: "0");

  void sepeteEkle(StokKart stokKart, KurModel stokKartKur, double miktar,
      {double iskonto1 = 0,
      double iskonto2 = 0,
      double iskonto3 = 0,
      double iskonto4 = 0,
      double iskonto5 = 0,
      double iskonto6 = 0,
      int malFazlasi = 0,
      double fiyat = 0}) {
    int birimID = -1;

    for (var element in listeler.listOlcuBirim) {
      if (stokKart.OLCUBIRIM1 == element.ACIKLAMA) {
        birimID = element.ID!;
      }
    }
    double tempFiyat = 0;
 
    if (fiyat == 0) {
      tempFiyat = stokKart.guncelDegerler!.fiyat!;
    } else {
      tempFiyat = fiyat;
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
        malFazlasi: malFazlasi,

        ALTHESAP: widget.altHesap,
        urunListedenMiGeldin:
            false, // kullanıcı sepetten mi ekledi yoksa düzneleden mi
        stokAdi: stokKart.ADI!,
        KDVOrani: double.parse(stokKart.SATIS_KDV.toString()),
        birim: stokKart.OLCUBIRIM1!,
        birimID: birimID,
        dovizAdi: stokKartKur.ACIKLAMA!,
        dovizId: stokKartKur.ID!,
        burutFiyat: tempFiyat!,
        iskonto: iskonto1,
        iskonto2: iskonto2,
        iskonto3: iskonto3,
        iskonto4: iskonto4,
        iskonto5: iskonto5,
        iskonto6: iskonto6,
        miktar: (miktar).toInt(),
        stokKodu: stokKart.guncelDegerler!.guncelBarkod!,
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
  FocusScope.of(context).requestFocus(focusNode);
    return AlertDialog(
      title: SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          
          child: Row(
            children: [
              const Text("Stok Düzenleme"),
              Spacer(),
              IconButton(
                onPressed: () {
                 Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                iconSize: MediaQuery.of(context).size.width * .1,
                alignment: Alignment.center,
              )
            ],
          ),
        ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              
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
                                (double.parse(miktarController.text) -
                                        widget.gelenStokKart.guncelDegerler!
                                            .carpan!)
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
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.06,
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
                            focusNode: focusNode,
                            onTap: () => miktarController.selection = TextSelection(baseOffset: 0, extentOffset: miktarController.value.text.length),
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
                              (double.parse(miktarController.text) +
                                      widget.gelenStokKart.guncelDegerler!
                                          .carpan!)
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
                                    Ctanim.kullanici!.GISKDEGISTIRILSIN1 ==
                                            "E"
                                        ? true
                                        : false,
                                controller: isk1Controller,
                     onTap: () => isk1Controller.selection = TextSelection(baseOffset: 0, extentOffset: isk1Controller.value.text.length),

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
                                    Ctanim.kullanici!.GISKDEGISTIRILSIN1 ==
                                            "E"
                                        ? true
                                        : false,
                                controller: isk2Controller,
                     onTap: () => isk2Controller.selection = TextSelection(baseOffset: 0, extentOffset: isk2Controller.value.text.length),

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
                                    Ctanim.kullanici!.GISKDEGISTIRILSIN1 ==
                                            "E"
                                        ? true
                                        : false,
                                controller: isk3Controller,
                          onTap: () => isk3Controller.selection = TextSelection(baseOffset: 0, extentOffset: isk3Controller.value.text.length),

                                
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
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "İskonto 4",
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
                                    Ctanim.kullanici!.GISKDEGISTIRILSIN1 ==
                                            "E"
                                        ? true
                                        : false,
                                controller: isk4Controller,
                      onTap: () => isk4Controller.selection = TextSelection(baseOffset: 0, extentOffset: isk4Controller.value.text.length),

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
                        "İskonto 5",
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
                                    Ctanim.kullanici!.GISKDEGISTIRILSIN1 ==
                                            "E"
                                        ? true
                                        : false,
                                controller: isk5Controller,
                                 onTap: () => isk5Controller.selection = TextSelection(baseOffset: 0, extentOffset: isk5Controller.value.text.length),

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
                        "İskonto 6",
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
                                    Ctanim.kullanici!.GISKDEGISTIRILSIN1 ==
                                            "E"
                                        ? true
                                        : false,
                                controller: isk6Controller,
                                onTap: () => isk6Controller.selection = TextSelection(baseOffset: 0, extentOffset: isk6Controller.value.text.length),

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
                        controller: malFazlasiController,
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
                        controller: fiyatController,
                     onTap: () => fiyatController.selection = TextSelection(baseOffset: 0, extentOffset: fiyatController.value.text.length),

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
                  KurModel gidecekKur = listeler.listKur.first;
                  if (Ctanim.kullanici!.LISTEFIYAT! == "E") {
                    for (var element in listeler.listKur) {
                      if (widget.gelenStokKart.LISTEDOVIZ ==
                          element.ACIKLAMA) {
                        gidecekKur = element;
                      }
                    }
                  } else {
                    for (var element in listeler.listKur) {
                      if (widget.gelenStokKart.SATDOVIZ == element.ACIKLAMA) {
                        gidecekKur = element;
                      }
                    }
                  }
          
                  double miktar = double.parse(miktarController.text);
                  print("turan" + miktar.toString());
                  sepeteEkle(widget.gelenStokKart, gidecekKur, miktar,
                      iskonto1: double.parse(isk1Controller.text == ""
                              ? "0"
                              : isk1Controller.text) ??
                          0,
                      iskonto2: double.parse(isk2Controller.text == ""
                              ? "0"
                              : isk2Controller.text) ??
                          0,
                      iskonto3: double.parse(isk3Controller.text) ?? 0,
                      iskonto4: double.parse(isk4Controller.text) ?? 0,
                      iskonto5: double.parse(isk5Controller.text) ?? 0,
                      iskonto6: double.parse(isk6Controller.text) ?? 0,
                      malFazlasi:
                          int.parse(malFazlasiController.text) ?? 0,
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
      ),
    );
  }
}