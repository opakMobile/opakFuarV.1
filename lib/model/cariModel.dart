import 'package:opak_fuar/model/cariAltHesapModel.dart';

class Cari {
  int? ID;
  int? KOSULID;
  String? KOD = "";
  String? ADI = "";
  String? ILCE = "";
  String? IL = "";
  String? ADRES = "";
  String? VERGIDAIRESI = "";
  String? VERGINO = "";
  String? KIMLIKNO = "";
  String? TIPI = "";
  String? TELEFON = "";
  String? FAX = "";
  int? FIYAT = 0;
  int? ULKEID = 0;
  String? EMAIL = "";
  String? WEB = "";
  int? PLASIYERID = 0;
  double? ISKONTO = 0.0;
  String? EFATURAMI = "H";
  String? VADEGUNU = "";
  String? ACIKLAMA1 = "";
  double? BAKIYE = 0.0;
  List<CariAltHesap> cariAltHesaplar = [];

  Cari(
      {this.ID,
      this.KOSULID,
      this.KOD,
      this.ADI,
      this.ILCE,
      this.IL,
      this.ADRES,
      this.VERGIDAIRESI,
      this.VERGINO,
      this.KIMLIKNO,
      this.TIPI,
      this.TELEFON,
      this.FAX,
      this.FIYAT,
      this.ULKEID,
      this.EMAIL,
      this.WEB,
      this.PLASIYERID,
      this.ISKONTO,
      this.EFATURAMI,
      this.VADEGUNU,
      this.ACIKLAMA1,
      this.BAKIYE});

  Cari.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    KOSULID = int.parse(json['KOSULID'].toString());
    KOD = json['KOD'];
    ADI = json['ADI'];
    ILCE = json['ILCE'];
    IL = json['IL'];
    ADRES = json['ADRES'];
    VERGIDAIRESI = json['VERGI_DAIRESI'];
    VERGINO = json['VERGINO'].toString();
    KIMLIKNO = json['KIMLIKNO'].toString();
    TIPI = json['TIPI'];
    TELEFON = json['TELEFON'].toString();
    FAX = json['FAX'].toString();
    FIYAT = int.parse(json['FIYAT'].toString());
    ULKEID = int.parse(json['ULKEID'].toString());
    EMAIL = json['EMAIL'];
    WEB = json['WEB'];
    PLASIYERID = int.parse(json['PLASIYERID'].toString());
    ISKONTO = double.parse(json['ISKONTO'].toString());
    EFATURAMI = json['EFATURAMI'];
    VADEGUNU = json['VADEGUNU'];
    ACIKLAMA1 = json['ACIKLAMA1'];
    BAKIYE = double.parse(json['BAKIYE'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['KOSULID'] = KOSULID;
    data['KOD'] = KOD;
    data['ADI'] = ADI;
    data['ILCE'] = ILCE;
    data['IL'] = IL;
    data['ADRES'] = ADRES;
    data['VERGIDAIRESI'] = VERGIDAIRESI;
    data['VERGINO'] = VERGINO;
    data['KIMLIKNO'] = KIMLIKNO;
    data['TIPI'] = TIPI;
    data['TELEFON'] = TELEFON;
    data['FAX'] = FAX;
    data['FIYAT'] = FIYAT;
    data['ULKEID'] = ULKEID;
    data['EMAIL'] = EMAIL;
    data['WEB'] = WEB;
    data['PLASIYERID'] = PLASIYERID;
    data['ISKONTO'] = ISKONTO;
    data['EFATURAMI'] = EFATURAMI;
    data['VADEGUNU'] = VADEGUNU;
    data['ACIKLAMA1'] = ACIKLAMA1;
    data['BAKIYE'] = BAKIYE;
    return data;
  }
}
