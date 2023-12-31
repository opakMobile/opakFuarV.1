import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/sepet/sepetDetay.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';
import 'package:uuid/uuid.dart';
import '../db/veriTabaniIslemleri.dart';
import '../model/cariModel.dart';
import '../sabitler/Ctanim.dart';

class SepetCariList extends StatefulWidget {
  SepetCariList({required this.islem});

  final bool islem;
  @override
  State<SepetCariList> createState() => _SepetCariListState();
}

class _SepetCariListState extends State<SepetCariList> {
  FisController fisEx = Get.find();

  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
  }

  List<Cari> listenecekCariler = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var element in fisEx.list_fis_gidecek) {
      listenecekCariler.add(element.cariKart);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cariEx.searchCari("");
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
                    onChanged: ((value) => cariEx.searchCari(value)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                // ! Cari Listesi
                SingleChildScrollView(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        itemCount: listenecekCariler.length,
                        itemBuilder: (context, index) {
                          Cari cari = listenecekCariler[index];
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(cari.IL!.toString()),
                                      widget.islem == true
                                          ? Text(cari.BAKIYE.toString())
                                          : Container(),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                 
                                    fisEx.fis!.value =
                                        fisEx.list_fis_gidecek[index];
                                    //Fis.empty().fisVeHareketSil(fisEx.fis!.value.ID!);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SiparisUrunAra(
                                                  cari: cari,
                                                )));
                                  
                                },
                              ),
                              Divider(
                                thickness: 2,
                                color: Colors.black87,
                              )
                            ],
                          );
                        },
                      )),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
