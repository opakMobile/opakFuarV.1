/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myjsonString>);
var myKullaniciModelNode = KullaniciModel.fromjson(map);
*/
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class KullaniciModel {
  String? KOD;
  String? SIFRE;
  String? KASAKOD;
  String? ONLINE;
  String? ISLEMAKTARILSIN;
  String? STOKKISIT;
  String? CARIKISIT;
  String? DEPOKISIT;
  String? SFIYAT1;
  String? SFIYAT2;
  String? SFIYAT3;
  String? SFIYAT4;
  String? SFIYAT5;
  String? LISTEFIYAT;
  String? SONFIYAT;
  String? FIYATDEGISTIRILSIN;
  String? SISK1;
  String? SISK2;
  String? SISK3;
  String? SISK4;
  String? SISK5;
  String? SISK6;
  String? SISKDEGISTIRILSIN1;
  String? SISKDEGISTIRILSIN2;
  String? SISKDEGISTIRILSIN3;
  String? SISKDEGISTIRILSI4;
  String? SISKDEGISTIRILSIN5;
  String? SISKDEGISTIRILSIN6;
  String? GISK1;
  String? GISK2;
  String? GISK3;
  String? GISKDEGISTIRILSIN1;
  String? GISKDEGISTIRILSIN2;
  String? GISKDEGISTIRILSIN3;
  String? SATISTIPI;
  String? ARACDEPO;
  String? EFATURA;
  String? EARSIV;
  String? EFATURASERINO;
  String? EARSIVSERINO;
  String? FATURASERISERINO;
  String? ONAYVARMI;
  String? SIPKDV;
  String? FATKDV;
  String? PLASIYERMUSTERI;
  String? CARIBAKIYEONLINE;
  String? EIRSALIYESERINO;
  String? IRSALIYESERISERINO;
  String? SATIRSKDV;
  String? ALIRSKDV;
  String? EIRSALIYE;
  String? PERSATKDV;
  String? YERELSUBEID;
  String? YERELDEPOID;
  String? SATISTEKLIFKDV;
  String? INTERAKTIFRAPOR;
  String? KDVISKONTOONCE;
  String? KDVDAHILFATURAISKONTOSONRA;
  String? ALISFIYATGORMESIN;
  String? KASAADI;
  String? EFATNO;
  String? EARSIVNO;
  String? FATNO;
  String? IRSNO;
  String? EIRSNO;
  String? OTOMATIKSTOKKODU;
  String? MALFAZLASI;
  String? PDFACIKLAMA;
  String? KULLANICIADI;
  String? FUARADI;
  String? BAYISECILI;

  KullaniciModel(
      {this.KOD,
      this.SIFRE,
      this.KASAKOD,
      this.ONLINE,
      this.ISLEMAKTARILSIN,
      this.STOKKISIT,
      this.CARIKISIT,
      this.DEPOKISIT,
      this.SFIYAT1,
      this.SFIYAT2,
      this.SFIYAT3,
      this.SFIYAT4,
      this.SFIYAT5,
      this.LISTEFIYAT,
      this.SONFIYAT,
      this.FIYATDEGISTIRILSIN,
      this.SISK1,
      this.SISK2,
      this.SISK3,
      this.SISK4,
      this.SISK5,
      this.SISK6,
      this.SISKDEGISTIRILSIN1,
      this.SISKDEGISTIRILSIN2,
      this.SISKDEGISTIRILSIN3,
      this.SISKDEGISTIRILSI4,
      this.SISKDEGISTIRILSIN5,
      this.SISKDEGISTIRILSIN6,
      this.GISK1,
      this.GISK2,
      this.GISK3,
      this.GISKDEGISTIRILSIN1,
      this.GISKDEGISTIRILSIN2,
      this.GISKDEGISTIRILSIN3,
      this.SATISTIPI,
      this.ARACDEPO,
      this.EFATURA,
      this.EARSIV,
      this.EFATURASERINO,
      this.EARSIVSERINO,
      this.FATURASERISERINO,
      this.ONAYVARMI,
      this.SIPKDV,
      this.FATKDV,
      this.PLASIYERMUSTERI,
      this.CARIBAKIYEONLINE,
      this.EIRSALIYESERINO,
      this.IRSALIYESERISERINO,
      this.SATIRSKDV,
      this.ALIRSKDV,
      this.EIRSALIYE,
      this.PERSATKDV,
      this.YERELSUBEID,
      this.YERELDEPOID,
      this.SATISTEKLIFKDV,
      this.INTERAKTIFRAPOR,
      this.KDVISKONTOONCE,
      this.KDVDAHILFATURAISKONTOSONRA,
      this.ALISFIYATGORMESIN,
      this.KASAADI,
      this.EFATNO,
      this.EARSIVNO,
      this.FATNO,
      this.IRSNO,
      this.EIRSNO,
      this.OTOMATIKSTOKKODU,
      this.MALFAZLASI,
      this.PDFACIKLAMA,
      this.KULLANICIADI,
      this.FUARADI,
      this.BAYISECILI});

  KullaniciModel.fromjson(Map<String, dynamic> json) {
    KOD = json['KOD'] ?? "KOD";
    SIFRE = json['SIFRE'] ?? "SIFRE";
    KASAKOD = json['KASAKOD'] ?? "KASAKOD";
    ONLINE = json['ONLINE'] ?? "ONLINE";
    ISLEMAKTARILSIN = json['ISLEMAKTARILSIN'] ?? "ISLEMAKTARILSIN";
    STOKKISIT = json['STOKKISIT'] ?? "STOKKISIT";
    CARIKISIT = json['CARIKISIT'] ?? "CARIKISIT";
    DEPOKISIT = json['DEPOKISIT'] ?? "DEPOKISIT";
    SFIYAT1 = json['SFIYAT1'] ?? "SFIYAT1";
    SFIYAT2 = json['SFIYAT2'] ?? "SFIYAT2";
    SFIYAT3 = json['SFIYAT3'] ?? "SFIYAT3";
    SFIYAT4 = json['SFIYAT4'] ?? "SFIYAT4";
    SFIYAT5 = json['SFIYAT5'] ?? "SFIYAT5";
    LISTEFIYAT = json['LISTEFIYAT'] ?? "LISTEFIYAT";
    SONFIYAT = json['SONFIYAT'] ?? "SONFIYAT";
    FIYATDEGISTIRILSIN = json['FIYATDEGISTIRILSIN'] ?? "FIYATDEGISTIRILSIN";
    SISK1 = json['SISK1'] ?? "SISK1";
    SISK2 = json['SISK2'] ?? "SISK2";
    SISK3 = json['SISK3'] ?? "SISK3";
    SISK4 = json['SISK4'] ?? "SISK4";
    SISK5 = json['SISK5'] ?? "SISK5";
    SISK6 = json['SISK6'] ?? "SISK6";
    SISKDEGISTIRILSIN1 = json['SISKDEGISTIRILSIN1'] ?? "SISKDEGISTIRILSIN1";
    SISKDEGISTIRILSIN2 = json['SISKDEGISTIRILSIN2'] ?? "SISKDEGISTIRILSIN2";
    SISKDEGISTIRILSIN3 = json['SISKDEGISTIRILSIN3'] ?? "SISKDEGISTIRILSIN3";
    SISKDEGISTIRILSI4 = json['SISKDEGISTIRILSI4'] ?? "SISKDEGISTIRILSI4";
    SISKDEGISTIRILSIN5 = json['SISKDEGISTIRILSIN5'] ?? "SISKDEGISTIRILSIN5";
    SISKDEGISTIRILSIN6 = json['SISKDEGISTIRILSIN6'] ?? "SISKDEGISTIRILSIN6";
    GISK1 = json['GISK1'] ?? "GISK1";
    GISK2 = json['GISK2'] ?? "GISK2";
    GISK3 = json['GISK3'] ?? "GISK3";
    GISKDEGISTIRILSIN1 = json['GISKDEGISTIRILSIN1'] ?? "GISKDEGISTIRILSIN1";
    GISKDEGISTIRILSIN2 = json['GISKDEGISTIRILSIN2'] ?? "GISKDEGISTIRILSIN2";
    GISKDEGISTIRILSIN3 = json['GISKDEGISTIRILSIN3'] ?? "GISKDEGISTIRILSIN3";
    SATISTIPI = json['SATISTIPI'] ?? "SATISTIPI";
    ARACDEPO = json['ARACDEPO'] ?? "ARACDEPO";
    EFATURA = json['EFATURA'] ?? "EFATURA";
    EARSIV = json['EARSIV'] ?? "EARSIV";
    EFATURASERINO = json['EFATURA_SERINO'] ?? "EFATURA_SERINO";
    EARSIVSERINO = json['EARSIV_SERINO'] ?? "EARSIV_SERINO";
    FATURASERISERINO = json['FATURASERI_SERINO'] ?? "FATURASERI_SERINO";
    ONAYVARMI = json['ONAYVARMI'] ?? "ONAYVARMI";
    SIPKDV = json['SIPKDV'] ?? "SIPKDV";
    FATKDV = json['FATKDV'] ?? "FATKDV";
    PLASIYERMUSTERI = json['PLASIYERMUSTERI'] ?? "PLASIYERMUSTERI";
    CARIBAKIYEONLINE = json['CARIBAKIYEONLINE'] ?? "CARIBAKIYEONLINE";
    EIRSALIYESERINO = json['EIRSALIYE_SERINO'] ?? "EIRSALIYE_SERINO";
    IRSALIYESERISERINO = json['IRSALIYESERI_SERINO'] ?? "IRSALIYESERI_SERINO";
    SATIRSKDV = json['SATIRSKDV'] ?? "SATIRSKDV";
    ALIRSKDV = json['ALIRSKDV'] ?? "ALIRSKDV";
    EIRSALIYE = json['EIRSALIYE'] ?? "EIRSALIYE";
    PERSATKDV = json['PERSATKDV'] ?? "PERSATKDV";
    YERELSUBEID = json['YEREL_SUBEID'] ?? "YEREL_SUBEID";
    YERELDEPOID = json['YEREL_DEPOID'] ?? "YEREL_DEPOID";
    SATISTEKLIFKDV = json['SATISTEKLIFKDV'] ?? "SATISTEKLIFKDV";
    INTERAKTIFRAPOR = json['INTERAKTIF_RAPOR'] ?? "INTERAKTIF_RAPOR";
    KDVISKONTOONCE = json['KDVISKONTOONCE'] ?? "KDVISKONTOONCE";
    KDVDAHILFATURAISKONTOSONRA =
        json['KDVDAHILFATURAISKONTOSONRA'] ?? "KDVDAHILFATURAISKONTOSONRA";
    ALISFIYATGORMESIN = json['ALISFIYATGORMESIN'] ?? "ALISFIYATGORMESIN";
    KASAADI = json['KASAADI'] ?? "KASAADI";
    EFATNO = json['EFATNO'] ?? "EFATNO";
    EARSIVNO = json['EARSIVNO'] ?? "EARSIVNO";
    FATNO = json['FATNO'] ?? "FATNO";
    IRSNO = json['IRSNO'] ?? "IRSNO";
    MALFAZLASI = json['MALFAZLASI'] ?? "MALFAZLASI";
    EIRSNO = json['EIRSNO'] ?? "EIRSNO";
    OTOMATIKSTOKKODU = json['OTOMATIKSTOKKODU'] ?? "OTOMATIKSTOKKODU";
    PDFACIKLAMA = json['PDFACIKLAMA'] ?? "PDFACIKLAMA";
    KULLANICIADI = json['KULLANICIADI'] ?? "KULLANICIADI";
    BAYISECILI =json['BAYISECILI'] ?? "H";
    FUARADI = "";
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['KOD'] = KOD; //
    data['SIFRE'] = SIFRE; //
    data['KASAKOD'] = KASAKOD;
    data['ONLINE'] = ONLINE; //
    data['ISLEMAKTARILSIN'] = ISLEMAKTARILSIN; //
    data['STOKKISIT'] = STOKKISIT;

    ///
    data['CARIKISIT'] = CARIKISIT;

    ///
    data['DEPOKISIT'] = DEPOKISIT;

    ///
    data['SFIYAT1'] = SFIYAT1; //
    data['SFIYAT2'] = SFIYAT2; //
    data['SFIYAT3'] = SFIYAT3; //
    data['SFIYAT4'] = SFIYAT4; //
    data['SFIYAT5'] = SFIYAT5; //
    data['LISTEFIYAT'] = LISTEFIYAT;
    data['SONFIYAT'] = SONFIYAT;
    data['MALFAZLASI'] = MALFAZLASI;

    ///?????????
    data['FIYATDEGISTIRILSIN'] = FIYATDEGISTIRILSIN; //
    data['SISK1'] = SISK1; //
    data['SISK2'] = SISK2; //
    data['SISK3'] = SISK3; //
    data['SISK4'] = SISK4; //
    data['SISK5'] = SISK5; //
    data['SISK6'] = SISK6; //
    data['SISKDEGISTIRILSIN1'] = SISKDEGISTIRILSIN1; //
    data['SISKDEGISTIRILSIN2'] = SISKDEGISTIRILSIN2; //
    data['SISKDEGISTIRILSIN3'] = SISKDEGISTIRILSIN3; //
    data['SISKDEGISTIRILSI4'] = SISKDEGISTIRILSI4; //
    data['SISKDEGISTIRILSIN5'] = SISKDEGISTIRILSIN5; //
    data['SISKDEGISTIRILSIN6'] = SISKDEGISTIRILSIN6; //
    data['GISK1'] = GISK1; //
    data['GISK2'] = GISK2; //
    data['GISK3'] = GISK3; //
    data['GISKDEGISTIRILSIN1'] = GISKDEGISTIRILSIN1; //
    data['GISKDEGISTIRILSIN2'] = GISKDEGISTIRILSIN2; //
    data['GISKDEGISTIRILSIN3'] = GISKDEGISTIRILSIN3; //
    data['SATISTIPI'] = SATISTIPI;

    ///?????????
    data['ARACDEPO'] = ARACDEPO;

    ///?????????
    data['EFATURA'] = EFATURA; //
    data['EARSIV'] = EARSIV; //
    data['EFATURA_SERINO'] = EFATURASERINO; //
    data['EARSIV_SERINO'] = EARSIVSERINO; //
    data['FATURASERI_SERINO'] = FATURASERISERINO; //
    data['ONAYVARMI'] = ONAYVARMI;

    ///?????????
    data['SIPKDV'] = SIPKDV; //
    data['FATKDV'] = FATKDV; //
    data['PLASIYERMUSTERI'] = PLASIYERMUSTERI; // getir cariye paremetre gönder
    data['CARIBAKIYEONLINE'] = CARIBAKIYEONLINE;

    ///?????????
    data['EIRSALIYE_SERINO'] = EIRSALIYESERINO; //
    data['IRSALIYESERI_SERINO'] = IRSALIYESERISERINO; //
    data['SATIRSKDV'] = SATIRSKDV; //
    data['ALIRSKDV'] = ALIRSKDV; //
    data['EIRSALIYE'] = EIRSALIYE;

    ///
    data['PERSATKDV'] = PERSATKDV; //
    data['YEREL_SUBEID'] = YERELSUBEID; //
    data['YEREL_DEPOID'] = YERELDEPOID; //
    data['SATISTEKLIFKDV'] = SATISTEKLIFKDV; //
    data['INTERAKTIF_RAPOR'] = INTERAKTIFRAPOR;

    ///?????????
    data['KDVISKONTOONCE'] = KDVISKONTOONCE;

    ///?????????
    data['KDVDAHILFATURAISKONTOSONRA'] = KDVDAHILFATURAISKONTOSONRA;

    ///?????????
    data['ALISFIYATGORMESIN'] = ALISFIYATGORMESIN;
    data['KASAADI'] = KASAADI;
    data['EFATNO'] = EFATNO;
    data['EARSIVNO'] = EARSIVNO;
    data['FATNO'] = FATNO;
    data['IRSNO'] = IRSNO;
    data['EIRSNO'] = EIRSNO;
    data['OTOMATIKSTOKKODU'] = OTOMATIKSTOKKODU;
    data['PDFACIKLAMA'] = PDFACIKLAMA;
    data['KULLANICIADI'] = KULLANICIADI ?? "KULLANICIADI";
    data['BAYISECILI'] = BAYISECILI ?? "H";
    data['FUARADI'] = "";
    return data;
  }

  static Future<void> saveUser(KullaniciModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.tojson());
    await prefs.setString("kullanici", userJson);
  }

  static Future<KullaniciModel?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("kullanici");
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return KullaniciModel.fromjson(userMap);
    }
    return null;
  }

  static Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("kullanici");
  }
}

