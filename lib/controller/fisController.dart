import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:opak_fuar/model/cariModel.dart';

import '../db/veriTabaniIslemleri.dart';
import '../model/fis.dart';
import '../model/fisHareket.dart';
import '../sabitler/Ctanim.dart';

class FisController extends GetxController {
  RxList<FisHareket> gecmisFisHareket = <FisHareket>[].obs;
  RxList<Fis> sonListem = <Fis>[].obs;
  Rx<Fis>? fis = Fis.empty().obs;
  RxList<Fis> list_fis = <Fis>[].obs;
  RxList<Fis> list_tum_fis = <Fis>[].obs;
  RxList<Fis> list_fis_son10 = <Fis>[].obs;
  RxList<Fis> list_fis_gidecek = <Fis>[].obs;
  RxList<Fis> list_fis_giden = <Fis>[].obs;
  RxList<Fis> list_fis_cari_ozel = <Fis>[].obs;
  RxList<Fis> list_fis_kaydedilen = <Fis>[].obs;
  RxList<Fis> list_fis_giden_tarihli = <Fis>[].obs;
  RxList<Fis> list_fis_kaydedilen_tarihli = <Fis>[].obs;
  RxDouble toplam = 0.0.obs;
  late DateTime fis_tarihi;
  List<FisHareket> denemelistesi = [];

  void fiseStokEkle(
      {required bool urunListedenMiGeldin,
      required double KUR,
      int malFazlasi = 0,
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

        if(malFazlasi == null || malFazlasi == 0){
          malFazlasi = 0;
        }
    bool stokVarMi = false;
    int? fisId = fis!.value.ID;

    double HbrutFiyat = burutFiyat;
    double HnetFiyat = HbrutFiyat * (1 - iskonto / 100) * (1 - iskonto2 / 100)*(1 - iskonto3 / 100)
    * (1 - iskonto4 / 100) * (1 - iskonto5 / 100)*(1 - iskonto6 / 100);
    double Hiskonto = HbrutFiyat - HnetFiyat;
    double HkdvDahilNetFiyat = (HnetFiyat * (1 + KDVOrani / 100));
    double HkdvTutar = HnetFiyat * (KDVOrani / 100);
    double HbrutToplamFiyat = 0.0;
    double HnetToplamFiyat = 0.0;
    double HiskontoToplamFiyat = 0.0;
    double HkdvDahilNetFiyatToplam = 0.0;
    double HkdvTutarToplam = 0.0;

    for (FisHareket fisHareket in fis!.value.fisStokListesi) {
      if (fisHareket.STOKKOD == stokKodu && fisHareket.ALTHESAP == ALTHESAP) {
        stokVarMi = true;
        if (urunListedenMiGeldin == false) {
          // sepet listesi düzenle true gelecek
          fisHareket.MALFAZLASI = malFazlasi;
          fisHareket.MIKTAR =
              int.parse((fisHareket.MIKTAR! + miktar).toString());
          HbrutToplamFiyat = HbrutFiyat * fisHareket.MIKTAR!;
          HnetToplamFiyat = HnetFiyat * fisHareket.MIKTAR!;
          HiskontoToplamFiyat = Hiskonto * fisHareket.MIKTAR!;
          HkdvDahilNetFiyatToplam = HkdvDahilNetFiyat * fisHareket.MIKTAR!;
          HkdvTutarToplam = HkdvTutar * fisHareket.MIKTAR!;
        } else {
          fisHareket.MIKTAR = int.parse((miktar).toString());
          HbrutToplamFiyat = HbrutFiyat * fisHareket.MIKTAR!;
          HnetToplamFiyat = HnetFiyat * fisHareket.MIKTAR!;
          HiskontoToplamFiyat = Hiskonto * fisHareket.MIKTAR!;
          HkdvDahilNetFiyatToplam = HkdvDahilNetFiyat * fisHareket.MIKTAR!;
          HkdvTutarToplam = HkdvTutar * fisHareket.MIKTAR!;
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
      MIKTAR: int.parse(miktar.toString()),
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

    fis!.value.fisStokListesi.insert(0,yeniFisHareket);
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
    if(tt.length == 0){
      return genelToplam;

    }else{
         for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      genelToplam += element.GENELTOPLAM!;
    }

    }
 
    return genelToplam;
  }
   Future<List<Fis>> getCariToplam(String cariKod) async {
     List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'CARIKOD = ? AND AKTARILDIMI = ?', whereArgs: [cariKod,true]);
    return List<Fis>.from(result.map((json) => Fis.fromJson(json)).toList());
  }



    Future<void> listTumFisleriGetir() async {
    List<Fis> tt = await getTumfis();
    for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      List<FisHareket> fisHar = await getFisHar(element.ID!);
      element.fisStokListesi = fisHar;

      element.cariKart =
          cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD,orElse: () => element.cariKart = Cari(ADI: "CARİ GÖNDERİLMEDEN SİLİNMİŞ"),);
    }
    list_tum_fis.addAll(tt);
  }
   Future<List<Fis>> getTumfis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",  orderBy: 'ID DESC'
        );
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

  Future<void> listGidecekTekFisGetir(
      {required String belgeTip, required int fisID}) async {
    list_fis_gidecek.clear();
    List<Fis> tt = await getGidecekTekfis(belgeTip, fisID);
    for (var i = 0; i < tt.length; i++) {
      var element = tt[i];
      List<FisHareket> fisHar = await getFisHar(element.ID!);
      element.fisStokListesi = fisHar;
      if (belgeTip != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    }
    list_fis_gidecek.addAll(tt);
  }

  Future<List<Fis>> getGidecekTekfis(String belgeTip, int fisID) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'ID = ?',
        whereArgs: [
          fisID
        ]); // doprudan fiş ıd veriyosun diğer bakılacaklara gerek yok ki
    return List<Fis>.from(result.map((json) => Fis.fromJson(json)).toList());
  }

  Future<RxList<Fis>> listSonFisleriGetir() async {
    List<Fis> tt = await getSonFis();

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
      if (Ctanim().MapFisTipTersENG[element.TIP] != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    });

    list_fis_son10.assignAll(tt);
    return list_fis_son10;
  }

  Future<List<Fis>> getSonFis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'DURUM = ?', whereArgs: [false], orderBy: 'ID DESC', limit: 10);
    List<Fis> son10Fis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return son10Fis;
  }

  Future<RxList<Fis>> listGidenFisleriGetir() async {
    List<Fis> tt = await getGidenFis();

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
      if (Ctanim().MapFisTipTersENG[element.TIP] != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    });

    list_fis_giden.assignAll(tt);
    return list_fis_giden;
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

  Future<List<Fis>> getGidenFis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'AKTARILDIMI = ?',
        whereArgs: [true],
        limit: 50,
        orderBy: 'ID DESC');
    List<Fis> gidenFis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Fis>> listKaydedilmisFisleriGetir() async {
    List<Fis> tt = await getKaydedilmisFis();
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
      if (Ctanim().MapFisTipTersENG[element.TIP] != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    });

    list_fis_kaydedilen.assignAll(tt);
    return list_fis_kaydedilen;
  }

  Future<List<Fis>> getKaydedilmisFis() async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'DURUM = ? AND AKTARILDIMI = ?',
        whereArgs: [true, false],
        limit: 50,
        orderBy: 'ID DESC');
    List<Fis> gidenFis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Fis>> listTarihliGidenFisleriGetir(
      String basTar, String bitTar) async {
    List<Fis> tt = await getTarihliGidenFis(basTar, bitTar);

    // FisHareketlerini alırken forEach kullanmak yerine Future.forEach kullanın
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
      if (Ctanim().MapFisTipTersENG[element.TIP] != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    });

    list_fis_giden_tarihli.assignAll(tt);
    return list_fis_giden_tarihli;
  }

  Future<List<Fis>> getTarihliGidenFis(String basTar, String bitTar) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'AKTARILDIMI = ? AND TARIH >= ? AND TARIH <= ?',
        whereArgs: [true, basTar, bitTar],
        orderBy: 'ID DESC');
    List<Fis> gidenFis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return gidenFis;
  }

  Future<RxList<Fis>> listTarihliKaydedilenFisleriGetir(
      String basTar, String bitTar) async {
    List<Fis> tt = await getTarihliKaydedilenFis(basTar, bitTar);
    await Future.forEach(tt, (element) async {
      List<FisHareket> fisHarList = await getFisHar(element.ID!);
      element.fisStokListesi = fisHarList;
      if (Ctanim().MapFisTipTersENG[element.TIP] != "Depo_Transfer") {
        element.cariKart =
            cariEx.searchCariList.firstWhere((c) => c.KOD == element.CARIKOD);
      }
    });

    list_fis_kaydedilen_tarihli.assignAll(tt);
    return list_fis_kaydedilen_tarihli;
  }

  Future<List<Fis>> getTarihliKaydedilenFis(
      String basTar, String bitTar) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query("TBLFISSB",
        where: 'AKTARILDIMI = ? AND TARIH >= ? AND TARIH <= ? AND DURUM = ?',
        whereArgs: [false, basTar, bitTar, true],
        orderBy: 'ID DESC');
    List<Fis> gidenFis =
        List.generate(result.length, (i) => Fis.fromJson(result[i]));
    return gidenFis;
  }

  Future<int> getFisSayisi({required String belgeTipi}) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query(
      "TBLFISSB",
      columns: ["TIP"],
      where: 'DURUM = ? AND TIP = ?',
      whereArgs: [false, Ctanim().MapFisTip[belgeTipi]],
    );
    return result.length;
  }

  Future<int> getFislerSayisi(
      {required String belgeTipi1,
      required String belgeTipi2,
      required String belgeTipi3}) async {
    List<Map<String, dynamic>> result = await Ctanim.db?.query(
      "TBLFISSB",
      columns: ["TIP"],
      where: 'DURUM = ? AND (TIP = ? OR TIP = ? OR TIP = ?)',
      whereArgs: [
        false,
        Ctanim().MapFisTip[belgeTipi1],
        Ctanim().MapFisTip[belgeTipi2],
        Ctanim().MapFisTip[belgeTipi3]
      ],
    );
    return result.length;
  }

  Widget gecmisSatisYok() {
    return Center(child: Text("Geçmiş Satış Bilgisi Bulunamadı."));
  }

  Future<void> listFisStokHareketGetir(String Kod) async {
    gecmisFisHareket.clear();
    sonListem.clear();

    List<Map<String, dynamic>> result = await Ctanim.db
        ?.query("TBLFISHAR", where: 'STOKKOD = ?', whereArgs: [Kod]);
    if (result.isEmpty) {
      gecmisSatisYok();
      return;
    }

    String fisIDs = result
        .map((e) => e['FIS_ID'].toString())
        .join(','); // fiş idler , ayrılıp stringe at

    List<Map<String, dynamic>> donus = await Ctanim.db?.query("TBLFISSB",
        where: 'ID IN ($fisIDs)'); // Tüm fişler tek seferde getirilir

    for (Map<String, dynamic> fisMap in donus) {
      Fis fis = Fis.fromJson(fisMap);

      // Fişteki stok hareketlerinden sadece Kod'a uygun olanlar seçilir ve gecmisFisHareket listesine eklenir
      List<FisHareket> fisHareketleri = result
          .where((e) => e['FIS_ID'] == fis.ID && e['STOKKOD'] == Kod)
          .map((e) => FisHareket.fromJson(e))
          .toList();
      fis.fisStokListesi = fisHareketleri;

      sonListem.add(Fis.fromFis(fis, fisHareketleri));
    }
  }
}
