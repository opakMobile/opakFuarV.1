import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/model/KurModel.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/pages/CustomAlertDialog.dart';
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
  SiparisUrunAra({required this.cari, required this.varsayilan});

  late Cari cari;
  late CariAltHesap varsayilan;

  @override
  State<SiparisUrunAra> createState() => _SiparisUrunAraState();
}

class _SiparisUrunAraState extends State<SiparisUrunAra>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    //doğrudan cari alt hesapları verecez

    seciliAltHesap = widget.cari.cariAltHesaplar.first;

    for (int i = 0; i < stokKartEx.searchList.length; i++) {
      String tempMiktar = stokKartEx.searchList[i].SACIKLAMA9!.split(".")[0];
      aramaMiktarController.add(
          TextEditingController(text: tempMiktar == "0" ? "1" : tempMiktar));
      focusNodeList.add(FocusNode());
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
        stokKartEx.searchList[i].guncelDegerler!.carpan = 1;

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
        stokKartEx.searchList[i].guncelDegerler!.carpan = 1;
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

    Ctanim.secililiMarkalarFiltre.clear();
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
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
    //Ctanim.seciliMarkalarFiltreMap.clear();
    /* stokKartEx.searchC(
        "", "", "", Ctanim.seciliIslemTip, Ctanim.seciliStokFiyatListesi);*/
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('Uygulama ön planda');
    }
    if (state == AppLifecycleState.paused) {
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
      print('Uygulama arka planda');
    }
    if (state == AppLifecycleState.inactive) {
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
      print('Uygulama arka planda');
    }
    
  }

  String result = '';
  bool aramaModu = false;
  bool okumaModu = true;
  TextEditingController editingController = TextEditingController();
  List<TextEditingController> aramaMiktarController = [];
  final StokKartController stokKartEx = Get.find();

  CariAltHesap? seciliAltHesap;
  bool sepetteara = false;

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
  List<FocusNode> focusNodeList = [];
  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    FocusNode focusDrop = FocusNode();

    if (Ctanim.urunAraFocus == true) {
      FocusScope.of(context).requestFocus(focusNode);
      Ctanim.urunAraFocus = false;
      focusDrop.unfocus();
    }

    if (okumaModu == false && aramaModu == false) {
      setState(() {
        okumaModu = true;
      });
    }

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
        body: GestureDetector(
          onTap: () {
            focusNode.unfocus();
            for (var i = 0; i < focusNodeList.length; i++) {
              focusNodeList[i].unfocus();
            }
          },
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: CheckboxListTile(
                              title: Text(
                                "Okuma Modu",
                                style: TextStyle(fontSize: 12),
                              ),
                              value: okumaModu,
                              onChanged: (value) async {
                                await textAramaYap("", context);
                                editingController.text = "";
                                // FocusScope.of(context).requestFocus(focusNode);
                                setState(() {
                                  okumaModu = value!;
                                  sepetteara = false;
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
                              onChanged: (value) async {
                                editingController.text = "";
                                setState(() {
                                  aramaModu = value!;
                                  sepetteara = false;
                                  if (value == true) {
                                    okumaModu = false;
                                  }
                                });
                                await textAramaYap("", context);
                              }),
                        ),
                      ],
                    ),
                    okumaModu == true
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: CheckboxListTile(
                                title: Text(
                                  "Sepette arama yap",
                                  style: TextStyle(fontSize: 12),
                                ),
                                value: sepetteara,
                                onChanged: (value) async {
                                  // bura gidecek
                                  //     await textAramaYap("", context);
                                  //editingController.text = "";
                                  setState(() {
                                    sepetteara = value!;
                                  });
                                }),
                          )
                        : Container(),
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
                            autofocus: true,
                            focusNode: focusNode,
                            controller: editingController,
                            onTap: () {
                              for (var i = 0; i < focusNodeList.length; i++) {
                                focusNodeList[i].unfocus();
                              }
                              Ctanim.urunAraFocus = true;
                              editingController.text = "";
                              /*
                              editingController.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      editingController.value.text.length);
                                      */
                            },
                            onFieldSubmitted: ((value) async {
                              await textAramaYap(value, context);
                            }),
                            onChanged: (value) {
                              if (sepetteara == true) {
                                setState(() {});
                              }
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () async {
                                  await textAramaYap(
                                      editingController.text, context);
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
                              }
                              await textAramaYap(result, context);
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
                                focusNode: focusDrop,
                                value: seciliAltHesap,
                                items: widget.cari.cariAltHesaplar
                                    .map((CariAltHesap banka) {
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
                                    Ctanim.urunAraFocus = true;
                                    seciliAltHesap = selected!;
                                    fisEx.fis!.value.ALTHESAP =
                                        selected.ALTHESAP;
                                  });
                                  await textAramaYap("", context);

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
                          : ekranYuksekligi * 0.57,
                      child: okumaModu == true
                          ? okumaModuList(
                              seciliAltHesap: seciliAltHesap!.ALTHESAP!,
                              sepetteAra: sepetteara,
                              editinControllerText: editingController.text,
                            )
                          : SingleChildScrollView(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: ListView.builder(
                                  itemCount: stokKartEx.tempList
                                      .length, // stokKartEx.searchList.length,
                                  itemBuilder: (context, index) {
                                    StokKart stokModel =
                                        stokKartEx.tempList[index];
                                    //    stokKartEx.searchList[index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: ekranYuksekligi < 650
                                            ? ekranYuksekligi * 0.07
                                            : ekranYuksekligi * 0.002,
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
                                                      stokModel.ADI!,
                                                      style: TextStyle(
                                                        color: fisEx.fis!.value
                                                                .fisStokListesi
                                                                .any((element) =>
                                                                    element
                                                                        .STOKKOD ==
                                                                    stokModel
                                                                        .guncelDegerler!
                                                                        .guncelBarkod)
                                                            ? Colors.red
                                                            : Colors.black,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      stokModel.guncelDegerler!
                                                              .guncelBarkod! +
                                                          "  " +
                                                          "KDV " +
                                                          stokModel.SATIS_KDV
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: fisEx.fis!.value
                                                                .fisStokListesi
                                                                .any((element) =>
                                                                    element
                                                                        .STOKKOD ==
                                                                    stokModel
                                                                        .guncelDegerler!
                                                                        .guncelBarkod)
                                                            ? Colors.red
                                                            : Colors.black,
                                                      ),
                                                    ),
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
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                  ),
                                                  child: TextFormField(
                                                    focusNode:
                                                        focusNodeList[index],
                                                    onTap: () {
                                                      focusNode.unfocus();
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              focusNodeList[
                                                                  index]);

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
                                                                      .length);
                                                    },
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "İskonto",
                                                      style: TextStyle(
                                                          fontSize: 13),
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
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          stokModel
                                                              .guncelDegerler!
                                                              .iskonto1!
                                                              .toStringAsFixed(
                                                                  2),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Miktar",
                                                      style: TextStyle(
                                                          fontSize: 13),
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
                                                            BorderRadius
                                                                .circular(5),
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
                                                            BorderRadius
                                                                .circular(5),
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
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          stokModel
                                                              .guncelDegerler!
                                                              .fiyat!
                                                              .toStringAsFixed(
                                                                  2),
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
                                                      bool urunDuz = false;
                                                      int Fismiktar = 0;
                                                      for (var element in fisEx
                                                          .fis!
                                                          .value
                                                          .fisStokListesi) {
                                                        if (element.STOKKOD ==
                                                                stokModel
                                                                    .guncelDegerler!
                                                                    .guncelBarkod! &&
                                                            element.ALTHESAP ==
                                                                seciliAltHesap!
                                                                    .ALTHESAP!) {
                                                          urunDuz = true;
                                                          Fismiktar =
                                                              element.MIKTAR!;
                                                        }
                                                      }
                                                      print(
                                                          "gelen miktar $gelenMiktar");
                                                      Ctanim.urunAraFocus =
                                                          false;
                                                      editingController.text =
                                                          "";
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return fisHareketDuzenle(
                                                              urunDuzenlemeyeGeldim:
                                                                  urunDuz,
                                                              fisHareketMiktar:
                                                                  Fismiktar!,
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
                                                          /*
                                                          Ctanim
                                                              .genelToplamHesapla(
                                                                  fisEx);
                                                                  */
                                                        });
                                                      });
                                                    },
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.add_circle,
                                                        size: 40,
                                                        color: Colors.green,
                                                      ),
                                                      onPressed: () async {
                                                        focusNodeList[index]
                                                            .unfocus();
                                                        Ctanim.urunAraFocus =
                                                            true;
                                                        editingController.text =
                                                            "";
                                                        KurModel gidecekKur =
                                                            listeler
                                                                .listKur.first;
                                                        for (var element
                                                            in listeler
                                                                .listKur) {
                                                          if (stokModel
                                                                  .SATDOVIZ ==
                                                              element
                                                                  .ACIKLAMA) {
                                                            gidecekKur =
                                                                element;
                                                          }
                                                        }
                                                        double miktar = 0.0;
                                                        String tempSacikalama9 =
                                                            stokModel
                                                                .SACIKLAMA9!
                                                                .split(".")[0];
                                                        if (tempSacikalama9 ==
                                                            "0") {
                                                          tempSacikalama9 = "1";
                                                        }
                                                        double kontrolCarpan = stokModel
                                                                    .guncelDegerler!
                                                                    .carpan! >
                                                                1
                                                            ? stokModel
                                                                .guncelDegerler!
                                                                .carpan!
                                                            : double.tryParse(
                                                                    tempSacikalama9) ??
                                                                1;

                                                        if (double.parse(
                                                                    aramaMiktarController[
                                                                            index]
                                                                        .text) %
                                                                kontrolCarpan !=
                                                            0) {
                                                          await showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return CustomAlertDialog(
                                                                  align:
                                                                      TextAlign
                                                                          .left,
                                                                  title: 'Hata',
                                                                  message: 'Eklemeye çalıştığınız miktar  ' +
                                                                      kontrolCarpan
                                                                          .toString() +
                                                                      " katı olmalıdır.",
                                                                  onPres:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  buttonText:
                                                                      'Tamam',
                                                                );
                                                              });
                                                          return;
                                                        } else {
                                                          miktar = double.parse(
                                                              aramaMiktarController[
                                                                      index]
                                                                  .text);
                                                        }

                                                        print("turan" +
                                                            miktar.toString());
                                                        sepeteEkle(stokModel,
                                                            gidecekKur, miktar,
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
                                                            malFazlasi: (double.tryParse(
                                                                        stokModel
                                                                            .SACIKLAMA10!)!)
                                                                    .toInt() ??
                                                                0);
                                                        showSnackBar(
                                                            context, miktar);
                                                      },
                                                    ),
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  stokModel.OLCUBIRIM2 != ""
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              stokModel
                                                                      .OLCUBIRIM2! +
                                                                  " :",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .orange),
                                                            ),
                                                            Text(
                                                              stokModel
                                                                  .BIRIMADET1!, // stokModel.BRUTTOPLAMFIYAT!.toStringAsFixed(2),//
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : Container(),
                                                  stokModel.OLCUBIRIM3 != ""
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              stokModel
                                                                      .OLCUBIRIM3! +
                                                                  " :",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .orange),
                                                            ),
                                                            Text(
                                                              stokModel
                                                                  .BIRIMADET2!, // stokModel.BRUTTOPLAMFIYAT!.toStringAsFixed(2),//
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : Container(),
                                                  stokModel.OLCUBIRIM4 != ""
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              stokModel
                                                                      .OLCUBIRIM4! +
                                                                  " :",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .orange),
                                                            ),
                                                            Text(
                                                              stokModel
                                                                  .BIRIMADET3!, // stokModel.BRUTTOPLAMFIYAT!.toStringAsFixed(2),//
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : Container(),
                                                  stokModel.OLCUBIRIM5 != ""
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              stokModel
                                                                      .OLCUBIRIM5! +
                                                                  " :",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .orange),
                                                            ),
                                                            Text(
                                                              stokModel
                                                                  .BIRIMADET4!, // stokModel.BRUTTOPLAMFIYAT!.toStringAsFixed(2),//
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : Container(),
                                                  stokModel.OLCUBIRIM6 != ""
                                                      ? Row(
                                                          children: [
                                                            Text(
                                                              stokModel
                                                                      .OLCUBIRIM6! +
                                                                  " :",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .orange),
                                                            ),
                                                            Text(
                                                              stokModel
                                                                  .BIRIMADET5!, // stokModel.BRUTTOPLAMFIYAT!.toStringAsFixed(2),//
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : Container(),
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
                            "Satış Toplamı:",
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
                                  fisEx.fis!.value.ARA_TOPLAM.toString()),
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

  Future<void> textAramaYap(String value, BuildContext context) async {
    stokKartEx.tempList.clear();
    if (okumaModu == false) {
      SatisTipiModel m =
          SatisTipiModel(ID: -1, TIP: "", FIYATTIP: "", ISK1: "", ISK2: "");
      stokKartEx.searchC(
          value!,
          widget.cari.KOD!,
          Ctanim.satisFiyatListesi.first,
          m,
          Ctanim.seciliStokFiyatListesi,
          seciliAltHesap!.ALTHESAPID!);

      aramaMiktarController.clear();
      for (int i = 0; i < stokKartEx.tempList.length; i++) {
        String tempSaciklama9 =
            stokKartEx.tempList[i].SACIKLAMA9!.split(".")[0];
        String tempMiktar = stokKartEx.tempList[i].guncelDegerler!.carpan! > 1
            ? ((stokKartEx.tempList[i].guncelDegerler!.carpan!).toInt())
                .toString()
            : tempSaciklama9;
        aramaMiktarController.add(
            TextEditingController(text: tempMiktar == "0" ? "1" : tempMiktar));
      }

      setState(() {});
      //editingController.text = "";
    } else {
      if (sepetteara == true) {
        // okumaModuList( seciliAltHesap: seciliAltHesap!.ALTHESAP!,sepetteAra: sepetteara,editinControllerText: editingController.text,);
        FocusScope.of(context).unfocus();
      } else {
        int okutulanCarpan = 1;
        List<String> aranacak = [];
        if (value!.contains("*")) {
          aranacak = value.split("*");
          okutulanCarpan = int.parse(aranacak[0]);
          value = aranacak[1];
          print(aranacak);
        } else if (value.contains("x")) {
          aranacak = value.split("x");
          okutulanCarpan = int.parse(aranacak[0]);
          value = aranacak[1];
          print(aranacak);
        } else if (value.contains("X")) {
          aranacak = value.split("X");
          okutulanCarpan = int.parse(aranacak[0]);
          value = aranacak[1];
          print(aranacak);
        }
        // buraya da nokta ekleneblir ama beklesin
        SatisTipiModel m =
            SatisTipiModel(ID: -1, TIP: "", FIYATTIP: "", ISK1: "", ISK2: "");
        stokKartEx.searchC(
            value,
            widget.cari.KOD!,
            Ctanim.satisFiyatListesi.first,
            m,
            Ctanim.seciliStokFiyatListesi,
            seciliAltHesap!.ALTHESAPID!);

        if (stokKartEx.tempList.length == 1) {
          String tempSacikalama9 =
              stokKartEx.tempList[0].SACIKLAMA9!.split(".")[0];
          if (tempSacikalama9 == "0") {
            tempSacikalama9 = "1";
          }
          double gelenMiktar = 0.0;
          if (stokKartEx.tempList[0].guncelDegerler!.carpan! > 1) {
            gelenMiktar = double.parse(
                    stokKartEx.tempList[0].guncelDegerler!.carpan.toString())! *
                okutulanCarpan;
          } else {
            gelenMiktar = double.parse(tempSacikalama9)! * okutulanCarpan;
          }

          // FocusScope.of(context).requestFocus(focusNode);
          bool urunVar = false;
          int Fmiktar = 0;

          for (var element in fisEx.fis!.value.fisStokListesi) {
            if ((stokKartEx.tempList[0].guncelDegerler!.guncelBarkod! ==
                    element.STOKKOD &&
                element.ALTHESAP == seciliAltHesap!.ALTHESAP!)) {
              urunVar = true;
              Fmiktar = element.MIKTAR!;
            }
          }
          Ctanim.urunAraFocus = false;
          editingController.text = "";
          var donen = await showDialog(
              context: context,
              builder: (context) {
                return fisHareketDuzenle(
                  urunDuzenlemeyeGeldim: urunVar,
                  fisHareketMiktar: Fmiktar,
                  okutulanCarpan: okutulanCarpan,
                  altHesap: seciliAltHesap!.ALTHESAP!,
                  gelenStokKart: stokKartEx.tempList[0],
                  gelenMiktar: gelenMiktar,
                );
              });
          if (donen != null || donen == null) {
            print("NULL DEĞİL");

            setState(() {
              // Ctanim.genelToplamHesapla(fisEx);
              //FocusScope.of(context).requestFocus(focusNode);
            });
          }
        }
        // editingController.text = "";
        //FocusScope.of(context).requestFocus(focusNode);
      }
    }
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
    /*
    setState(() {
      Ctanim.urunAraFocus = true;
    });
    */
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

        malFazlasi: malFazlasi,
        ALTHESAP: seciliAltHesap!.ALTHESAP!,
        urunListedenMiGeldin: true,
        stokAdi: stokKart.ADI!,
        KDVOrani: double.parse(stokKart.SATIS_KDV.toString()),
        birim: stokKart.OLCUBIRIM1!,
        birimID: 1,
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
        stokKodu: stokKart.guncelDegerler!.guncelBarkod!,
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
