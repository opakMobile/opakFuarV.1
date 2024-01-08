import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/sepet/sepetDetay.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';
import 'package:uuid/uuid.dart';
import '../db/veriTabaniIslemleri.dart';
import '../model/cariModel.dart';
import '../sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';

enum SampleItem { itemOne, itemTwo }

class SepetCariList extends StatefulWidget {
  SepetCariList({required this.islem});

  final bool islem;
  @override
  State<SepetCariList> createState() => _SepetCariListState();
}

class _SepetCariListState extends State<SepetCariList> {
  FisController fisEx = Get.find();
  SampleItem? selectedMenu;

  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
  }

  List<Fis> bekleyenler = [];
  List<Fis> aktarilanlar = [];
  List<Fis> tumu = [];
  void cariAra(String query) {
    if (query.isEmpty) {
      tempFis.assignAll(fisEx.list_tum_fis);
    } else {
      var results;
      List<String> queryparcali = query.split(" ");
      if (queryparcali.length == 1) {
        results = fisEx.list_tum_fis
            .where((value) =>
                (value.cariKart.ADI!
                        .toLowerCase()
                        .contains(queryparcali[0].toLowerCase()) ||
                    value.cariKart.KOD!
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    value.cariKart.TELEFON!
                        .toLowerCase()
                        .contains(query.toLowerCase())) &&
                value.AKTARILDIMI == localAktarildiMi)
            .toList();
      } else if (queryparcali.length == 2) {
        results = fisEx.list_tum_fis
            .where((value) =>
                ((value.cariKart.ADI!
                            .toLowerCase()
                            .contains(queryparcali[0].toLowerCase()) &&
                        value.cariKart.ADI!
                            .toLowerCase()
                            .contains(queryparcali[1].toLowerCase())) ||
                    value.cariKart.KOD!
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    value.cariKart.TELEFON!
                        .toLowerCase()
                        .contains(query.toLowerCase())) &&
                value.AKTARILDIMI == localAktarildiMi)
            .toList();
      } else if (queryparcali.length == 3) {
        results = fisEx.list_tum_fis
            .where((value) =>
                ((value.cariKart.ADI!
                            .toLowerCase()
                            .contains(queryparcali[0].toLowerCase()) &&
                        value.cariKart.ADI!
                            .toLowerCase()
                            .contains(queryparcali[1].toLowerCase()) &&
                        value.cariKart.ADI!
                            .toLowerCase()
                            .contains(queryparcali[2].toLowerCase())) ||
                    value.cariKart.KOD!
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    value.cariKart.TELEFON!
                        .toLowerCase()
                        .contains(query.toLowerCase())) &&
                value.AKTARILDIMI == localAktarildiMi)
            .toList();
      } else if (queryparcali.length == 4) {
        results = fisEx.list_tum_fis
            .where((value) =>
                ((value.cariKart.ADI!
                            .toLowerCase()
                            .contains(queryparcali[0].toLowerCase()) &&
                        value.cariKart.ADI!
                            .toLowerCase()
                            .contains(queryparcali[1].toLowerCase()) &&
                        value.cariKart.ADI!
                            .toLowerCase()
                            .contains(queryparcali[2].toLowerCase()) &&
                        value.cariKart.ADI!
                            .toLowerCase()
                            .contains(queryparcali[3].toLowerCase())) ||
                    value.cariKart.KOD!
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    value.cariKart.TELEFON!
                        .toLowerCase()
                        .contains(query.toLowerCase())) &&
                value.AKTARILDIMI == localAktarildiMi)
            .toList();
      }
      tempFis.assignAll(results);
    }
  }

  //List<Cari> listenecekCariler = [];
  List<Fis> tempFis = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var element in fisEx.list_tum_fis) {
      if (element.AKTARILDIMI == false) {
        tempFis.add(element);
      }

      /*
      if(element.AKTARILDIMI == false){
        bekleyenler.add(element);
    }else{
        aktarilanlar.add(element);
    }
    */
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cariEx.searchCari("");
  }

  bool localAktarildiMi = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                        textCapitalization: TextCapitalization.characters,
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
                            cariAra(value);
                          });
                        }),
                      ),
                    ),
                    PopupMenuButton<SampleItem>(
                      icon: Icon(Icons.filter_list),
                      onOpened: () {
                        print("object");
                      },
                      initialValue: selectedMenu,
                      // Callback that sets the selected popup menu item.
                      onSelected: (SampleItem item) {
                        setState(() {
                          selectedMenu = item;
                        });
                      },

                      itemBuilder: (context) => <PopupMenuEntry<SampleItem>>[
                        PopupMenuItem<SampleItem>(
                          value: SampleItem.itemOne,
                          onTap: () {
                            localAktarildiMi = false;
                            tempFis.clear();
                            for (var element in fisEx.list_tum_fis) {
                              if (element.AKTARILDIMI == false) {
                                tempFis.add(element);
                              }
                              setState(() {});
                            }
                          },
                          child: Text('Bekleyenleri Göster'),
                        ),
                        PopupMenuItem<SampleItem>(
                          value: SampleItem.itemTwo,
                          child: Text('Aktarılanları Göster'),
                          onTap: () {
                            localAktarildiMi = true;
                            tempFis.clear();
                            for (var element in fisEx.list_tum_fis) {
                              if (element.AKTARILDIMI == true) {
                                tempFis.add(element);
                              }
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                // ! Cari Listesi
                SingleChildScrollView(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: tempFis.length == 0
                          ? localAktarildiMi
                              ? Center(
                                  child: Text("Aktarılan Sipariş Yok."),
                                )
                              : Center(
                                  child: Text("Bekleyen Sipariş Yok."),
                                )
                          : ListView.builder(
                              itemCount: tempFis.length,
                              itemBuilder: (context, index) {
                                Cari cari = tempFis[index].cariKart;
                                String harf1 =
                                    Ctanim.cariIlkIkiDon(cari.ADI!)[0];
                                String harf2 =
                                    Ctanim.cariIlkIkiDon(cari.ADI!)[0];
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
                                      title: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.45,
                                            child: Text(
                                              cari.ADI.toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Spacer(),
                                          tempFis[index].AKTARILDIMI == false
                                              ? SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .15,
                                                  child: Text(
                                                    "Beklemede",
                                                    style: TextStyle(
                                                        color: Colors.amber,
                                                        fontSize: 9),
                                                  ))
                                              : SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .15,
                                                  child: Text(
                                                    "Aktarıldı",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11),
                                                  ))
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  child: Text(
                                                    cari.ADRES!.toString()??"",
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                
                                                widget.islem == true
                                                    ? Text(
                                                        maxLines: 1,
                                                        style: TextStyle(fontSize: 12),
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        Ctanim.donusturMusteri(
                                                            tempFis[index]
                                                                .GENELTOPLAM!
                                                                .toString()))
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      onLongPress: () async {
                                        if (localAktarildiMi == false) {
                                          await showAlertDialog(context, index);
                                        }
                                      },
                                      onTap: () {
                                        if (tempFis[index].AKTARILDIMI! ==
                                            false) {
                                          fisEx.fis!.value = tempFis[index];
                                          Ctanim.genelToplamHesapla(fisEx);
                                    CariAltHesap? vs;
                                    cari.cariAltHesaplar.clear();
                                    List<String> altListe = cari.ALTHESAPLAR!.split(",");
                                    for(var elemnt in listeler.listCariAltHesap){
                                      if(altListe.contains(elemnt.ALTHESAPID.toString())){
                                        cari.cariAltHesaplar.add(elemnt);
                                      }
                                       if(elemnt.ZORUNLU == "E" && elemnt.VARSAYILAN == "E"){
                                          vs = elemnt;
                                        }

                                    }
                                    if(cari.cariAltHesaplar.isEmpty){
                                      for(var elemnt in listeler.listCariAltHesap){
                                        if(elemnt.ZORUNLU == "E" && elemnt.VARSAYILAN == "E"){
                                          cari.cariAltHesaplar.add(elemnt);
                                        }
                                      }
                                    }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SiparisUrunAra(
                                                        varsayilan: vs!=null?vs:cari.cariAltHesaplar.first,
                                                        cari: cari,
                                                      )));
                                        }
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

  showAlertDialog(BuildContext context, int index) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("İptal"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Devam"),
      onPressed: () {
        try {
          fisEx.fis?.value = tempFis[index];
          print(fisEx.fis?.value.ID);
          Fis.empty().fisVeHareketSil(fisEx.fis!.value.ID!);
          fisEx.list_tum_fis
              .removeWhere((item) => item.ID == fisEx.fis!.value.ID!);

          setState(() {
            tempFis.removeWhere((item) => item.ID == fisEx.fis!.value.ID!);
          });
          const snackBar = SnackBar(
            duration: Duration(microseconds: 500),
            content: Text(
              'Sipariş silindi..',
              style: TextStyle(fontSize: 16),
            ),
            showCloseIcon: true,
            backgroundColor: Colors.blue,
            closeIconColor: Colors.white,
          );
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
        } on PlatformException catch (e) {
          print(e);
        }
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("İşlem Onayı"),
      content: Text(
          "Belge Silindiğinde Geri Döndürürelemez. Devam Etmek İstiyor musunuz?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
