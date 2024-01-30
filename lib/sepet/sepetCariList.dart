import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/model/ShataModel.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/pages/LoadingSpinner.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/sepet/sepetDetay.dart';
import 'package:opak_fuar/siparis/PdfOnizleme.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';
import 'package:opak_fuar/webServis/base.dart';
import 'package:uuid/uuid.dart';
import '../db/veriTabaniIslemleri.dart';
import '../model/cariModel.dart';
import '../pages/CustomAlertDialog.dart';
import '../pages/verıGondermeHataDiyalog.dart';
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
  //List<Fis> gonderilecekFis = [];
  //List<bool> gonderilecekFisDurum = [];

  void cariAra(String query) {
    if (query.isEmpty) {
      tempFis.clear();
      for (var element in fisEx.list_tum_fis) {
        if (element.AKTARILDIMI == localAktarildiMi) {
          tempFis.add(element);
        }
      }
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
                        .contains(query.toLowerCase()) ||
                    value.cariKart.IL!
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    value.cariKart.ILCE!
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
                        .contains(query.toLowerCase()) ||
                    value.cariKart.IL!
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    value.cariKart.ILCE!
                        .toLowerCase()
                        .contains(query.toLowerCase())) &&
                value.cariKart.AKTARILDIMI == localAktarildiMi)
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
                        .contains(query.toLowerCase()) ||
                    value.cariKart.IL!
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    value.cariKart.ILCE!
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
                        .contains(query.toLowerCase()) ||
                    value.cariKart.IL!
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    value.cariKart.ILCE!
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

  BaseService bs = BaseService();
  bool localAktarildiMi = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // Gönderilecek fişleri gönder butonu
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await seciliFisGonder(
                context,
                tempFis
                    .where((element) => element.seciliFisGonder == true)
                    .toList());
          },
          child: Icon(Icons.send),
        ),
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
                localAktarildiMi == false
                    ? Text(
                        "Siparişi silmek için uzun basınız",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontStyle: FontStyle.italic),
                      )
                    : Container(),
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
                                      leading: tempFis[index].AKTARILDIMI ==
                                              true
                                          ? CircleAvatar(
                                              backgroundColor: randomColor(),
                                              child: Text(
                                                harf1 + harf2,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )
                                          : Checkbox(
                                              value: tempFis[index]
                                                  .seciliFisGonder,
                                              onChanged: (value) {
                                                setState(() {
                                                  tempFis[index]
                                                      .seciliFisGonder = value!;
                                                });
                                              },
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  child: Text(
                                                    cari.ADRES!.toString() ??
                                                        "",
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                widget.islem == true
                                                    ? Text(
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                          print(fisEx.fis!.value.TIP);
                                          Ctanim.genelToplamHesapla(fisEx);
                                          CariAltHesap? vs;
                                          cari.cariAltHesaplar.clear();
                                          List<String> altListe =
                                              cari.ALTHESAPLAR!.split(",");
                                          for (var elemnt
                                              in listeler.listCariAltHesap) {
                                            if (altListe.contains(
                                                elemnt.ALTHESAPID.toString())) {
                                              cari.cariAltHesaplar.add(elemnt);
                                            }
                                            if (elemnt.ZORUNLU == "E" &&
                                                elemnt.VARSAYILAN == "E") {
                                              vs = elemnt;
                                            }
                                          }
                                          if (cari.cariAltHesaplar.isEmpty) {
                                            for (var elemnt
                                                in listeler.listCariAltHesap) {
                                              if (elemnt.ZORUNLU == "E" &&
                                                  elemnt.VARSAYILAN == "E") {
                                                cari.cariAltHesaplar
                                                    .add(elemnt);
                                              }
                                            }
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SiparisUrunAra(
                                                        sepettenMiGeldin: true,
                                                        varsayilan: vs != null
                                                            ? vs
                                                            : cari
                                                                .cariAltHesaplar
                                                                .first,
                                                        cari: cari,
                                                      ))).then((value) {
                                            /*
                                                  fisEx.list_tum_fis.clear();
                                                    await  fisEx
                                                        .listTumFisleriGetir();
                                                        tempFis.clear();
                                                    for (var element
                                                        in fisEx.list_tum_fis) {
                                                      if (element.AKTARILDIMI ==
                                                          localAktarildiMi) {
                                                        tempFis.add(element);
                                                      }
                                                    }
                                                    */
                                            setState(() {});
                                          });
                                        } else {
                                          DateTime date =
                                              DateFormat("yyyy-MM-dd")
                                                  .parse(tempFis[index].TARIH!);

                                          DateTime now = DateTime.now();

                                          int differenceInDays =
                                              now.difference(date).inDays;
                                          if (differenceInDays < 1) {
                                            fisEx.fis!.value = tempFis[index];
                                            Ctanim.genelToplamHesapla(fisEx);
                                            CariAltHesap? vs;
                                            cari.cariAltHesaplar.clear();
                                            List<String> altListe =
                                                cari.ALTHESAPLAR!.split(",");
                                            for (var elemnt
                                                in listeler.listCariAltHesap) {
                                              if (altListe.contains(elemnt
                                                  .ALTHESAPID
                                                  .toString())) {
                                                cari.cariAltHesaplar
                                                    .add(elemnt);
                                              }
                                              if (elemnt.ZORUNLU == "E" &&
                                                  elemnt.VARSAYILAN == "E") {
                                                vs = elemnt;
                                              }
                                            }
                                            if (cari.cariAltHesaplar.isEmpty) {
                                              for (var elemnt in listeler
                                                  .listCariAltHesap) {
                                                if (elemnt.ZORUNLU == "E" &&
                                                    elemnt.VARSAYILAN == "E") {
                                                  cari.cariAltHesaplar
                                                      .add(elemnt);
                                                }
                                              }
                                            }
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SiparisUrunAra(
                                                          sepettenMiGeldin:
                                                              true,
                                                          varsayilan: vs != null
                                                              ? vs
                                                              : cari
                                                                  .cariAltHesaplar
                                                                  .first,
                                                          cari: cari,
                                                        )));
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomAlertDialog(
                                                    pdfSimgesi: false,
                                                    align: TextAlign.left,
                                                    title: 'Uyarı',
                                                    onSecondPress: () async {
                                                      List<Fis> pdfeGidecek =
                                                          parcalaFis(
                                                              tempFis[index]);

                                                      // ha bura
                                                      bool internet = true;

                                                      if (await Connectivity()
                                                              .checkConnectivity() ==
                                                          ConnectivityResult
                                                              .none) {
                                                        internet = false;
                                                      }

                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    PdfOnizleme(
                                                                      m: pdfeGidecek,
                                                                      fastReporttanMiGelsin:
                                                                          internet,
                                                                    )),
                                                      );
                                                    },
                                                    secondButtonText:
                                                        "PDF Görüntüle",
                                                    message:
                                                        'Bu sipariş opağa aktarılmış. Düzenleme yapılamaz. PDF görüntülemek ister misiniz?',
                                                    onPres: () async {
                                                      Navigator.pop(context);
                                                    },
                                                    buttonText: 'Geri',
                                                  );
                                                });
                                          }

                                          /*
                                              
                                              */
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

  Future<void> seciliFisGonder(
      BuildContext context, List<Fis> gonderilecekFis) async {
    if (listeler.listCari.any((element) => element.AKTARILDIMI == "H")) {
      await showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              align: TextAlign.left,
              title: 'Uyarı',
              message:
                  'Henüz gönderilmemiş cariler mevcut. Lütfen güncellemeden önce carileri gönderin.',
              onPres: () async {
                Navigator.pop(context);
              },
              buttonText: 'Tamam',
            );
          });
    } else {
      String hataTopla = "";
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingSpinner(
            color: Colors.black,
            message: "Siparişler Gönderiliyor. Lütfen Bekleyiniz...",
          );
        },
      );

      if (gonderilecekFis.length > 0) {
        for (int j = 0; j < gonderilecekFis.length; j++) {
          if (gonderilecekFis[j].ACIKLAMA4 != "" &&
              gonderilecekFis[j].ACIKLAMA5 != "") {
            if (gonderilecekFis[j].fisStokListesi.length > 0) {
              List<String> althesaplar = [];
              for (int i = 0;
                  i < gonderilecekFis[j].fisStokListesi.length;
                  i++) {
                if (!althesaplar
                    .contains(gonderilecekFis[j].fisStokListesi[i].ALTHESAP)) {
                  althesaplar
                      .add(gonderilecekFis[j].fisStokListesi[i].ALTHESAP!);
                }
              }
              List<Fis> parcaliFisler = [];

              for (var element in althesaplar) {
                var uuidx = Uuid();
                String neu = uuidx.v1();

                print("Baba fiş UUID:" + gonderilecekFis[j].UUID!);
                Fis fis = Fis.empty();
                fis = Fis.fromFis(gonderilecekFis[j], []);
                fis.USTUUID = fis.UUID;
                fis.UUID = neu;
                print("Yavru fiş USTUUID:" + fis.USTUUID!);
                print("Yavru fiş UUID:" + fis.UUID!);
                fis.SIPARISSAYISI = althesaplar.length;
                fis.KALEMSAYISI = 0;
                fis.ALTHESAP = element;

                for (int k = 0;
                    k < gonderilecekFis[j].fisStokListesi.length;
                    k++) {
                  if (gonderilecekFis[j].fisStokListesi[k].ALTHESAP ==
                      element) {
                    // ha bura
                    FisHareket yavruFishareket = FisHareket.fromFishareket(
                        gonderilecekFis[j].fisStokListesi[k]);
                    yavruFishareket.UUID = fis.UUID;
                    print("Baba fişHAR UUID:" +
                        gonderilecekFis[j].fisStokListesi[k].UUID!);
                    print("Yavru fişHAR UUID:" + yavruFishareket.UUID!);

                    fis.fisStokListesi.add(yavruFishareket);
                    fis.KALEMSAYISI = fis.KALEMSAYISI! + 1;
                  }
                }

                parcaliFisler.add(fis);
              }
              gonderilecekFis[j].AKTARILDIMI = true;

              Fis.empty().fisEkle(belgeTipi: "YOK", fis: gonderilecekFis[j]);
              print("E YAPILAN FİŞ:" +
                  gonderilecekFis[j].CARIADI! +
                  "//" +
                  gonderilecekFis[j].fisStokListesi.length.toString());
              String genelHata = "";
              List<Map<String, dynamic>> jsonListesi = [];
              for (var element in parcaliFisler) {
                jsonListesi.add(element.toJson2());
              }
              SHataModel gelenHata = await bs.ekleSiparisFuar(
                  UstUuid: jsonListesi[0]["USTUUID"]!,
                  jsonDataList: jsonListesi,
                  sirket: Ctanim.sirket!,
                  pdfMi: "H");

              if (gelenHata.Hata == "true") {
                genelHata += gelenHata.HataMesaj!;
              }
              if (genelHata != "") {
                gonderilecekFis[j].AKTARILDIMI = false;
                Fis.empty().fisEkle(belgeTipi: "YOK", fis: gonderilecekFis[j]);
                print("H YAPILAN FİŞ:" +
                    gonderilecekFis[j].CARIADI! +
                    "//" +
                    gonderilecekFis[j].fisStokListesi.length.toString());

                hataTopla = hataTopla +
                    "\n" +
                    gonderilecekFis[j].CARIADI! +
                    " ait belge gönderilemedi.\n Hata Mesajı :" +
                    genelHata +
                    "\n";
              }
            } else {
              hataTopla = hataTopla +
                  "\n" +
                  gonderilecekFis[j].CARIADI! +
                  " ait " +
                  "belge gönderilemedi.\nHata Mesajı :" +
                  "Fis Stok Listesi Boş\n";
            }
          } else {
            hataTopla = hataTopla +
                "\n" +
                gonderilecekFis[j].CARIADI! +
                " ait " +
                "sipariş gönderilemedi. " +
                "Bayi seçimi yapılmamış\n";
          }
        }

        if (hataTopla != "") {
          Navigator.pop(context);
          bs.printWrapped(hataTopla);
          await showDialog(
              context: context,
              builder: (context) {
                return VeriGondermeHataDialog(
                  align: TextAlign.left,
                  title: 'Hata',
                  message:
                      'Web Servise Veri Gönderilirken Bazı Hatalar İle Karşılaşıldı:\n' +
                          hataTopla,
                  onPres: () async {
                    Navigator.pop(context);
                  },
                  buttonText: 'Tamam',
                );
              });
        } else {
          await showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                  align: TextAlign.left,
                  title: 'İşlem Başarılı',
                  message: 'Siparişler başarıyla gönderildi.',
                  onPres: () async {
                    setState(() {});
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  buttonText: 'Tamam',
                );
              });
        }

        setState(() {});
      } else {
        Navigator.pop(context);
        await showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                align: TextAlign.left,
                title: 'Boş Liste',
                message: 'Seçilmiş Sipariş Yok',
                onPres: () async {
                  Navigator.pop(context);
                },
                buttonText: 'Tamam',
              );
            });
      }
    }
    setState(() {
      tempFis.clear();
      for (var element in fisEx.list_tum_fis) {
        if (element.AKTARILDIMI == localAktarildiMi) {
          tempFis.add(element);
        }
      }
    });
  }

  List<Fis> parcalaFis(Fis fisParam) {
    List<Fis> parcaliFisler = [];
    if (fisParam.fisStokListesi.length > 0) {
      List<String> althesaplar = [];
      for (int i = 0; i < fisParam.fisStokListesi.length; i++) {
        if (!althesaplar.contains(fisParam.fisStokListesi[i].ALTHESAP)) {
          althesaplar.add(fisParam.fisStokListesi[i].ALTHESAP!);
        }
      }
      for (var element in althesaplar) {
        var uuidx = Uuid();
        String neu = uuidx.v1();

        Fis fis = Fis.empty();
        fis = Fis.fromFis(fisParam, []);
        fis.USTUUID = fis.UUID;
        fis.UUID = neu;
        fis.SIPARISSAYISI = althesaplar.length;
        fis.KALEMSAYISI = 0;
        fis.ALTHESAP = element;

        for (int k = 0; k < fisParam.fisStokListesi.length; k++) {
          if (fisParam.fisStokListesi[k].ALTHESAP == element) {
            FisHareket aa =
                FisHareket.fromFishareket(fisParam.fisStokListesi[k]);
            aa.UUID = fis.UUID;

            fis.fisStokListesi.add(aa);
            fis.KALEMSAYISI = fis.KALEMSAYISI! + 1;
          }
        }

        parcaliFisler.add(fis);
      }
    }

    return parcaliFisler;
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
