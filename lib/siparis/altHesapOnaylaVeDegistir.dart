import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/db/veriTabaniIslemleri.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/model/satisTipiModel.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/pages/CustomAlertDialog.dart';
import 'package:opak_fuar/pages/LoadingSpinner.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/siparis/siparisTamamla.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';

class AltHesapOnaylaVeDegistir extends StatefulWidget {
  const AltHesapOnaylaVeDegistir(
      {super.key,
      required this.listCariAltHesap,
      required this.gelenAltHesap,
      required this.hepsiMi});
  final List<CariAltHesap> listCariAltHesap;
  final CariAltHesap? gelenAltHesap;
  final bool? hepsiMi;

  @override
  State<AltHesapOnaylaVeDegistir> createState() =>
      _AltHesapOnaylaVeDegistirState();
}

class _AltHesapOnaylaVeDegistirState extends State<AltHesapOnaylaVeDegistir> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seciliAltHesap = widget.listCariAltHesap.first;
  }

  CariAltHesap? seciliAltHesap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Alt Hesap Onayla ve Değiştir '),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CariAltHesap>(
                value: seciliAltHesap,
                items: widget.listCariAltHesap.map((CariAltHesap banka) {
                  return DropdownMenuItem<CariAltHesap>(
                    value: banka,
                    child: Text(
                      banka.ALTHESAP!,
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (CariAltHesap? selected) async {
                  setState(() {
                    seciliAltHesap = selected;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Kapat'),
        ),
        TextButton(
          onPressed: () async {
            if (widget.hepsiMi == false) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LoadingSpinner(
                    color: Colors.black,
                    message:
                        "Seçili ürünlerin althesapları değiştiriliyor. Lütfen Bekleyiniz...",
                  );
                },
              );
              String hataTopla = "";
              for (var element in fisEx.fis!.value.fisStokListesi) {
                if (element.AltHesapDegistir == true) {
                  if (fisEx.fis!.value.fisStokListesi.any((vv) =>
                      vv.STOKKOD == element.STOKKOD &&
                      vv.ALTHESAP == seciliAltHesap!.ALTHESAP!)) {
                    element.AltHesapDegistir = false;
                    hataTopla += "${element.STOKKOD} / ${element.STOKADI} \n";
                  } else {
                    element.ALTHESAP = seciliAltHesap!.ALTHESAP;
                    altHesapDegistirFiseEkle(element);
                    fisEx.fis!.value.AKTARILDIMI = false;
                    await Fis.empty()
                        .fisEkle(fis: fisEx.fis!.value, belgeTipi: "YOK");
                    Ctanim.genelToplamHesapla(fisEx);
                  }
                }
              }
              if (hataTopla != "") {
                hataTopla +=
                    "yukardaki ürün(ler) zaten değiştirilmek istenen althesapta mevcut. Lütfen farklı bir althesap seçiniz.\n";

                await showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        align: TextAlign.left,
                        title: 'Uyarı',
                        message: hataTopla,
                        onPres: () async {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        buttonText: 'Tamam',
                      );
                    });
                setState(() {});
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            } else {
              String hataTopla = "";
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LoadingSpinner(
                    color: Colors.black,
                    message:
                        "${widget.gelenAltHesap!.ALTHESAP}'a ait ürünlerin alt hesapları değiştiriliyor. Lütfen Bekleyiniz...",
                  );
                },
              );
              for (var element in fisEx.fis!.value.fisStokListesi) {
                if (element.ALTHESAP == widget.gelenAltHesap!.ALTHESAP) {
                  if (fisEx.fis!.value.fisStokListesi.any((vv) =>
                      vv.STOKKOD == element.STOKKOD &&
                      vv.ALTHESAP == seciliAltHesap!.ALTHESAP!)) {
                    element.AltHesapDegistir = false;
                    hataTopla += "${element.STOKKOD} / ${element.STOKADI} \n";
                  } else {
                    element.AltHesapDegistir = true;
                    element.ALTHESAP = seciliAltHesap!.ALTHESAP;
                    altHesapDegistirFiseEkle(element);
                    fisEx.fis!.value.AKTARILDIMI = false;
                    await Fis.empty()
                        .fisEkle(fis: fisEx.fis!.value, belgeTipi: "YOK");
                    Ctanim.genelToplamHesapla(fisEx);
                  }
                }
              }
              if (hataTopla != "") {
                hataTopla +=
                    "yukardaki ürün(ler) zaten değiştirilmek istenen althesapta mevcut. Lütfen farklı bir althesap seçiniz.\n";

                await showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        align: TextAlign.left,
                        title: 'Uyarı',
                        message: hataTopla,
                        onPres: () async {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        buttonText: 'Tamam',
                      );
                    });
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            }
          },
          child: Text('Tamam'),
        ),
      ],
    );
  }

  void altHesapDegistirFiseEkle(FisHareket element) {
    List<StokKart> stok = [];
    bool barkodMu = false;
    for (var el in stokKartEx.searchList) {
      if (el.KOD == element.STOKKOD) {
        stok.add(el);
      } else if (el.BARKOD1 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN1! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN1!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD1!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT1! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD1!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT1;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK1;
               stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      } else if (el.BARKOD2 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN2! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN2!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD2!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT2! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD2!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT2;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK2;
               stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      } else if (el.BARKOD3 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN3! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN3!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD3!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT3! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD3!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT3;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK3;
               stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      } else if (el.BARKOD4 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN4! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN4!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD4!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT4! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD4!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT4;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK4;
               stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      } else if (el.BARKOD5 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN5! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN5!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD5!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT5! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD5!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT5;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK5;
               stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      } else if (el.BARKOD6 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN6! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN6!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD6!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT6! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD6!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT6;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK6;
          stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      }
    }
    if (stok.isEmpty) {
      listeler.listDahaFazlaBarkod
          .where((dahaFazla) => dahaFazla.KOD == element.STOKKOD);
    }
  if(barkodMu == false){
        SatisTipiModel satisTipiModel =
        SatisTipiModel(ID: -1, TIP: "a", FIYATTIP: "", ISK1: "", ISK2: "");

    List<dynamic> gelenFiyatVeIskonto = stokKartEx.fiyatgetir(
        stok.first,
        fisEx.fis!.value.CARIKOD!,
        Ctanim.satisFiyatListesi.first,
        satisTipiModel,
        Ctanim.seciliStokFiyatListesi,
        seciliAltHesap!.ALTHESAPID);

    stok.first.guncelDegerler!.guncelBarkod = element.STOKKOD;
    stok.first.guncelDegerler!.carpan = 1;
    stok.first.guncelDegerler!.fiyat =
        double.parse(gelenFiyatVeIskonto[0].toString());

    stok.first.guncelDegerler!.iskonto1 =
        double.parse(gelenFiyatVeIskonto[1].toString());

    stok.first.guncelDegerler!.iskonto2 =
        double.parse(gelenFiyatVeIskonto[4].toString());

    stok.first.guncelDegerler!.iskonto3 =
        double.parse(gelenFiyatVeIskonto[5].toString());

    stok.first.guncelDegerler!.iskonto4 =
        double.parse(gelenFiyatVeIskonto[6].toString());

    stok.first.guncelDegerler!.iskonto5 =
        double.parse(gelenFiyatVeIskonto[7].toString());

    stok.first.guncelDegerler!.iskonto6 =
        double.parse(gelenFiyatVeIskonto[8].toString());

    stok.first.guncelDegerler!.seciliFiyati = gelenFiyatVeIskonto[2].toString();
    stok.first.guncelDegerler!.fiyatDegistirMi = gelenFiyatVeIskonto[3];

    stok.first.guncelDegerler!.netfiyat =
        stok.first.guncelDegerler!.hesaplaNetFiyat();
    //fiyat listesi koşul arama fonksiyonua gönderiliyor orda ekleme yapsanda buraya eklemez giyatListesiKosulu cTanima ekle !
    if (!Ctanim.fiyatListesiKosul
        .contains(stok.first.guncelDegerler!.seciliFiyati)) {
      Ctanim.fiyatListesiKosul.add(stok.first.guncelDegerler!.seciliFiyati!);
    }


  }

    double tempFiyat = 0;

    tempFiyat = stok.first.guncelDegerler!.fiyat!;

    double KDVTUtarTemp =
        stok.first.guncelDegerler!.fiyat! * (1 + (stok.first.SATIS_KDV!));

    //  fisEx.fis!.value.fisStokListesi.remove(element);

    fisEx.fiseStokEkle(
      // belgeTipi: widget.belgeTipi,
      altHesapDegistirMi: true,

      malFazlasi: element.MALFAZLASI,
      ALTHESAP: seciliAltHesap!.ALTHESAP!,
      urunListedenMiGeldin: true,
      stokAdi: stok.first.ADI!,
      KDVOrani: double.parse(stok.first.SATIS_KDV.toString()),
      birim: element.BIRIM!,
      birimID: 1,
      dovizAdi: stok.first.ACIKLAMA!,
      dovizId: stok.first.ID!,
      burutFiyat: tempFiyat,
      iskonto: stok.first.guncelDegerler!.iskonto1!,
      iskonto2: stok.first.guncelDegerler!.iskonto2!,
      iskonto3: stok.first.guncelDegerler!.iskonto3!,
      iskonto4: stok.first.guncelDegerler!.iskonto4!,
      iskonto5: stok.first.guncelDegerler!.iskonto5!,
      iskonto6: stok.first.guncelDegerler!.iskonto6!,
      miktar: element.MIKTAR!,
      stokKodu: stok.first.guncelDegerler!.guncelBarkod!,
      Aciklama1: '',
      KUR: element.KUR!,
      TARIH: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      UUID: fisEx.fis!.value.UUID!,
    );
  }
}
