import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:opak_fuar/db/veriTabaniIslemleri.dart';
import 'package:opak_fuar/model/KurModel.dart';
import 'package:opak_fuar/model/ShataModel.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/cariModel.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:xml/xml.dart' as xml;

import '../model/dahaFazlaBarkodModel.dart';
import '../model/kullaniciModel.dart';
import '../model/kullanıcıYetki.dart';
import '../model/stokFiyatListesiHarModel.dart';
import '../model/stokFiyatListesiModel.dart';
import '../sabitler/Ctanim.dart';
import '../sabitler/sharedPreferences.dart';

class BaseService {
  Future<void> tumVerileriGuncelle() async {
    await getirStoklar(sirket: "AAGENELOPAK", kullaniciKodu: "1");
    await getirCariler(sirket: "AAGENELOPAK", kullaniciKodu: "1");
    await getirCariAltHesap(sirket: "AAGENELOPAK");
    await getirKur(sirket: "AAGENELOPAK");
  }

  Future<void> cariVerileriGuncelle() async {
    await getirCariler(sirket: "AAGENELOPAK", kullaniciKodu: "1");
    await getirCariAltHesap(sirket: "AAGENELOPAK");
  }

  Future<void> stokVerileriGuncelle() async {
    await getirStoklar(sirket: "AAGENELOPAK", kullaniciKodu: "1");
  }

  String temizleKontrolKarakterleri(String metin) {
    final kontrolKarakterleri = RegExp(r'[\x00-\x1F\x7F]');
    return metin.replaceAll(kontrolKarakterleri, '');
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

  Future<String> getirStoklar({required sirket, required kullaniciKodu}) async {
    var url = Uri.parse(
        "https://apkwebservis.nativeb4b.com/MobilService.asmx"); // dış ve iç denecek;
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

  Future<String> getirCariler({required sirket, required kullaniciKodu}) async {
    var url = Uri.parse("https://apkwebservis.nativeb4b.com/MobilService.asmx");
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
          List<dynamic> parsedList = json.decode(modelNode);

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
    var url = Uri.parse(
        "https://apkwebservis.nativeb4b.com/MobilService.asmx"); // dış ve iç denecek;
    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/GetirCariAltHesap'
    };

    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetirCariAltHesap xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
    </GetirCariAltHesap>
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
          List<dynamic> jsonData =
              jsonDecode(temizleKontrolKarakterleri(gelenHata.HataMesaj!));
          listeler.listCariAltHesap.clear();
          await VeriIslemleri().cariAltHesapTabloTemizle();

          for (var element in jsonData) {
            String KOD = element['KOD'];
            String ALTHESAP = element['ALTHESAP'];
            int DOVIZID = int.parse(element["DOVIZID"].toString());
            String VARSAYILAN = element['VARSAYILAN'];

            await VeriIslemleri().cariAltHesapEkle(CariAltHesap(
                KOD: KOD,
                ALTHESAP: ALTHESAP,
                DOVIZID: DOVIZID,
                VARSAYILAN: VARSAYILAN));

            listeler.listCariAltHesap.add(CariAltHesap(
                KOD: KOD,
                ALTHESAP: ALTHESAP,
                DOVIZID: DOVIZID,
                VARSAYILAN: VARSAYILAN));
          }

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
        return " Kullanıcı Bilgileri Getirilirken İstek Oluşturulamadı. " +
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
    Future<SHataModel> ekleFatura(
      {required String sirket,
      required Map<String, dynamic> jsonDataList}) async {
    SHataModel hata = SHataModel(Hata: "true", HataMesaj: "Veri Gönderilemedi");

    var jsonString;
    var url = Uri.parse(Ctanim.IP); // dış ve iç denecek;

    jsonString = jsonEncode(jsonDataList);

    var headers = {
      'Content-Type': 'text/xml; charset=utf-8',
      'SOAPAction': 'http://tempuri.org/EkleFatura',
    };
    String body = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <EkleFatura xmlns="http://tempuri.org/">
      <Sirket>$sirket</Sirket>
      <Fis>$jsonString</Fis>
    </EkleFatura>
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


}
