import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/db/veriTabaniIslemleri.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/stokKosulAnaModel.dart';
import 'package:opak_fuar/model/stokKosulModel.dart';
import 'package:opak_fuar/pages/LoadingSpinner.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/sabitler/sharedPreferences.dart';
import 'package:opak_fuar/webServis/base.dart';

import '../model/ShataModel.dart';
import '../model/cariModel.dart';
import '../pages/CustomAlertDialog.dart';
import '../sabitler/Ctanim.dart';

class CariFormPage extends StatefulWidget {
  CariFormPage({required this.yeniKayit, Cari? cari = null}) {
    if (cari != null) {
      this.cari = cari;
    }
  }

  late Cari cari;
  bool yeniKayit;
  @override
  State<CariFormPage> createState() => _CariFormPageState();
}

class _CariFormPageState extends State<CariFormPage> {
  BaseService bs = BaseService();
  bool altBayi = false;
  bool bayi = false;
  TextEditingController _SirketIsmi = TextEditingController();
  TextEditingController _AdresBilgileri = TextEditingController();
  TextEditingController _YetkiliKisi = TextEditingController();
  TextEditingController _SehirSeciniz = TextEditingController();
  TextEditingController _IlceSeciniz = TextEditingController();
  TextEditingController _VergiDairesi = TextEditingController();
  TextEditingController _VergiNumarasi = TextEditingController();
  TextEditingController _CepTelefonu = TextEditingController();
  TextEditingController _MailAdresi = TextEditingController();
  TextEditingController _Aciklama = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.yeniKayit == false) {
      if (widget.cari.TIPI == "Alt Bayi") {
        altBayi = true;
      } else {
        bayi = true;
      }
      _SirketIsmi.text = widget.cari.ADI!;
      _AdresBilgileri.text = widget.cari.ADRES!;
      _YetkiliKisi.text = widget.cari.PLASIYERID!.toString();
      _SehirSeciniz.text = widget.cari.IL!;
      _IlceSeciniz.text = widget.cari.ILCE!;
      _VergiDairesi.text = widget.cari.VERGI_DAIRESI ?? "";
      _VergiNumarasi.text = widget.cari.VERGINO!;
      _CepTelefonu.text = widget.cari.TELEFON!;
      _MailAdresi.text = widget.cari.EMAIL!;
      _Aciklama.text = widget.cari.ACIKLAMA1!;
    }
    for (var element in listeler.listCariAltHesap) {
      seciliAltHesaplar.add(
          element.VARSAYILAN == "E" && element.ZORUNLU == "E" ? true : false);
    }
    if (listeler.listStokKosulAna.isNotEmpty) {
      for (var element2 in listeler.listStokKosulAna) {
        seciliKosullar.add(false);
      }
      seciliKosullar[0] = true;
      seciliStokKosul = listeler.listStokKosulAna[0];
    }
  }

  void sayfayiTemizle() {
    _SirketIsmi.clear();
    _AdresBilgileri.clear();
    _YetkiliKisi.clear();
    _SehirSeciniz.clear();
    _IlceSeciniz.clear();
    _VergiDairesi.clear();
    _VergiNumarasi.clear();
    _CepTelefonu.clear();
    _MailAdresi.clear();
    _Aciklama.clear();
  }

  List<bool> seciliAltHesaplar = [];
  List<bool> seciliKosullar = [];
  StokKosulAnaModel? seciliStokKosul;

  @override
  Widget build(BuildContext context) {
    double ekranYuksekligi = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: bottombarDizayn(context),
        body: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    // ! Üst Kısım
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                    ),

                    // ! Form
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.07),
                      child: Form(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    child: Text(
                                      "Müşteri Bilgileri",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 17, 100, 168),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          thickness: 1.5,
                                          color: const Color.fromARGB(
                                              255, 17, 100, 168))),
                                ],
                              ),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),

                              // ! Müşteri / Şirket İsmi Giriniz
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    autofocus: true,
                                    controller: _SirketIsmi,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label:
                                          Text('Müşteri / Şirket İsmi Giriniz'),
                                    ),
                                  ),
                                ),
                              ),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    controller: _YetkiliKisi,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label: Text('Yetkili Kişi Giriniz'),
                                    ),
                                  ),
                                ),
                              ),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),

                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    controller: _CepTelefonu,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label: Text("Cep Telefonu Giriniz"),
                                    ),
                                  ),
                                ),
                              ),
                              // ! Mail Adresi Giriniz
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),

                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    controller: _MailAdresi,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label: Text("Mail Adresi Giriniz"),
                                    ),
                                  ),
                                ),
                              ),
                              // ! Adres Bilgileri Giriniz
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),

                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    child: Text(
                                      "Adres Bilgileri",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 17, 100, 168),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          thickness: 1.5,
                                          color: const Color.fromARGB(
                                              255, 17, 100, 168))),
                                ],
                              ),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    controller: _AdresBilgileri,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label: Text('Adres Bilgileri Giriniz'),
                                    ),
                                  ),
                                ),
                              ),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                        controller: _SehirSeciniz,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          label: Text('Şehir'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                        controller: _IlceSeciniz,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          label: Text('İlçe'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    child: Text(
                                      "Vergi Bilgileri",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 17, 100, 168),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          thickness: 1.5,
                                          color: const Color.fromARGB(
                                              255, 17, 100, 168))),
                                ],
                              ),
                              // ! Vergi Dairesi Giriniz
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),

                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    controller: _VergiDairesi,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label: Text("Vergi Dairesi Giriniz"),
                                    ),
                                  ),
                                ),
                              ),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    controller: _VergiNumarasi,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label: Text("Vergi Numarası Giriniz"),
                                    ),
                                  ),
                                ),
                              ),
                              widget.yeniKayit ?
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container():Container(),
                                  widget.yeniKayit ?
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    child: Text(
                                      "Alt Hesap Seçimi",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 17, 100, 168),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          thickness: 1.5,
                                          color: const Color.fromARGB(
                                              255, 17, 100, 168))),
                                ],
                              ):Container(),
                             widget.yeniKayit? ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container():Container(),
                             widget.yeniKayit? Container(
                                height: ekranYuksekligi > 650
                                    ? listeler.listCariAltHesap.length /
                                        2 *
                                        MediaQuery.of(context).size.height *
                                        0.07
                                    : listeler.listCariAltHesap.length /
                                        2 *
                                        MediaQuery.of(context).size.height *
                                        0.085,
                                width: MediaQuery.of(context).size.width * .9,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.05,
                                      right: MediaQuery.of(context).size.width *
                                          0.05),
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 4,
                                      crossAxisSpacing:
                                          MediaQuery.of(context).size.width *
                                              0.09,
                                      mainAxisSpacing:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                    ),
                                    itemCount: listeler.listCariAltHesap.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: ekranYuksekligi > 650
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.1,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                        value:
                                                            seciliAltHesaplar[
                                                                index],
                                                        onChanged: (value) {
                                                          if (listeler
                                                                      .listCariAltHesap[
                                                                          index]
                                                                      .ZORUNLU ==
                                                                  "E" &&
                                                              listeler
                                                                      .listCariAltHesap[
                                                                          index]
                                                                      .VARSAYILAN ==
                                                                  "E") {
                                                            return;
                                                          } else {
                                                            print(
                                                                "DEĞİŞİRRRRRR");
                                                            setState(() {
                                                              seciliAltHesaplar[
                                                                      index] =
                                                                  value!;
                                                            });
                                                          }
                                                        }),
                                                    SizedBox(
                                                      width: ekranYuksekligi >
                                                              650
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.23
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Text(
                                                        listeler
                                                            .listCariAltHesap[
                                                                index]
                                                            .ALTHESAP!,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.03),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ):Container(),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),
                              // ! Alt Bayi veya Bayi
                              listeler.listStokKosulAna.isNotEmpty && widget.yeniKayit
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          child: Text(
                                            "Stok Koşul Seçimi",
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 17, 100, 168),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                            child: Divider(
                                                thickness: 1.5,
                                                color: const Color.fromARGB(
                                                    255, 17, 100, 168))),
                                      ],
                                    )
                                  : Container(),
                              listeler.listStokKosulAna.isNotEmpty && widget.yeniKayit
                                  ? ekranYuksekligi < 650
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        )
                                      : Container()
                                  : Container(),
                              listeler.listStokKosulAna.isNotEmpty&& widget.yeniKayit
                                  ? Container(
                                      height: ekranYuksekligi > 650
                                          ? listeler.listCariAltHesap.length *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.052
                                          : listeler.listCariAltHesap.length *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.062,
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                        child: ListView.builder(
                                          itemCount:
                                              listeler.listStokKosulAna.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: ekranYuksekligi > 650
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.06
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.07,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(
                                                              value:
                                                                  seciliKosullar[
                                                                      index],
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  if (value ==
                                                                      true) {
                                                                    for (var i =
                                                                            0;
                                                                        i < seciliKosullar.length;
                                                                        i++) {
                                                                      seciliKosullar[
                                                                              i] =
                                                                          false;
                                                                      if (i ==
                                                                          index) {
                                                                        seciliKosullar[i] =
                                                                            true;
                                                                        seciliStokKosul =
                                                                            listeler.listStokKosulAna[i];
                                                                      }
                                                                    }
                                                                  }
                                                                });
                                                              }),
                                                          Text(
                                                            listeler
                                                                .listStokKosulAna[
                                                                    index]
                                                                .ADI!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.035),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : Container(),

                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    child: Text(
                                      "Diğer Bilgileri",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 17, 100, 168),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          thickness: 1.5,
                                          color: const Color.fromARGB(
                                              255, 17, 100, 168))),
                                ],
                              ),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    controller: _Aciklama,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label: Text("Açıklama Giriniz"),
                                    ),
                                  ),
                                ),
                              ),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),
                              // ! Alt Bayi veya Bayi

                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.black54),
                                        ),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                value: altBayi,
                                                onChanged: (value) {
                                                  setState(() {
                                                    altBayi = value!;
                                                    if (altBayi == true) {
                                                      bayi = false;
                                                    }
                                                  });
                                                }),
                                            Text("Alt Bayi"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.black54),
                                        ),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                value: bayi,
                                                onChanged: (value) {
                                                  setState(() {
                                                    bayi = value!;
                                                    if (bayi == true) {
                                                      altBayi = false;
                                                    }
                                                  });
                                                }),
                                            Text(" Bayi"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ekranYuksekligi < 650
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    )
                                  : Container(),

                              // ! Kaydet Butonu sil Değiştir

                              widget.yeniKayit == false
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width:
                                          MediaQuery.of(context).size.width * 9,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return LoadingSpinner(
                                                color: Colors.black,
                                                message:
                                                    "Cari güncelleme yapılıyor. Lütfen Bekleyiniz...",
                                              );
                                            },
                                          );
                                          // bekleme
                                          Cari cari = Cari.empty();
                                          cari.PLASIYERID =
                                              int.parse(Ctanim.kullanici!.KOD!);
                                          cari.KOD = widget.cari.KOD;
                                          cari.ADI = _SirketIsmi.text;
                                          cari.ADRES = _AdresBilgileri.text;
                                          cari.IL = _SehirSeciniz.text;
                                          cari.ILCE = _IlceSeciniz.text;
                                          cari.VERGI_DAIRESI =
                                              _VergiDairesi.text;
                                          cari.VERGINO = _VergiNumarasi.text;
                                          cari.TELEFON = _CepTelefonu.text;
                                          cari.EMAIL = _MailAdresi.text;
                                          cari.ACIKLAMA1 = _Aciklama.text;
                                          cari.ACIKLAMA4 = _YetkiliKisi.text;
                                          cari.AKTARILDIMI = "H";
                                          cari.ALTHESAPLAR =
                                              widget.cari.ALTHESAPLAR;
                                          cari.KOSULID = widget.cari.KOSULID;    
                                          cari.TIPI = altBayi == true
                                              ? "Alt Bayi"
                                              : "Bayi";

                                          await VeriIslemleri().cariEkle(cari,
                                              guncellemeMi: true);
                                          await VeriIslemleri().cariGetir();

                                          //asd
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CustomAlertDialog(
                                                  align: TextAlign.left,
                                                  title: 'Başarılı',
                                                  message:
                                                      'Cari güncelleme tamamlandı.',
                                                  onPres: () async {
                                                    sayfayiTemizle();
                                                    Navigator.pop(context);
                                                  },
                                                  buttonText: 'Tamam',
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.edit),
                                        label: Text(
                                          "Değiştir",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                       height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width:
                                          MediaQuery.of(context).size.width * 9,
                                      child: Center(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            if (_MailAdresi.text != "" &&
                                                _CepTelefonu.text != "" &&
                                                _AdresBilgileri.text != "" &&
                                                _SirketIsmi.text != "") {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return LoadingSpinner(
                                                    color: Colors.black,
                                                    message:
                                                        "Cari kaydı yapılıyor. Lütfen Bekleyiniz...",
                                                  );
                                                },
                                              );
                                              Cari cari = Cari.empty();
                                              DateTime now = DateTime.now();
                                              String formattedDate =
                                                  DateFormat('ddMMHHmm')
                                                      .format(now);

                                              String paddedString = Ctanim
                                                  .cariKod
                                                  .toString()
                                                  .padLeft(5, "0");
                                              print(Ctanim.kullanici!.KOD! +
                                                  "-" +
                                                  formattedDate +
                                                  paddedString);
                                              cari.KOD =
                                                  Ctanim.kullanici!.KOD! +
                                                      "-" +
                                                      formattedDate +
                                                      paddedString;
                                              cari.PLASIYERID = int.parse(
                                                  Ctanim.kullanici!.KOD!);
                                              cari.ADI = _SirketIsmi.text;
                                              cari.ADRES = _AdresBilgileri.text;
                                              cari.IL = _SehirSeciniz.text;
                                              cari.ILCE = _IlceSeciniz.text;
                                              cari.VERGI_DAIRESI =
                                                  _VergiDairesi.text;
                                              cari.VERGINO =
                                                  _VergiNumarasi.text;
                                              cari.TELEFON = _CepTelefonu.text;
                                              cari.EMAIL = _MailAdresi.text;
                                              cari.ACIKLAMA1 = _Aciklama.text;
                                              cari.ACIKLAMA4 =
                                                  _YetkiliKisi.text;
                                              cari.AKTARILDIMI = "H";
                                              cari.TIPI = altBayi == true
                                                  ? "Alt Bayi"
                                                  : "Bayi";
                                              cari.KOSULID = seciliStokKosul != null ?
                                                  seciliStokKosul!.ID:0;
                                            

                                              for (int i = 0;
                                                  i <
                                                      listeler.listCariAltHesap
                                                          .length;
                                                  i++) {
                                                if (seciliAltHesaplar[i] ==
                                                    true) {
                                                  CariAltHesap yeniAltHesap = CariAltHesap(
                                                      ALTHESAP: listeler
                                                          .listCariAltHesap[i]
                                                          .ALTHESAP,
                                                      DOVIZID: listeler
                                                          .listCariAltHesap[i]
                                                          .DOVIZID,
                                                      VARSAYILAN: listeler
                                                                  .listCariAltHesap[
                                                                      i]
                                                                  .VARSAYILAN ==
                                                              "E"
                                                          ? "E"
                                                          : "H",
                                                      ALTHESAPID: listeler
                                                          .listCariAltHesap[i]
                                                          .ALTHESAPID,
                                                      ZORUNLU: listeler
                                                                  .listCariAltHesap[
                                                                      i]
                                                                  .ZORUNLU ==
                                                              "E"
                                                          ? "E"
                                                          : "H");

                                                  cari.ALTHESAPLAR =
                                                      cari.ALTHESAPLAR != ""
                                                          ? cari.ALTHESAPLAR! +
                                                              "," +
                                                              yeniAltHesap
                                                                  .ALTHESAPID
                                                                  .toString()
                                                          : yeniAltHesap
                                                              .ALTHESAPID
                                                              .toString();
                                                }
                                              }
                                              print("ALT HESAPLAR");
                                              print(cari.ALTHESAPLAR);

                                              await VeriIslemleri()
                                                  .cariEkle(cari);
                                              await VeriIslemleri().cariGetir();
                                              Ctanim.cariKod =
                                                  Ctanim.cariKod! + 1;
                                              await SharedPrefsHelper
                                                  .cariKoduKaydet(
                                                      Ctanim.cariKod!);

                                              seciliAltHesaplar.clear();
                                              seciliKosullar.clear();
                                              for (var element in listeler
                                                  .listCariAltHesap) {
                                                seciliAltHesaplar.add(
                                                    element.VARSAYILAN == "E" &&
                                                            element.ZORUNLU ==
                                                                "E"
                                                        ? true
                                                        : false);
                                              }
                                              if (listeler.listStokKosulAna
                                                  .isNotEmpty) {
                                                for (var element2 in listeler
                                                    .listStokKosulAna) {
                                                  seciliKosullar.add(false);
                                                }
                                                seciliKosullar[0] = true;
                                                seciliStokKosul = listeler
                                                    .listStokKosulAna[0];
                                              }
                                              setState(() {});

                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomAlertDialog(
                                                      align: TextAlign.left,
                                                      title: 'Başarılı',
                                                      message:
                                                          'Cari kaydı yapıldı.',
                                                      onPres: () async {
                                                        sayfayiTemizle();
                                                        Navigator.pop(context);
                                                      },
                                                      buttonText: 'Tamam',
                                                    );
                                                  });
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomAlertDialog(
                                                      align: TextAlign.left,
                                                      title: 'Hata',
                                                      message:
                                                          'Yeni cari eklemede cari adı, mail adresi, telefon numarası ve adres bilgileri boş bırakılamaz.',
                                                      onPres: () async {
                                                        Navigator.pop(context);
                                                      },
                                                      buttonText: 'Geri',
                                                    );
                                                  });
                                            }
                                          },
                                          icon: Icon(Icons.save),
                                          label: Text(
                                            "Kaydet",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                         style: ElevatedButton.styleFrom(
                                          primary: Colors.green,
                                          onPrimary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
