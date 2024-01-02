import 'dart:math';

import 'package:flutter/material.dart';
import 'package:opak_fuar/db/veriTabaniIslemleri.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
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
  bool AliciMusteri = false;
  bool AliciBayi = false;
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(120.0),
            child: Stack(
              children: [
                appBarDizayn(context),
                // ! Üst Kısım
              ],
            )),
        bottomNavigationBar: bottombarDizayn(context),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1.2,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
            ),
            child: SingleChildScrollView(
              child: Column(
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
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              // ! Müşteri / Şirket İsmi Giriniz
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                child: Center(
                                  child: TextFormField(
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
                              // ! Adres Bilgileri Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: TextFormField(
                                    controller: _AdresBilgileri,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label: Text('Adres Bilgileri Giriniz'),
                                    ),
                                  ),
                                ),
                              ),
                              // ! Yetkili Kişi Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  controller: _YetkiliKisi,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text('Yetkili Kişi Giriniz'),
                                  ),
                                ),
                              ),
                              // ! Şehir Seçiniz ve İlçe Seçiniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _SehirSeciniz,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          label: Text('Şehir Seçiniz'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _IlceSeciniz,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          label: Text('İlçe Seçiniz'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ! Vergi Dairesi Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  controller: _VergiDairesi,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text("Vergi Dairesi Giriniz"),
                                  ),
                                ),
                              ),
                              // ! Vergi Numarası Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  controller: _VergiNumarasi,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text("Vergi Numarası Giriniz"),
                                  ),
                                ),
                              ),
                              // ! Cep Telefonu Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  controller: _CepTelefonu,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text("Cep Telefonu Giriniz"),
                                  ),
                                ),
                              ),
                              // ! Mail Adresi Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  controller: _MailAdresi,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text("Mail Adresi Giriniz"),
                                  ),
                                ),
                              ),
                              // ! Açıklama Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  controller: _Aciklama,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text("Açıklama Giriniz"),
                                  ),
                                ),
                              ),
                              // ! Alıcı Müşteri veya Bayi
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
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
                                                value: AliciMusteri,
                                                onChanged: (value) {
                                                  setState(() {
                                                    AliciMusteri = value!;
                                                    if (AliciMusteri == true) {
                                                      AliciBayi = false;
                                                    }
                                                  });
                                                }),
                                            Text("Alt Bayi"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
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
                                                value: AliciBayi,
                                                onChanged: (value) {
                                                  setState(() {
                                                    AliciBayi = value!;
                                                    if (AliciBayi == true) {
                                                      AliciMusteri = false;
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
                              // ! Kaydet Butonu sil Değiştir
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              widget.yeniKayit == false
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
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
                                          cari.TIPI = AliciMusteri == true
                                              ? "Alıcı Müşteri"
                                              : "Alıcı Bayi";
                                          await VeriIslemleri().cariEkle(cari,
                                              guncellemeMi: true);
                                          await VeriIslemleri().cariGetir();
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
                                                      Navigator.pop(context);
                                                    },
                                                    buttonText: 'Tamam',
                                                  );
                                                });
                                        },
                                        icon: Icon(Icons.edit),
                                        label: Text(
                                          "Değiştir",
                                          style: TextStyle(fontSize: 11),
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
                                              0.05,
                                      child: Center(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return LoadingSpinner(
                                                  color: Colors.black,
                                                  message:
                                                      "Cari kaydı yapılıyor. Lütfen Bekleyiniz...",
                                                );
                                              },
                                            );
                                            Cari cari = Cari.empty();

                                            String paddedString = Ctanim.cariKod
                                                .toString()
                                                .padLeft(5, "0");
                                            cari.KOD = Ctanim.kullanici!.KOD! +
                                                "-" +
                                                paddedString;
                                            cari.PLASIYERID = int.parse(
                                                Ctanim.kullanici!.KOD!);
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
                                            cari.TIPI = AliciMusteri == true
                                                ? "Alıcı Müşteri"
                                                : "Alıcı Bayi";
                                            await VeriIslemleri()
                                                .cariEkle(cari);
                                            await VeriIslemleri().cariGetir();

                                            for (var element
                                                in listeler.listCariAltHesap) {
                                              if (element.VARSAYILAN == "E" &&
                                                  element.ZORUNLU == "E") {
                                                CariAltHesap yeniAltHesap =
                                                    CariAltHesap(
                                                        KOD: cari.KOD,
                                                        ALTHESAP:
                                                            element.ALTHESAP,
                                                        DOVIZID:
                                                            element.DOVIZID,
                                                        VARSAYILAN: "E",
                                                        ALTHESAPID:
                                                            element.ALTHESAPID,
                                                        ZORUNLU: "E");
                                                await VeriIslemleri()
                                                    .cariAltHesapEkle(
                                                        yeniAltHesap);
                                                break;
                                              }
                                            }

                                            Ctanim.cariKod =
                                                Ctanim.cariKod! + 1;
                                            await SharedPrefsHelper
                                                .cariKoduKaydet(
                                                    Ctanim.cariKod!);
                                            await VeriIslemleri()
                                                .cariAltHesapGetir();
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
                                                      Navigator.pop(context);
                                                    },
                                                    buttonText: 'Tamam',
                                                  );
                                                });
                                          },
                                          icon: Icon(Icons.save),
                                          label: Text("Kaydet"),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
