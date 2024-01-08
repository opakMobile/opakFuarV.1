import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/sepet/sepetDetay.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';
import 'package:uuid/uuid.dart';
import '../db/veriTabaniIslemleri.dart';
import '../model/cariModel.dart';
import '../sabitler/Ctanim.dart';
import '../sabitler/sharedPreferences.dart';

class SiparisCariList extends StatefulWidget {
  SiparisCariList({required this.islem});

  final bool islem;
  @override
  State<SiparisCariList> createState() => _SiparisCariListState();
}

class _SiparisCariListState extends State<SiparisCariList> {
  FisController fisEx = Get.find();
  var uuid = Uuid();
  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
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
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Obx(() {
                      return ListView.builder(
                        itemCount: cariEx.searchCariList.length,
                        itemBuilder: (context, index) {
                          Cari cari = cariEx.searchCariList[index];
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
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.8,
                                    child: Text(
                                      cari.ADRES!.toString(),
                                      maxLines: 3,
                                      
                                      overflow: TextOverflow.ellipsis,
                                    ), 
                                )),
                                onTap: () async {
                                  if (widget.islem) {
                                    /*
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SepetDetay(
                                                  cari: cari,
                                                )));
                                                */
                                  } else {
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
                                    Fis fis = Fis.empty();
                                    fisEx.fis!.value = fis;
                                    fisEx.fis!.value.cariKart = cari;
                                    fisEx.fis!.value.CARIKOD = cari.KOD;
                                    fisEx.fis!.value.CARIADI = cari.ADI;
                                    fisEx.fis!.value.SUBEID = int.parse(
                                        Ctanim.kullanici!.YERELSUBEID!);
                                    fisEx.fis!.value.PLASIYERKOD =
                                        Ctanim.kullanici!.KOD;
                                    fisEx.fis!.value.DEPOID = int.parse(Ctanim
                                        .kullanici!.YERELDEPOID!); //TODO
                                    fisEx.fis!.value.ISLEMTIPI = "0";
                                    fisEx.fis!.value.ALTHESAP = vs!=null?vs.ALTHESAP:cari.cariAltHesaplar.first.ALTHESAP;

                                    fisEx.fis!.value.UUID = uuid.v1();
                                    fisEx.fis!.value.VADEGUNU = cari.VADEGUNU;
                                    fisEx.fis!.value.BELGENO =
                                        Ctanim.siparisNumarasi.toString();
                                    Ctanim.siparisNumarasi =
                                        Ctanim.siparisNumarasi + 1;
                                    await SharedPrefsHelper
                                        .siparisNumarasiKaydet(
                                            Ctanim.siparisNumarasi);
                                    fisEx.fis!.value.TARIH =
                                        DateFormat("yyyy-MM-dd")
                                            .format(DateTime.now());

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
                      );
                    }),
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
