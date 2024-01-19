import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:opak_fuar/model/cariModel.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';

import '../db/veriTabaniIslemleri.dart';
import '../model/fis.dart';
import '../model/fisHareket.dart';
import '../sabitler/Ctanim.dart';

class FisController extends GetxController {
  Rx<Fis>? fis = Fis.empty().obs;
  RxList<Fis> list_fis = <Fis>[].obs;
  RxList<Fis> list_tum_fis = <Fis>[].obs;
  RxList<Fis> list_fis_son = <Fis>[].obs;
  RxList<Fis> list_fis_gidecek = <Fis>[].obs;
  RxList<Fis> list_fis_cari_ozel = <Fis>[].obs;
  RxDouble toplam = 0.0.obs;
  late DateTime fis_tarihi;
  List<FisHareket> denemelistesi = [];
  //s

  void fiseStokEkle(
      {
      bool altHesapDegistirMi = false,  
      required bool urunListedenMiGeldin,
      required double KUR,
      required int malFazlasi,
      required String ALTHESAP,
      required String TARIH,
      required String Aciklama1,
      required String UUID,
      required String stokAdi,
      required String stokKodu,
      required double KDVOrani,
      required int miktar,
      required double burutFiyat,
      required double iskonto,
      required double iskonto2,
      required double iskonto3,
      required double iskonto4,
      required double iskonto5,
      required double iskonto6,
      required String birim,
      required int birimID,
      required int dovizId,
      required String dovizAdi}) {
    if (malFazlasi == null || malFazlasi == 0) {
      malFazlasi = 0;
    }

    int tempMiktar = miktar;
    int a = (miktar / (1 + (malFazlasi / 100))).ceil();
    print(a);
    if (a > 0) {
      miktar = a;
    }else{
      malFazlasi = 0;
    }

    bool stokVarMi = false;
    int? fisId = fis!.value.ID;

    double HbrutFiyat = burutFiyat;
    double HnetFiyat = HbrutFiyat *
        (1 - iskonto / 100) *
        (1 - iskonto2 / 100) *
        (1 - iskonto3 / 100) *
        (1 - iskonto4 / 100) *
        (1 - iskonto5 / 100) *
        (1 - iskonto6 / 100);
    double Hiskonto = HbrutFiyat - HnetFiyat;
    double HkdvDahilNetFiyat = (HnetFiyat * (1 + KDVOrani / 100));
    double HkdvTutar = HnetFiyat * (KDVOrani / 100);
    double HbrutToplamFiyat = 0.0;
    double HnetToplamFiyat = 0.0;
    double HiskontoToplamFiyat = 0.0;
    double HkdvDahilNetFiyatToplam = 0.0;
    double HkdvTutarToplam = 0.0;
/*
    if(altHesapDegistirMi == true){
       FisHareket? silinecek ;
      for(var element in fisEx.fis!.value!.fisStokListesi){
        if(stokKodu == element.STOKKOD && ALTHESAP == element.ALTHESAP &&element.MIKTAR! != tempMiktar){
          int altHesapMiktar = element.MIKTAR!;
        silinecek = element;
          tempMiktar += altHesapMiktar;

        }
      }
      if(silinecek !=null){
      fisEx.fis!.value!.fisStokListesi.remove(silinecek);

      }

    }
    */

    for (FisHareket fisHareket in fis!.value.fisStokListesi) {
      if (fisHareket.STOKKOD == stokKodu && fisHareket.ALTHESAP == ALTHESAP) {

        stokVarMi = true;
        if (urunListedenMiGeldin == false) {
          // sepet listesi düzenle true gelecek
          fisHareket.MALFAZLASI = malFazlasi;
          fisHareket.MIKTAR =
              int.parse((fisHareket.MIKTAR! + tempMiktar).toString());
          HbrutToplamFiyat = HbrutFiyat * miktar;
          HnetToplamFiyat = HnetFiyat * miktar;
          HiskontoToplamFiyat = Hiskonto * miktar;
          HkdvDahilNetFiyatToplam = HkdvDahilNetFiyat * miktar;
          HkdvTutarToplam = HkdvTutar * miktar;
        } else {
          fisHareket.MALFAZLASI = malFazlasi;
          fisHareket.MIKTAR = int.parse((tempMiktar).toString());
          HbrutToplamFiyat = HbrutFiyat * miktar;
          HnetToplamFiyat = HnetFiyat * miktar;
          HiskontoToplamFiyat = Hiskonto * miktar;
          HkdvDahilNetFiyatToplam = HkdvDahilNetFiyat * miktar;
          HkdvTutarToplam = HkdvTutar * miktar;
        }

        fisHareket.KDVORANI = Ctanim.noktadanSonraAlinacak(KDVOrani);
        fisHareket.BRUTFIYAT = Ctanim.noktadanSonraAlinacak(HbrutFiyat);
        fisHareket.ISKONTO = Ctanim.noktadanSonraAlinacak(Hiskonto);
        fisHareket.KDVDAHILNETFIYAT =
            Ctanim.noktadanSonraAlinacak(HkdvDahilNetFiyat);
        fisHareket.KDVTUTAR = Ctanim.noktadanSonraAlinacak(HkdvTutar);
        fisHareket.NETFIYAT = Ctanim.noktadanSonraAlinacak(HnetFiyat);
        fisHareket.NETTOPLAM = Ctanim.noktadanSonraAlinacak(HnetToplamFiyat);
        fisHareket.BRUTTOPLAMFIYAT =
            Ctanim.noktadanSonraAlinacak(HbrutToplamFiyat);
        fisHareket.ISKONTOTOPLAM =
            Ctanim.noktadanSonraAlinacak(HiskontoToplamFiyat);
        fisHareket.KDVDAHILNETTOPLAM =
            Ctanim.noktadanSonraAlinacak(HkdvDahilNetFiyatToplam);
        fisHareket.KDVTOPLAM = Ctanim.noktadanSonraAlinacak(HkdvTutarToplam);
        fisHareket.ISK = Ctanim.noktadanSonraAlinacak(iskonto);
        fisHareket.ISK2 = Ctanim.noktadanSonraAlinacak(iskonto2);
        fisHareket.ISK3 = Ctanim.noktadanSonraAlinacak(iskonto3);
        fisHareket.ISK4 = Ctanim.noktadanSonraAlinacak(iskonto4);
        fisHareket.ISK5 = Ctanim.noktadanSonraAlinacak(iskonto5);
        fisHareket.ISK6 = Ctanim.noktadanSonraAlinacak(iskonto6);
        //fisHareket.BURUTFIYAT = burutFiyat;
        //fisHareket.ISK = iskonto;

        // fisHareket.NETFIYAT = burutFiyat * (1 - iskonto / 100);
        //fisHareket.KDVDAHILNETFIYAT =
        //  (burutFiyat * (1 - iskonto / 100)) * miktar;

        return;
      }
    }
    HbrutToplamFiyat = HbrutFiyat * miktar;
    HnetToplamFiyat = HnetFiyat * miktar;
    HiskontoToplamFiyat = Hiskonto * miktar;
    HkdvDahilNetFiyatToplam = HkdvDahilNetFiyat * miktar;
    HkdvTutarToplam = HkdvTutar * miktar;
    FisHareket yeniFisHareket = FisHareket(
      MALFAZLASI: malFazlasi ?? 0,
      ALTHESAP: ALTHESAP,
      UUID: UUID,
      TARIH: TARIH,
      KUR: KUR,
      ACIKLAMA1: Aciklama1,
      ID: 0,
      FIS_ID: fisId,
      STOKKOD: stokKodu,
      STOKADI: stokAdi,
      KDVORANI: KDVOrani,
      MIKTAR: int.parse(tempMiktar.toString()),
      BRUTFIYAT: Ctanim.noktadanSonraAlinacak(HbrutFiyat),
      ISK: iskonto,
      ISK2: iskonto2,
      ISK3: iskonto3,
      ISK4: iskonto4,
      ISK5: iskonto5,
      ISK6: iskonto6,
      ISKONTO: Ctanim.noktadanSonraAlinacak(Hiskonto),
      KDVDAHILNETFIYAT: Ctanim.noktadanSonraAlinacak(HkdvDahilNetFiyat),
      KDVTUTAR: Ctanim.noktadanSonraAlinacak(HkdvTutar),
      NETFIYAT: Ctanim.noktadanSonraAlinacak(HnetFiyat),
      BRUTTOPLAMFIYAT: Ctanim.noktadanSonraAlinacak(HbrutToplamFiyat),
      BIRIM: birim,
      BIRIMID: birimID,
      DOVIZADI: dovizAdi,
      DOVIZID: dovizId,
      ISKONTOTOPLAM: Ctanim.noktadanSonraAlinacak(HiskontoToplamFiyat),
      KDVDAHILNETTOPLAM: Ctanim.noktadanSonraAlinacak(HkdvDahilNetFiyatToplam),
      KDVTOPLAM: Ctanim.noktadanSonraAlinacak(HkdvTutarToplam),
      NETTOPLAM: Ctanim.noktadanSonraAlinacak(HnetToplamFiyat),
    );

    fis!.value.fisStokListesi.insert(0, yeniFisHareket);
  }

  Future<List<FisHareket>> getFisHar(int fisId) async {
    List<Map<String, dynamic>> result = await Ctanim.db
        ?.query("TBLFISHAR", where: 'FIS_ID = ? ', whereArgs: [fisId]);
    List<FisHareket> tt1 =
        List.generate(result.length, (i) => FisHareket.fromJson(result[i]));
    return tt1;
  }

  Future<double> cariToplamGetir(String cariKod) async {
    List<Fis> tt = await getCariToplam(cariKod);
    double genelToplam = 0;
    if (tt.length == 0) {
      return genelToplam;
    } else {
      for (var i = 0; i < tt.length; i++) {
        var element = tt[i];
        genelToplam += element.GENELTOPLAM!;
      }
    }

    return genelToplam;
  }

  Future<List<Fis>> getCariToplam(String cariKod) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'CARIKOD = ? AND AKTARILDIMI = ?', whereArgs: [cariKod, true]);
    return List<Fis>.from(result.map((json) => Fis.fromJson(json)).toList());
  }

  Future<void> listTumFisleriGetir() async {
    List<Fis> tt = await getTumfis();
    for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      List<FisHareket> fisHar = await getFisHar(element.ID!);
      element.fisStokListesi = fisHar;

      element.cariKart = cariEx.searchCariList.firstWhere(
        (c) => c.KOD == element.CARIKOD,
        orElse: () =>
            element.cariKart = Cari(ADI: "CARİ GÖNDERİLMEDEN SİLİNMİŞ"),
      );
    }
    list_tum_fis.addAll(tt);
  }

  Future<List<Fis>> getTumfis() async {
    List<Map<String, dynamic>> result =
        await Ctanim.db?.query("TBLFISSB", orderBy: 'ID DESC');
    return List<Fis>.from(result.map((json) => Fis.fromJson(json)).toList());
  }

  Future<void> listGidecekFisGetir() async {
    List<Fis> tt = await getGidecekfis();
    for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      List<FisHareket> fisHar = await getFisHar(element.ID!);
      element.fisStokListesi = fisHar;

      element.cariKart =
          cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
    }
    list_fis_gidecek.addAll(tt);
  }

  Future<List<Fis>> getGidecekfis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'DURUM = ? AND AKTARILDIMI = ?', whereArgs: [true, false]);
    return List<Fis>.from(result.map((json) => Fis.fromJson(json)).toList());
  }





  Future<RxList<Fis>> listSonFisGetir() async {
    List<Fis> tt = await getSonFis();

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
      element.cariKart =
          cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);

     
    });

    list_fis_son.assignAll(tt);
    return list_fis_son;
  }

  Future<List<Fis>> getSonFis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'DURUM = ?', whereArgs: [true], orderBy: 'ID DESC', limit: 1);
    List<Fis> son10Fis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return son10Fis;
  }



  Future<List<Fis>> getCariFis(String cariadi) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'CARIADI = ?', whereArgs: [cariadi], orderBy: 'ID DESC');
    List<Fis> gidenFis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Fis>> listCariFisGetir(String cariadi) async {
    List<Fis> tt = await getCariFis(cariadi);
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
    });

    list_fis_cari_ozel.assignAll(tt);
    return list_fis_cari_ozel;
  }
}
