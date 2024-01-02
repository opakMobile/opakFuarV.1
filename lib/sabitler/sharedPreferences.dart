import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Ctanim.dart';

class SharedPrefsHelper {
  static Future<void> IpKaydet(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Ctanim.IP = ip;
    await prefs.setString('ip', ip);
  }

  static Future<String> IpGetir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ip = prefs.getString('ip');
    if (ip != null) {
      Ctanim.IP = ip;
      return ip;
    } else {
      return "";
    }
  }

  static Future<void> sirketSil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('sirket');
  }

  static Future<void> sirketKaydet(String sirket) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Ctanim.sirket = sirket;
    await prefs.setString('sirket', sirket);
  }

  static Future<String> sirketGetir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sirket = prefs.getString('sirket');
    if (sirket != null) {
      Ctanim.sirket = sirket;
      return sirket;
    } else {
      return "";
    }
  }

  static Future<void> siparisNumarasiKaydet(int number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('siparisNo', number.toString());
  }

  static Future<int> siparisNumarasiGetir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedNumber = prefs.getString('siparisNo');
    if (storedNumber != null) {
      return int.parse(storedNumber);
    } else {
      return -1;
    }
  }

  static Future<void> siparisNumarasiSil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('siparisNo');
  }

  static Future<void> IpSil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('ip');
  }

  static Future<void> lisansNumarasiKaydet(String lisans) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lisansNo', lisans);
  }

  static Future<void> saveList(List<bool> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = list.map((item) => item.toString()).toList();
    await prefs.setStringList("savelist", stringList);
  }

  static Future<void> yetkiKaydet(List<bool> boolList, String _key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String boolListString =
          boolList.map((boolVal) => boolVal.toString()).join(',');
      prefs.setString(_key, boolListString);
    } catch (e) {
      print("Kaydetme Hatası: $e");
    }
  }

  static Future<List<bool>> yetkiCek(String _key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? boolListString = prefs.getString(_key);
      if (boolListString == null || boolListString.isEmpty) {
        return [];
      }

      List<String> boolStringList = boolListString.split(',');

      List<bool> boolList = boolStringList.map((str) => str == 'true').toList();
      listeler.plasiyerYetkileri.clear();
      listeler.plasiyerYetkileri.addAll(boolList);
      return boolList;
    } catch (e) {
      print("Çekme Hatası: $e");
      return [];
    }
  }

  static Future<void> kullaniciKoduKaydet(String kod) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('setKulKod', kod);
  }
  
    static Future<void> cariKoduKaydet(int number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cariKod', number.toString());
  }

  static Future<int> cariKoduGetir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedNumber = prefs.getString('cariKod');
    if (storedNumber != null) {
      return int.parse(storedNumber);
    } else {
      return -1;
    }
  }
}
