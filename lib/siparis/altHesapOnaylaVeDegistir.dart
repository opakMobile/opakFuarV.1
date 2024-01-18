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
              hataTopla +=
                        "${element.STOKKOD} / ${element.STOKADI}  zaten değiştirilmek istenen althesapta mevcut. Lütfen farklı bir althesap seçiniz.\n";                  } else {
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
                    setState(() {
                      
                    });
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
                                    "${seciliAltHesap!.ALTHESAP}'a ait ürünlerin alt hesapları değiştiriliyor. Lütfen Bekleyiniz...",
                              );
                            },
                          );
              for (var element in fisEx.fis!.value.fisStokListesi) {
                if (element.ALTHESAP == widget.gelenAltHesap!.ALTHESAP) {
                  if (fisEx.fis!.value.fisStokListesi.any((vv) =>
                      vv.STOKKOD == element.STOKKOD &&
                      vv.ALTHESAP == seciliAltHesap!.ALTHESAP!)) {
                     element.AltHesapDegistir = false;
                    hataTopla +=
                        "${element.STOKKOD} / ${element.STOKADI}  zaten değiştirilmek istenen althesapta mevcut. Lütfen farklı bir althesap seçiniz.\n";
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
    List<StokKart> stok = stokKartEx.searchList
        .where((element2) => (element2.KOD == element.STOKKOD ||
            element2.BARKOD1 == element.STOKKOD ||
            element2.BARKOD2 == element.STOKKOD ||
            element2.BARKOD3 == element.STOKKOD ||
            element2.BARKOD4 == element.STOKKOD ||
            element2.BARKOD5 == element.STOKKOD ||
            element2.BARKOD6 == element.STOKKOD))
        .toList();
    if (stok.isEmpty) {
      listeler.listDahaFazlaBarkod
          .where((dahaFazla) => dahaFazla.KOD == element.STOKKOD);
    }

    SatisTipiModel satisTipiModel =
        SatisTipiModel(ID: -1, TIP: "a", FIYATTIP: "", ISK1: "", ISK2: "");

    List<dynamic> gelenFiyatVeIskonto = stokKartEx.fiyatgetir(
        stok.first,
        fisEx.fis!.value.CARIKOD!,
        Ctanim.satisFiyatListesi.first,
        satisTipiModel,
        Ctanim.seciliStokFiyatListesi,
        seciliAltHesap!.ALTHESAPID);

    stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD;
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
