import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opak_fuar/pages/homePage.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/sabitler/listeler.dart';

import '../model/fuarModel.dart';

class FuarSec extends StatefulWidget {
  const FuarSec({super.key});

  @override
  State<FuarSec> createState() => _FuarSecState();
}

class _FuarSecState extends State<FuarSec> {
  FuarModel? secilifuar;
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.01),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Uygulmaya devam etmek için fuar seçimi zorunludur. Lütfen işlem yapılacak fuarı seçiniz.",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          color: Colors.orange),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    
                    child: Card(
                      elevation: 45,
                      borderOnForeground: true,
                      color: Colors.grey[350],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.925,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.027,
                                  right: MediaQuery.of(context).size.width *
                                      0.047),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<FuarModel>(
                                  dropdownColor: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                  icon: Icon(Icons.arrow_drop_down),
                                  itemHeight:
                                      MediaQuery.of(context).size.height * 0.09,
                                  hint: Text("Fuar Seçiniz"),
                                  value: secilifuar,
                                  items:
                                      listeler.listFuar.map((FuarModel fuar) {
                                    return DropdownMenuItem<FuarModel>(
                                      value: fuar,
                                      child: Text(fuar.KOD!,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.018,
                                          )),
                                    );
                                  }).toList(),
                                  onChanged: (FuarModel? fuar) async {
                                    setState(() {
                                      secilifuar = fuar;
                                      Ctanim.kullanici!.FUARADI =
                                          secilifuar!.KOD;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    "*Uyarı: Seçilen fuar tipi oluşturulan siparişlere yansıyacaktır.",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                        fontSize: 12),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (secilifuar == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Fuar tipi seçilmeden uygulamaya devam edilemez.")));
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false,
                          );
                        }
                      },
                      child: Text("Uygulamaya Devam Et",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(color: Colors.green, width: 0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




/*

  FuarSec() {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.07,
            child: Material(
              child: Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<FuarModel>(
                    //  focusNode: focusDrop,
                    value: secilifuar,
                    items: listeler.listFuar.map((FuarModel fuar) {
                      return DropdownMenuItem<FuarModel>(
                        value: fuar,
                        child: Text(
                          fuar.KOD!,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (FuarModel? fuar) async {
                      setState(() {
                        secilifuar = fuar;
                      });

                      //     await FuarModel.saveFuar(secilifuar!);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }*/