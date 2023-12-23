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
