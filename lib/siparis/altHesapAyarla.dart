import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/model/KurModel.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/pages/CustomAlertDialog.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/siparis/altHesapOnaylaVeDegistir.dart';
import 'package:opak_fuar/siparis/fisHareketDuzenle.dart';
import 'package:opak_fuar/siparis/okumaModuTasarim.dart';
import 'package:opak_fuar/siparis/siparisTamamla.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../controller/stokKartController.dart';
import '../model/cariModel.dart';
import '../model/satisTipiModel.dart';
import '../sabitler/Ctanim.dart';

class AltHesapAyarla extends StatefulWidget {
  @override
  State<AltHesapAyarla> createState() => _SiparisUrunAraState();
}

class _SiparisUrunAraState extends State<AltHesapAyarla> {
  bool aramaAktif = false;
  List<CariAltHesap> altHesaplar = [];
  @override
  void initState() {
    super.initState();
    altHesaplar.clear();

    for (var element1 in listeler.listCariAltHesap) {
      if (fisEx.fis!.value.cariKart.cariAltHesaplar
              .any((asd) => asd.ALTHESAP == element1.ALTHESAP) &&
          !altHesaplar.contains(element1)) {
        altHesaplar.add(element1);
      }
    }

    if (altHesaplar.length > 0) {
      seciliAltHesap = altHesaplar[0];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
/*
    if (fisEx.fis!.value.fisStokListesi.length > 0) {
      fisEx.fis!.value.DURUM = true;
      final now = DateTime.now();
      final formatter = DateFormat('HH:mm');
      String saat = formatter.format(now);
      fisEx.fis!.value.SAAT = saat;
      fisEx.fis!.value.AKTARILDIMI = false;
      Fis.empty().fisEkle(fis: fisEx.fis!.value, belgeTipi: "YOK");
      fisEx.fis!.value = Fis.empty();
    }
*/
    super.dispose();
    //Ctanim.seciliMarkalarFiltreMap.clear();
    /* stokKartEx.searchC(
        "", "", "", Ctanim.seciliIslemTip, Ctanim.seciliStokFiyatListesi);*/
  }

  String result = '';

  TextEditingController editingController = TextEditingController();
  List<TextEditingController> aramaMiktarController = [];
  final StokKartController stokKartEx = Get.find();

  CariAltHesap? seciliAltHesap;

/*  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stokKartEx.tempList.addAll(stokKartEx.searchList);
    tempTempStok.addAll(stokKartEx.tempList);
    for (var element in stokKartEx.searchList) {
      if (!markalar.contains(element.MARKA) && element.MARKA != "") {
        markalar.add(element.MARKA!);
        Ctanim.seciliMarkalarFiltreMap.add({false: element.MARKA!});
      }
    }
  }*/
  String? althesapAdi;
  String? altHesapToplami;

  @override
  Widget build(BuildContext context) {
    bool buldu = false;
    double ekranYuksekligi = MediaQuery.of(context).size.height;
    //Ctanim.genelToplamHesapla(fisEx);
    for(var el in fisEx.fis!.value.altHesapToplamlar){
      if(el.ALTHESAPADI == seciliAltHesap!.ALTHESAP){
        buldu = true;
        althesapAdi = el.ALTHESAPADI;
        altHesapToplami = el.TOPLAM.toString();
      }
    }
    if(buldu==false){
      althesapAdi = seciliAltHesap!.ALTHESAP;
      altHesapToplami = "0";
    }
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_arrow,
          backgroundColor: Color.fromARGB(255, 30, 38, 45),
          buttonSize: Size(65, 65),
          children: [
            SpeedDialChild(
                backgroundColor: Color.fromARGB(255, 70, 89, 105),
                child: Icon(
                  Icons.check,
                  color: Colors.blue,
                  size: 32,
                ),
                label: "Tamamının althesabını güncelle",
                onTap: () async {
                  await _showDialog(altHesaplar, seciliAltHesap!, true)
                      .then((value) {
                    setState(() {
                      print("TURAN");
                    });
                    return null;
                  });
                }),
            SpeedDialChild(
                backgroundColor: Color.fromARGB(255, 70, 89, 105),
                child: Icon(
                  Icons.all_inbox,
                  color: Colors.green,
                  size: 32,
                ),
                label: "Seçilen stokların althesabını güncelle",
                onTap: () async {
                  await _showDialog(altHesaplar, seciliAltHesap!, false)
                      .then((value) {
                    setState(() {});
                    return;
                  });
                }),
            SpeedDialChild(
                backgroundColor: Color.fromARGB(255, 70, 89, 105),
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 32,
                ),
                label: "Seçilenleri temizle",
                onTap: () async {
                  fisEx.fis!.value.fisStokListesi
                      .where((element) => element.AltHesapDegistir == true)
                      .forEach((element) {
                    element.AltHesapDegistir = false;
                  });
                }),
          ],
        ),
        // appBar: appBarDizayn(context),
        body: GestureDetector(
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                top: ekranYuksekligi * 0.01,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /* SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                            child: UcCizgi()),*/
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      ],
                    ),
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
                            controller: editingController,
                            onTap: () {
                              editingController.text = "";
                              /*
                              editingController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      editingController.value.text.length);
                                      */
                            },
                            onFieldSubmitted: ((value) async {
                              aramaAktif = true;
                              // await textAramaYap(value, context);
                            }),
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () async {
                                  //   await textAramaYap( editingController.text, context);
                                },
                              ),
                              hintText: 'Aranacak Kelime( Kod/ Ad / Barkod)',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SimpleBarcodeScannerPage(),
                                  ));
                              SatisTipiModel m = SatisTipiModel(
                                  ID: -1,
                                  TIP: "",
                                  FIYATTIP: "",
                                  ISK1: "",
                                  ISK2: "");
                              if (res is String) {
                                result = res;
                                editingController.text = result;
                                aramaAktif = true;
                              }
                              //  await textAramaYap(result, context);
                              /*
                              stokKartEx.searchC(
                                  result,
                                  widget.cari.KOD!,
                                  "Fiyat1",
                                  m,
                                  Ctanim.seciliStokFiyatListesi,
                                  seciliAltHesap!.ALTHESAPID);
                              if (okumaModu == true) {
                                asdas
                                
                                if (stokKartEx.tempList.length == 1) {
                                  double gelenMiktar = double.parse(stokKartEx
                                      .tempList[0].guncelDegerler!.carpan!
                                      .toString());
                                  Ctanim.urunAraFocus = false;
                                  editingController.text = "";
                                
                                 await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return fisHareketDuzenle(
                                          urunDuzenlemeyeGeldim: true,
                                          okutulanCarpan: 1,
                                          altHesap: seciliAltHesap!.ALTHESAP!,
                                          gelenStokKart: stokKartEx.tempList[0],
                                          gelenMiktar: gelenMiktar,
                                        );
                                      }).then((value) {
                                    setState(() {
                                      // Ctanim.genelToplamHesapla(fisEx);
                                    });
                                  });
                                }
                                stokKartEx.searchC(
                                    "",
                                    "",
                                    Ctanim.satisFiyatListesi.first,
                                    m,
                                    Ctanim.seciliStokFiyatListesi,
                                    seciliAltHesap!.ALTHESAPID);
                                    
                              }
                              // editingController.text = "";
                                
                              setState(() {});
                              */
                            },
                            icon: Icon(
                              Icons.camera_alt,
                              size:
                                  40, //MediaQuery.of(context).size.width * 0.1,
                              color: Colors.black54,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "Alt Hesap:",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<CariAltHesap>(
                                value: seciliAltHesap,
                                items: altHesaplar.map((CariAltHesap banka) {
                                  return DropdownMenuItem<CariAltHesap>(
                                    value: banka,
                                    child: Text(
                                      banka.ALTHESAP!,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (CariAltHesap? selected) async {
                                  setState(() {
                                    seciliAltHesap = selected!;
                                    fisEx.fis!.value.ALTHESAP =
                                        selected.ALTHESAP;
                                  });
                                  // await textAramaYap("", context);

                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.black87,
                    ),
                    Container(
                      height: ekranYuksekligi < 650
                          ? ekranYuksekligi * .53
                          : ekranYuksekligi * 0.65,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: ListView.builder(
                            itemCount: fisEx.fis!.value.fisStokListesi
                                .length, // stokKartEx.searchList.length,
                            itemBuilder: (context, index) {
                              FisHareket stokModel =
                                  fisEx.fis!.value!.fisStokListesi[index]!;

                              if (aramaAktif == true &&
                                  editingController.text != "") {
                                if ((stokModel.STOKKOD ==
                                            editingController.text ||
                                        stokModel.STOKADI!
                                            .toLowerCase()
                                            .contains(
                                                editingController.text)) &&
                                    stokModel.ALTHESAP ==
                                        seciliAltHesap!.ALTHESAP) {
                                  //aramaAktif = false;
                                  return altHesapDegistirListe(
                                      ekranYuksekligi, context, stokModel);
                                } else {
                                  return Container();
                                }
                              } else {
                                return stokModel.ALTHESAP ==
                                        seciliAltHesap!.ALTHESAP
                                    ? altHesapDegistirListe(
                                        ekranYuksekligi, context, stokModel)
                                    : Container();
                              }

                              //    stokKartEx.searchList[index];
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.045,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${althesapAdi}  Toplamı:",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                                child: Text(
                              Ctanim.donusturMusteri(
                                  altHesapToplami!),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding altHesapDegistirListe(
      double ekranYuksekligi, BuildContext context, FisHareket stokModel) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ekranYuksekligi < 650
            ? ekranYuksekligi * 0.07
            : ekranYuksekligi * 0.002,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stokModel.STOKADI!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      stokModel.STOKKOD! +
                          "  " +
                          "KDV " +
                          stokModel.KDVORANI.toString(),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: stokModel.AltHesapDegistir,
                onChanged: (value) {
                  setState(() {
                    stokModel.AltHesapDegistir = value!;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "İskonto",
                      style: TextStyle(fontSize: 13),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          stokModel.ISK!.toStringAsFixed(2),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Miktar",
                      style: TextStyle(fontSize: 13),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(stokModel.MIKTAR!.toStringAsFixed(2)),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text("Birim", style: TextStyle(fontSize: 13)),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          stokModel.BIRIM!,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text("Fiyat", style: TextStyle(fontSize: 13)),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          stokModel.BRUTFIYAT!.toStringAsFixed(2),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Toplam: ",
                      style: TextStyle(fontSize: 11, color: Colors.orange),
                    ),
                    Text(
                      stokModel.BRUTTOPLAMFIYAT!.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
          
                Row(
                  children: [
                    Text(
                      "İskonto: ",
                      style: TextStyle(fontSize: 11, color: Colors.orange),
                    ),
                    Text(
                      stokModel.ISKONTOTOPLAM!.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "KDV: ",
                      style: TextStyle(fontSize: 11, color: Colors.orange),
                    ),
                    Text(
                      stokModel.KDVTOPLAM!.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Genel Toplam: ",
                      style: TextStyle(fontSize: 11, color: Colors.orange),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        stokModel.KDVDAHILNETTOPLAM!.toStringAsFixed(2),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
                  ),
          ),
          Divider(
            thickness: 1.5,
            color: Colors.black87,
          )
        ],
      ),
    );
  }

  _showDialog(List<CariAltHesap> altHesaplar, CariAltHesap seciliAltHesap,
      bool hepsiMi) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AltHesapOnaylaVeDegistir(
            listCariAltHesap: altHesaplar,
            gelenAltHesap: seciliAltHesap,
            hepsiMi: hepsiMi);
      },
    ).then((value) {
      setState(() {});
      return;
    });
  }
}
