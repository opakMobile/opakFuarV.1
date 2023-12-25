import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/model/KurModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/pages/CustomAlertDialog.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/siparis/PdfOnizleme.dart';
import 'package:opak_fuar/siparis/siparisTamamla.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../controller/stokKartController.dart';
import '../model/cariModel.dart';
import '../model/satisTipiModel.dart';
import '../sabitler/Ctanim.dart';

FisController fisEx = Get.find();

class SiparisUrunAra extends StatefulWidget {
  SiparisUrunAra({required this.cari});

  late Cari cari;

  @override
  State<SiparisUrunAra> createState() => _SiparisUrunAraState();
}

class _SiparisUrunAraState extends State<SiparisUrunAra> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < stokKartEx.searchList.length; i++) {
      aramaMiktarController.add(TextEditingController());
    }
  }

  String result = '';
  bool aramaModu = true;
  bool okumaModu = false;
  TextEditingController editingController = TextEditingController();
  List<TextEditingController> aramaMiktarController = [];
  final StokKartController stokKartEx = Get.find();

  String seciliAltHesap = "Peşin";
  List<String> altHesaplar = [
    "Peşin",
    "Nakit",
    "Kredi Kartı",
    "Sezon",
    "Ara Ödeme"
  ];

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Ctanim.secililiMarkalarFiltre.clear();
    //Ctanim.seciliMarkalarFiltreMap.clear();
    /* stokKartEx.searchC(
        "", "", "", Ctanim.seciliIslemTip, Ctanim.seciliStokFiyatListesi);*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
        bottomNavigationBar: bottombarDizayn(
          context,
          buttonVarMi: true,
          button: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (Ctanim.kullanici!.ISLEMAKTARILSIN == "E") {
                    fisEx.fis!.value.DURUM = true;
                    final now = DateTime.now();
                    final formatter = DateFormat('HH:mm');
                    String saat = formatter.format(now);
                    fisEx.fis!.value.SAAT = saat;
                    Fis fiss = fisEx.fis!.value;

                    await Fis.empty()
                        .fisEkle(fis: fisEx.fis!.value, belgeTipi: "YOK");

                    fisEx.fis!.value = Fis.empty();
                
                         Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SiparisTamamla(fiss:fiss)));
                  }
                 
                },
                child: Text(
                  "Siparişi Tamamla",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                )),
          ),
        ),
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Row(
                          children: [
                            Checkbox(
                                value: okumaModu,
                                onChanged: (value) {
                                  setState(() {
                                    okumaModu = value!;
                                    if (value == true) {
                                      aramaModu = false;
                                    }
                                  });
                                }),
                            Text("Okuma Modu"),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Row(
                          children: [
                            Checkbox(
                                value: aramaModu,
                                onChanged: (value) {
                                  setState(() {
                                    aramaModu = value!;
                                    if (value == true) {
                                      okumaModu = false;
                                    }
                                  });
                                }),
                            Text(" Arama Modu"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextFormField(
                          controller: editingController,
                          onChanged: ((value) {
                            /*
                            SatisTipiModel m = SatisTipiModel(
                                ID: -1,
                                TIP: "",
                                FIYATTIP: "",
                                ISK1: "",
                                ISK2: "");
                            stokKartEx.searchC(value, "", "Fiyat1", m,
                                Ctanim.seciliStokFiyatListesi);
                            // setState(() {});*/
                          }),
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
                            /*   setState(() {
                              if (res is String) {
                                result = res;
                                editingController.text = result;
                              }
                              SatisTipiModel m = SatisTipiModel(
                                  ID: -1,
                                  TIP: "",
                                  FIYATTIP: "",
                                  ISK1: "",
                                  ISK2: "");
                              stokKartEx.searchC(result, "", "Fiyat1", m,
                                  Ctanim.seciliStokFiyatListesi);
                            });*/
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.black54,
                          )
                          //    height: 60, width: 60),
                          ),
                    ],
                  ),
                  // ! Firma adı
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      widget.cari.ADI!.toString(),
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),

                  // ! Satış Toplamı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Satış Toplamı:",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                            child: Text(
                          "1.456.568,45 TL",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ],
                  ),
                  // ! Alt Hesap
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Alt Hesap:",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.04,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: seciliAltHesap,
                              items: altHesaplar.map((String banka) {
                                return DropdownMenuItem<String>(
                                  value: banka,
                                  child: Text(
                                    banka,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? selected) {
                                setState(() {
                                  seciliAltHesap = selected!;
                                });
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
                  okumaModu == true
                      ? okumaModuList()
                      : SingleChildScrollView(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.builder(
                              itemCount: stokKartEx.searchList.length,
                              itemBuilder: (context, index) {
                                StokKart stokModel =
                                    stokKartEx.searchList[index];
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                stokModel.ADI!,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(stokModel.KOD! +
                                                  "  " +
                                                  "KDV " +
                                                  stokModel.SATIS_KDV
                                                      .toString()),
                                            ],
                                          ),
                                        ),
                                        Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .06,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            child: TextFormField(
                                              autocorrect: true,
                                              controller:
                                                  aramaMiktarController[index],
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "1",
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                                border: InputBorder.none,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                        RegExp(r'^[\d\.]*$')),
                                              ],
                                              onChanged: (newValue) {},
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "İskonto",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    stokModel.SATISISK!
                                                        .toStringAsFixed(2),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Mal Fazlası",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    stokModel.SATISISK!
                                                        .toStringAsFixed(2),
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
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                child: Center(
                                                  child: Text("1"),
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("Birim",
                                                  style:
                                                      TextStyle(fontSize: 13)),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    stokModel.OLCUBIRIM1!,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("Fiyat",
                                                  style:
                                                      TextStyle(fontSize: 13)),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    stokModel.SFIYAT1!
                                                        .toStringAsFixed(2),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .07,
                                            child: Center(
                                                child: IconButton(
                                              icon: Icon(
                                                Icons.add_circle,
                                                size: 40,
                                                color: Colors.green,
                                              ),
                                              onPressed: () {
                                                // ! Miktar Gir ve iskonto mal fazlası fiyat değiştir
                                                double gelenMiktar =
                                                    double.parse(
                                                        aramaMiktarController[
                                                                index]
                                                            .text);
                                                print(
                                                    "gelen miktar $gelenMiktar");
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return fisHareketDuzenle(
                                                        gelenStokKart:
                                                            stokModel,
                                                        gelenMiktar:
                                                            gelenMiktar,
                                                      );
                                                    });
                                              },
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1.5,
                                      color: Colors.black87,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class fisHareketDuzenle extends StatefulWidget {
  fisHareketDuzenle({
    super.key,
    required this.gelenStokKart,
    required this.gelenMiktar,
  });
  final StokKart gelenStokKart;
  final double gelenMiktar;

  @override
  State<fisHareketDuzenle> createState() => _fisHareketDuzenleState();
}

class _fisHareketDuzenleState extends State<fisHareketDuzenle> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    miktarController.text = widget.gelenMiktar.toString();
    fiyatController.text = widget.gelenStokKart.SFIYAT1.toString();
    isk1Controller.text = widget.gelenStokKart.SATISISK.toString();
    isk2Controller.text = "0";
    isk3Controller.text = "0";
    malFazlasiController.text = "0";
    print("Miktar ${miktarController.text}");
  }

  final TextEditingController miktarController =
      TextEditingController(text: "1");

  final TextEditingController isk1Controller = TextEditingController(text: "0");

  final TextEditingController isk2Controller = TextEditingController(text: "0");

  final TextEditingController isk3Controller = TextEditingController(text: "0");

  final TextEditingController malFazlasiController =
      TextEditingController(text: "0");

  final TextEditingController fiyatController =
      TextEditingController(text: "0");

  void sepeteEkle(StokKart stokKart, KurModel stokKartKur, double miktar,
      {double iskonto1 = 0,
      double iskonto2 = 0,
      double iskonto3 = 0,
      double malFazlasi = 0,
      double fiyat = 0}) {
    int birimID = -1;

    for (var element in listeler.listOlcuBirim) {
      if (stokKart.OLCUBIRIM1 == element.ACIKLAMA) {
        birimID = element.ID!;
      }
    }
    double tempFiyat = 0;
    double tempIskonto1 = 0;
    if (fiyat != 0) {
      tempFiyat = fiyat;
    } else {
      tempFiyat = stokKart.SFIYAT1!;
    }
    if (iskonto1 != 0) {
      tempIskonto1 = iskonto1;
    } else {
      tempIskonto1 = stokKart.SATISISK!;
    }

    listeler.listKur.forEach((element) {
      if (element.ANABIRIM == "E") {
        if (stokKartKur.ACIKLAMA != element.ACIKLAMA) {
          tempFiyat = tempFiyat * stokKartKur.KUR!;
        }
      }
    });

    double KDVTUtarTemp =
        stokKart.guncelDegerler!.fiyat! * (1 + (stokKart.SATIS_KDV!));
    {
      fisEx.fiseStokEkle(
        // belgeTipi: widget.belgeTipi,
        urunListedenMiGeldin: false,
        stokAdi: stokKart.ADI!,
        KDVOrani: double.parse(stokKart.SATIS_KDV.toString()),
        birim: stokKart.OLCUBIRIM1!,
        birimID: birimID,
        dovizAdi: stokKartKur.ACIKLAMA!,
        dovizId: stokKartKur.ID!,
        burutFiyat: tempFiyat!,
        iskonto: tempIskonto1,
        iskonto2: 0.0,
        miktar: (miktar).toInt(),
        stokKodu: stokKart.KOD!,
        Aciklama1: '',
        KUR: stokKartKur.KUR!,
        TARIH: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        UUID: fisEx.fis!.value.UUID!,
      );
      // Ctanim.genelToplamHesapla(fisEx);

      // miktar = stokKart.guncelDegerler!.carpan!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                "Miktar",
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.remove_circle,
                          size: 40,
                          color: Colors.red,
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: miktarController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "1",
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          )),
                    ),
                  ),
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_circle,
                          size: 40,
                          color: Colors.green,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Divider(
                endIndent: 20,
                indent: 20,
                thickness: 1,
                color: Colors.black45,
              ),
              // !
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                "İskonto",
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "İskonto 1",
                        style: TextStyle(fontSize: 14),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: isk1Controller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "1",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "İskonto 2",
                        style: TextStyle(fontSize: 14),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: isk2Controller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "1",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "İskonto 3",
                        style: TextStyle(fontSize: 14),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: isk3Controller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "1",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Divider(
                endIndent: 20,
                indent: 20,
                thickness: 1,
                color: Colors.black45,
              ),
              // !
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                "Mal Fazlası",
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "1",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Divider(
                endIndent: 20,
                indent: 20,
                thickness: 1,
                color: Colors.black87,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                "Fiyat",
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "1",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Divider(
                endIndent: 20,
                indent: 20,
                thickness: 1,
                color: Colors.black45,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(
                      MediaQuery.of(context).size.width * 0.3,
                      MediaQuery.of(context).size.height * 0.05)),
                ),
                onPressed: () {
                  KurModel kur =
                      KurModel(ID: 1, ACIKLAMA: "USD", KUR: 30, ANABIRIM: "H");
                  double miktar = double.parse(miktarController.text);
                  print("turan" + miktar.toString());
                  sepeteEkle(widget.gelenStokKart, kur, miktar,
                      iskonto1: double.parse(isk1Controller.text) ?? 0,
                      iskonto2: double.parse(isk2Controller.text) ?? 0,
                      iskonto3: double.parse(isk3Controller.text) ?? 0,
                      malFazlasi: double.parse(malFazlasiController.text) ?? 0,
                      fiyat: double.parse(fiyatController.text));

                  Navigator.pop(context);
                },
                child: Text("Uygula"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class okumaModuList extends StatelessWidget {
  const okumaModuList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,

        //!! Sepet Listesi Buraya Gelecek
        child: ListView.builder(
          itemCount: fisEx.fis!.value.fisStokListesi.length,
          itemBuilder: (context, index) {
            FisHareket stokModel = fisEx.fis!.value.fisStokListesi[index];
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Text(
                              stokModel.STOKADI!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )),
                        Text(stokModel.STOKKOD! +
                            "  " +
                            "KDV " +
                            stokModel.KDVORANI.toString()),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.19,
                      child: Card(
                        elevation: 10,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Değiştir",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 3,
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
                            "Mal Fazlası",
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
                              child: Text("MF"),
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
                                "Adet",
                                // stokModel.BIRIMID.toString()!,
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
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.19,
                        child: Card(
                          elevation: 10,
                          child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Sil",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                //! Toplam, İskonto, KDV, Genel Toplam
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Toplam: ",
                          style: TextStyle(fontSize: 11, color: Colors.orange),
                        ),
                        Text(
                          stokModel.NETTOPLAM!.toStringAsFixed(2),
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
                          stokModel.KDVTUTAR!.toStringAsFixed(2),
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
                        Text(
                          stokModel.KDVDAHILNETTOPLAM!.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.black87,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
