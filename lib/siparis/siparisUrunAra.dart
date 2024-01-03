import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/model/KurModel.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/siparis/fisHareketDuzenle.dart';
import 'package:opak_fuar/siparis/okumaModuTasarim.dart';
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

    for (var element in listeler.listCariAltHesap) {
      if (element.KOD == fisEx.fis!.value.cariKart.KOD) {
        altHesaplar.add(element);
      }
      /*
      if(element.VARSAYILAN == "E"){
        seciliAltHesap = element;
      }
      */
    }
    if (altHesaplar.isEmpty) {
      CariAltHesap ss = CariAltHesap(
          KOD: "-1",
          ALTHESAP: "YOK",
          DOVIZID: -1,
          VARSAYILAN: "H",
          ALTHESAPID: -1,
          ZORUNLU: "H");
      altHesaplar.add(ss);
      seciliAltHesap = ss;
    } else {
      seciliAltHesap = altHesaplar.first;
    }

    for (int i = 0; i < stokKartEx.searchList.length; i++) {
      aramaMiktarController.add(TextEditingController(text: "1"));
    }
    stokKartEx.tempList.clear();
    SatisTipiModel satisTipiModel =
        SatisTipiModel(ID: -1, TIP: "a", FIYATTIP: "", ISK1: "", ISK2: "");
    if (stokKartEx.searchList.length > 100) {
      for (int i = 0; i < 100; i++) {
        print(Ctanim.seciliStokFiyatListesi.ADI);

        List<dynamic> gelenFiyatVeIskonto = stokKartEx.fiyatgetir(
            stokKartEx.searchList[i],
            widget.cari.KOD!,
            "Fiyat1",
            satisTipiModel,
            Ctanim.seciliStokFiyatListesi,
            widget.cari.cariAltHesaplar.first.ALTHESAPID);

        stokKartEx.searchList[i].guncelDegerler!.fiyat =
            double.parse(gelenFiyatVeIskonto[0].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto1 =
            double.parse(gelenFiyatVeIskonto[1].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto2 =
            double.parse(gelenFiyatVeIskonto[4].toString()) ?? 0.0;

        stokKartEx.searchList[i].guncelDegerler!.iskonto3 =
            double.parse(gelenFiyatVeIskonto[5].toString() ?? "0");

        stokKartEx.searchList[i].guncelDegerler!.iskonto4 =
            double.parse(gelenFiyatVeIskonto[6].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto5 =
            double.parse(gelenFiyatVeIskonto[7].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto6 =
            double.parse(gelenFiyatVeIskonto[8].toString());

        stokKartEx.searchList[i].guncelDegerler!.guncelBarkod =
            stokKartEx.searchList[i].KOD;
        stokKartEx.searchList[i].guncelDegerler!.seciliFiyati =
            gelenFiyatVeIskonto[2].toString();
        stokKartEx.searchList[i].guncelDegerler!.fiyatDegistirMi =
            gelenFiyatVeIskonto[3];
        stokKartEx.searchList[i].guncelDegerler!.carpan = 1.0;

        stokKartEx.searchList[i].guncelDegerler!.netfiyat =
            stokKartEx.searchList[i].guncelDegerler!.hesaplaNetFiyat();
        //fiyat listesi koşul arama fonksiyonua gönderiliyor orda ekleme yapsanda buraya eklemez giyatListesiKosulu cTanima ekle !
        if (!Ctanim.fiyatListesiKosul
            .contains(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati)) {
          Ctanim.fiyatListesiKosul
              .add(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati!);
        }
        stokKartEx.tempList.add(stokKartEx.searchList[i]);
      }
    } else {
      for (int i = 0; i < stokKartEx.searchList.length; i++) {
        List<dynamic> gelenFiyatVeIskonto = stokKartEx.fiyatgetir(
            stokKartEx.searchList[i],
            widget.cari.KOD!,
            "Fiyat1",
            satisTipiModel,
            Ctanim.seciliStokFiyatListesi,
            widget.cari.cariAltHesaplar.first.ALTHESAPID);
        stokKartEx.searchList[i].guncelDegerler!.guncelBarkod =
            stokKartEx.searchList[i].KOD;
        stokKartEx.searchList[i].guncelDegerler!.carpan = 1.0;
        stokKartEx.searchList[i].guncelDegerler!.fiyat =
            double.parse(gelenFiyatVeIskonto[0].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto1 =
            double.parse(gelenFiyatVeIskonto[1].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto2 =
            double.parse(gelenFiyatVeIskonto[4].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto3 =
            double.parse(gelenFiyatVeIskonto[5].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto4 =
            double.parse(gelenFiyatVeIskonto[6].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto5 =
            double.parse(gelenFiyatVeIskonto[7].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto6 =
            double.parse(gelenFiyatVeIskonto[8].toString());

        stokKartEx.searchList[i].guncelDegerler!.seciliFiyati =
            gelenFiyatVeIskonto[2].toString();
        stokKartEx.searchList[i].guncelDegerler!.fiyatDegistirMi =
            gelenFiyatVeIskonto[3];

        stokKartEx.searchList[i].guncelDegerler!.netfiyat =
            stokKartEx.searchList[i].guncelDegerler!.hesaplaNetFiyat();
        //fiyat listesi koşul arama fonksiyonua gönderiliyor orda ekleme yapsanda buraya eklemez giyatListesiKosulu cTanima ekle !
        if (!Ctanim.fiyatListesiKosul
            .contains(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati)) {
          Ctanim.fiyatListesiKosul
              .add(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati!);
        }
        stokKartEx.tempList.add(stokKartEx.searchList[i]);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Ctanim.secililiMarkalarFiltre.clear();
    Fis.empty().fisEkle(fis: fisEx.fis!.value!, belgeTipi: "YOK");
    //Ctanim.seciliMarkalarFiltreMap.clear();
    /* stokKartEx.searchC(
        "", "", "", Ctanim.seciliIslemTip, Ctanim.seciliStokFiyatListesi);*/
  }

  String result = '';
  bool aramaModu = false;
  bool okumaModu = true;
  TextEditingController editingController = TextEditingController();
  List<TextEditingController> aramaMiktarController = [];
  final StokKartController stokKartEx = Get.find();

  CariAltHesap? seciliAltHesap;
  List<CariAltHesap> altHesaplar = [];

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
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    //FocusScope.of(context).requestFocus(focusNode);
    double ekranYuksekligi = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
       // appBar: appBarDizayn(context),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SiparisTamamla()));
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
              top: ekranYuksekligi*0.01,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
            ),
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
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: CheckboxListTile(
                            title: Text(
                              "Okuma Modu",
                              style: TextStyle(fontSize: 12),
                            ),
                            value: okumaModu,
                            onChanged: (value) {
                             // FocusScope.of(context).requestFocus(focusNode);
                              setState(() {
                                okumaModu = value!;
                                if (value == true) {
                                  aramaModu = false;
                                }
                              });
                            }),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: CheckboxListTile(
                            title: Text(
                              "Arama Modu",
                              style: TextStyle(fontSize: 12),
                            ),
                            value: aramaModu,
                            onChanged: (value) {
                              setState(() {
                                aramaModu = value!;
                                if (value == true) {
                                  okumaModu = false;
                                }
                              });
                            }),
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
                          focusNode: focusNode,
                          controller: editingController,
                         onTap: () =>   editingController.selection = TextSelection(baseOffset: 0, extentOffset: editingController.value.text.length),
                          onFieldSubmitted: ((value)  {
                            stokKartEx.tempList.clear();
                            if (okumaModu == false) {
                              SatisTipiModel m = SatisTipiModel(
                                  ID: -1,
                                  TIP: "",
                                  FIYATTIP: "",
                                  ISK1: "",
                                  ISK2: "");
                              stokKartEx.searchC(
                                  value!,
                                  widget.cari.KOD!,
                                  "Fiyat1",
                                  m,
                                  Ctanim.seciliStokFiyatListesi,
                                  seciliAltHesap!.ALTHESAPID!);

                              setState(() {});
                              //editingController.text = "";
                            } else {
                              int okutulanCarpan = 1;
                               List<String> aranacak = [];
                              if (value!.contains("*")) {
                               aranacak = value.split("*");
                                okutulanCarpan = int.parse(aranacak[0]);
                                value = aranacak[1];
                                print(aranacak);
                              }
                               else   if (value.contains("x")) {
                               aranacak = value.split("x");
                                okutulanCarpan = int.parse(aranacak[0]);
                                value = aranacak[1];
                                print(aranacak);
                              }
                                else  if (value.contains("X")) {
                               aranacak = value.split("X");
                                okutulanCarpan = int.parse(aranacak[0]);
                                value = aranacak[1];
                                print(aranacak);
                              }
                              SatisTipiModel m = SatisTipiModel(
                                  ID: -1,
                                  TIP: "",
                                  FIYATTIP: "",
                                  ISK1: "",
                                  ISK2: "");
                              stokKartEx.searchC(
                                  value,
                                  widget.cari.KOD!,
                                  "Fiyat1",
                                  m,
                                  Ctanim.seciliStokFiyatListesi,
                                  seciliAltHesap!.ALTHESAPID!);

                              if (stokKartEx.tempList.length == 1) {
                                double gelenMiktar = stokKartEx
                                    .tempList[0].guncelDegerler!.carpan!*okutulanCarpan;
                                // FocusScope.of(context).requestFocus(focusNode);

                                 showDialog(
                                    context: context,
                                    builder: (context) {
                                      return fisHareketDuzenle(
                                        urunDuzenlemeyeGeldim: false,
                                        okutulanCarpan: okutulanCarpan,
                                        altHesap: seciliAltHesap!.ALTHESAP!,
                                        gelenStokKart: stokKartEx.tempList[0],
                                        gelenMiktar: gelenMiktar,
                                      );
                                    }).then((value) {
                                  setState(() {
                                    Ctanim.genelToplamHesapla(fisEx);
                                  });
                                });
                              }
                              editingController.text = "";
                              FocusScope.of(context).requestFocus(focusNode);
                              
                            }
                          }),
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.search),
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
                            }
                            stokKartEx.searchC(
                                result,
                                widget.cari.KOD!,
                                "Fiyat1",
                                m,
                                Ctanim.seciliStokFiyatListesi,
                                seciliAltHesap!.ALTHESAPID);
                            if (okumaModu == true) {
                              if (stokKartEx.tempList.length == 1) {
                                double gelenMiktar = stokKartEx
                                    .tempList[0].guncelDegerler!.carpan!;

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return fisHareketDuzenle(
                                        urunDuzenlemeyeGeldim: false,
                                        okutulanCarpan: 1,
                                        altHesap: seciliAltHesap!.ALTHESAP!,
                                        gelenStokKart: stokKartEx.tempList[0],
                                        gelenMiktar: gelenMiktar,
                                      );
                                    }).then((value) {
                                  setState(() {
                                    Ctanim.genelToplamHesapla(fisEx);
                                  });
                                });
                              }
                              stokKartEx.searchC(
                                  "",
                                  "",
                                  "Fiyat1",
                                  m,
                                  Ctanim.seciliStokFiyatListesi,
                                  seciliAltHesap!.ALTHESAPID);
                            }
                           // editingController.text = "";

                            setState(() {});
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            size: 40, //MediaQuery.of(context).size.width * 0.1,
                            color: Colors.black54,
                          )),
                    ],
                  ),
                  // ! Firma adı
                  Padding(
                    padding: EdgeInsets.all(3.0),
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

                  // ! Alt Hesap
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
                              onChanged: (CariAltHesap? selected) {
                                setState(() {
                                  seciliAltHesap = selected!;
                                  fisEx.fis!.value.ALTHESAP = selected.ALTHESAP;
                                });
                                stokKartEx.tempList.clear();
                                SatisTipiModel satisTipiModel = SatisTipiModel(
                                    ID: -1,
                                    TIP: "a",
                                    FIYATTIP: "",
                                    ISK1: "",
                                    ISK2: "");
                                if (stokKartEx.searchList.length > 100) {
                                  for (int i = 0; i < 100; i++) {
                                    print(Ctanim.seciliStokFiyatListesi.ADI);
                                    List<dynamic> gelenFiyatVeIskonto =
                                        stokKartEx.fiyatgetir(
                                            stokKartEx.searchList[i],
                                            widget.cari.KOD!,
                                            "Fiyat1",
                                            satisTipiModel,
                                            Ctanim.seciliStokFiyatListesi,
                                            seciliAltHesap!.ALTHESAPID);

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .fiyat =
                                        double.parse(
                                            gelenFiyatVeIskonto[0].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto1 =
                                        double.parse(
                                            gelenFiyatVeIskonto[1].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto2 =
                                        double.parse(
                                            gelenFiyatVeIskonto[4].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto3 =
                                        double.parse(
                                            gelenFiyatVeIskonto[5].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto4 =
                                        double.parse(
                                            gelenFiyatVeIskonto[6].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto5 =
                                        double.parse(
                                            gelenFiyatVeIskonto[7].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto6 =
                                        double.parse(
                                            gelenFiyatVeIskonto[8].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .guncelBarkod =
                                        stokKartEx.searchList[i].KOD;
                                    stokKartEx.searchList[i].guncelDegerler!
                                            .seciliFiyati =
                                        gelenFiyatVeIskonto[2].toString();
                                    stokKartEx.searchList[i].guncelDegerler!
                                            .fiyatDegistirMi =
                                        gelenFiyatVeIskonto[3];
                                    stokKartEx.searchList[i].guncelDegerler!
                                        .carpan = 1.0;

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .netfiyat =
                                        stokKartEx.searchList[i].guncelDegerler!
                                            .hesaplaNetFiyat();
                                    //fiyat listesi koşul arama fonksiyonua gönderiliyor orda ekleme yapsanda buraya eklemez giyatListesiKosulu cTanima ekle !
                                    if (!Ctanim.fiyatListesiKosul.contains(
                                        stokKartEx.searchList[i].guncelDegerler!
                                            .seciliFiyati)) {
                                      Ctanim.fiyatListesiKosul.add(stokKartEx
                                          .searchList[i]
                                          .guncelDegerler!
                                          .seciliFiyati!);
                                    }
                                    stokKartEx.tempList
                                        .add(stokKartEx.searchList[i]);
                                  }
                                } else {
                                  for (int i = 0;
                                      i < stokKartEx.searchList.length;
                                      i++) {
                                    List<dynamic> gelenFiyatVeIskonto =
                                        stokKartEx.fiyatgetir(
                                            stokKartEx.searchList[i],
                                            widget.cari.KOD!,
                                            "Fiyat1",
                                            satisTipiModel,
                                            Ctanim.seciliStokFiyatListesi,
                                            seciliAltHesap!.ALTHESAPID);
                                    stokKartEx.searchList[i].guncelDegerler!
                                            .guncelBarkod =
                                        stokKartEx.searchList[i].KOD;
                                    stokKartEx.searchList[i].guncelDegerler!
                                        .carpan = 1.0;
                                    stokKartEx.searchList[i].guncelDegerler!
                                            .fiyat =
                                        double.parse(
                                            gelenFiyatVeIskonto[0].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto1 =
                                        double.parse(
                                            gelenFiyatVeIskonto[1].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto2 =
                                        double.parse(
                                            gelenFiyatVeIskonto[4].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto3 =
                                        double.parse(
                                            gelenFiyatVeIskonto[5].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto4 =
                                        double.parse(
                                            gelenFiyatVeIskonto[6].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto5 =
                                        double.parse(
                                            gelenFiyatVeIskonto[7].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .iskonto6 =
                                        double.parse(
                                            gelenFiyatVeIskonto[8].toString());

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .seciliFiyati =
                                        gelenFiyatVeIskonto[2].toString();
                                    stokKartEx.searchList[i].guncelDegerler!
                                            .fiyatDegistirMi =
                                        gelenFiyatVeIskonto[3];

                                    stokKartEx.searchList[i].guncelDegerler!
                                            .netfiyat =
                                        stokKartEx.searchList[i].guncelDegerler!
                                            .hesaplaNetFiyat();
                                    //fiyat listesi koşul arama fonksiyonua gönderiliyor orda ekleme yapsanda buraya eklemez giyatListesiKosulu cTanima ekle !
                                    if (!Ctanim.fiyatListesiKosul.contains(
                                        stokKartEx.searchList[i].guncelDegerler!
                                            .seciliFiyati)) {
                                      Ctanim.fiyatListesiKosul.add(stokKartEx
                                          .searchList[i]
                                          .guncelDegerler!
                                          .seciliFiyati!);
                                    }
                                    stokKartEx.tempList
                                        .add(stokKartEx.searchList[i]);
                                  }
                                }
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
                    height: ekranYuksekligi < 550
                        ? ekranYuksekligi * .25
                        : ekranYuksekligi * 0.42,
                    child: okumaModu == true
                        ? okumaModuList()
                        : SingleChildScrollView(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: ListView.builder(
                                itemCount: stokKartEx.tempList
                                    .length, // stokKartEx.searchList.length,
                                itemBuilder: (context, index) {
                                  StokKart stokModel =
                                      stokKartEx.tempList[index];
                                  //    stokKartEx.searchList[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12,
                                    ),
                                    child: Column(
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
                                                    stokModel.ADI! +
                                                        " " +
                                                        stokModel.SATDOVIZ!,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                  onTap: () =>
                                                      aramaMiktarController[
                                                                  index]
                                                              .selection =
                                                          TextSelection(
                                                              baseOffset: 0,
                                                              extentOffset:
                                                                  aramaMiktarController[
                                                                          index]
                                                                      .value
                                                                      .text
                                                                      .length),
                                                  autocorrect: true,
                                                  controller:
                                                      aramaMiktarController[
                                                          index],
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                    /* label: Text( 
                                                      aramaMiktarController[index]
                                                          .text),*/

                                                    hintStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                    border: InputBorder.none,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^[\d\.]*$')),
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
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.13,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        stokModel
                                                            .guncelDegerler!
                                                            .iskonto1!
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
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.13,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
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
                                                      style: TextStyle(
                                                          fontSize: 13)),
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.13,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        stokModel.OLCUBIRIM1!,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text("Fiyat",
                                                      style: TextStyle(
                                                          fontSize: 13)),
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.04,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.13,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        stokModel
                                                            .guncelDegerler!
                                                            .fiyat!
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
                                                    child: GestureDetector(
                                                  onLongPress: () {
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
                                                            urunDuzenlemeyeGeldim: false,
                                                            okutulanCarpan: 1,
                                                            altHesap:
                                                                seciliAltHesap!
                                                                    .ALTHESAP!,
                                                            gelenStokKart:
                                                                stokModel,
                                                            gelenMiktar:
                                                                gelenMiktar,
                                                          );
                                                        }).then((value) {
                                                      setState(() {
                                                        Ctanim
                                                            .genelToplamHesapla(
                                                                fisEx);
                                                      });
                                                    });
                                                  },
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.add_circle,
                                                      size: 40,
                                                      color: Colors.green,
                                                    ),
                                                    onPressed: () {
                                                      KurModel gidecekKur =
                                                          listeler
                                                              .listKur.first;
                                                      for (var element
                                                          in listeler.listKur) {
                                                        if (stokModel
                                                                .SATDOVIZ ==
                                                            element.ACIKLAMA) {
                                                          gidecekKur = element;
                                                        }
                                                      }
                                                      double miktar = stokModel.guncelDegerler!.carpan !>1 ?stokModel.guncelDegerler!.carpan!
                                                        :double.parse(
                                                          aramaMiktarController[
                                                                  index]
                                                              .text);
                                                      print("turan" +
                                                          miktar.toString());
                                                      sepeteEkle(
                                                        stokModel,
                                                        gidecekKur,
                                                        miktar,
                                                        iskonto1: stokModel
                                                            .guncelDegerler!
                                                            .iskonto1!,
                                                        iskonto2: stokModel
                                                            .guncelDegerler!
                                                            .iskonto2!,
                                                        iskonto3: stokModel
                                                            .guncelDegerler!
                                                            .iskonto3!,
                                                        iskonto4: stokModel
                                                            .guncelDegerler!
                                                            .iskonto4!,
                                                        iskonto5: stokModel
                                                            .guncelDegerler!
                                                            .iskonto5!,
                                                        iskonto6: stokModel
                                                            .guncelDegerler!
                                                            .iskonto6!,
                                                      );
                                                      showSnackBar(
                                                          context, miktar);
                                                    },
                                                  ),
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
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
                          Ctanim.donusturMusteri(
                              fisEx.fis!.value.GENELTOPLAM.toString()),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, double miktar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Stok eklendi " + miktar.toString() + " adet ürün sepete eklendi ! ",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        duration: Duration(milliseconds: 700),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void sepeteEkle(StokKart stokKart, KurModel stokKartKur, double miktar,
      {double iskonto1 = 0,
      double iskonto2 = 0,
      double iskonto3 = 0,
      double iskonto4 = 0,
      double iskonto5 = 0,
      double iskonto6 = 0,
      int malFazlasi = 0,
      double fiyat = 0}) {
    int birimID = -1;

    for (var element in listeler.listOlcuBirim) {
      if (stokKart.OLCUBIRIM1 == element.ACIKLAMA) {
        birimID = element.ID!;
      }
    }
    double tempFiyat = 0;

    if (fiyat != 0) {
      tempFiyat = fiyat;
    } else {
      tempFiyat = stokKart.guncelDegerler!.fiyat!;
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

        ALTHESAP: seciliAltHesap!.ALTHESAP!,
        urunListedenMiGeldin: false,
        stokAdi: stokKart.ADI!,
        KDVOrani: double.parse(stokKart.SATIS_KDV.toString()),
        birim: stokKart.OLCUBIRIM1!,
        birimID: birimID,
        dovizAdi: stokKartKur.ACIKLAMA!,
        dovizId: stokKartKur.ID!,
        burutFiyat: tempFiyat,
        iskonto: iskonto1,
        iskonto2: iskonto2,
        iskonto3: iskonto3,
        iskonto4: iskonto4,
        iskonto5: iskonto5,
        iskonto6: iskonto6,
        miktar: (miktar).toInt(),
        stokKodu: stokKart.KOD!,
        Aciklama1: '',
        KUR: stokKartKur.KUR!,
        TARIH: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        UUID: fisEx.fis!.value.UUID!,
      );
      setState(() {
        Ctanim.genelToplamHesapla(fisEx);
      });

      // miktar = stokKart.guncelDegerler!.carpan!;
    }
  }
}
