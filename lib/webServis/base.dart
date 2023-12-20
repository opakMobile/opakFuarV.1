import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:opak_fuar/db/veriTaban%C4%B1Islemleri.dart';
import 'package:opak_fuar/model/ShataModel.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/cariModel.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:xml/xml.dart' as xml;

class BaseService {

  Future<void> tumVerileriGuncelle() async {
    await getirStoklar(
        sirket: "AAGENELOPAK", kullaniciKodu: "1"); 
    await getirCariler(
        sirket: "AAGENELOPAK", kullaniciKodu: "1");
    await getirCariAltHesap(sirket: "AAGENELOPAK");        
  }


  String temizleKontrolKarakterleri(String metin) {
    final kontrolKarakterleri = RegExp(r'[\x00-\x1F\x7F]');
    return metin.replaceAll(kontrolKarakterleri, '');
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
     var url = Uri.parse(
        "https://apkwebservis.nativeb4b.com/MobilService.asmx");
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
    Future<String> getirCariAltHesap({required String sirket}) async {
        var url = Uri.parse(
        "https://apkwebservis.nativeb4b.com/MobilService.asmx");// dış ve iç denecek;
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

}
