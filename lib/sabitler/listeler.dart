import 'package:opak_fuar/model/KurModel.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/cariModel.dart';
import 'package:opak_fuar/model/olcuBirimModel.dart';
import 'package:opak_fuar/model/raporModel.dart';
import 'package:opak_fuar/model/stokKartModel.dart';

import '../model/cariKosulModel.dart';
import '../model/cariStokKosulModel.dart';
import '../model/dahaFazlaBarkodModel.dart';
import '../model/kullanıcıYetki.dart';
import '../model/stokFiyatListesiHarModel.dart';
import '../model/stokFiyatListesiModel.dart';
import '../model/stokKosulModel.dart';

class listeler {
  static List<RaporModel> listRapor = [
    RaporModel(
        ID: 1,
        UUID: '123456789',
        CARIADI: 'Cari Adı 1',
        SATIRSAYISI: 10,
        IL: 'İstanbul',
        TOPLAMTUTAR: 1000),
    RaporModel(
        ID: 2,
        UUID: '123456789',
        CARIADI: 'Cari Adı 2',
        SATIRSAYISI: 20,
        IL: 'Konya',
        TOPLAMTUTAR: 2000),
    RaporModel(
        ID: 3,
        UUID: '123456789',
        CARIADI: 'Cari Adı 3',
        SATIRSAYISI: 30,
        IL: 'Ankara',
        TOPLAMTUTAR: 3000),
    RaporModel(
        ID: 4,
        UUID: '123456789',
        CARIADI: 'Cari Adı 4',
        SATIRSAYISI: 40,
        IL: 'İzmir',
        TOPLAMTUTAR: 4000),
    RaporModel(
        ID: 5,
        UUID: '123456789',
        CARIADI: 'Cari Adı 5',
        SATIRSAYISI: 50,
        IL: 'Bolu',
        TOPLAMTUTAR: 5000),
    RaporModel(
        ID: 6,
        UUID: '123456789',
        CARIADI: 'Cari Adı 1',
        SATIRSAYISI: 10,
        IL: 'Çankırı',
        TOPLAMTUTAR: 1000),
    RaporModel(
        ID: 7,
        UUID: '123456789',
        CARIADI: 'Cari Adı 2',
        SATIRSAYISI: 20,
        IL: 'Ağrı',
        TOPLAMTUTAR: 2000),
    RaporModel(
        ID: 8,
        UUID: '123456789',
        CARIADI: 'Cari Adı 3',
        SATIRSAYISI: 30,
        IL: 'Afyonkarahisar',
        TOPLAMTUTAR: 3000),
    RaporModel(
        ID: 9,
        UUID: '123456789',
        CARIADI: 'Cari Adı 4',
        SATIRSAYISI: 40,
        IL: 'Şırnak',
        TOPLAMTUTAR: 4000),
    RaporModel(
        ID: 10,
        UUID: '123456789',
        CARIADI: 'Cari Adı 5',
        SATIRSAYISI: 50,
        IL: 'İstanbul',
        TOPLAMTUTAR: 5000),
  ];
  static List<StokKart> listStok = [];
  static List<StokKosulModel> listStokKosul = [];
  static List<CariKosulModel> listCariKosul = [];
  static List<CariStokKosulModel> listCariStokKosul = [];
  static List<StokFiyatListesiHarModel> listStokFiyatListesiHar = [];
  static List<StokFiyatListesiModel> listStokFiyatListesi = [];

  static List<DahaFazlaBarkod> listDahaFazlaBarkod = [];
  static List<KurModel> listKur = [];

  static List<Cari> listCari = [];
  static List<OlcuBirimModel> listOlcuBirim = [];
  static List<CariAltHesap> listCariAltHesap = [];
  static List<KullaniciYetki> yetki = [];
  static List<bool> plasiyerYetkileri = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
}
