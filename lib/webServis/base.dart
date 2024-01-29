import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:opak_fuar/db/veriTabaniIslemleri.dart';
import 'package:opak_fuar/model/KurModel.dart';
import 'package:opak_fuar/model/ShataModel.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/cariModel.dart';
import 'package:opak_fuar/model/fuarModel.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/model/stokKosulModel.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:xml/xml.dart' as xml;

import '../model/dahaFazlaBarkodModel.dart';
import '../model/kullaniciModel.dart';
import '../model/kullanıcıYetki.dart';
import '../model/olcuBirimModel.dart';
import '../model/stokFiyatListesiHarModel.dart';
import '../model/stokFiyatListesiModel.dart';
import '../sabitler/Ctanim.dart';
import '../sabitler/sharedPreferences.dart';

class BaseService {
  Future<void> tumVerileriGuncelle() async {
    await getirStoklar(
        sirket: Ctanim.sirket, kullaniciKodu: Ctanim.kullanici!.KOD!);

    await getirCariler(
        sirket: Ctanim.sirket,
        kullaniciKodu:
            Ctanim.kullanici!.KOD!); //aktarilmayanVarmi: aktarilmayanVarmi);
    await getirCariAltHesap(
        sirket: Ctanim.sirket!); //aktarilmayanVarMi: aktarilmayanVarmi);

    await getirKur(sirket: Ctanim.sirket);
    await getirStokKosul(sirket: Ctanim.sirket!);
  }

  Future<void> cariVerileriGuncelle() async {
    await getirCariler(
        sirket: Ctanim.sirket,
        kullaniciKodu:
            Ctanim.kullanici!.KOD!); //aktarilmayanVarmi: aktarilmayanVarmi);
    await getirCariAltHesap(
        sirket: Ctanim.sirket!); //aktarilmayanVarMi:aktarilmayanVarmi);
  }

  Future<void> stokVerileriGuncelle() async {
    await getirStoklar(
        sirket: Ctanim.sirket, kullaniciKodu: Ctanim.kullanici!.KOD!);
    //valla billa
    await getirStokKosul(sirket: Ctanim.sirket!);
  }

  String temizleKontrolKarakterleri(String metin) {
    final kontrolKarakterleri = RegExp(r'[\x00-\x1F\x7F]');
    return metin.replaceAll(kontrolKarakterleri, '');
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,1000}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  List<String> parseSoapResponse(String soapResponse) {
    var document = xml.XmlDocument.parse(soapResponse);
    var envelope = document.findAllElements('soap:Envelope').single;
    var body = envelope.findElements('soap:Body').single;
    var response = body.findElements('GetirAPKServisIPResponse').single;
    var result = response.findElements('GetirAPKServisIPResult').single;
    List<String> donecek = result.text.split("|");
    return donecek;
  }

  String temizleKontrolKarakterleri1(String metin) {
    final kontrolKarakterleri = RegExp(r'[\x00-\x1F\x7F]');

    final int chunkSize =
        1024; // Metni kaç karakterlik parçalara böleceğimizi belirtiyoruz.
    final int length = metin.length;
    final StringBuffer result = StringBuffer();

    for (int i = 0; i < length; i += chunkSize) {
      int end = (i + chunkSize < length) ? i + chunkSize : length;
      String chunk = metin.substring(i, end);
      result.write(chunk.replaceAll(kontrolKarakterleri, ''));
    }

    return result.toString();
  }
  

  Future<String> getirStoklar({required sirket, required kullaniciKodu}) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirStok'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirStok xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <PlasiyerKod>$kullaniciKodu</PlasiyerKod>
    </GetirStok>
  </soap:Body>
</soap:Envelope>
''';

    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      listeler.listStok = [];
      return "İnternet Yok";
    }

    List<StokKart> tt = [];
    try {
      http.Response response =
          await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        //var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
        //Map<String, dynamic> jsonData = jsonDecode(parsedXml.innerText);
        //SHataModel gelenHata = SHataModel.fromJson(jsonData);
        //  if (gelenHata.Hata == "true") {
        //    print(gelenHata.HataMesaj);
        //    return gelenHata.HataMesaj!;
        //   }
        //  else {

        var jsonData = [];
        try {
          var tt = temizleKontrolKarakterleri1(parsedXml.innerText);
          jsonData = json.decode(tt);
        } catch (e) {
          print(e);
        }
        List<StokKart> liststokTemp = [];

        liststokTemp = List<StokKart>.from(
            jsonData.map((model) => StokKart.fromJson(model)));
        listeler.listStok.clear();
        await VeriIslemleri().stokTabloTemizle();

        liststokTemp.forEach((webservisStok) async {
          await VeriIslemleri().stokEkle(webservisStok);
        });

        await VeriIslemleri().stokGetir();
        return "";
        // }
      } else {
        return " Stok Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } on PlatformException catch (e) {
      return "Stoklar için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }
  
  /*

  Future<String> getirStoklar({required sirket, required kullaniciKodu}) async {
    var url = Uri.parse(
        Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirStok'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirStok xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <PlasiyerKod>$kullaniciKodu</PlasiyerKod>
    </GetirStok>
  </soap:Body>
</soap:Envelope>
''';

    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      listeler.listStok.clear();
      return "İnternet Yok";
    }

    List<StokKart> tt = [];
    try {
      http.Response response =
          await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        Map<String, dynamic> jsonData = jsonDecode(parsedXml.innerText);
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          print(gelenHata.HataMesaj);
          return gelenHata.HataMesaj!;
        } else {
          String modelNode = gelenHata.HataMesaj!;
          Iterable? l;
          try {
            l = json.decode(temizleKontrolKarakterleri(modelNode));
          } catch (e) {
            print(e);
          }
          List<StokKart> liststokTemp = [];

          liststokTemp =
              List<StokKart>.from(l!.map((model) => StokKart.fromJson(model)));
          listeler.listStok.clear();
          await VeriIslemleri().stokTabloTemizle();

          liststokTemp.forEach((webservisStok) async {
            await VeriIslemleri().stokEkle(webservisStok);
          });

          await VeriIslemleri().stokGetir();
          return "";
        }
      } else {
        return " Stok Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } on PlatformException catch (e) {
      return "Stoklar için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }
  */

  Future<String> getirCariler({required sirket, required kullaniciKodu}) async {
    var url = Uri.parse(Ctanim.IP);
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirCari'
    };
    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirCari xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <PlasiyerKod>$kullaniciKodu</PlasiyerKod>
    </GetirCari>
  </soap:Body>
</soap:Envelope>
''';

    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      listeler.listCari = [];
      return "İnternet Yok";
    }
    List<Cari> ttcari = [];
    try {
      http.Response response =
          await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          String modelNode = gelenHata.HataMesaj!;

          Iterable? l;
          String temizJson = temizleKontrolKarakterleri(modelNode);
          try {
            l = json.decode(temizJson);
          } catch (e) {
            print(e);
          }

          List<Cari> listcariTemp = [];
          listcariTemp =
              List<Cari>.from(l!.map((model) => Cari.fromJson(model)));

          listeler.listCari.clear();
          await VeriIslemleri().cariTabloTemizle();

          listcariTemp.forEach((webservisCari) async {
            webservisCari.AKTARILDIMI = "E";
            await VeriIslemleri().cariEkle(webservisCari);
          });

          await VeriIslemleri().cariGetir();

          return "";
        }
      } else {
        return " Cariler Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }

      // databaseden veri getirir
    } on Exception catch (e) {
      listeler.listCari = ttcari;
      return "Cariler için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<String> getirKur({required sirket}) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirKur'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirKur xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
    </GetirKur>
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response =
          await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          listeler.listKur.clear();
          await VeriIslemleri().kurTemizle();

          String modelNode = gelenHata.HataMesaj!;
          Iterable l = json.decode(modelNode);

          listeler.listKur =
              List<KurModel>.from(l.map((model) => KurModel.fromJson(model)));

          for (var element in listeler.listKur) {
            await VeriIslemleri().kurEkle(element);
          }
          return "";
        }
      } else {
        Exception('Kur verisi alınamadı. StatusCode: ${response.statusCode}');
        return " Kurlar Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      Exception('Hata: $e');
      return "Kurlar için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<String> getKullanicilar(
      {required String kullaniciKodu,
      required String sirket,
      required String IP}) async {
    var url = Uri.parse(IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirPlasiyerParam'
    };

    String body = '''<?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:xsd="http://www.w3.org/2001/XMLSchema"
          xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <GetirPlasiyerParam xmlns="http://tempuri.org/">
            <Sirket>$sirket</Sirket>
            <PlasiyerKod>$kullaniciKodu</PlasiyerKod>
          </GetirPlasiyerParam>
        </soap:Body>
      </soap:Envelope>''';

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          String modelNode = gelenHata.HataMesaj!;
          List<dynamic> parsedList =
              json.decode(temizleKontrolKarakterleri(modelNode));
          Map<String, dynamic> kullaniciJson = parsedList[0];
          Ctanim.kullanici = KullaniciModel.fromjson(kullaniciJson);
          return "";
        }
      } else {
        print('SOAP isteği başarısız: ${response.statusCode}');
        return " Kullanıcı Bilgileri Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      print('Hata: $e');
      return " Kullanıcı bilgiler için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<String> getirCariAltHesap({required String sirket}) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirAltHesap'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirAltHesap xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
    </GetirAltHesap>
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          String modelNode = gelenHata.HataMesaj!;

          Iterable? l;
          String temizJson = temizleKontrolKarakterleri(modelNode);
          try {
            l = json.decode(temizJson);
          } catch (e) {
            print(e);
          }

          List<CariAltHesap> listcariTemp = [];
          listcariTemp = List<CariAltHesap>.from(
              l!.map((model) => CariAltHesap.fromJson(model)));

          listeler.listCariAltHesap.clear();
          await VeriIslemleri().cariAltHesapTabloTemizle();

          listcariTemp.forEach((webservisCari) async {
            await VeriIslemleri().cariAltHesapEkle(webservisCari);
          });

          await VeriIslemleri().cariAltHesapGetir();

          return "";
        }
      } else {
        Exception('Alt Hesaplar Alınamadı. StatusCode: ${response.statusCode}');
        return " Cari Alt Hesaplar Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      Exception('Hata: $e');
      return " Cari Alt Hesaplar için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  Future<String> kullaniciSayisiSorgula({
    required String LisansNo,
  }) async {
    var url = Uri.parse('http://setuppro.opakyazilim.net/Service1.asmx');
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/MobilLisansSorgula'
    };
    String? privateID = await _getId();
    print(privateID);

    String body = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <MobilLisansSorgula xmlns="http://tempuri.org/">
      <_MacAdres>$privateID</_MacAdres>
      <_LisansNo>$LisansNo</_LisansNo>
    </MobilLisansSorgula>
  </soap:Body>
</soap:Envelope>''';

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        String jsonData = temizleKontrolKarakterleri(parsedXml.innerText);
        if (jsonData == "OK") {
          return jsonData;
        } else {
          return "";
        }
      } else {
        print('SOAP isteği başarısız: ${response.statusCode}');
        return " Kullanıcı Sayısı Bilgileri Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      print('Hata: $e');
      return " Kullanıcı bilgiler için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<List<String>> makeSoapRequest(String lisansNumarasi) async {
    var url = Uri.parse('http://setuppro.opakyazilim.net/Service1.asmx');
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirAPKServisIP'
    };

    var body = "<?xml version=\"1.0\" encoding=\"utf-8\"?>  " +
        " <soap:Envelope xmlns:xsi=\"http:\/\/www.w3.org\/2001\/XMLSchema-instance\" xmlns:xsd=\"http:\/\/www.w3.org\/2001\/XMLSchema\" " +
        " xmlns:soap=\"http:\/\/schemas.xmlsoap.org\/soap\/envelope\/\">" +
        " <soap:Body>" +
        "<GetirAPKServisIP xmlns=\"http:\/\/tempuri.org\/\">" +
        "  <SipNo>$lisansNumarasi</SipNo>" +
        "</GetirAPKServisIP>" +
        " <\/soap:Body> " +
        " <\/soap:Envelope> ";

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        var tt = parseSoapResponse(response.body);
        return tt;
      } else {
        print('SOAP isteği başarısız: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }

  Future<String> getirPlasiyerYetki({
    required String sirket,
    required String kullaniciKodu,
    required String IP,
  }) async {
    var url = Uri.parse(IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirPlasiyeYetki'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirPlasiyeYetki xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <PlasiyerKod>$kullaniciKodu</PlasiyerKod>
    </GetirPlasiyeYetki>
  </soap:Body>
</soap:Envelope>
''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData = jsonDecode(parsedXml.innerText);
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          if (gelenHata.Hata == "false" && gelenHata.HataMesaj == "") {
            return "Veri Bulunamadı";
          }
          String modelNode = gelenHata.HataMesaj!;
          Iterable l = json.decode(modelNode);
          listeler.yetki.clear();

          listeler.yetki = List<KullaniciYetki>.from(
              l.map((model) => KullaniciYetki.fromJson(model)));

          for (var element in listeler.yetki) {
            print(element);
            bool sonBool;
            if (element.deger == "False") {
              sonBool = false;
            } else {
              sonBool = true;
            }
            listeler.plasiyerYetkileri.removeAt(element.sira!);
            listeler.plasiyerYetkileri.insert(element.sira!, sonBool);
          }
          await SharedPrefsHelper.yetkiKaydet(
              listeler.plasiyerYetkileri, "yetkiler");

          return "";
        }
      } else {
        Exception(
            'Plasiyer Yetki Alınamadı. StatusCode: ${response.statusCode}');

        return 'Plasiyer Yetki Alınamadı. StatusCode: ${response.statusCode}';
      }
    } catch (e) {
      Exception('Hata: $e');

      return "Plasiyer Yetki için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<String> getirStokFiyatListesi({
    required String sirket,
  }) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirStokFiyatListesi'
    };

    String body = '''
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
      <soap:Body>
        <GetirStokFiyatListesi xmlns="http://tempuri.org/">
          <Sirket>$sirket</Sirket>
        </GetirStokFiyatListesi>
      </soap:Body>
    </soap:Envelope>

    ''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          listeler.listStokFiyatListesi.clear();

          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));
          final List<Map<String, dynamic>> data =
              List<Map<String, dynamic>>.from(
                  json.decode(gelenHata.HataMesaj!));
          print(data);
          for (var element in jsonData) {
            StokFiyatListesiModel a = StokFiyatListesiModel.fromJson(element);
            listeler.listStokFiyatListesi.add(a);
          }
          listeler.listStokFiyatListesi.insert(
              0, StokFiyatListesiModel(ID: -1, ADI: "Kullanmadan Devam Et"));
          await VeriIslemleri().stokFiyatListesiTemizle();

          for (var element in listeler.listStokFiyatListesi) {
            await VeriIslemleri().stokFiyatListesiEkle(element);
          }

          return "";
        }
      } else {
        Exception(
            'Stok Fiyat Listesi (Koşul) Bilgisi Alınamadı. StatusCode: ${response.statusCode}');

        return "Stok Fiyat Listesi (Koşul) Alınamadı";
      }
    } catch (e) {
      print("aa" + e.toString());
      Exception('Hata: $e');

      return "Tanımlı Stok Fiyat Listesi (Koşul)  Bulunamadı";
    }
  }

  Future<String> getirStokFiyatHarListesi({
    required String sirket,
  }) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirStokFiyatListesiHar'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirStokFiyatListesiHar xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
    </GetirStokFiyatListesiHar>
  </soap:Body>
</soap:Envelope>

''';

    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          listeler.listStokFiyatListesiHar.clear();
          List<dynamic> jsonData = jsonDecode(temizleKontrolKarakterleri(gelenHata
              .HataMesaj!)); // burayı kaldır aga gereksiz bi daha bekletiyo decodelere
          /*
          final List<Map<String, dynamic>> data =
              List<Map<String, dynamic>>.from(
                  json.decode(gelenHata.HataMesaj!)); //bak
          await VeriIslemleri().stokFiyatListesiHarTemizle();
          */

          for (var element in jsonData) {
            StokFiyatListesiHarModel a =
                StokFiyatListesiHarModel.fromJson(element);
            listeler.listStokFiyatListesiHar.add(a);
          }

          for (var element in listeler.listStokFiyatListesiHar) {
            await VeriIslemleri().stokFiyatListesiHarEkle(element);
          }

          return "";
        }
      } else {
        Exception(
            'Stok Fiyat Listesi Hareketleri (Koşul) Bilgisi Alınamadı. StatusCode: ${response.statusCode}');

        return "Stok Fiyat Listesi Hareketleri (Koşul) Alınamadı";
      }
    } catch (e) {
      print("aa" + e.toString());
      Exception('Hata: $e');

      return "Tanımlı Stok Fiyat Listesi Hareketleri (Koşul)  Bulunamadı";
    }
  }

  Future<String> getirDahaFazlaBarkod(
      {required String sirket, required String kullaniciKodu}) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirStokBarkod'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirStokBarkod xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <PlasiyerKod>$kullaniciKodu</PlasiyerKod>
    </GetirStokBarkod>
  </soap:Body>
</soap:Envelope>
''';
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          List<dynamic> jsonData = jsonDecode(gelenHata.HataMesaj!);

          List<DahaFazlaBarkod> tempList = List<DahaFazlaBarkod>.from(
              jsonData.map((model) => DahaFazlaBarkod.fromJson(model)));

          tempList.forEach((barkodlar) async {
            int Index = listeler.listDahaFazlaBarkod
                .indexWhere((element) => element.BARKOD == barkodlar.BARKOD);
            if (Index > -1) {
              DahaFazlaBarkod localstok =
                  listeler.listDahaFazlaBarkod.firstWhere(
                (element) => element.BARKOD == barkodlar.BARKOD,
              );
              barkodlar.BARKOD = localstok.BARKOD;
              await VeriIslemleri().dahaFazlaBarkodGuncelle(barkodlar);
            } else {
              await VeriIslemleri().dahaFazlaBarkodEkle(barkodlar);
            }
          });
          await VeriIslemleri().dahaFazlaBarkodGetir();
          return "";
        }
      } else {
        Exception(
            'Daha Fazla Barkod verisi alınamadı. StatusCode: ${response.statusCode}');
        return 'Daha Fazla Barkod Alınamadı. StatusCode: ${response.statusCode}';
      }
    } catch (e) {
      Exception('Hata: $e');
      return "Daha Fazla Barkod için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<SHataModel> ekleSiparisFuar({
    required String sirket,
    required List<Map<String, dynamic>> jsonDataList,
    required String UstUuid,
    required String pdfMi
  }) async {
    SHataModel hata = SHataModel(Hata: "true", HataMesaj: "Veri Gönderilemedi");

    var jsonString;

    var url = Uri.parse(Ctanim.IP);
    // dış ve iç denecek;

    jsonString = jsonEncode(jsonDataList);
    String base64EncodedString = base64Encode(utf8.encode(jsonString));
    printWrapped(base64EncodedString);

    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/EkleSiparisFuar',
    };
    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <EkleSiparisFuar xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <Fis>$base64EncodedString</Fis>
      <UstUuid>$UstUuid</UstUuid>
      <Pdf>$pdfMi</Pdf>
    </EkleSiparisFuar>
  </soap:Body>
</soap:Envelope>

''';
    //printWrapped(base64EncodedString);
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData = jsonDecode(parsedXml.innerText);
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        return gelenHata;
      } else {
        Exception(
            'Fatura Verisi Gönderilemedi. StatusCode: ${response.statusCode}');
        return hata;
      }
    } catch (e) {
      Exception('Hata: $e');
      return hata;
    }
  }

  Future<String> getirOlcuBirim({required String sirket}) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirOlcuBirim'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirOlcuBirim xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
    </GetirOlcuBirim>
  </soap:Body>
</soap:Envelope>
''';
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          await VeriIslemleri().olcuBirimTemizle();
          listeler.listOlcuBirim.clear();

          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));

          listeler.listOlcuBirim = List<OlcuBirimModel>.from(
              jsonData.map((model) => OlcuBirimModel.fromJson(model)));

          listeler.listOlcuBirim.forEach((webservisCariStokKosul) async {
            await VeriIslemleri().olcuBirimEkle(webservisCariStokKosul);
          });
          return "";
        }
      } else {
        Exception(
            'Ölçü Birim verisi alınamadı. StatusCode: ${response.statusCode}');
        return 'Ölçü Birim Verisi Alınamadı. StatusCode: ${response.statusCode}';
      }
    } catch (e) {
      Exception('Hata: $e');
      return "Ölçü Birim için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<SHataModel> cariGuncelle(
      {required String sirket,
      required Map<String, dynamic> jsonDataList}) async {
    SHataModel hata = SHataModel(Hata: "true", HataMesaj: "Veri Gönderilemedi");

    var jsonString;
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;

    jsonString = jsonEncode(jsonDataList);

    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/CariGuncelle',
    };
    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <CariGuncelle xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <Cari>$jsonString</Cari>
    </CariGuncelle>
  </soap:Body>
</soap:Envelope>
''';
    //printWrapped(jsonString);
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);

        Map<String, dynamic> jsonData = jsonDecode(parsedXml.innerText);
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        return gelenHata;
      } else {
        Exception(
            'Fatura Verisi Gönderilemedi. StatusCode: ${response.statusCode}');
        return hata;
      }
    } catch (e) {
      Exception('Hata: $e');
      return hata;
    }
  }

  Future<String> getirStokKosul({required String sirket}) async {
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirStokKosul'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirStokKosul xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
    </GetirStokKosul>
  </soap:Body>
</soap:Envelope>
''';
    try {
      http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          await VeriIslemleri().StokKosulTemizle();
          listeler.listStokKosul.clear();

          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));
          List<StokKosulModel> tempList = [];
          tempList = List<StokKosulModel>.from(
              jsonData.map((model) => StokKosulModel.fromJson(model)));

          tempList.forEach((webservisStokKosul) async {
            await VeriIslemleri().stokKosulEkle(webservisStokKosul);
          });

          await VeriIslemleri().stokKosulGetir();
          return "";
        }
      } else {
        Exception(
            'Stok Kosul verisi alınamadı. StatusCode: ${response.statusCode}');
        return " Stok Kosul Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      Exception('Hata: $e');
      return "Stok Kosul için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }

  Future<String> getFuar({required String sirket,}) async {
    // dış ve iç denecek;
    var url = Uri.parse(Ctanim.IP); 
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirFuar'
    };

    String body = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirFuar xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
    </GetirFuar>
  </soap:Body>
</soap:Envelope>''';

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var rawXmlResponse = response.body;
        xml.XmlDocument parsedXml = xml.XmlDocument.parse(rawXmlResponse);
        Map<String, dynamic> jsonData =
            jsonDecode(temizleKontrolKarakterleri(parsedXml.innerText));
        SHataModel gelenHata = SHataModel.fromJson(jsonData);
        if (gelenHata.Hata == "true") {
          return gelenHata.HataMesaj!;
        } else {
          listeler.listFuar.clear();
          await VeriIslemleri().fuarModelTemizle();
          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));
          for (var element in jsonData) {
            FuarModel a = FuarModel.fromJson(element);
            listeler.listFuar.add(a);
            
          }
           listeler.listFuar.forEach((webservisStokKosul) async {
            await VeriIslemleri().fuarModelEkle(webservisStokKosul);
          });

          await VeriIslemleri().fuarModelGetir();
          return "";
        }
      } else {
        print('SOAP isteği başarısız: ${response.statusCode}');
        return " Fuar Tipleri Getirilirken İstek Oluşturulamadı. " +
            response.statusCode.toString();
      }
    } catch (e) {
      print('Hata: $e');
      return " Kullanıcı bilgiler için Webservisten veri çekilemedi. Hata Mesajı : " +
          e.toString();
    }
  }
}
