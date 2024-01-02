import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:opak_fuar/cari/cariDetayPage.dart';
import 'package:opak_fuar/cari/cariFormPage.dart';
import 'package:opak_fuar/model/cariModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import '../db/veriTabaniIslemleri.dart';
import '../siparis/siparisUrunAra.dart';

class BayiSec extends StatefulWidget {
  BayiSec({required this.bayiList});
  final List<Cari> bayiList;

  @override
  State<BayiSec> createState() => _BayiSecState();
}

class _BayiSecState extends State<BayiSec> {
  List<Cari> tempBayiList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tempBayiList.clear();
    tempBayiList.addAll(widget.bayiList);
  }

  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
  }

  void bayiAra(String query) {
    if (query.isEmpty) {
      tempBayiList.assignAll(widget.bayiList);
    } else {
      var results = widget.bayiList
          .where((value) =>
              value.ADI!.toLowerCase().contains(query.toLowerCase()) ||
              value.KOD!.toLowerCase().contains(query.toLowerCase()) ||
              value.IL!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      tempBayiList.assignAll(results);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
        bottomNavigationBar: bottombarDizayn(context),
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
              child: Column(children: [
                // ! Üst Kısım
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                // ! Search Bar
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Aranacak Kelime( Ünvan/ Kod / İl/ İlçe)',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: ((value) {
                      setState(() {
                        bayiAra(value);
                      });
                    }),
                  ),
                ),
                // ! Cari Listesi
                SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: ListView.builder(
                      itemCount: tempBayiList.length,
                      itemBuilder: (context, index) {
                        Cari cari = tempBayiList[index];
                        String harf1 = Ctanim.cariIlkIkiDon(cari.ADI!)[0];
                        String harf2 = Ctanim.cariIlkIkiDon(cari.ADI!)[0];
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: randomColor(),
                                child: Text(
                                  harf1 + harf2,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                cari.ADI.toString(),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(cari.IL!.toString()),
                              ),
                              onTap: () async {
                                fisEx.fis!.value.ACIKLAMA4 = cari.KOD;
                                fisEx.fis!.value.ACIKLAMA5 = cari.ADI;
                                Navigator.pop(context);
                              },
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black87,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
