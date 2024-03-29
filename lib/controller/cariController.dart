import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import '../db/dataBaseHelper.dart';
import '../model/cariModel.dart';
import '../sabitler/Ctanim.dart';
import '../sabitler/listeler.dart';

class CariController extends GetxController {
  RxList<Cari> searchCariList = <Cari>[].obs;
  

  @override
  void onInit() {
    super.onInit();
  }
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

  void searchCari(String query) {
    if (query.isEmpty) {
      searchCariList.assignAll(listeler.listCari);
    } else {
      var results ;

    List<String> queryparcali = turkishToEnglish(query).split(" ");
      if (queryparcali.length == 1) {
        results = listeler.listCari
            .where((value) =>
                turkishToEnglish(value.ADI!)
                    .contains(queryparcali[0].toLowerCase()) ||
                value.KOD!.toLowerCase().contains(query.toLowerCase()) ||
                value.TELEFON!.toLowerCase().contains(query.toLowerCase())||
                value.IL!.toLowerCase().contains(query.toLowerCase())||
                value.ILCE!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else if (queryparcali.length == 2) {
        results = listeler.listCari
            .where((value) =>
                (turkishToEnglish(value.ADI!)
                        .contains(queryparcali[0].toLowerCase()) &&
                    turkishToEnglish(value.ADI!)
                        .contains(queryparcali[1].toLowerCase())) ||
                value.KOD!.toLowerCase().contains(query.toLowerCase()) ||
                value.TELEFON!.toLowerCase().contains(query.toLowerCase())||
                value.IL!.toLowerCase().contains(query.toLowerCase())||
                value.ILCE!.toLowerCase().contains(query.toLowerCase())||
                (value.IL!.toLowerCase().contains(queryparcali[0].toLowerCase())&& value.ILCE!.toLowerCase().contains(queryparcali[1].toLowerCase()))||
                (value.ILCE!.toLowerCase().contains(queryparcali[0].toLowerCase())&& value.IL!.toLowerCase().contains(queryparcali[1].toLowerCase())) ||
                (turkishToEnglish(value.ADI!).contains(queryparcali[0].toLowerCase())&& value.IL!.toLowerCase().contains(queryparcali[1].toLowerCase()))||
                (value.IL!.toLowerCase().contains(queryparcali[0].toLowerCase())&& turkishToEnglish(value.ADI!).contains(queryparcali[1].toLowerCase()))
                )
            .toList();
      } else if (queryparcali.length == 3) {
        results = listeler.listCari
            .where((value) =>
                (turkishToEnglish(value.ADI!)
                        .contains(queryparcali[0].toLowerCase()) &&
                    turkishToEnglish(value.ADI!)
                        .contains(queryparcali[1].toLowerCase()) &&
                    turkishToEnglish(value.ADI!)
                        .contains(queryparcali[2].toLowerCase())) ||
                value.KOD!.toLowerCase().contains(query.toLowerCase()) ||
                value.TELEFON!.toLowerCase().contains(query.toLowerCase())||
                value.IL!.toLowerCase().contains(query.toLowerCase())||
                value.ILCE!.toLowerCase().contains(query.toLowerCase())||
                (value.IL!.toLowerCase().contains(queryparcali[0].toLowerCase())&& value.ILCE!.toLowerCase().contains(queryparcali[1].toLowerCase())&& turkishToEnglish(value.ADI!).contains(queryparcali[2].toLowerCase()))||
                (value.ILCE!.toLowerCase().contains(queryparcali[0].toLowerCase())&& value.IL!.toLowerCase().contains(queryparcali[1].toLowerCase())&& turkishToEnglish(value.ADI!).contains(queryparcali[2].toLowerCase())) ||
                (turkishToEnglish(value.ADI!).contains(queryparcali[0].toLowerCase())&& value.ILCE!.toLowerCase().contains(queryparcali[1].toLowerCase())&& value.IL!.toLowerCase().contains(queryparcali[2].toLowerCase())) ||
                (turkishToEnglish(value.ADI!).contains(queryparcali[0].toLowerCase())&& value.IL!.toLowerCase().contains(queryparcali[1].toLowerCase())&& value.ILCE!.toLowerCase().contains(queryparcali[2].toLowerCase()))
                
                )
            .toList();
      } else if (queryparcali.length == 4) {
        results = listeler.listCari
            .where((value) =>
                (value.ADI!
                        .toLowerCase()
                        .contains(queryparcali[0].toLowerCase()) &&
                    value.ADI!
                        .toLowerCase()
                        .contains(queryparcali[1].toLowerCase()) &&
                    value.ADI!
                        .toLowerCase()
                        .contains(queryparcali[2].toLowerCase()) &&
                    value.ADI!
                        .toLowerCase()
                        .contains(queryparcali[3].toLowerCase())) ||
                value.KOD!.toLowerCase().contains(query.toLowerCase()) ||
                value.TELEFON!.toLowerCase().contains(query.toLowerCase())||
                value.IL!.toLowerCase().contains(query.toLowerCase())||
                value.ILCE!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      searchCariList.assignAll(results);
    }
  }

  



  Future<String> servisCariGetir() async {
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
      return 'İnternet bağlantısı yok.';
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
        return 'İnternet bağlantısı yok.';
      } else {
        String cariDon = await bs.getirCariler(
            sirket: Ctanim.sirket!, kullaniciKodu: Ctanim.kullanici!.KOD);
        String altHesapDon = await bs.getirCariAltHesap(sirket: Ctanim.sirket!);
        

        if (cariDon == "" && altHesapDon == "") {
          return "";
        } else if (cariDon != "" && altHesapDon == "") {
          return cariDon;
        } else if (cariDon == "" && altHesapDon != "") {
          return altHesapDon;
        } else {
          return cariDon + " / " + altHesapDon;
        }
      }
    }
  }
}
