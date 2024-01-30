import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/sabitler/sharedPreferences.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';
import 'package:uuid/uuid.dart';

import '../model/cariModel.dart';
import '../model/fis.dart';
import 'cariDetayIncele.dart';

class CariDetayPage extends StatefulWidget {
  CariDetayPage({required this.cari, required this.genelToplam});

  late Cari cari;
  final double genelToplam;

  @override
  State<CariDetayPage> createState() => _CariDetayPageState();
}


class _CariDetayPageState extends State<CariDetayPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
var uuid = Uuid();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
        bottomNavigationBar: bottombarDizayn(
          context,
          button: Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton.icon(
              onPressed: () async {
                                    CariAltHesap? vs;
                                    widget.cari.cariAltHesaplar.clear();
                                    List<String> altListe = widget.cari.ALTHESAPLAR!.split(",");
                                    for(var elemnt in listeler.listCariAltHesap){
                                      if(altListe.contains(elemnt.ALTHESAPID.toString())){
                                       widget.cari.cariAltHesaplar.add(elemnt);
                                      }
                                       if(elemnt.ZORUNLU == "E" && elemnt.VARSAYILAN == "E"){
                                          vs = elemnt;
                                        }

                                    }
                                    if(widget.cari.cariAltHesaplar.isEmpty){
                                      for(var elemnt in listeler.listCariAltHesap){
                                        if(elemnt.ZORUNLU == "E" && elemnt.VARSAYILAN == "E"){
                                          widget.cari.cariAltHesaplar.add(elemnt);
                                        }
                                      }
                                    }
                                    Fis fis = Fis.empty();
                                    fisEx.fis!.value = fis;
                                    fisEx.fis!.value.cariKart = widget.cari;
                                    fisEx.fis!.value.CARIKOD = widget.cari.KOD;
                                    fisEx.fis!.value.CARIADI = widget.cari.ADI;
                                    fisEx.fis!.value.SUBEID = int.parse(
                                        Ctanim.kullanici!.YERELSUBEID!);
                                    fisEx.fis!.value.PLASIYERKOD =
                                        Ctanim.kullanici!.KOD;
                                    fisEx.fis!.value.DEPOID = int.parse(Ctanim
                                        .kullanici!.YERELDEPOID!); //TODO
                                    fisEx.fis!.value.ISLEMTIPI = "0";
                                    fisEx.fis!.value.ALTHESAP = widget.cari.cariAltHesaplar.first.ALTHESAP;
                                    fisEx.fis!.value.FUARADI = Ctanim.kullanici!.FUARADI;
                                    fisEx.fis!.value.UUID = uuid.v1();
                                    fisEx.fis!.value.VADEGUNU = widget.cari.VADEGUNU;
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
                                                  sepettenMiGeldin: false,
                                                  varsayilan: vs!=null?vs:widget.cari.cariAltHesaplar.first,
                                                  cari: widget.cari,
                                                )));
              },
              icon: Icon(
                Icons.shopping_cart_checkout,
                size: 30,
              ),
              label: Text(
                "Sipariş Al",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          buttonVarMi: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
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
              // ! Firma Adı
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.04,
                color: Colors.red,
                child: Center(
                  child: Text(
                    widget.cari.ADI.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Column(
                  children: [
                    // ! Sipariş Toplamı
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.11,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Sipariş Toplamı",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(
                                  child: Text(
                               Ctanim.donusturMusteri(widget.genelToplam.toString()),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
/*
                    SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .32,
                        child: ListView.builder(
                          itemCount: fisEx.list_fis_cari_ozel.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // ! Tarih / Firma
                                Card(
                                  elevation: 5,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 8.0),
                                            child: Text(
                                                "Tarih" +
                                                    aaa[index]["tarih"]
                                                        .toString() +
                                                    "Bakiye" +
                                                    aaa[index]["bakiye"]
                                                        .toString() +
                                                    "Ad" +
                                                    aaa[index]["name"]
                                                        .toString() +
                                                    "Soyad" +
                                                    aaa[index]["surname"]
                                                        .toString() +
                                                    "Id" +
                                                    aaa[index]["id"]
                                                        .toString() +
                                                    "dasdasdasdsadasdasdasdasdasdsa",
                                                maxLines: 3,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                )),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 5.0),
                                            child: Text(
                                                aaa[index]["name"].toString()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // ! İncele
                                Card(
                                  elevation: 3,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.09,
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CariDetayIncele(
                                                        cari: widget.cari,
                                                      )));
                                        },
                                        child: Text(
                                          "İncele",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    */
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
