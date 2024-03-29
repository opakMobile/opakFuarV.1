import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../sabitler/Ctanim.dart';

class FisHareket {
  int? ID = 0;
  String? ALTHESAP;
  int? FIS_ID = 0;
  String? UUID = "";
  int? MIKTAR = 0;
  double? BRUTFIYAT = 0.0; // liste fiyatı
  double? ISKONTO = 0.0; // brutfiyat-netfiyat
  double? KDVDAHILNETFIYAT = 0.0; //NETFİYAT*(1+(KDVTUTAR/100))
  double? KDVORANI = 0.0;
  double? KDVTUTAR = 0.0; // NETFİYAT*(KDVORANI/100)
  double? ISK = 0.0;
  double? ISK2 = 0.0;
  double? ISK3 = 0.0;
  double? ISK4 = 0.0;
  double? ISK5 = 0.0;
  double? ISK6 = 0.0;
  double? NETFIYAT = 0.0; // brut * (1-(ISK1/100))*(1-(ISK2/100))3
  double? BRUTTOPLAMFIYAT = 0.0; //burut*miktar
  double? NETTOPLAM = 0.0;
  double? ISKONTOTOPLAM = 0.0;
  double? KDVDAHILNETTOPLAM = 0.0;
  double? KDVTOPLAM = 0.0;
  String? STOKKOD = "";
  String? STOKADI = "";
  String? BIRIM = "";
  int? BIRIMID = 0;
  int? DOVIZID = 0;
  String? DOVIZADI = "";
  String? TARIH = DateFormat("yyyy-MM-dd").format(DateTime.now());
  double? KUR = 0.0;
  String? ACIKLAMA1 = "";
  int MALFAZLASI = 0;
  bool? AltHesapDegistir = false;

  FisHareket({
    required this.ID,
    required this.ALTHESAP,
    required this.FIS_ID,
    required this.STOKKOD,
    required this.STOKADI,
    required this.KDVORANI,
    required this.MIKTAR,
    required this.BRUTFIYAT,
    required this.ISKONTO,
    required this.ISK,
    required this.ISK2,
    required this.ISK3,
    required this.ISK4,
    required this.ISK5,
    required this.ISK6,
    required this.NETFIYAT,
    required this.KDVDAHILNETFIYAT,
    required this.BRUTTOPLAMFIYAT,
    required this.NETTOPLAM,
    required this.KDVDAHILNETTOPLAM,
    required this.KDVTOPLAM,
    required this.ISKONTOTOPLAM,
    required this.BIRIM,
    required this.BIRIMID,
    required this.KDVTUTAR,
    required this.DOVIZID,
    required this.DOVIZADI,
    required this.TARIH,
    required this.KUR,
    required this.ACIKLAMA1,
    required this.UUID,
    required this.MALFAZLASI
  });
  
 
FisHareket.fromFishareket(FisHareket fisHareket){
  this.ID = fisHareket.ID;
  this.ALTHESAP = fisHareket.ALTHESAP;
  this.FIS_ID = fisHareket.FIS_ID;
  this.STOKKOD = fisHareket.STOKKOD;
  this.STOKADI = fisHareket.STOKADI;
  this.KDVORANI = fisHareket.KDVORANI;
  this.MIKTAR = fisHareket.MIKTAR;
  this.BRUTFIYAT = fisHareket.BRUTFIYAT;
  this.ISKONTO = fisHareket.ISKONTO;
  this.ISK = fisHareket.ISK;
  this.ISK2 = fisHareket.ISK2;
  this.ISK3 = fisHareket.ISK3;
  this.ISK4 = fisHareket.ISK4;
  this.ISK5 = fisHareket.ISK5;
  this.ISK6 = fisHareket.ISK6;
  this.NETFIYAT = fisHareket.NETFIYAT;
  this.KDVDAHILNETFIYAT = fisHareket.KDVDAHILNETFIYAT;
  this.BRUTTOPLAMFIYAT = fisHareket.BRUTTOPLAMFIYAT;
  this.NETTOPLAM = fisHareket.NETTOPLAM;
  this.KDVDAHILNETTOPLAM = fisHareket.KDVDAHILNETTOPLAM;
  this.KDVTOPLAM = fisHareket.KDVTOPLAM;
  this.ISKONTOTOPLAM = fisHareket.ISKONTOTOPLAM;
  this.BIRIM = fisHareket.BIRIM;
  this.BIRIMID = fisHareket.BIRIMID;
  this.KDVTUTAR = fisHareket.KDVTUTAR;
  this.DOVIZID = fisHareket.DOVIZID;
  this.DOVIZADI = fisHareket.DOVIZADI;
  this.TARIH = fisHareket.TARIH;
  this.KUR = fisHareket.KUR;
  this.ACIKLAMA1 = fisHareket.ACIKLAMA1;
  this.UUID = fisHareket.UUID;
  this.MALFAZLASI = fisHareket.MALFAZLASI;

    

}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = ID;
    data['ALTHESAP'] = ALTHESAP;
    data['FIS_ID'] = FIS_ID;
    data['STOKKOD'] = STOKKOD;
    data['STOKADI'] = STOKADI;
    data['KDVORANI'] = KDVORANI;
    data['MIKTAR'] = MIKTAR;
    data['BRUTFIYAT'] = BRUTFIYAT;
    data['ISKONTO'] = ISKONTO;
    data['ISK'] = ISK;
    data['ISK2'] = ISK2;
    data['ISK3'] = ISK3;
    data['ISK4'] = ISK4;
    data['ISK5'] = ISK5;
    data['ISK6'] = ISK6;
    data['NETFIYAT'] = NETFIYAT;
    data['KDVDAHILNETFIYAT'] = KDVDAHILNETFIYAT;
    data['BRUTTOPLAMFIYAT'] = BRUTTOPLAMFIYAT;
    data['NETTOPLAM'] = NETTOPLAM;
    data['ISKONTOTOPLAM'] = ISKONTOTOPLAM;
    data['KDVDAHILNETTOPLAM'] = KDVDAHILNETTOPLAM;
    data['KDVTOPLAM'] = KDVTOPLAM;
    data['BIRIM'] = BIRIM;
    data['BIRIMID'] = BIRIMID;
    data['KDVTUTAR'] = KDVTUTAR;
    data['DOVIZID'] = DOVIZID;
    data['DOVIZADI'] = DOVIZADI;
    data['TARIH'] = TARIH;
    data['KUR'] = KUR;
    data['ACIKLAMA1'] = ACIKLAMA1;
    data['UUID'] = UUID;
    data['MALFAZLASI'] = MALFAZLASI;
    return data;
  }

  FisHareket.empty()
      : this(
          ID: 0,
          ALTHESAP: "",
          FIS_ID: 0,
          STOKKOD: "",
          STOKADI: "",
          KDVORANI: 0.0,
          ISKONTO: 0.0,
          MIKTAR: 0,
          BRUTFIYAT: 0.0,
          ISK: 0.0,
          ISK2: 0.0,
          ISK3: 0.0,
          ISK4: 0.0,
          ISK5: 0.0,
          ISK6: 0.0,
          BRUTTOPLAMFIYAT: 0.0,
          NETFIYAT: 0.0,
          KDVDAHILNETFIYAT: 0.0,
          BIRIM: "",
          BIRIMID: 0,
          KDVTUTAR: 0.0,
          DOVIZID: 0,
          DOVIZADI: "",
          TARIH: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          KUR: 1.0,
          ACIKLAMA1: "",
          UUID: "",
          ISKONTOTOPLAM: 0.0,
          KDVDAHILNETTOPLAM: 0.0,
          KDVTOPLAM: 0.0,
          NETTOPLAM: 0.0,
          MALFAZLASI: 0
        );
  FisHareket.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    ALTHESAP = json['ALTHESAP'];
    FIS_ID = int.parse(json['FIS_ID'].toString());
    STOKKOD = json['STOKKOD'];
    STOKADI = json['STOKADI'];
    KDVORANI = double.parse(json['KDVORANI'].toString());
    MIKTAR = int.parse(json['MIKTAR'].toString());
    BRUTFIYAT = double.parse(json['BRUTFIYAT'].toString());
    ISKONTO = double.parse(json['ISKONTO'].toString());
    ISK = double.parse(json['ISK'].toString());
    ISK2 = double.parse(json['ISK2'].toString());
    ISK3 = double.parse(json['ISK3'].toString());
    ISK4 = double.parse(json['ISK4'].toString());
    ISK5 = double.parse(json['ISK5'].toString());
    ISK6 = double.parse(json['ISK6'].toString());
    NETFIYAT = double.parse(json['NETFIYAT'].toString());
    KDVDAHILNETFIYAT = double.parse(json['KDVDAHILNETFIYAT'].toString());
    BRUTTOPLAMFIYAT = double.parse(json['BRUTTOPLAMFIYAT'].toString());
    NETTOPLAM = double.parse(json['NETTOPLAM'].toString());
    ISKONTOTOPLAM = double.parse(json['ISKONTOTOPLAM'].toString());
    KDVDAHILNETTOPLAM = double.parse(json['KDVDAHILNETTOPLAM'].toString());
    KDVTOPLAM = double.parse(json['KDVTOPLAM'].toString());
    BIRIM = json['BIRIM'];
    BIRIMID = int.parse(json['BIRIMID'].toString());
    KDVTUTAR = double.parse(json['KDVTUTAR'].toString());
    DOVIZID = int.parse(json['DOVIZID'].toString());
    DOVIZADI = json['DOVIZADI'];
    TARIH = json['TARIH'];
    KUR = double.parse(json['KUR'].toString());
    ACIKLAMA1 = json['ACIKLAMA1'];
    UUID = json['UUID'];
    MALFAZLASI = int.parse(json['MALFAZLASI'].toString());
  }

  Future<int?> fisHareketEkle(FisHareket fisHareket) async {
    if (fisHareket.ID! > 0) {
      try {
        var result = await Ctanim.db?.update("TBLFISHAR", fisHareket.toJson(),
            where: 'ID = ?', whereArgs: [fisHareket.ID]);
        return result;
      } on PlatformException catch (e) {
        return -1;
      }
    } else {
      try {
        fisHareket.ID = null;
        var result = await Ctanim.db?.insert("TBLFISHAR", fisHareket.toJson());

        return result;
      } on PlatformException catch (e) {
        return -1;
      }
    }
  }

  Future<int> fisHareketSil(int Id) async {
    var result =
        await Ctanim.db?.delete("TBLFISHAR", where: 'ID = ?', whereArgs: [Id]);
    return result;
  }
}
