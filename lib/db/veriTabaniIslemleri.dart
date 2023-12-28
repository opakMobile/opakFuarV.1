import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:opak_fuar/model/KurModel.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/cariModel.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';

import '../controller/cariController.dart';
import '../controller/stokKartController.dart';
import '../model/dahaFazlaBarkodModel.dart';
import '../model/stokFiyatListesiHarModel.dart';
import '../model/stokFiyatListesiModel.dart';

CariController cariEx = Get.find();
final StokKartController stokKartEx = Get.find();

class VeriIslemleri {
  Future<List<StokKart>?> stokGetir() async {
    var result = await Ctanim.db?.query("TBLSTOKSB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLSTOKSB");
    listeler.listStok =
        List.generate(maps.length, (i) => StokKart.fromJson(maps[i]));
    stokKartEx.searchList.assignAll(listeler.listStok);

    return listeler.listStok;
  }

  //database stokları güncelle
  Future<int?> stokGuncelle(StokKart stokKart) async {
    var result = await Ctanim.db?.update("TBLSTOKSB", stokKart.toJson(),
        where: 'ID = ?', whereArgs: [stokKart.ID]);
    return result;
  }

  //database stok ekle
  Future<int?> stokEkle(StokKart stokKart, {bool yeniStokMu = false}) async {
    try {
      stokKart.ID = null;
      var result = await Ctanim.db?.insert("TBLSTOKSB", stokKart.toJson());
      if (yeniStokMu == true) {
        listeler.listStok.add(stokKart);
      }
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> stokTabloTemizle() async {
    try {
      await Ctanim.db?.delete("TBLSTOKSB");
      print("TBLSTOKSB tablosu temizlendi.");

      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLSTOKSB");

      await Ctanim.db?.execute("""CREATE TABLE TBLSTOKSB (
         ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      KOD TEXT NOT NULL,
      ADI TEXT NOT NULL,
      SATDOVIZ TEXT,
      ALDOVIZ TEXT ,
      SATIS_KDV DECIMAL ,
      STOKTIP TEXT,
      ALIS_KDV DECIMAL,
      SFIYAT1 DECIMAL ,
      SFIYAT2 DECIMAL ,
      SFIYAT3 DECIMAL ,
      SFIYAT4 DECIMAL ,
      SFIYAT5 DECIMAL ,
      AFIYAT1 DECIMAL ,
      AFIYAT2 DECIMAL ,
      AFIYAT3 DECIMAL ,
      AFIYAT4 DECIMAL ,
      AFIYAT5 DECIMAL ,
      OLCUBIRIM1 TEXT ,
      OLCUBIRIM2 TEXT ,
      BIRIMADET1 TEXT ,
      OLCUBIRIM3 TEXT ,
      BIRIMADET2 TEXT ,
      RAPORKOD1 TEXT ,
      RAPORKOD1ADI TEXT ,
      RAPORKOD2 TEXT ,
      RAPORKOD2ADI TEXT ,
      RAPORKOD3 TEXT ,
      RAPORKOD3ADI TEXT ,
      RAPORKOD4 TEXT ,
      RAPORKOD4ADI TEXT ,
      RAPORKOD5 TEXT ,
      RAPORKOD5ADI TEXT ,
      RAPORKOD6 TEXT ,
      RAPORKOD6ADI TEXT ,
      RAPORKOD7 TEXT ,
      RAPORKOD7ADI TEXT ,
      RAPORKOD8 TEXT ,
      RAPORKOD8ADI TEXT ,
      RAPORKOD9 TEXT ,
      RAPORKOD9ADI TEXT ,
      RAPORKOD10 TEXT ,
      RAPORKOD10ADI TEXT ,
      URETICI_KODU TEXT ,
      URETICIBARKOD TEXT ,
      RAF TEXT ,
      GRUP_KODU TEXT ,
      GRUP_ADI TEXT ,
      ACIKLAMA TEXT ,
      ACIKLAMA1 TEXT ,
      ACIKLAMA2 TEXT ,
      ACIKLAMA3 TEXT ,
      ACIKLAMA4 TEXT ,
      ACIKLAMA5 TEXT ,
      ACIKLAMA6 TEXT ,
      ACIKLAMA7 TEXT ,
      ACIKLAMA8 TEXT ,
      ACIKLAMA9 TEXT ,
      ACIKLAMA10 TEXT ,
      SACIKLAMA1 TEXT ,
      SACIKLAMA2 TEXT ,
      SACIKLAMA3 TEXT ,
      SACIKLAMA4 TEXT ,
      SACIKLAMA5 TEXT ,
      SACIKLAMA6 TEXT ,
      SACIKLAMA7 TEXT ,
      SACIKLAMA8 TEXT ,
      SACIKLAMA9 TEXT ,
      SACIKLAMA10 TEXT ,
      KOSULGRUP_KODU TEXT ,
      KOSULALISGRUP_KODU TEXT ,
      MARKA TEXT ,
      AKTIF TEXT ,
      TIP TEXT ,
      B2CFIYAT DECIMAL ,
      B2CDOVIZ TEXT ,
      BARKOD1 TEXT ,
      BARKOD2 TEXT ,
      BARKOD3 TEXT ,
      BARKOD4 TEXT ,
      BARKOD5 TEXT ,
      BARKOD6 TEXT ,
      BARKODCARPAN1 DECIMAL ,
      BARKODCARPAN2 DECIMAL ,
      BARKODCARPAN3 DECIMAL ,
      BARKODCARPAN4 DECIMAL ,
      BARKODCARPAN5 DECIMAL ,
      BARKODCARPAN6 DECIMAL ,
      BARKOD1BIRIMADI TEXT ,
      BARKOD2BIRIMADI TEXT ,
      BARKOD3BIRIMADI TEXT ,
      BARKOD4BIRIMADI TEXT ,
      BARKOD5BIRIMADI TEXT ,
      BARKOD6BIRIMADI TEXT ,
      DAHAFAZLABARKOD TEXT ,
      BIRIM_AGIRLIK DECIMAL ,
      EN DECIMAL ,
      BOY DECIMAL ,
      YUKSEKLIK DECIMAL ,
      SATISISK DECIMAL ,
      ALISISK DECIMAL ,
      B2BFIYAT DECIMAL ,
      B2BDOVIZ TEXT ,
      LISTEFIYAT DECIMAL ,
      OLCUBR1 INTEGER,
      OLCUBR2 INTEGER,
      OLCUBR3 INTEGER,
      OLCUBR4 INTEGER,
      OLCUBR5 INTEGER,
      OLCUBR6 INTEGER,
      BARKODFIYAT1 DECIMAL,
      BARKODFIYAT2 DECIMAL,
      BARKODFIYAT3 DECIMAL,
      BARKODFIYAT4 DECIMAL,
      BARKODFIYAT5 DECIMAL,
      BARKODFIYAT6 DECIMAL,
      BARKODISK1 DECIMAL,
      BARKODISK2 DECIMAL,
      BARKODISK3 DECIMAL,
      BARKODISK4 DECIMAL,
      BARKODISK5 DECIMAL,
      BARKODISK6 DECIMAL,
      BAKIYE DECIMAL,
      LISTEDOVIZ TEXT 
      )""");

      print("TBLCARISB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<List<Cari>?> cariGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLCARISB");
    listeler.listCari =
        List.generate(maps.length, (i) => Cari.fromJson(maps[i]));

    cariEx.searchCariList.assignAll(listeler.listCari);

    await cariAltHesapGetir();
    return listeler.listCari;
  }

  //database carileri güncelle
  Future<int?> cariGuncelle(Cari cariKart) async {
    var result = await Ctanim.db?.update("TBLCARISB", cariKart.toJson(),
        where: 'ID = ?', whereArgs: [cariKart.ID]);
    return result;
  }

  //database cari ekle
  Future<int?> cariEkle(Cari cariKart) async {
    try {
      cariKart.ID = null;
      var result = await Ctanim.db?.insert("TBLCARISB", cariKart.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> cariTabloTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLCARISB");
      print("TBLCARISB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLCARISB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""CREATE TABLE TBLCARISB (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      KOSULID INTEGER ,
      KOD TEXT NOT NULL,
      ADI TEXT NOT NULL,
      ILCE TEXT,
      IL TEXT ,
      ADRES TEXT ,
      VERGIDAIRESI TEXT,
      VERGINO TEXT ,
      KIMLIKNO TEXT ,
      TIPI TEXT ,
      TELEFON TEXT ,
      FAX TEXT ,
      FIYAT INTEGER ,
      ULKEID INTEGER ,
      EMAIL TEXT ,
      WEB TEXT ,
      PLASIYERID INTEGER ,
      ISKONTO DECIMAL ,
      EFATURAMI TEXT ,
      VADEGUNU TEXT ,
      BAKIYE DECIMAL 
      )""");

      print("TBLCARISB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> cariAltHesapTabloTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLCARIALTHESAPSB");
      print("TBLCARIALTHESAPSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLCARIALTHESAPSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute(""" CREATE TABLE TBLCARIALTHESAPSB (
      KOD TEXT ,
      ALTHESAP TEXT,
      DOVIZID INTEGER,
      VARSAYILAN TEXT
    )""");

      print("TBLCARIALTHESAPSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<List<CariAltHesap>?> cariAltHesapGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLCARIALTHESAPSB");

    listeler.listCariAltHesap =
        List.generate(maps.length, (i) => CariAltHesap.fromJson(maps[i]));

    for (int i = 0; i < listeler.listCari.length; i++) {
      for (var element2 in listeler.listCariAltHesap) {
        if (listeler.listCari[i].KOD == element2.KOD) {
          listeler.listCari[i].cariAltHesaplar.add(element2);
        }
      }
    }
    return listeler.listCariAltHesap;
  }

  //database carileri güncelle
  Future<int?> cariAltHesapGuncelle(CariAltHesap cariAltHesap) async {
    var result = await Ctanim.db?.update(
        "TBLCARIALTHESAPSB", cariAltHesap.toJson(),
        where: 'KOD = ?', whereArgs: [cariAltHesap.KOD]);
    return result;
  }

  //database cari ekle
  Future<int?> cariAltHesapEkle(CariAltHesap cariAltHesap) async {
    try {
      // cariAltHesap.KOD = null;
      var result =
          await Ctanim.db?.insert("TBLCARIALTHESAPSB", cariAltHesap.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<int?> kurEkle(KurModel kurModel) async {
    try {
      var result = await Ctanim.db?.insert("TBLKURSB", kurModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> kurTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLKURSB');
    }
  }

  Future<void> kurGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listKur.clear();
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLKURSB");
    listeler.listKur =
        List.generate(maps.length, (i) => KurModel.fromJson(maps[i]));
    print(listeler.listKur);
  }

  Future<List<DahaFazlaBarkod>?> dahaFazlaBarkodGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLDAHAFAZLABARKODSB");
    listeler.listDahaFazlaBarkod =
        List.generate(maps.length, (i) => DahaFazlaBarkod.fromJson(maps[i]));

    return listeler.listDahaFazlaBarkod;
  }

  Future<void> stokFiyatListesiGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listStokFiyatListesi.clear();
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLSTOKFIYATLISTESISB");
    listeler.listStokFiyatListesi = List.generate(
        maps.length, (i) => StokFiyatListesiModel.fromJson(maps[i]));
    print(listeler.listStokFiyatListesi);
  }

  Future<void> stokFiyatListesiTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLSTOKFIYATLISTESISB');
    }
  }

  Future<int?> stokFiyatListesiEkle(
      StokFiyatListesiModel stokFiyatListesiModel) async {
    try {
      var result = await Ctanim.db
          ?.insert("TBLSTOKFIYATLISTESISB", stokFiyatListesiModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<int?> stokFiyatListesiHarEkle(
      StokFiyatListesiHarModel stokFiyatListesiHarModel) async {
    try {
      var result = await Ctanim.db?.insert(
          "TBLSTOKFIYATLISTESIHARSB", stokFiyatListesiHarModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> stokFiyatListesiHarGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listStokFiyatListesiHar.clear();
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLSTOKFIYATLISTESIHARSB");
    listeler.listStokFiyatListesiHar = List.generate(
        maps.length, (i) => StokFiyatListesiHarModel.fromJson(maps[i]));
    print(listeler.listStokFiyatListesiHar);
  }

  Future<int> veriGetir() async {
    //  await fisEkParamGetir();
    // await ondalikGetir();
    //   await islemTipiGetir();
    //   await plasiyerBankaGetir();
//    await plasiyerBankaSozlesmeGetir();
    await stokFiyatListesiGetir();
    await stokFiyatListesiHarGetir();
    //   await rafGetir();
    //   await olcuBirimGetir();
    await kurGetir();
//    await cariKosulGetir();
//    await stokKosulGetir();
    //   await cariStokKosulGetir();
    await dahaFazlaBarkodGetir();
    List<StokKart>? temp1 = await stokGetir();
    List<Cari>? temp2 = await cariGetir();
    // List<SubeDepoModel>? temp3 = await subeDepoGetir();
    if (temp1!.length > 0 || temp2!.length > 0 /* || temp3!.length > 0*/) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<int?> dahaFazlaBarkodGuncelle(DahaFazlaBarkod dahaFazlaBarkod) async {
    var result = await Ctanim.db?.update(
        "TBLDAHAFAZLABARKODSB", dahaFazlaBarkod.toJson(),
        where: 'BARKOD = ?', whereArgs: [dahaFazlaBarkod.BARKOD]);
    return result;
  }

  Future<int?> dahaFazlaBarkodEkle(DahaFazlaBarkod dahaFazlaBarkod) async {
    try {
      var result = await Ctanim.db
          ?.insert("TBLDAHAFAZLABARKODSB", dahaFazlaBarkod.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
