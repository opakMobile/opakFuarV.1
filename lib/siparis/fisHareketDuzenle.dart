import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/model/KurModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/pages/CustomAlertDialog.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/siparis/okumaModuTasarim.dart';
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
    this.fisHareketMiktar = 0,
    this.malFazlasi = -1,
    this.fiyat = -1,
    required this.okutulanCarpan,
    required this.urunDuzenlemeyeGeldim,
  });
  final StokKart gelenStokKart;
  final double gelenMiktar;
  final String altHesap;
  final int okutulanCarpan;
  final bool urunDuzenlemeyeGeldim;

  double isk1;
  double isk2;
  double isk3;
  double isk4;
  double isk5;
  double isk6;
  double malFazlasi;
  double fiyat;
  int fisHareketMiktar;

  @override
  State<fisHareketDuzenle> createState() => _fisHareketDuzenleState();
}

class _fisHareketDuzenleState extends State<fisHareketDuzenle> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int gelenMiktarInt = widget.gelenMiktar.toInt();
    miktarController.text = gelenMiktarInt != -1
        ? gelenMiktarInt.toString()
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

    malFazlasiController.text = widget.malFazlasi != -1
        ? widget.malFazlasi.toString()
        :
    
    widget.gelenStokKart.SACIKLAMA10!.toString();
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
        urunListedenMiGeldin: widget
            .urunDuzenlemeyeGeldim, // kullanıcı sepetten mi ekledi yoksa düzneleden mi
        stokAdi: stokKart.ADI!,
        KDVOrani: double.parse(stokKart.SATIS_KDV.toString()),
        birim: stokKart.OLCUBIRIM1!,
        birimID: 1,
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

  void showSnackBar(BuildContext context, {double miktar = 0}) {
    ScaffoldMessenger.of(context).showSnackBar(
      miktar >= 1
          ? SnackBar(
              content: Text(
                "Stok eklendi " +
                    miktar.toString() +
                    " adet ürün sepete eklendi ! ",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              duration: Duration(milliseconds: 700),
              backgroundColor: Colors.blue,
            )
          : SnackBar(
              content: Text(
                "Stok sepetten kaldırıldı.",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              duration: Duration(milliseconds: 700),
              backgroundColor: Colors.blue,
            ),
    );
  }

  int i = 0;
  bool detay = false;
  @override
  Widget build(BuildContext context) {
    if (i == 0 && Ctanim.urunAraFocus == false) {

      /*
      FocusScope.of(context).requestFocus(focusNode1);
      */
      miktarController.selection = TextSelection(
          baseOffset: 0, extentOffset: miktarController.value.text.length);

      i++;
    }
    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      title: SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Text(
                      widget.gelenStokKart.ADI! +
                          " - %" +
                          widget.gelenStokKart.SATIS_KDV!.toStringAsFixed(0) +
                          " KDV",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15),
                    )),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Ctanim.urunAraFocus = true;
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
SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        widget.gelenStokKart.OLCUBIRIM2 != ""
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(
                                        widget.gelenStokKart.OLCUBIRIM2! + " :",
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 11,
                                            color: Colors.orange),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.09,
                                      child: Text(
                                        widget.gelenStokKart
                                            .BIRIMADET1!, // widget.gelenStokKart.BRUTTOPLAMFIYAT!.toStringAsFixed(2),//
                                        style: TextStyle(
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        widget.gelenStokKart.OLCUBIRIM3 != ""
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Text(
                                          widget.gelenStokKart.OLCUBIRIM3! +
                                              " :",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 11,
                                              color: Colors.orange),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.09,
                                        child: Text(
                          overflow: TextOverflow.ellipsis,
                                          widget.gelenStokKart
                                              .BIRIMADET2!, // widget.gelenStokKart.BRUTTOPLAMFIYAT!.toStringAsFixed(2),//
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Row(
                      children: [
                        widget.gelenStokKart.OLCUBIRIM4 != ""
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(
                                        widget.gelenStokKart.OLCUBIRIM4! + " :",
                                        style: TextStyle(

                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 11,
                                            color: Colors.orange),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.09,
                                      child: Text(
                                                overflow: TextOverflow.ellipsis,
                                        widget.gelenStokKart
                                            .BIRIMADET3!, // widget.gelenStokKart.BRUTTOPLAMFIYAT!.toStringAsFixed(2),//
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        widget.gelenStokKart.OLCUBIRIM5 != ""
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(
                                        widget.gelenStokKart.OLCUBIRIM5! + " :",
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 11,
                                            color: Colors.orange),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.09,
                                      child: Text(
                                                overflow: TextOverflow.ellipsis,
                                        widget.gelenStokKart
                                            .BIRIMADET4!, // widget.gelenStokKart.BRUTTOPLAMFIYAT!.toStringAsFixed(2),//
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Row(
                      children: [
                        widget.gelenStokKart.OLCUBIRIM6 != ""
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Text(
                                        widget.gelenStokKart.OLCUBIRIM6! + " :",
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 11,
                                            color: Colors.orange),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.09,
                                      child: Text(
                               overflow: TextOverflow.ellipsis,
                                        widget.gelenStokKart
                                        
                                            .BIRIMADET5!, // stokModel.BRUTTOPLAMFIYAT!.toStringAsFixed(2),//
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    )
                  ],
                ),
              ),
            ), Row(
              children: [
                Text(
                  "Bakiye: ",
                  style: TextStyle(fontSize: 14, color: Colors.orange),
                ),
                Text(
                  widget.gelenStokKart.BAKIYE!.toStringAsFixed(0),
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
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
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(
                      MediaQuery.of(context).size.width * 0.6,
                      MediaQuery.of(context).size.height * 0.05)),
                ),
                onPressed: () {
                  fisHareketUygula(context);
                },
                child: Text("Uygula"),
              ),

              Text(
                "Miktar",
                style: TextStyle(fontSize: 22),
              ),
              widget.urunDuzenlemeyeGeldim == true
                  ? Text(
                      "Sepetteki miktar: ${widget.fisHareketMiktar > 0 ? widget.fisHareketMiktar : widget.gelenMiktar.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 11),
                    )
                  : Container(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: IconButton(
                        onPressed: () {
                        String tempSaciklama9 =
                              widget.gelenStokKart.SACIKLAMA9!.split(".")[0];
                     if(tempSaciklama9 == "0"){
                            tempSaciklama9 = "1";
                          }
                          String tempMiktar =
                              widget.gelenStokKart.guncelDegerler!.carpan! > 1
                                  ? ((widget.gelenStokKart.guncelDegerler!
                                              .carpan!)
                                          .toInt())
                                      .toString()
                                  : tempSaciklama9;

                       
                          if ((int.parse(miktarController.text)) -
                                  int.parse(tempMiktar)
                                       >
                              0) {
                            miktarController.text =
                                (int.parse(miktarController.text) -
                                        int.parse(tempMiktar))
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
                            onEditingComplete: () {
                              fisHareketUygula(context);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              //FilteringTextInputFormatter.allow(
                              //   RegExp(r'^\d+\.?\d{0,2}')),
                              //FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: miktarController,
                            //focusNode: focusNode1,
                            autofocus: true,
                            onTap: () => miktarController.selection =
                                TextSelection(
                                    baseOffset: 0,
                                    extentOffset:
                                        miktarController.value.text.length),
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
                          String tempSaciklama9 =
                              widget.gelenStokKart.SACIKLAMA9!.split(".")[0];
                          if(tempSaciklama9 == "0"){
                            tempSaciklama9 = "1";
                          }

                          String tempMiktar =
                              widget.gelenStokKart.guncelDegerler!.carpan! > 1
                                  ? ((widget.gelenStokKart.guncelDegerler!
                                              .carpan!)
                                          .toInt())
                                      .toString()
                                  : tempSaciklama9;

                          miktarController.text =
                              (int.parse(miktarController.text) +
                                      int.parse(tempMiktar))
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

              Divider(
                endIndent: 20,
                indent: 20,
                thickness: 1,
                color: Colors.black45,
              ),
              // !

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
                        onTap: () => fiyatController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: fiyatController.value.text.length),
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
              Divider(
                endIndent: 20,
                indent: 20,
                thickness: 1,
                color: Colors.black45,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      detay = !detay;
                    });
                  },
                  child: ListTile(
                      title: Text(
                        "Diğer Detaylar",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w500),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              detay = !detay;
                            });
                          },
                          icon: detay == false
                              ? Icon(Icons.arrow_drop_down)
                              : Icon(Icons.arrow_drop_up_sharp))),
                ),
              ),
              detay == true
                  ? Column(
                      children: [
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                Ctanim.kullanici!.MALFAZLASI == "E"
                                    ? Text(
                                        "Mal Fazlası",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04),
                                      )
                                    : Container(),
                                Ctanim.kullanici!.MALFAZLASI == "E"
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      )
                                    : Container(),
                                Ctanim.kullanici!.MALFAZLASI == "E"
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Material(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: TextFormField(
                                                onTap: () => 
                                                      malFazlasiController
                                                              .selection =
                                                          TextSelection(
                                                              baseOffset: 0,
                                                              extentOffset:
                                                                 malFazlasiController
                                                                      .value
                                                                      .text
                                                                      .length),
                                         
                                                controller:
                                                    malFazlasiController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "1",
                                                  hintStyle: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                              )),
                                        ),
                                      )
                                    : Container(),
                                Text(
                                  "İskonto",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "İskonto 1",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Material(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: TextFormField(
                                                  enabled: Ctanim.kullanici!
                                                              .GISKDEGISTIRILSIN1 ==
                                                          "E"
                                                      ? true
                                                      : false,
                                                  controller: isk1Controller,
                                                  onTap: () =>
                                                      isk1Controller.selection =
                                                          TextSelection(
                                                              baseOffset: 0,
                                                              extentOffset:
                                                                  isk1Controller
                                                                      .value
                                                                      .text
                                                                      .length),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "1",
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Material(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: TextFormField(
                                                  enabled: Ctanim.kullanici!
                                                              .GISKDEGISTIRILSIN1 ==
                                                          "E"
                                                      ? true
                                                      : false,
                                                  controller: isk2Controller,
                                                  onTap: () =>
                                                      isk2Controller.selection =
                                                          TextSelection(
                                                              baseOffset: 0,
                                                              extentOffset:
                                                                  isk2Controller
                                                                      .value
                                                                      .text
                                                                      .length),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "1",
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Material(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: TextFormField(
                                                  enabled: Ctanim.kullanici!
                                                              .GISKDEGISTIRILSIN1 ==
                                                          "E"
                                                      ? true
                                                      : false,
                                                  controller: isk3Controller,
                                                  onTap: () =>
                                                      isk3Controller.selection =
                                                          TextSelection(
                                                              baseOffset: 0,
                                                              extentOffset:
                                                                  isk3Controller
                                                                      .value
                                                                      .text
                                                                      .length),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "1",
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "İskonto 4",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Material(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: TextFormField(
                                                  enabled: Ctanim.kullanici!
                                                              .GISKDEGISTIRILSIN1 ==
                                                          "E"
                                                      ? true
                                                      : false,
                                                  controller: isk4Controller,
                                                  onTap: () =>
                                                      isk4Controller.selection =
                                                          TextSelection(
                                                              baseOffset: 0,
                                                              extentOffset:
                                                                  isk4Controller
                                                                      .value
                                                                      .text
                                                                      .length),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "1",
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Material(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: TextFormField(
                                                  enabled: Ctanim.kullanici!
                                                              .GISKDEGISTIRILSIN1 ==
                                                          "E"
                                                      ? true
                                                      : false,
                                                  controller: isk5Controller,
                                                  onTap: () =>
                                                      isk5Controller.selection =
                                                          TextSelection(
                                                              baseOffset: 0,
                                                              extentOffset:
                                                                  isk5Controller
                                                                      .value
                                                                      .text
                                                                      .length),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "1",
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Material(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: TextFormField(
                                                  enabled: Ctanim.kullanici!
                                                              .GISKDEGISTIRILSIN1 ==
                                                          "E"
                                                      ? true
                                                      : false,
                                                  controller: isk6Controller,
                                                  onTap: () =>
                                                      isk6Controller.selection =
                                                          TextSelection(
                                                              baseOffset: 0,
                                                              extentOffset:
                                                                  isk6Controller
                                                                      .value
                                                                      .text
                                                                      .length),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "1",
                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Divider(
                                  endIndent: 20,
                                  indent: 20,
                                  thickness: 1,
                                  color: Colors.black45,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                             
                               
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Divider(
                                  endIndent: 20,
                                  indent: 20,
                                  thickness: 1,
                                  color: Colors.black87,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                              ],
                            )),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fisHareketUygula(BuildContext context) async {
    Ctanim.urunAraFocus = true;
    if (miktarController.text.contains("*")) {
      List<String> parcali = miktarController.text.split("*");
      double miktar = double.parse(parcali[0]) * double.parse(parcali[1]);
      miktarController.text = miktar.toString();
    } else if (miktarController.text.contains("x")) {
      List<String> parcali = miktarController.text.split("x");
      double miktar = double.parse(parcali[0]) * double.parse(parcali[1]);
      miktarController.text = miktar.toString();
    } else if (miktarController.text.contains("X")) {
      List<String> parcali = miktarController.text.split("X");
      double miktar = double.parse(parcali[0]) * double.parse(parcali[1]);
      miktarController.text = miktar.toString();
    } else if (miktarController.text.contains(".")) {
      List<String> parcali = miktarController.text.split(".");
      int miktar = int.parse(parcali[0]) * int.parse(parcali[1]);
      miktarController.text = miktar.toString();
    }
    if (double.parse(miktarController.text) == 0) {
          await showDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                align: TextAlign.left,
                                title: 'İşlem Onayı',
                                message:
                                    '${widget.gelenStokKart.ADI} siparişten silinecek. İşleme devam etmek istiyor musunuz?',
                                onPres: () async {
                                  Navigator.pop(context);
                                },
                                buttonText: 'İptal',
                                secondButtonText: "Devam Et",
                                onSecondPress: () async {
                                        //sil
      Ctanim.urunAraFocus = true;
      if (fisEx.fis!.value.fisStokListesi.any((item1) =>
          item1.STOKKOD == widget.gelenStokKart.guncelDegerler!.guncelBarkod &&
          item1.ALTHESAP == widget.altHesap)) {
        /*
             fisEx.fis?.value.altHesapToplamlar
                                    .removeWhere((item) {
                                  String a = "";
                                  for (var element in item.STOKKODLIST!) {
                                    if (element == stokModel.STOKKOD) {
                                      a = element;
                                    }
                                  }

                                  return a == stokModel.STOKKOD!;
                                });
                                */
        fisEx.fis?.value.fisStokListesi.removeWhere((item) =>
            item.STOKKOD == widget.gelenStokKart.guncelDegerler!.guncelBarkod &&
            item.ALTHESAP == widget.altHesap);

        await Fis.empty().fisHareketSil(
            fisEx.fis!.value.ID!,
            widget.gelenStokKart.guncelDegerler!.guncelBarkod!,
            widget.altHesap);
        setState(() {});
        Ctanim.genelToplamHesapla(fisEx);

        Navigator.pop(context);
        showSnackBar(context);
      } else {
        await showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                align: TextAlign.left,
                title: 'Uyarı',
                message: 'Silinmek istenen ürün sepette mevcut değil.',
                onPres: () async {
                  Navigator.pop(context);
                  Ctanim.urunAraFocus = false;
                },
                buttonText: 'Tamam',
              );
            });
      }
                                  

                                  Navigator.pop(context);
                                },
                              );
                            });

    } else {
      String tempSacikalama9 = widget.gelenStokKart.SACIKLAMA9!.split(".")[0];
      double kontrolCarpan = 0.0;
      if(tempSacikalama9 == "0"){
        tempSacikalama9 = "1";

      }
         kontrolCarpan = widget.gelenStokKart.guncelDegerler!.carpan! > 1
          ? widget.gelenStokKart.guncelDegerler!.carpan!
          : double.tryParse(tempSacikalama9) ?? 1;

      
  

      if (double.parse(miktarController.text) % kontrolCarpan != 0) {
        // HATA GOSTER
        Ctanim.urunAraFocus = false;
        await showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                align: TextAlign.left,
                title: 'Hata',
                message: 'Eklemeye çalıştığınız miktar  ' +
                    kontrolCarpan.toString() +
                    " katı olmalıdır.",
                onPres: () async {
                  Navigator.pop(context);
                  Ctanim.urunAraFocus = false;
                },
                buttonText: 'Tamam',
              );
            });
        Ctanim.urunAraFocus = false;

        return;
      }

      KurModel gidecekKur = listeler.listKur.first;
      if (Ctanim.kullanici!.LISTEFIYAT! == "E") {
        for (var element in listeler.listKur) {
          if (widget.gelenStokKart.LISTEDOVIZ == element.ACIKLAMA) {
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
          iskonto1: double.parse(
                  isk1Controller.text == "" ? "0" : isk1Controller.text) ??
              0,
          iskonto2: double.parse(
                  isk2Controller.text == "" ? "0" : isk2Controller.text) ??
              0,
          iskonto3: double.tryParse(isk3Controller.text) ?? 0,
          iskonto4: double.tryParse(isk4Controller.text) ?? 0,
          iskonto5: double.tryParse(isk5Controller.text) ?? 0,
          iskonto6: double.tryParse(isk6Controller.text) ?? 0,
          malFazlasi:
              (double.tryParse(malFazlasiController.text)!).toInt() ?? 0,
          //
          fiyat: double.tryParse(fiyatController.text) ?? 0);

      Navigator.pop(context);
      showSnackBar(context, miktar: miktar);
    }
  }
}
