import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import '../db/veriTabaniIslemleri.dart';
import '../model/cariModel.dart';
import '../model/satisTipiModel.dart';
import '../model/stokFiyatListesiModel.dart';
import '../model/stokKartModel.dart';
import '../sabitler/Ctanim.dart';
import '../webservis/base.dart';
import '../sabitler/listeler.dart';

class StokKartController extends GetxController {
  RxList<StokKart> searchList = <StokKart>[].obs;
  RxList<StokKart> tempList = <StokKart>[].obs;

  // RxList<StokKart> stoklar = stoklar.obs;
  BaseService bs = BaseService();
  VeriIslemleri veriislemi = VeriIslemleri();

  @override
  void onInit() {
    super.onInit();
  }

/*  void sepetGuncellenenStok(int index, double iskonto, String fiyat) {
    var stokKart = searchList[index];

    stokKart.SATISISK = iskonto;
    stokKart.SFIYAT1 = double.parse(fiyat);
    update();
  }*/

  List<dynamic> fiyatgetir(
      StokKart Stok,
      String CariKod,
      String _FiyatTip,
      SatisTipiModel satisTipi,
      StokFiyatListesiModel stokFiyatListesi,
      int seciliAltHesapID) {
    bool fiyatDegistirsinMi = false;
    if (Ctanim.kullanici!.FIYATDEGISTIRILSIN == "E") {
      fiyatDegistirsinMi = true;
    }

    String Fiyattip = _FiyatTip;
    double kosulYoksaTekrarDonecek = 0.0;
    Cari seciliCari = Cari();
    double iskontoDegeri1 = 0;
    double iskontoDegeri2 = 0;
    double iskontoDegeri3 = 0;
    double iskontoDegeri4 = 0;
    double iskontoDegeri5 = 0;
    double iskontoDegeri6 = 0;
    Stok.guncelDegerler!.guncelDegerSifirla();

    for (var cari in listeler.listCari) {
      if (cari.KOD == CariKod) {
        seciliCari = cari;
      }
    }

    Fiyattip = Fiyattip;
    String seciliFiyat = "";
    double kosuldanDonenFiyat = 0.0;
    if (CariKod != '') {
      if (satisTipi.ID != -1) {
        double iskonto = 0.0;
        if (satisTipi.ISK1 == "S.Açıklama 1") {
          iskonto = double.parse(Stok.SACIKLAMA1.toString());
        } else if (satisTipi.ISK1 == "S.Açıklama 2") {
          iskonto = double.parse(Stok.SACIKLAMA2.toString());
        } else if (satisTipi.ISK1 == "S.Açıklama 3") {
          iskonto = double.parse(Stok.SACIKLAMA3.toString());
        } else if (satisTipi.ISK1 == "S.Açıklama 4") {
          iskonto = double.parse(Stok.SACIKLAMA4.toString());
        } else if (satisTipi.ISK1 == "S.Açıklama 5") {
          iskonto = double.parse(Stok.SACIKLAMA5.toString());
        } else if (satisTipi.ISK1 == "S Fiyat 1") {
          iskonto = double.parse(Stok.SFIYAT1.toString());
        } else if (satisTipi.ISK1 == "S Fiyat 2") {
          iskonto = double.parse(Stok.SFIYAT2.toString());
        } else if (satisTipi.ISK1 == "S Fiyat 3") {
          iskonto = double.parse(Stok.SFIYAT3.toString());
        } else if (satisTipi.ISK1 == "S Fiyat 4") {
          iskonto = double.parse(Stok.SFIYAT4.toString());
        } else if (satisTipi.ISK1 == "S Fiyat 5") {
          iskonto = double.parse(Stok.SFIYAT5.toString());
        } else if (satisTipi.ISK1 == "A Fiyat 1") {
          iskonto = double.parse(Stok.AFIYAT1.toString());
        } else if (satisTipi.ISK1 == "A Fiyat 2") {
          iskonto = double.parse(Stok.AFIYAT2.toString());
        } else if (satisTipi.ISK1 == "A Fiyat 3") {
          iskonto = double.parse(Stok.AFIYAT3.toString());
        } else if (satisTipi.ISK1 == "A Fiyat 4") {
          iskonto = double.parse(Stok.AFIYAT4.toString());
        } else if (satisTipi.ISK1 == "A Fiyat 5") {
          iskonto = double.parse(Stok.AFIYAT5.toString());
        } else if (satisTipi.ISK1 == "Satış İsk.") {
          iskonto = double.parse(Stok.SATISISK.toString());
        } else if (satisTipi.ISK1 == "Alış İsk.") {
          iskonto = double.parse(Stok.ALISISK.toString());
        }
        double fiyat = 0.0;
        if (satisTipi.FIYATTIP == "S.Açıklama 1") {
          fiyat = double.parse(Stok.SACIKLAMA1.toString());
        } else if (satisTipi.FIYATTIP == "S.Açıklama 2") {
          fiyat = double.parse(Stok.SACIKLAMA2.toString());
        } else if (satisTipi.FIYATTIP == "S.Açıklama 3") {
          fiyat = double.parse(Stok.SACIKLAMA3.toString());
        } else if (satisTipi.FIYATTIP == "S.Açıklama 4") {
          fiyat = double.parse(Stok.SACIKLAMA4.toString());
        } else if (satisTipi.FIYATTIP == "S.Açıklama 5") {
          fiyat = double.parse(Stok.SACIKLAMA5.toString());
        } else if (satisTipi.FIYATTIP == "S Fiyat 1") {
          fiyat = double.parse(Stok.SFIYAT1.toString());
        } else if (satisTipi.FIYATTIP == "S Fiyat 2") {
          fiyat = double.parse(Stok.SFIYAT2.toString());
        } else if (satisTipi.FIYATTIP == "S Fiyat 3") {
          fiyat = double.parse(Stok.SFIYAT3.toString());
        } else if (satisTipi.FIYATTIP == "S Fiyat 4") {
          fiyat = double.parse(Stok.SFIYAT4.toString());
        } else if (satisTipi.FIYATTIP == "S Fiyat 5") {
          fiyat = double.parse(Stok.SFIYAT5.toString());
        } else if (satisTipi.FIYATTIP == "A Fiyat 1") {
          fiyat = double.parse(Stok.AFIYAT1.toString());
        } else if (satisTipi.FIYATTIP == "A Fiyat 2") {
          fiyat = double.parse(Stok.AFIYAT2.toString());
        } else if (satisTipi.FIYATTIP == "A Fiyat 3") {
          fiyat = double.parse(Stok.AFIYAT3.toString());
        } else if (satisTipi.FIYATTIP == "A Fiyat 4") {
          fiyat = double.parse(Stok.AFIYAT4.toString());
        } else if (satisTipi.FIYATTIP == "A Fiyat 5") {
          fiyat = double.parse(Stok.AFIYAT5.toString());
        } else if (satisTipi.FIYATTIP == "Satış İsk.") {
          fiyat = double.parse(Stok.SATISISK.toString());
        } else if (satisTipi.FIYATTIP == "Alış İsk.") {
          fiyat = double.parse(Stok.ALISISK.toString());
        }

        return [
          fiyat,
          iskonto,
          Ctanim.seciliIslemTip.TIP,
          false,
          0.0,
          0.0,
          0.0,
          0.0,
          0.0
        ];
      } else {
        if (Ctanim.kullanici!.SATISTIPI == "0") {
          StokKart ff = searchList.where((p0) => p0.KOD == Stok.KOD).first;

          if (Fiyattip == 'Fiyat1') {
            kosulYoksaTekrarDonecek == ff.SFIYAT1;
            //double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [
              ff.SFIYAT1,
              ff.SATISISK,
              "Fiyat1",
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else if (Fiyattip == 'Fiyat2') {
            // iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == ff.SFIYAT2;
            // double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [
              ff.SFIYAT2,
              ff.SATISISK,
              "Fiyat2",
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else if (Fiyattip == 'Fiyat3') {
            // iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == ff.SFIYAT3;
            // double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [
              ff.SFIYAT3,
              ff.SATISISK,
              "Fiyat3",
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else if (Fiyattip == 'Fiyat4') {
            // iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == ff.SFIYAT4;
            //double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [
              ff.SFIYAT4,
              ff.SATISISK,
              "Fiyat4",
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else if (Fiyattip == 'Fiyat5') {
            // iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == ff.SFIYAT5;
            //double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [
              ff.SFIYAT5,
              ff.SATISISK,
              "Fiyat5",
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else if (Fiyattip == 'ListeFiyat') {
            // iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == ff.LISTEFIYAT;
            //double iskonto = iskontoGetir(Stok.KOD, CariKod);
            return [
              ff.LISTEFIYAT,
              ff.SATISISK,
              "ListeFiyat",
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else {
            //double iskonto = iskontoGetir(Stok.KOD, CariKod);
            kosulYoksaTekrarDonecek == 0.0;
            return [0.0, ff.SATISISK, Fiyattip, true, 0.0, 0.0, 0.0, 0.0, 0.0];
          }
        } else if (Ctanim.kullanici!.SATISTIPI == "1") {
          // opak kosul
          for (var element in listeler.listStokKosul) {
            if (element.KOSULID == seciliCari.KOSULID &&
                element.GRUPKODU == Stok.KOSULGRUP_KODU &&
                (element.ALTHESAPID == seciliAltHesapID || element.ALTHESAPID == 0)) {
              // stok kosul var
              if (element.ISK1 != 0) {
                iskontoDegeri1 = element.ISK1!;
              }
              if (element.ISK2 != 0) {
                iskontoDegeri2 = element.ISK2!;
              }
              if (element.ISK3 != 0) {
                iskontoDegeri3 = element.ISK3!;
              }
              if (element.ISK4 != 0) {
                iskontoDegeri4 = element.ISK4!;
              }
              if (element.ISK5 != 0) {
                iskontoDegeri5 = element.ISK5!;
              }
              if (element.ISK6 != 0) {
                iskontoDegeri6 = element.ISK6!;
              }

              if (element.FIYAT == 1) {
                kosuldanDonenFiyat = Stok.SFIYAT1!;
                seciliFiyat = "Fiyat1";
              } else if (element.FIYAT == 2) {
                seciliFiyat = "Fiyat2";
                kosuldanDonenFiyat = Stok.SFIYAT2!;
              } else if (element.FIYAT == 3) {
                seciliFiyat = "Fiyat3";
                kosuldanDonenFiyat = Stok.SFIYAT3!;
              } else if (element.FIYAT == 4) {
                seciliFiyat = "Fiyat4";
                kosuldanDonenFiyat = Stok.SFIYAT4!;
              } else if (element.FIYAT == 5) {
                seciliFiyat = "Fiyat5";
                kosuldanDonenFiyat = Stok.SFIYAT5!;
              }
              /*
              double iskonto = iskontoGetir(
                Stok.KOD,
                seciliCari.KOD!,
                isk1: element.ISK1!,
                isk2: element.ISK2!,
                isk3: element.ISK3!,
                isk4: element.ISK4!,
                isk5: element.ISK5!,
                isk6: element.ISK6!,
              );
              */
              return [
                kosuldanDonenFiyat,
                iskontoDegeri1,
                seciliFiyat,
                false,
                iskontoDegeri2,
                iskontoDegeri3,
                iskontoDegeri4,
                iskontoDegeri5,
                iskontoDegeri6
              ];
            } else {
              kosuldanDonenFiyat = 0;
            }
          }
          if (kosuldanDonenFiyat == 0) {
            for (var element in listeler.listCariKosul) {
              if (element.CARIKOD == seciliCari.KOD &&
                  element.GRUPKODU == Stok.GRUP_KODU) {
                // cari kosul var
                if (element.ISK1 != 0) {
                  iskontoDegeri1 = element.ISK1!;
                } else if (element.ISK2 != 0) {
                  iskontoDegeri2 = element.ISK2!;
                } else if (element.ISK3 != 0) {
                  iskontoDegeri3 = element.ISK3!;
                } else if (element.ISK4 != 0) {
                  iskontoDegeri4 = element.ISK4!;
                } else if (element.ISK5 != 0) {
                  iskontoDegeri5 = element.ISK5!;
                } else if (element.ISK6 != 0) {
                  iskontoDegeri6 = element.ISK6!;
                }

                if (element.FIYAT == 1) {
                  seciliFiyat = "Fiyat1";
                  kosuldanDonenFiyat = Stok.SFIYAT1!;
                } else if (element.FIYAT == 2) {
                  seciliFiyat = "Fiyat2";
                  kosuldanDonenFiyat = Stok.SFIYAT2!;
                } else if (element.FIYAT == 3) {
                  seciliFiyat = "Fiyat3";
                  kosuldanDonenFiyat = Stok.SFIYAT3!;
                } else if (element.FIYAT == 4) {
                  seciliFiyat = "Fiyat4";
                  kosuldanDonenFiyat = Stok.SFIYAT4!;
                } else if (element.FIYAT == 5) {
                  seciliFiyat = "Fiyat5";
                  kosuldanDonenFiyat = Stok.SFIYAT5!;
                }
                /*
                double iskonto = iskontoGetir(
                  Stok.KOD,
                  seciliCari.KOD!,
                  isk1: element.ISK1!,
                  isk2: element.ISK2!,
                  isk3: element.ISK3!,
                  isk4: element.ISK4!,
                  isk5: element.ISK5!,
                  isk6: element.ISK6!,
                );
                */
                return [
                  kosuldanDonenFiyat,
                  iskontoDegeri1,
                  seciliFiyat,
                  false,
                  0.0,
                  0.0,
                  0.0,
                  0.0,
                  0.0
                ];
              } else {
                kosuldanDonenFiyat = 0;
              }
            }
          }
          if (kosuldanDonenFiyat == 0) {
            for (var element in listeler.listCariStokKosul) {
              if (element.CARIKOD == seciliCari.KOD &&
                  element.STOKKOD == Stok.KOD) {
                // caristok kosul var
                if (element.ISK1 != 0) {
                  iskontoDegeri1 = element.ISK1!;
                } else if (element.ISK2 != 0) {
                  iskontoDegeri2 = element.ISK2!;
                }
                if (element.FIYAT == 1) {
                  seciliFiyat = "Fiyat1";
                  kosuldanDonenFiyat = Stok.SFIYAT1!;
                } else if (element.FIYAT == 2) {
                  seciliFiyat = "Fiyat2";
                  kosuldanDonenFiyat = Stok.SFIYAT2!;
                } else if (element.FIYAT == 3) {
                  seciliFiyat = "Fiyat3";
                  kosuldanDonenFiyat = Stok.SFIYAT3!;
                } else if (element.FIYAT == 4) {
                  seciliFiyat = "Fiyat4";
                  kosuldanDonenFiyat = Stok.SFIYAT4!;
                } else if (element.FIYAT == 5) {
                  seciliFiyat = "Fiyat5";
                  kosuldanDonenFiyat = Stok.SFIYAT5!;
                }
                /*
                double iskonto = iskontoGetir(
                  Stok.KOD,
                  seciliCari.KOD!,
                  isk1: element.ISK1!,
                  isk2: element.ISK2!,
                );
                */
                return [
                  kosuldanDonenFiyat,
                  iskontoDegeri1,
                  seciliFiyat,
                  false,
                  0.0,
                  0.0,
                  0.0,
                  0.0,
                  0.0
                ];
              } else {
                kosuldanDonenFiyat = 0;
              }
            }
          }
        } else if (Ctanim.kullanici!.SATISTIPI == "2") {
          return [0, 0, seciliCari.FIYAT, false, 0.0, 0.0, 0.0, 0.0, 0.0];
        } else if (Ctanim.kullanici!.SATISTIPI == "3") {
          if (Ctanim.seciliStokFiyatListesi.ID != -1) {
            for (var element in listeler.listStokFiyatListesiHar) {
              if (Ctanim.seciliStokFiyatListesi.ID == element.USTID &&
                  element.STOKKOD == Stok.KOD) {
                return [
                  element.FIYAT,
                  element.ISK1,
                  Ctanim.seciliStokFiyatListesi.ADI,
                  false,
                  0.0,
                  0.0,
                  0.0,
                  0.0,
                  0.0
                ];
              }
            }
            StokKart ff = searchList.where((p0) => p0.KOD == Stok.KOD).first;

            if (Fiyattip == 'Fiyat1') {
              kosulYoksaTekrarDonecek == ff.SFIYAT1;
              //double iskonto = iskontoGetir(Stok.KOD, CariKod);
              return [
                ff.SFIYAT1,
                ff.SATISISK,
                "Fiyat1",
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            } else if (Fiyattip == 'Fiyat2') {
              // iskontoGetir(Stok.KOD, CariKod);
              kosulYoksaTekrarDonecek == ff.SFIYAT2;
              // double iskonto = iskontoGetir(Stok.KOD, CariKod);
              return [
                ff.SFIYAT2,
                ff.SATISISK,
                "Fiyat2",
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            } else if (Fiyattip == 'Fiyat3') {
              // iskontoGetir(Stok.KOD, CariKod);
              kosulYoksaTekrarDonecek == ff.SFIYAT3;
              // double iskonto = iskontoGetir(Stok.KOD, CariKod);
              return [
                ff.SFIYAT3,
                ff.SATISISK,
                "Fiyat3",
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            } else if (Fiyattip == 'Fiyat4') {
              // iskontoGetir(Stok.KOD, CariKod);
              kosulYoksaTekrarDonecek == ff.SFIYAT4;
              //double iskonto = iskontoGetir(Stok.KOD, CariKod);
              return [
                ff.SFIYAT4,
                ff.SATISISK,
                "Fiyat4",
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            } else if (Fiyattip == 'Fiyat5') {
              // iskontoGetir(Stok.KOD, CariKod);
              kosulYoksaTekrarDonecek == ff.SFIYAT5;
              //double iskonto = iskontoGetir(Stok.KOD, CariKod);
              return [
                ff.SFIYAT5,
                ff.SATISISK,
                "Fiyat5",
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            } else {
              //double iskonto = iskontoGetir(Stok.KOD, CariKod);
              kosulYoksaTekrarDonecek == 0.0;
              return [
                0.0,
                ff.SATISISK,
                Fiyattip,
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            }
          } else {
            StokKart ff = searchList.where((p0) => p0.KOD == Stok.KOD).first;

            if (Fiyattip == 'Fiyat1') {
              kosulYoksaTekrarDonecek == ff.SFIYAT1;
              //double iskonto = iskontoGetir(Stok.KOD, CariKod);
              return [
                ff.SFIYAT1,
                ff.SATISISK,
                "Fiyat1",
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            } else if (Fiyattip == 'Fiyat2') {
              // iskontoGetir(Stok.KOD, CariKod);
              kosulYoksaTekrarDonecek == ff.SFIYAT2;
              // double iskonto = iskontoGetir(Stok.KOD, CariKod);
              return [
                ff.SFIYAT2,
                ff.SATISISK,
                "Fiyat2",
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            } else if (Fiyattip == 'Fiyat3') {
              // iskontoGetir(Stok.KOD, CariKod);
              kosulYoksaTekrarDonecek == ff.SFIYAT3;
              // double iskonto = iskontoGetir(Stok.KOD, CariKod);
              return [
                ff.SFIYAT3,
                ff.SATISISK,
                "Fiyat3",
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            } else if (Fiyattip == 'Fiyat4') {
              // iskontoGetir(Stok.KOD, CariKod);
              kosulYoksaTekrarDonecek == ff.SFIYAT4;
              //double iskonto = iskontoGetir(Stok.KOD, CariKod);
              return [
                ff.SFIYAT4,
                ff.SATISISK,
                "Fiyat4",
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            } else if (Fiyattip == 'Fiyat5') {
              // iskontoGetir(Stok.KOD, CariKod);
              kosulYoksaTekrarDonecek == ff.SFIYAT5;
              //double iskonto = iskontoGetir(Stok.KOD, CariKod);
              return [
                ff.SFIYAT5,
                ff.SATISISK,
                "Fiyat5",
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            } else {
              //double iskonto = iskontoGetir(Stok.KOD, CariKod);
              kosulYoksaTekrarDonecek == 0.0;
              return [
                0.0,
                ff.SATISISK,
                Fiyattip,
                true,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0
              ];
            }
          }
        }
        if (kosuldanDonenFiyat == 0) {
          if (Fiyattip == "Fiyat1") {
            return [
              Stok.SFIYAT1,
              Stok.SATISISK,
              _FiyatTip,
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else if (Fiyattip == "Fiyat2") {
            return [
              Stok.SFIYAT2,
              Stok.SATISISK,
              _FiyatTip,
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else if (Fiyattip == "Fiyat3") {
            return [
              Stok.SFIYAT3,
              Stok.SATISISK,
              _FiyatTip,
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else if (Fiyattip == "Fiyat4") {
            return [
              Stok.SFIYAT4,
              Stok.SATISISK,
              _FiyatTip,
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else if (Fiyattip == "Fiyat5") {
            return [
              Stok.SFIYAT5,
              Stok.SATISISK,
              _FiyatTip,
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          } else if (Fiyattip == "ListeFiyat") {
            return [
              Stok.LISTEFIYAT,
              Stok.SATISISK,
              _FiyatTip,
              true,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            ];
          }
        }
      }
      return [];
    }
    return [];
  }

/*
  void searchB(String query) {
    if (query.isEmpty) {
      searchList.assignAll(listeler.listStok);
    } else {
      var results = listeler.listStok
          .where((value) =>
              value.ADI!.toLowerCase().contains(query.toLowerCase()) ||
              value.KOD!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      searchList.assignAll(results);
    }
  }
*/
  String turkishToEnglish(String input) {
    // Küçük harfe çevir
    String lowerCaseText = input.toLowerCase();

    // Türkçe karakterleri İngilizce karakterlere çevir
    final Map<String, String> turkishToEnglishMap = {
      'ç': 'c',
      'ğ': 'g',
      'ı': 'i',
      'ö': 'o',
      'ş': 's',
      'ü': 'u',
    };

    for (var entry in turkishToEnglishMap.entries) {
      lowerCaseText = lowerCaseText.replaceAll(entry.key, entry.value);
    }

    return lowerCaseText;
  }

  void searchC(
      String query,
      String cariKod,
      String fiyatTip,
      SatisTipiModel satisTipi,
      StokFiyatListesiModel stokFiyatListesiModel,
      int seciliAltHesapID) {
    // QUERY BOŞSA
    if (query.isEmpty) {
      tempList.clear();
      if (listeler.listStok.length > 100) {
        if (Ctanim.secililiMarkalarFiltre.isEmpty) {
          for (int i = 0; i < 100; i++) {
            if (cariKod == "") {
              tempList.add(listeler.listStok[i]);
            } else {
              List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                  listeler.listStok[i],
                  cariKod,
                  fiyatTip,
                  satisTipi,
                  stokFiyatListesiModel,
                  seciliAltHesapID);
              listeler.listStok[i].guncelDegerler!.carpan = 1.0;
              listeler.listStok[i].guncelDegerler!.guncelBarkod =
                  listeler.listStok[i].KOD!;
              listeler.listStok[i].guncelDegerler!.fiyat =
                  double.parse(gelenFiyatVeIskonto[0].toString());

              listeler.listStok[i].guncelDegerler!.iskonto1 =
                  double.parse(gelenFiyatVeIskonto[1].toString());

              listeler.listStok[i].guncelDegerler!.iskonto2 =
                  double.parse(gelenFiyatVeIskonto[4].toString());

              listeler.listStok[i].guncelDegerler!.iskonto3 =
                  double.parse(gelenFiyatVeIskonto[5].toString());

              listeler.listStok[i].guncelDegerler!.iskonto4 =
                  double.parse(gelenFiyatVeIskonto[6].toString());

              listeler.listStok[i].guncelDegerler!.iskonto5 =
                  double.parse(gelenFiyatVeIskonto[7].toString());

              listeler.listStok[i].guncelDegerler!.iskonto6 =
                  double.parse(gelenFiyatVeIskonto[8].toString());
              listeler.listStok[i].guncelDegerler!.seciliFiyati =
                  gelenFiyatVeIskonto[2].toString();
              listeler.listStok[i].guncelDegerler!.fiyatDegistirMi =
                  gelenFiyatVeIskonto[3];

              listeler.listStok[i].guncelDegerler!.netfiyat =
                  listeler.listStok[i].guncelDegerler!.hesaplaNetFiyat();
              if (!Ctanim.fiyatListesiKosul.contains(
                  listeler.listStok[i].guncelDegerler!.seciliFiyati)) {
                Ctanim.fiyatListesiKosul
                    .add(listeler.listStok[i].guncelDegerler!.seciliFiyati!);
              }

              tempList.add(listeler.listStok[i]);
            }
          }
        } else {
          tempList.clear();
          if (cariKod == "") {
            List<StokKart> results = [];
            results.addAll(listeler.listStok);
            results.removeWhere((element) =>
                !Ctanim.secililiMarkalarFiltre.contains(element.MARKA));
            tempList.assignAll(results);
          } else {
            tempList.clear();
            List<StokKart> results = [];
            results.addAll(listeler.listStok);
            results.removeWhere((element) =>
                !Ctanim.secililiMarkalarFiltre.contains(element.MARKA));

            if (results.length > 100) {
              for (int i = 0; i < 100; i++) {
                List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                    results[i],
                    cariKod,
                    fiyatTip,
                    satisTipi,
                    stokFiyatListesiModel,
                    seciliAltHesapID);
                results[i].guncelDegerler!.carpan = 1.0;
                results[i].guncelDegerler!.guncelBarkod = results[i].KOD!;
                results[i].guncelDegerler!.fiyat =
                    double.parse(gelenFiyatVeIskonto[0].toString());

                results[i].guncelDegerler!.iskonto1 =
                    double.parse(gelenFiyatVeIskonto[1].toString());

                results[i].guncelDegerler!.iskonto2 =
                    double.parse(gelenFiyatVeIskonto[4].toString());

                results[i].guncelDegerler!.iskonto3 =
                    double.parse(gelenFiyatVeIskonto[5].toString());

                results[i].guncelDegerler!.iskonto4 =
                    double.parse(gelenFiyatVeIskonto[6].toString());

                results[i].guncelDegerler!.iskonto5 =
                    double.parse(gelenFiyatVeIskonto[7].toString());

                results[i].guncelDegerler!.iskonto6 =
                    double.parse(gelenFiyatVeIskonto[8].toString());

                results[i].guncelDegerler!.seciliFiyati =
                    gelenFiyatVeIskonto[2].toString();
                results[i].guncelDegerler!.fiyatDegistirMi =
                    gelenFiyatVeIskonto[3];

                results[i].guncelDegerler!.netfiyat =
                    results[i].guncelDegerler!.hesaplaNetFiyat();
                if (!Ctanim.fiyatListesiKosul
                    .contains(results[i].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[i].guncelDegerler!.seciliFiyati!);
                }

                tempList.add(results[i]);
              }
            } else {
              for (int i = 0; i < results.length; i++) {
                List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                    results[i],
                    cariKod,
                    fiyatTip,
                    satisTipi,
                    stokFiyatListesiModel,
                    seciliAltHesapID);
                results[i].guncelDegerler!.carpan = 1.0;
                results[i].guncelDegerler!.guncelBarkod = results[i].KOD!;
                results[i].guncelDegerler!.fiyat =
                    double.parse(gelenFiyatVeIskonto[0].toString());

                results[i].guncelDegerler!.iskonto1 =
                    double.parse(gelenFiyatVeIskonto[1].toString());

                results[i].guncelDegerler!.iskonto2 =
                    double.parse(gelenFiyatVeIskonto[4].toString());

                results[i].guncelDegerler!.iskonto3 =
                    double.parse(gelenFiyatVeIskonto[5].toString());

                results[i].guncelDegerler!.iskonto4 =
                    double.parse(gelenFiyatVeIskonto[6].toString());

                results[i].guncelDegerler!.iskonto5 =
                    double.parse(gelenFiyatVeIskonto[7].toString());

                results[i].guncelDegerler!.iskonto6 =
                    double.parse(gelenFiyatVeIskonto[8].toString());

                results[i].guncelDegerler!.seciliFiyati =
                    gelenFiyatVeIskonto[2].toString();
                results[i].guncelDegerler!.fiyatDegistirMi =
                    gelenFiyatVeIskonto[3];

                results[i].guncelDegerler!.netfiyat =
                    results[i].guncelDegerler!.hesaplaNetFiyat();
                if (!Ctanim.fiyatListesiKosul
                    .contains(results[i].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[i].guncelDegerler!.seciliFiyati!);
                }

                tempList.add(results[i]);
              }
            }
          }
        }
      } else {
        if (Ctanim.secililiMarkalarFiltre.isEmpty) {
          for (int i = 0; i < listeler.listStok.length; i++) {
            if (cariKod == "") {
              tempList.add(listeler.listStok[i]);
            } else {
              List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                  listeler.listStok[i],
                  cariKod,
                  fiyatTip,
                  satisTipi,
                  stokFiyatListesiModel,
                  seciliAltHesapID);
              listeler.listStok[i].guncelDegerler!.carpan = 1.0;
              listeler.listStok[i].guncelDegerler!.guncelBarkod =
                  listeler.listStok[i].KOD!;
              listeler.listStok[i].guncelDegerler!.fiyat =
                  double.parse(gelenFiyatVeIskonto[0].toString());

              listeler.listStok[i].guncelDegerler!.iskonto1 =
                  double.parse(gelenFiyatVeIskonto[1].toString());

              listeler.listStok[i].guncelDegerler!.iskonto2 =
                  double.parse(gelenFiyatVeIskonto[4].toString());

              listeler.listStok[i].guncelDegerler!.iskonto3 =
                  double.parse(gelenFiyatVeIskonto[5].toString());

              listeler.listStok[i].guncelDegerler!.iskonto4 =
                  double.parse(gelenFiyatVeIskonto[6].toString());

              listeler.listStok[i].guncelDegerler!.iskonto5 =
                  double.parse(gelenFiyatVeIskonto[7].toString());

              listeler.listStok[i].guncelDegerler!.iskonto6 =
                  double.parse(gelenFiyatVeIskonto[8].toString());

              listeler.listStok[i].guncelDegerler!.seciliFiyati =
                  gelenFiyatVeIskonto[2].toString();
              listeler.listStok[i].guncelDegerler!.fiyatDegistirMi =
                  gelenFiyatVeIskonto[3];

              listeler.listStok[i].guncelDegerler!.netfiyat =
                  listeler.listStok[i].guncelDegerler!.hesaplaNetFiyat();
              if (!Ctanim.fiyatListesiKosul.contains(
                  listeler.listStok[i].guncelDegerler!.seciliFiyati)) {
                Ctanim.fiyatListesiKosul
                    .add(listeler.listStok[i].guncelDegerler!.seciliFiyati!);
              }

              tempList.add(listeler.listStok[i]);
            }
          }
        } else {
          if (cariKod == "") {
            List<StokKart> results = [];
            results.addAll(listeler.listStok);
            results.removeWhere((element) =>
                !Ctanim.secililiMarkalarFiltre.contains(element.MARKA));

            tempList.assignAll(results);
          } else {
            tempList.clear();
            List<StokKart> results = [];
            results.addAll(listeler.listStok);
            results.removeWhere((element) =>
                !Ctanim.secililiMarkalarFiltre.contains(element.MARKA));

            for (int i = 0; i < results.length; i++) {
              List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                  results[i],
                  cariKod,
                  fiyatTip,
                  satisTipi,
                  stokFiyatListesiModel,
                  seciliAltHesapID);
              results[i].guncelDegerler!.carpan = 1.0;
              results[i].guncelDegerler!.guncelBarkod = results[i].KOD!;
              results[i].guncelDegerler!.fiyat =
                  double.parse(gelenFiyatVeIskonto[0].toString());

              results[i].guncelDegerler!.iskonto1 =
                  double.parse(gelenFiyatVeIskonto[1].toString());

              results[i].guncelDegerler!.iskonto2 =
                  double.parse(gelenFiyatVeIskonto[4].toString());

              results[i].guncelDegerler!.iskonto3 =
                  double.parse(gelenFiyatVeIskonto[5].toString());

              results[i].guncelDegerler!.iskonto4 =
                  double.parse(gelenFiyatVeIskonto[6].toString());

              results[i].guncelDegerler!.iskonto5 =
                  double.parse(gelenFiyatVeIskonto[7].toString());

              results[i].guncelDegerler!.iskonto6 =
                  double.parse(gelenFiyatVeIskonto[8].toString());

              results[i].guncelDegerler!.seciliFiyati =
                  gelenFiyatVeIskonto[2].toString();
              results[i].guncelDegerler!.fiyatDegistirMi =
                  gelenFiyatVeIskonto[3];

              results[i].guncelDegerler!.netfiyat =
                  results[i].guncelDegerler!.hesaplaNetFiyat();
              if (!Ctanim.fiyatListesiKosul
                  .contains(results[i].guncelDegerler!.seciliFiyati)) {
                Ctanim.fiyatListesiKosul
                    .add(results[i].guncelDegerler!.seciliFiyati!);
              }

              tempList.add(results[i]);
            }
          }
        }
      }
    }
    // QUERY DOLUYSA
    else {
      var results;
      List<String> queryparcali = turkishToEnglish(query).split(" ");
      if (queryparcali.length == 1) {
        results = listeler.listStok
            .where((value) =>
                turkishToEnglish(value.ADI!)
                    .contains(queryparcali[0].toLowerCase()) ||
                value.KOD!.toLowerCase().contains(query.toLowerCase()) ||
                value.MARKA!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (queryparcali.length == 2) {
        results = listeler.listStok
            .where((value) =>
                (turkishToEnglish(value.ADI!)
                        .contains(queryparcali[0].toLowerCase()) &&
                    turkishToEnglish(value.ADI!)
                        .contains(queryparcali[1].toLowerCase())) ||
                value.KOD!.toLowerCase().contains(query.toLowerCase()) ||
                value.MARKA!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (queryparcali.length == 3) {
        results = listeler.listStok
            .where((value) =>
                (turkishToEnglish(value.ADI!)
                        .contains(queryparcali[0].toLowerCase()) &&
                    turkishToEnglish(value.ADI!)
                        .contains(queryparcali[1].toLowerCase()) &&
                    turkishToEnglish(value.ADI!)
                        .contains(queryparcali[2].toLowerCase())) ||
                value.KOD!.toLowerCase().contains(query.toLowerCase()) ||
                value.MARKA!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (queryparcali.length == 4) {
        results = listeler.listStok
            .where((value) =>
                (turkishToEnglish(value.ADI!)
                        .contains(queryparcali[0].toLowerCase()) &&
                    turkishToEnglish(value.ADI!)
                        .contains(queryparcali[1].toLowerCase()) &&
                    turkishToEnglish(value.ADI!)
                        .contains(queryparcali[2].toLowerCase()) &&
                    turkishToEnglish(value.ADI!)
                        .contains(queryparcali[3].toLowerCase())) ||
                value.KOD!.toLowerCase().contains(query.toLowerCase()) ||
                value.MARKA!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      if (results.length == 0) {
        results = listeler.listStok
            .where(
                (value) => value.BARKOD1!.toLowerCase() == query.toLowerCase())
            .toList();
        //BARKOD1 İLE BULUNURSA YAPILACAKALAR
        if (results.length > 0) {
          results[0].guncelDegerler!.guncelDegerSifirla();
          if (cariKod == "") {
            tempList.assignAll(results);
          } else {
            if (results[0].BARKODCARPAN1! > 1) {
              results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN1!;
              results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD1!;
            } else {
              results[0].guncelDegerler!.carpan =
                  double.tryParse(results[0].SACIKLAMA9) ?? 1;
              results[0].guncelDegerler!.guncelBarkod = results[0].KOD!;
            }

            if (results[0].BARKODFIYAT1! > 0) {
              results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN1!;
              results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD1!;
              results[0].guncelDegerler!.fiyat = results[0].BARKODFIYAT1;

              results[0].guncelDegerler!.iskonto1 = results[0].BARKODISK1;
              results[0].guncelDegerler!.seciliFiyati =
                  "Barkod"; // hata verebilir
              results[0].guncelDegerler!.fiyatDegistirMi = false;
              results[0].guncelDegerler!.netfiyat =
                  results[0].guncelDegerler!.hesaplaNetFiyat();
              if (!Ctanim.fiyatListesiKosul
                  .contains(results[0].guncelDegerler!.seciliFiyati)) {
                Ctanim.fiyatListesiKosul
                    .add(results[0].guncelDegerler!.seciliFiyati!);
              }
            } else {
              List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                  results[0],
                  cariKod,
                  fiyatTip,
                  satisTipi,
                  stokFiyatListesiModel,
                  seciliAltHesapID);

              results[0].guncelDegerler.guncelBarkod = results[0].KOD!;
              results[0].guncelDegerler!.fiyat =
                  double.parse(gelenFiyatVeIskonto[0].toString());

              results[0].guncelDegerler!.iskonto1 =
                  double.parse(gelenFiyatVeIskonto[1].toString());

              results[0].guncelDegerler!.iskonto2 =
                  double.parse(gelenFiyatVeIskonto[4].toString());
              results[0].guncelDegerler!.iskonto3 =
                  double.parse(gelenFiyatVeIskonto[5].toString());
              results[0].guncelDegerler!.iskonto4 =
                  double.parse(gelenFiyatVeIskonto[6].toString());
              results[0].guncelDegerler!.iskonto5 =
                  double.parse(gelenFiyatVeIskonto[7].toString());
              results[0].guncelDegerler!.iskonto6 =
                  double.parse(gelenFiyatVeIskonto[8].toString());

              results[0].guncelDegerler!.seciliFiyati =
                  gelenFiyatVeIskonto[2].toString();

              results[0].guncelDegerler!.fiyatDegistirMi =
                  gelenFiyatVeIskonto[3];

              results[0].guncelDegerler!.netfiyat =
                  results[0].guncelDegerler!.hesaplaNetFiyat();

              if (!Ctanim.fiyatListesiKosul
                  .contains(results[0].guncelDegerler!.seciliFiyati)) {
                Ctanim.fiyatListesiKosul
                    .add(results[0].guncelDegerler!.seciliFiyati!);
              }
            }

            tempList.assignAll(results);
          }
        }

        if (results.length == 0) {
          results = listeler.listStok
              .where((value) =>
                  value.BARKOD2!.toLowerCase() == query.toLowerCase())
              .toList();
          //BARKOD2 İLE BULUNURSA YAPILACAKALAR
          if (results.length > 0) {
            results[0].guncelDegerler!.guncelDegerSifirla();
            if (cariKod == "") {
              tempList.assignAll(results);
            } else {
              if (results[0].BARKODCARPAN2! > 1) {
                results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN2!;
                results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD2!;
              } else {
                results[0].guncelDegerler!.carpan =
                    double.tryParse(results[0].SACIKLAMA9) ?? 1;
                results[0].guncelDegerler!.guncelBarkod = results[0].KOD!;
              }
              if (results[0].BARKODFIYAT2! > 0) {
                results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN2!;
                results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD2!;
                results[0].guncelDegerler!.fiyat = results[0].BARKODFIYAT2;
                results[0].guncelDegerler!.iskonto1 = results[0].BARKODISK2;
                results[0].guncelDegerler!.seciliFiyati =
                    "Barkod"; // hata verebilir
                results[0].guncelDegerler!.fiyatDegistirMi = false;
                results[0].guncelDegerler!.netfiyat =
                    results[0].guncelDegerler!.hesaplaNetFiyat();
                if (!Ctanim.fiyatListesiKosul
                    .contains(results[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[0].guncelDegerler!.seciliFiyati!);
                }
              } else {
                List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                    results[0],
                    cariKod,
                    fiyatTip,
                    satisTipi,
                    stokFiyatListesiModel,
                    seciliAltHesapID);
                results[0].guncelDegerler!.fiyat =
                    double.parse(gelenFiyatVeIskonto[0].toString());
                results[0].guncelDegerler.guncelBarkod = results[0].KOD!;

                results[0].guncelDegerler!.iskonto1 =
                    double.parse(gelenFiyatVeIskonto[1].toString());
                results[0].guncelDegerler!.iskonto2 =
                    double.parse(gelenFiyatVeIskonto[4].toString());
                results[0].guncelDegerler!.iskonto3 =
                    double.parse(gelenFiyatVeIskonto[5].toString());
                results[0].guncelDegerler!.iskonto4 =
                    double.parse(gelenFiyatVeIskonto[6].toString());
                results[0].guncelDegerler!.iskonto5 =
                    double.parse(gelenFiyatVeIskonto[7].toString());
                results[0].guncelDegerler!.iskonto6 =
                    double.parse(gelenFiyatVeIskonto[8].toString());

                results[0].guncelDegerler!.seciliFiyati =
                    gelenFiyatVeIskonto[2].toString();

                results[0].guncelDegerler!.fiyatDegistirMi =
                    gelenFiyatVeIskonto[3];

                results[0].guncelDegerler!.netfiyat =
                    results[0].guncelDegerler!.hesaplaNetFiyat();

                if (!Ctanim.fiyatListesiKosul
                    .contains(results[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[0].guncelDegerler!.seciliFiyati!);
                }
              }

              tempList.assignAll(results);
            }
          }
        }
        if (results.length == 0) {
          results = listeler.listStok
              .where((value) =>
                  value.BARKOD3!.toLowerCase() == query.toLowerCase())
              .toList();
          //BARKOD3 İLE BULUNURSA YAPILACAKALAR
          if (results.length > 0) {
            results[0].guncelDegerler!.guncelDegerSifirla();
            if (cariKod == "") {
              tempList.assignAll(results);
            } else {
              if (results[0].BARKODCARPAN3! > 1) {
                results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN3!;
                results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD3!;
              } else {
                results[0].guncelDegerler!.carpan =
                    double.tryParse(results[0].SACIKLAMA9) ?? 1;
                results[0].guncelDegerler!.guncelBarkod = results[0].KOD!;
              }
              if (results[0].BARKODFIYAT3! > 0) {
                results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN3!;
                results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD3!;
                results[0].guncelDegerler!.fiyat = results[0].BARKODFIYAT3;
                results[0].guncelDegerler!.iskonto1 = results[0].BARKODISK3;
                results[0].guncelDegerler!.seciliFiyati =
                    "Barkod"; // hata verebilir
                results[0].guncelDegerler!.fiyatDegistirMi = false;
                results[0].guncelDegerler!.netfiyat =
                    results[0].guncelDegerler!.hesaplaNetFiyat();
                if (!Ctanim.fiyatListesiKosul
                    .contains(results[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[0].guncelDegerler!.seciliFiyati!);
                }
              } else {
                List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                    results[0],
                    cariKod,
                    fiyatTip,
                    satisTipi,
                    stokFiyatListesiModel,
                    seciliAltHesapID);
                results[0].guncelDegerler!.fiyat =
                    double.parse(gelenFiyatVeIskonto[0].toString());
                results[0].guncelDegerler.guncelBarkod = results[0].KOD!;
                results[0].guncelDegerler!.iskonto1 =
                    double.parse(gelenFiyatVeIskonto[1].toString());
                results[0].guncelDegerler!.iskonto2 =
                    double.parse(gelenFiyatVeIskonto[4].toString());
                results[0].guncelDegerler!.iskonto3 =
                    double.parse(gelenFiyatVeIskonto[5].toString());
                results[0].guncelDegerler!.iskonto4 =
                    double.parse(gelenFiyatVeIskonto[6].toString());
                results[0].guncelDegerler!.iskonto5 =
                    double.parse(gelenFiyatVeIskonto[7].toString());
                results[0].guncelDegerler!.iskonto6 =
                    double.parse(gelenFiyatVeIskonto[8].toString());

                results[0].guncelDegerler!.seciliFiyati =
                    gelenFiyatVeIskonto[2].toString();

                results[0].guncelDegerler!.fiyatDegistirMi =
                    gelenFiyatVeIskonto[3];

                results[0].guncelDegerler!.netfiyat =
                    results[0].guncelDegerler!.hesaplaNetFiyat();

                if (!Ctanim.fiyatListesiKosul
                    .contains(results[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[0].guncelDegerler!.seciliFiyati!);
                }
              }

              tempList.assignAll(results);
            }
          }
        }

        if (results.length == 0) {
          results = listeler.listStok
              .where((value) =>
                  value.BARKOD4!.toLowerCase() == query.toLowerCase())
              .toList();
          //BARKOD4 İLE BULUNURSA YAPILACAKALAR
          if (results.length > 0) {
            results[0].guncelDegerler!.guncelDegerSifirla();
            if (cariKod == "") {
              tempList.assignAll(results);
            } else {
              if (results[0].BARKODCARPAN4! > 1) {
                results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN4!;
                results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD4!;
              } else {
                results[0].guncelDegerler!.carpan =
                    double.tryParse(results[0].SACIKLAMA9) ?? 1;
                results[0].guncelDegerler!.guncelBarkod = results[0].KOD!;
              }
              if (results[0].BARKODFIYAT4! > 0) {
                results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN4!;
                results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD4!;
                results[0].guncelDegerler!.fiyat = results[0].BARKODFIYAT4;
                results[0].guncelDegerler!.iskonto1 = results[0].BARKODISK4;
                results[0].guncelDegerler!.seciliFiyati =
                    "Barkod"; // hata verebilir
                results[0].guncelDegerler!.fiyatDegistirMi = false;
                results[0].guncelDegerler!.netfiyat =
                    results[0].guncelDegerler!.hesaplaNetFiyat();
                if (!Ctanim.fiyatListesiKosul
                    .contains(results[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[0].guncelDegerler!.seciliFiyati!);
                }
              } else {
                List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                    results[0],
                    cariKod,
                    fiyatTip,
                    satisTipi,
                    stokFiyatListesiModel,
                    seciliAltHesapID);
                results[0].guncelDegerler!.fiyat =
                    double.parse(gelenFiyatVeIskonto[0].toString());
                results[0].guncelDegerler.guncelBarkod = results[0].KOD!;

                results[0].guncelDegerler!.iskonto1 =
                    double.parse(gelenFiyatVeIskonto[1].toString());
                results[0].guncelDegerler!.iskonto2 =
                    double.parse(gelenFiyatVeIskonto[4].toString());
                results[0].guncelDegerler!.iskonto3 =
                    double.parse(gelenFiyatVeIskonto[5].toString());
                results[0].guncelDegerler!.iskonto4 =
                    double.parse(gelenFiyatVeIskonto[6].toString());
                results[0].guncelDegerler!.iskonto5 =
                    double.parse(gelenFiyatVeIskonto[7].toString());
                results[0].guncelDegerler!.iskonto6 =
                    double.parse(gelenFiyatVeIskonto[8].toString());

                results[0].guncelDegerler!.seciliFiyati =
                    gelenFiyatVeIskonto[2].toString();

                results[0].guncelDegerler!.fiyatDegistirMi =
                    gelenFiyatVeIskonto[3];

                results[0].guncelDegerler!.netfiyat =
                    results[0].guncelDegerler!.hesaplaNetFiyat();

                if (!Ctanim.fiyatListesiKosul
                    .contains(results[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[0].guncelDegerler!.seciliFiyati!);
                }
              }

              tempList.assignAll(results);
            }
          }
        }

        if (results.length == 0) {
          results = listeler.listStok
              .where((value) =>
                  value.BARKOD5!.toLowerCase() == query.toLowerCase())
              .toList();
          //BARKOD5 İLE BULUNURSA YAPILACAKALAR
          if (results.length > 0) {
            results[0].guncelDegerler!.guncelDegerSifirla();
            if (cariKod == "") {
              tempList.assignAll(results);
            } else {
              if (results[0].BARKODCARPAN5! > 1) {
                results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN5!;
                results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD5!;
              } else {
                results[0].guncelDegerler!.carpan =
                    double.tryParse(results[0].SACIKLAMA9) ?? 1;
                results[0].guncelDegerler!.guncelBarkod = results[0].KOD!;
              }
              if (results[0].BARKODFIYAT5! > 0) {
                results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN5!;
                results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD5!;
                results[0].guncelDegerler!.fiyat = results[0].BARKODFIYAT5;
                results[0].guncelDegerler!.iskonto1 = results[0].BARKODISK5;
                results[0].guncelDegerler!.seciliFiyati =
                    "Barkod"; // hata verebilir
                results[0].guncelDegerler!.fiyatDegistirMi = false;
                results[0].guncelDegerler!.netfiyat =
                    results[0].guncelDegerler!.hesaplaNetFiyat();
                if (!Ctanim.fiyatListesiKosul
                    .contains(results[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[0].guncelDegerler!.seciliFiyati!);
                }
              } else {
                List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                    results[0],
                    cariKod,
                    fiyatTip,
                    satisTipi,
                    stokFiyatListesiModel,
                    seciliAltHesapID);
                results[0].guncelDegerler!.fiyat =
                    double.parse(gelenFiyatVeIskonto[0].toString());
                results[0].guncelDegerler.guncelBarkod = results[0].KOD!;

                results[0].guncelDegerler!.iskonto1 =
                    double.parse(gelenFiyatVeIskonto[1].toString());
                results[0].guncelDegerler!.iskonto2 =
                    double.parse(gelenFiyatVeIskonto[4].toString());
                results[0].guncelDegerler!.iskonto3 =
                    double.parse(gelenFiyatVeIskonto[5].toString());
                results[0].guncelDegerler!.iskonto4 =
                    double.parse(gelenFiyatVeIskonto[6].toString());
                results[0].guncelDegerler!.iskonto5 =
                    double.parse(gelenFiyatVeIskonto[7].toString());
                results[0].guncelDegerler!.iskonto6 =
                    double.parse(gelenFiyatVeIskonto[8].toString());

                results[0].guncelDegerler!.seciliFiyati =
                    gelenFiyatVeIskonto[2].toString();

                results[0].guncelDegerler!.fiyatDegistirMi =
                    gelenFiyatVeIskonto[3];

                results[0].guncelDegerler!.netfiyat =
                    results[0].guncelDegerler!.hesaplaNetFiyat();

                if (!Ctanim.fiyatListesiKosul
                    .contains(results[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[0].guncelDegerler!.seciliFiyati!);
                }
              }

              tempList.assignAll(results);
            }
          }
        }

        if (results.length == 0) {
          results = listeler.listStok
              .where((value) =>
                  value.BARKOD6!.toLowerCase() == query.toLowerCase())
              .toList();
          //BARKO6 İLE BULUNURSA YAPILACAKALAR
          if (results.length > 0) {
            results[0].guncelDegerler!.guncelDegerSifirla();
            if (cariKod == "") {
              tempList.assignAll(results);
            } else {
              if (results[0].BARKODCARPAN6! > 1) {
                results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN6!;
                results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD6!;
              } else {
                results[0].guncelDegerler!.carpan =
                    double.tryParse(results[0].SACIKLAMA9) ?? 1;
                results[0].guncelDegerler!.guncelBarkod = results[0].KOD!;
              }
              if (results[0].BARKODFIYAT6! > 0) {
                results[0].guncelDegerler!.carpan = results[0].BARKODCARPAN6!;
                results[0].guncelDegerler!.guncelBarkod = results[0].BARKOD6!;
                results[0].guncelDegerler!.fiyat = results[0].BARKODFIYAT6;
                results[0].guncelDegerler!.iskonto1 = results[0].BARKODISK6;
                results[0].guncelDegerler!.seciliFiyati =
                    "Barkod"; // hata verebilir
                results[0].guncelDegerler!.fiyatDegistirMi = false;
                results[0].guncelDegerler!.netfiyat =
                    results[0].guncelDegerler!.hesaplaNetFiyat();
                if (!Ctanim.fiyatListesiKosul
                    .contains(results[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[0].guncelDegerler!.seciliFiyati!);
                }
              } else {
                List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                    results[0],
                    cariKod,
                    fiyatTip,
                    satisTipi,
                    stokFiyatListesiModel,
                    seciliAltHesapID);
                results[0].guncelDegerler!.fiyat =
                    double.parse(gelenFiyatVeIskonto[0].toString());
                results[0].guncelDegerler.guncelBarkod = results[0].KOD!;

                results[0].guncelDegerler!.iskonto1 =
                    double.parse(gelenFiyatVeIskonto[1].toString());
                results[0].guncelDegerler!.iskonto2 =
                    double.parse(gelenFiyatVeIskonto[4].toString());
                results[0].guncelDegerler!.iskonto3 =
                    double.parse(gelenFiyatVeIskonto[5].toString());
                results[0].guncelDegerler!.iskonto4 =
                    double.parse(gelenFiyatVeIskonto[6].toString());
                results[0].guncelDegerler!.iskonto5 =
                    double.parse(gelenFiyatVeIskonto[7].toString());
                results[0].guncelDegerler!.iskonto6 =
                    double.parse(gelenFiyatVeIskonto[8].toString());

                results[0].guncelDegerler!.seciliFiyati =
                    gelenFiyatVeIskonto[2].toString();

                results[0].guncelDegerler!.fiyatDegistirMi =
                    gelenFiyatVeIskonto[3];

                results[0].guncelDegerler!.netfiyat =
                    results[0].guncelDegerler!.hesaplaNetFiyat();

                if (!Ctanim.fiyatListesiKosul
                    .contains(results[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(results[0].guncelDegerler!.seciliFiyati!);
                }
              }

              tempList.assignAll(results);
            }
          }
        }
        if (results.length == 0) {
          //BURDA KALDIK
          var bul = listeler.listDahaFazlaBarkod
              .where((element) => element.BARKOD == query)
              .toList();
          if (bul.length > 0) {
            var sonBulunan = listeler.listStok
                .where((element) => element.KOD == bul[0].KOD)
                .toList();

            if (sonBulunan.length > 0) {
              if (cariKod == "") {
                tempList.assignAll(sonBulunan);
              } else {
                sonBulunan[0].guncelDegerler!.carpan =
                    1.0; //bul[0].CARPAN; burası değişecek
                sonBulunan[0].guncelDegerler!.guncelBarkod = bul[0].KOD;

                List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                    sonBulunan[0],
                    cariKod,
                    fiyatTip,
                    satisTipi,
                    stokFiyatListesiModel,
                    seciliAltHesapID);
                sonBulunan[0].guncelDegerler!.fiyat =
                    double.parse(gelenFiyatVeIskonto[0].toString());

                sonBulunan[0].guncelDegerler!.iskonto1 =
                    double.parse(gelenFiyatVeIskonto[1].toString());

                sonBulunan[0].guncelDegerler!.iskonto2 =
                    double.parse(gelenFiyatVeIskonto[4].toString());

                sonBulunan[0].guncelDegerler!.iskonto3 =
                    double.parse(gelenFiyatVeIskonto[5].toString());

                sonBulunan[0].guncelDegerler!.iskonto4 =
                    double.parse(gelenFiyatVeIskonto[6].toString());

                sonBulunan[0].guncelDegerler!.iskonto5 =
                    double.parse(gelenFiyatVeIskonto[7].toString());

                sonBulunan[0].guncelDegerler!.iskonto6 =
                    double.parse(gelenFiyatVeIskonto[8].toString());

                sonBulunan[0].guncelDegerler!.seciliFiyati =
                    gelenFiyatVeIskonto[2].toString();
                sonBulunan[0].guncelDegerler!.fiyatDegistirMi =
                    gelenFiyatVeIskonto[3];
                sonBulunan[0].BARKODCARPAN1 = bul[0].CARPAN;
                sonBulunan[0].guncelDegerler!.netfiyat =
                    sonBulunan[0].guncelDegerler!.hesaplaNetFiyat();
                if (!Ctanim.fiyatListesiKosul
                    .contains(sonBulunan[0].guncelDegerler!.seciliFiyati)) {
                  Ctanim.fiyatListesiKosul
                      .add(sonBulunan[0].guncelDegerler!.seciliFiyati!);
                }

                tempList.assignAll(sonBulunan);
              }
            }
          }
        }
      } else if (results.length > 100) {
        if (cariKod == "") {
          if (Ctanim.secililiMarkalarFiltre.isEmpty) {
            tempList.assignAll(results);
          } else {
            results.removeWhere((element) =>
                !Ctanim.secililiMarkalarFiltre.contains(element.MARKA));
            tempList.assignAll(results);
          }
        } else {
          if (Ctanim.secililiMarkalarFiltre.isEmpty) {
            for (int i = 0; i < 100; i++) {
              List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                  results[i],
                  cariKod,
                  fiyatTip,
                  satisTipi,
                  stokFiyatListesiModel,
                  seciliAltHesapID);
              results[i].guncelDegerler!.carpan = 1.0;
              results[i].guncelDegerler!.guncelBarkod = results[i].KOD!;
              results[i].guncelDegerler!.fiyat =
                  double.parse(gelenFiyatVeIskonto[0].toString());

              results[i].guncelDegerler!.iskonto1 =
                  double.parse(gelenFiyatVeIskonto[1].toString());

              results[i].guncelDegerler!.iskonto2 =
                  double.parse(gelenFiyatVeIskonto[4].toString());

              results[i].guncelDegerler!.iskonto3 =
                  double.parse(gelenFiyatVeIskonto[5].toString());

              results[i].guncelDegerler!.iskonto4 =
                  double.parse(gelenFiyatVeIskonto[6].toString());

              results[i].guncelDegerler!.iskonto5 =
                  double.parse(gelenFiyatVeIskonto[7].toString());

              results[i].guncelDegerler!.iskonto6 =
                  double.parse(gelenFiyatVeIskonto[8].toString());

              results[i].guncelDegerler!.seciliFiyati =
                  gelenFiyatVeIskonto[2].toString();
              results[i].guncelDegerler!.fiyatDegistirMi =
                  gelenFiyatVeIskonto[3];

              results[i].guncelDegerler!.netfiyat =
                  results[i].guncelDegerler!.hesaplaNetFiyat();
              if (!Ctanim.fiyatListesiKosul
                  .contains(results[i].guncelDegerler!.seciliFiyati)) {
                Ctanim.fiyatListesiKosul
                    .add(results[i].guncelDegerler!.seciliFiyati!);
              }
            }
            tempList.assignAll(results);
          } else {
            int sayac = 0;
            List<StokKart> results2 = [];
            for (var element in results) {
              if (Ctanim.secililiMarkalarFiltre.contains(element.MARKA)) {
                if (sayac < 100) {
                  sayac++;
                  results2.add(element);
                } else {
                  break;
                }
              }
            }

            for (int i = 0; i < results2.length; i++) {
              List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                  results2[i],
                  cariKod,
                  fiyatTip,
                  satisTipi,
                  stokFiyatListesiModel,
                  seciliAltHesapID);
              results2[i].guncelDegerler!.carpan = 1.0;
              results2[i].guncelDegerler!.guncelBarkod = results2[i].KOD!;
              results2[i].guncelDegerler!.fiyat =
                  double.parse(gelenFiyatVeIskonto[0].toString());

              results2[i].guncelDegerler!.iskonto1 =
                  double.parse(gelenFiyatVeIskonto[1].toString());

              results2[i].guncelDegerler!.iskonto2 =
                  double.parse(gelenFiyatVeIskonto[4].toString());

              results2[i].guncelDegerler!.iskonto3 =
                  double.parse(gelenFiyatVeIskonto[5].toString());

              results2[i].guncelDegerler!.iskonto4 =
                  double.parse(gelenFiyatVeIskonto[6].toString());

              results2[i].guncelDegerler!.iskonto5 =
                  double.parse(gelenFiyatVeIskonto[7].toString());

              results2[i].guncelDegerler!.iskonto6 =
                  double.parse(gelenFiyatVeIskonto[8].toString());

              results2[i].guncelDegerler!.seciliFiyati =
                  gelenFiyatVeIskonto[2].toString();
              results2[i].guncelDegerler!.fiyatDegistirMi =
                  gelenFiyatVeIskonto[3];

              results2[i].guncelDegerler!.netfiyat =
                  results2[i].guncelDegerler!.hesaplaNetFiyat();
              if (!Ctanim.fiyatListesiKosul
                  .contains(results2[i].guncelDegerler!.seciliFiyati)) {
                Ctanim.fiyatListesiKosul
                    .add(results2[i].guncelDegerler!.seciliFiyati!);
              }
            }
            tempList.assignAll(results2);
          }
        }
      } else {
        if (cariKod == "") {
          if (Ctanim.secililiMarkalarFiltre.isEmpty) {
            tempList.assignAll(results);
          } else {
            results.removeWhere((element) =>
                !Ctanim.secililiMarkalarFiltre.contains(element.MARKA));

            tempList.assignAll(results);
          }
        } else {
          if (Ctanim.secililiMarkalarFiltre.isEmpty) {
            for (int i = 0; i < results.length; i++) {
              List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                  results[i],
                  cariKod,
                  fiyatTip,
                  satisTipi,
                  stokFiyatListesiModel,
                  seciliAltHesapID);
              results[i].guncelDegerler!.carpan = 1.0;
              results[i].guncelDegerler!.guncelBarkod = results[i].KOD!;
              results[i].guncelDegerler!.fiyat =
                  double.parse(gelenFiyatVeIskonto[0].toString());

              results[i].guncelDegerler!.iskonto1 =
                  double.parse(gelenFiyatVeIskonto[1].toString());

              results[i].guncelDegerler!.iskonto2 =
                  double.parse(gelenFiyatVeIskonto[4].toString());

              results[i].guncelDegerler!.iskonto3 =
                  double.parse(gelenFiyatVeIskonto[5].toString());

              results[i].guncelDegerler!.iskonto4 =
                  double.parse(gelenFiyatVeIskonto[6].toString());

              results[i].guncelDegerler!.iskonto5 =
                  double.parse(gelenFiyatVeIskonto[7].toString());

              results[i].guncelDegerler!.iskonto6 =
                  double.parse(gelenFiyatVeIskonto[8].toString());

              results[i].guncelDegerler!.seciliFiyati =
                  gelenFiyatVeIskonto[2].toString();
              results[i].guncelDegerler!.fiyatDegistirMi =
                  gelenFiyatVeIskonto[3];

              results[i].guncelDegerler!.netfiyat =
                  results[i].guncelDegerler!.hesaplaNetFiyat();
              if (!Ctanim.fiyatListesiKosul
                  .contains(results[i].guncelDegerler!.seciliFiyati)) {
                Ctanim.fiyatListesiKosul
                    .add(results[i].guncelDegerler!.seciliFiyati!);
              }
            }
            tempList.assignAll(results);
          } else {
            List<StokKart> result2 = [];

            for (int i = 0; i < results.length; i++) {
              if (Ctanim.secililiMarkalarFiltre
                  .any((item) => item == results[i].MARKA)) {
                result2.add(results[i]);
              }
            }
            for (int i = 0; i < result2.length; i++) {
              List<dynamic> gelenFiyatVeIskonto = fiyatgetir(
                  result2[i],
                  cariKod,
                  fiyatTip,
                  satisTipi,
                  stokFiyatListesiModel,
                  seciliAltHesapID);
              result2[i].guncelDegerler!.carpan = 1.0;
              result2[i].guncelDegerler!.guncelBarkod = result2[i].KOD!;
              result2[i].guncelDegerler!.fiyat =
                  double.parse(gelenFiyatVeIskonto[0].toString());

              result2[i].guncelDegerler!.iskonto1 =
                  double.parse(gelenFiyatVeIskonto[1].toString());

              result2[i].guncelDegerler!.iskonto2 =
                  double.parse(gelenFiyatVeIskonto[4].toString());

              result2[i].guncelDegerler!.iskonto3 =
                  double.parse(gelenFiyatVeIskonto[5].toString());

              result2[i].guncelDegerler!.iskonto4 =
                  double.parse(gelenFiyatVeIskonto[6].toString());

              result2[i].guncelDegerler!.iskonto5 =
                  double.parse(gelenFiyatVeIskonto[7].toString());

              result2[i].guncelDegerler!.iskonto6 =
                  double.parse(gelenFiyatVeIskonto[8].toString());

              result2[i].guncelDegerler!.seciliFiyati =
                  gelenFiyatVeIskonto[2].toString();
              result2[i].guncelDegerler!.fiyatDegistirMi =
                  gelenFiyatVeIskonto[3];

              result2[i].guncelDegerler!.netfiyat =
                  result2[i].guncelDegerler!.hesaplaNetFiyat();
              if (!Ctanim.fiyatListesiKosul
                  .contains(result2[i].guncelDegerler!.seciliFiyati)) {
                Ctanim.fiyatListesiKosul
                    .add(result2[i].guncelDegerler!.seciliFiyati!);
              }
            }

            tempList.assignAll(result2);
          }
        }
      }
    }
  }

//servisten stokları günceller
  Future<String> servisStokGetir() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      print("internet yok");
      const snackBar = SnackBar(
        content: Text(
          'İnternet bağlantısı yok.',
          style: TextStyle(fontSize: 16),
        ),
        showCloseIcon: true,
        backgroundColor: Colors.blue,
        closeIconColor: Colors.white,
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      return "İnternet bağlantısı yok.";
    } else {
      if (Ctanim.db == null) {
        const snackBar = SnackBar(
          content: Text(
            'Veritabanı bağlantısı başarısız.',
            style: TextStyle(fontSize: 16),
          ),
          showCloseIcon: true,
          backgroundColor: Colors.blue,
          closeIconColor: Colors.white,
        );
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
        return 'Veritabanı bağlantısı başarısız.';
      } else {
        String don = await bs.getirStoklar(
            kullaniciKodu: Ctanim.kullanici!.KOD, sirket: Ctanim.sirket!);
        return don;
      }
    }
  }
}
