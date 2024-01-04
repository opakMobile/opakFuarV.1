import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/db/dataBaseHelper.dart';
import 'package:opak_fuar/pages/login.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';

import 'controller/cariController.dart';
import 'controller/stokKartController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dt = DatabaseHelper("fuar.db");
  Ctanim.db = await dt.database();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final cariEx = Get.put(CariController());
  final stokKartEx = Get.put(StokKartController());
  final fisEx = Get.put(FisController());
  @override
  Widget build(BuildContext context) {
    //! Ekranı yatay yapmaz

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(
        title: '',
      ),
    );
  }
}
