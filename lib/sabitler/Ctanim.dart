import 'dart:math';

import 'package:money_formatter/money_formatter.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/model/altHesapToplamModel.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/sabitler/listeler.dart';

import '../model/kullaniciModel.dart';
import '../model/satisTipiModel.dart';
import '../model/stokFiyatListesiModel.dart';

class Ctanim {
  //degiskenler
  static var db;
  static String? sirket;
  static String IP = "";
  static KullaniciModel? kullanici;
  static List<String> secililiMarkalarFiltre = [];
  static List<String> fiyatListesiKosul = [];
  static SatisTipiModel seciliIslemTip =
      SatisTipiModel(ID: -1, TIP: "a", FIYATTIP: "", ISK1: "", ISK2: "");
  static StokFiyatListesiModel seciliStokFiyatListesi =
      StokFiyatListesiModel(ID: -1, ADI: "");
  Map<String, int> MapFisTip = {
    "Perakende_Satis": 1,
    "Satis_Fatura": 2,
    "Alis_Fatura": 3,
    "Perakende_Satis_Iade": 4,
    "Satis_Iade_Fatura": 5,
    "Perakende_Iptal": 6,
    "Fatura_Iptal": 7,
    "Satis_Irsaliye": 8,
    "Satis_Irsaliye_Iptal": 9,
    "Gider_Pusulasi": 10,
    "Satin_Alma_Fisi": 11,
    "Alis_Irsaliye": 12,
    "Alinan_Siparis": 13,
    "Satis_Teklif": 14,
    "Depo_Transfer": 15,
    "Musteri_Siparis": 16
  };

  Map<int, String> MapFisTipTersENG = {
    1: "Perakende_Satis",
    2: "Satis_Fatura",
    3: "Alis_Fatura",
    4: "Perakende_Satis_Iade",
    5: "Satis_Iade_Fatura",
    6: "Perakende_Iptal",
    7: "Fatura_Iptal",
    8: "Satis_Irsaliye",
    9: "Satis_Irsaliye_Iptal",
    10: "Gider_Pusulasi",
    11: "Satin_Alma_Fisi",
    12: "Alis_Irsaliye",
    13: "Alinan_Siparis",
    14: "Satis_Teklif",
    15: "Depo_Transfer",
    16: "Musteri_Siparis",
  };


  //fonksiyonalar
    static double genelToplamHesapla(FisController fisEx, {bool KDVtipDegisti = false}) {
    double KDVTutari = 0.0;
    double urunToplami = 0.0;
    double genelUrunToplami = 0.0;
    double genelKalemIndirimToplami = 0.0;
    double araToplam = 0.0;
    double araToplam1 = 0.0;
    double kalemindirimToplami = 0.0;
    double genelToplam = 0.0;
    int anaBirimID = 0;

    for (var kur in listeler.listKur) {
      if (kur.ANABIRIM == "E") {
        anaBirimID = kur.ID!;
      }
    }
    for (FisHareket element in fisEx.fis!.value.fisStokListesi) {
      urunToplami = 0;
      kalemindirimToplami = 0;

      double brut = element.BRUTFIYAT!.toDouble();

      double kdvOrani = element.KDVORANI! / 100;
      int miktar = element.MIKTAR!;

      if (fisEx.fis!.value.DOVIZID != anaBirimID) {
        brut = brut / fisEx.fis!.value.KUR!;
      }
      /*
      if (fisEx.fis!.value.DOVIZID != element.DOVIZID) {
        if (anaBirimID != element.DOVIZID) {
          brut = brut * element.KUR!;
          brut = brut / fisEx.fis!.value.KUR!;
        } else {
          brut = brut / fisEx.fis!.value.KUR!;
        }
      }*/
/*
      if (Ctanim.KDVDahilMiDinamik == false) {
        fisEx.fis!.value.KDVDAHIL = "H";
        urunToplami += (brut * miktar);
      } 
      */
     // else {
        fisEx.fis!.value.KDVDAHIL = "E";
        //urunToplami += brut * (1 - kdvOrani) * miktar;
        urunToplami += brut / (1 + kdvOrani) * miktar;
   //   }

      double tt =
          double.parse(((element.ISK! / 100) * urunToplami).toStringAsFixed(2));
      double tt2 = double.parse(
          ((element.ISK2! / 100) * (urunToplami - tt)).toStringAsFixed(2));
      // (urunToplami - (((element.ISK! / 100) * urunToplami)));
      kalemindirimToplami = tt + tt2;
      if (KDVtipDegisti == true) {
        KDVTutari = KDVTutari + ((urunToplami - kalemindirimToplami) * kdvOrani);
      } else {
        KDVTutari =
            KDVTutari + ((urunToplami - kalemindirimToplami) * kdvOrani);
      }

      genelUrunToplami += urunToplami;

      //  alt hesap için
      
      List<AltHesapToplamModel> altHesapVarMi = fisEx.fis!.value!.altHesapToplamlar.where((altHesap) => altHesap.ALTHESAPADI! == element.ALTHESAP).toList();
      if(altHesapVarMi.isEmpty){
        AltHesapToplamModel aa = AltHesapToplamModel.empty();
        aa.ALTHESAPADI = element.ALTHESAP!;
        aa.TOPLAM = urunToplami;
        aa.STOKKODLIST!.add(element.STOKKOD!);
        fisEx.fis!.value.altHesapToplamlar.add(aa);
      }else{
        AltHesapToplamModel aa = altHesapVarMi.first;
        fisEx.fis!.value.altHesapToplamlar.removeWhere((element) => element.ALTHESAPADI == aa.ALTHESAPADI);
        if(!aa.STOKKODLIST!.contains(element.STOKKOD)){
          aa.TOPLAM = aa.TOPLAM! + urunToplami;
          aa.STOKKODLIST!.add(element.STOKKOD!);
        }
        fisEx.fis!.value!.altHesapToplamlar.add(aa);
      }
      // alt hesap için bitti

      genelKalemIndirimToplami += kalemindirimToplami;
    }

    double? controllerDeger =
        double.tryParse((fisEx.fis!.value.ISK1.toString())) ?? 0;
    double? controllerDeger2 =
        double.tryParse(fisEx.fis!.value.ISK2.toString()) ?? 0;
    double nettoplam = (urunToplami - kalemindirimToplami);

    double altIndirimToplami =
        double.parse(((nettoplam * controllerDeger / 100)).toStringAsFixed(2));
    araToplam1 =
        genelUrunToplami - genelKalemIndirimToplami - altIndirimToplami;
    if (controllerDeger2 != 0.0 && controllerDeger != 0.0) {
      altIndirimToplami += double.parse(
          (araToplam1 * controllerDeger2 / 100).toStringAsFixed(2));
    }

//
    //indirimToplami = indirimToplami + altIndirimToplami;

    araToplam = genelUrunToplami - genelKalemIndirimToplami - altIndirimToplami;

    KDVTutari = KDVTutari -
        double.parse(((controllerDeger / 100) * KDVTutari).toStringAsFixed(2));
    KDVTutari = KDVTutari -
        double.parse(((controllerDeger2 / 100) * KDVTutari).toStringAsFixed(2));
    genelToplam += araToplam + KDVTutari;
    fisEx.fis!.value.TOPLAM = Ctanim.noktadanSonraAlinacak(genelUrunToplami);
    fisEx.fis!.value.INDIRIM_TOPLAMI = Ctanim.noktadanSonraAlinacak(
        genelKalemIndirimToplami + altIndirimToplami);
    fisEx.fis!.value.ARA_TOPLAM = Ctanim.noktadanSonraAlinacak(araToplam);
    fisEx.fis!.value.KDVTUTARI = Ctanim.noktadanSonraAlinacak(KDVTutari);
    fisEx.fis!.value.GENELTOPLAM = Ctanim.noktadanSonraAlinacak(genelToplam);
    return fisEx.fis!.value.GENELTOPLAM??0;
  }

  static String donusturMusteri(String inText) {
    MoneyFormatter fmf = MoneyFormatter(amount: double.parse(inText));
    MoneyFormatterOutput fo = fmf.output;
    String tempSonTutar = fo.nonSymbol.toString();

    if (tempSonTutar.contains(",")) {
      String kusurat = "";
      List<String> gecici = tempSonTutar.split(",");
      for (int i = 1; i < gecici.length; i++) {
        if (i == gecici.length - 1) {
          String eklen = gecici[i].replaceAll(".", ",");
          kusurat = kusurat + eklen;
        } else {
          kusurat = kusurat + gecici[i] + ".";
        }
      }
      // String kusuratSon = kusurat.replaceAll(".", ",");
      String sonYazilacak = gecici[0] + "." + kusurat;
      return sonYazilacak;
    } else {
      String sonYazilacak = tempSonTutar.replaceAll(".", ",");
      return sonYazilacak;
    }
  }


  static List cariIlkIkiDon(String text) {
    String trim = text.trim();
    String harf1 = "";
    String harf2 = "";
    if (trim.length > 0) {
      harf1 = trim[0];
      if (trim.length == 1) {
        harf2 = "K";
      } else {
        harf2 = trim[1];
      }
    } else {
      harf1 = "A";
      harf2 = "B";
    }
    return [harf1, harf2];
  }

  static double noktadanSonraAlinacak(double veri) {
    String result = veri.toStringAsFixed(2);
    return double.parse(result);
  }
}
