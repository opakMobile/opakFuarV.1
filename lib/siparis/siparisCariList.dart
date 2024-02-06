import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:opak_fuar/controller/fisController.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/model/satisTipiModel.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/pages/ver%C4%B1GondermeHataDiyalog.dart';
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
                Row(
                  children: [
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
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Center(
                        child: Text(
                          "Fuar : " + Ctanim.kullanici!.FUARADI!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cari.ADRES!.toString(),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            cari.IL! + " / " + cari.ILCE!,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    )),
                                onTap: () async {
                                  if (widget.islem) {
                                    List<String> altListeCari =
                                        cari.ALTHESAPLAR!.split(",");
                                    List<String> altListeFis = fisEx
                                        .fis!.value.cariKart.ALTHESAPLAR!
                                        .split(",");
                                    List<int> olmayanlar = [];

                                    for (var el in altListeFis) {
                                      bool varMi = altListeCari
                                          .any((elele) => elele == el);
                                      if (varMi == true ) {
                                        print("Var" + el);
                                      } else{
                                        String altHesapAdi = "";
                                        for(var element2 in listeler.listCariAltHesap){
                                          if(element2.ALTHESAPID.toString() == el){
                                            altHesapAdi = element2.ALTHESAP!;
                                          }
                                        }
                                        List<FisHareket> opala = fisEx.fis!.value.fisStokListesi.where((element) => element.ALTHESAP == altHesapAdi).toList();
                                        if(opala.isNotEmpty){
                                          olmayanlar.add(int.parse(el));
                                        }
                                        
                                      }
                                    }
                                    if (olmayanlar.isNotEmpty) {
                                      String hataTopla = "";
                                      for (var element in olmayanlar) {
                                        for (var elemnt
                                            in listeler.listCariAltHesap) {
                                          if (elemnt.ALTHESAPID == element) {
                                            hataTopla +=
                                                elemnt.ALTHESAP! + "\n";
                                          }
                                        }
                                      }
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return VeriGondermeHataDialog(
                                              align: TextAlign.left,
                                              title: 'Hata',
                                              message:
                                                  'Değiştirlimek istenilen cari alt hesapları ile siparişin alt hesapları uyuşmuyor.\nSeçilen caride bulunmayan alt hesaplar:\n' +
                                                      hataTopla,
                                              onPres: () async {
                                                Navigator.pop(context);
                                              },
                                              buttonText: 'Tamam',
                                            );
                                          });
                                    }else{
                                  
                                      fisEx.fis!.value.CARIKOD = cari.KOD;
                                      fisEx.fis!.value.CARIADI = cari.ADI;
                                      List<CariAltHesap> altHesaplar = [];
                                      for (var element in listeler.listCariAltHesap) {
                                        if (altListeCari.contains(element.ALTHESAPID.toString())) {
                                          altHesaplar.add(element);
                                        }
                                      }
                                      for(var element in fisEx.fis!.value.fisStokListesi){
                                        List<CariAltHesap> altHesaplar2 = listeler.listCariAltHesap.where((element2) => element2.ALTHESAP == element.ALTHESAP).toList();
                                        altHesapDegistirFiseEkle(element, altHesaplar2.first);
                                      }   
                                       fisEx.fis!.value.cariKart.cariAltHesaplar.clear();
                                      fisEx.fis!.value.cariKart.cariAltHesaplar = altHesaplar;
                                   
                                      Fis.empty().fisEkle(fis: fisEx.fis!.value, belgeTipi: "YOK");
                                      Navigator.pop(context);
                                    }

                            
                                   
                                  
                                  } else {
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
                                          cari.cariAltHesaplar.add(elemnt);
                                          vs = elemnt;
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
                                    fisEx.fis!.value.DEPOID = int.parse(
                                        Ctanim.kullanici!.YERELDEPOID!); //TODO
                                    fisEx.fis!.value.ISLEMTIPI = "0";
                                    fisEx.fis!.value.ALTHESAP = vs != null
                                        ? vs.ALTHESAP
                                        : cari.cariAltHesaplar.first.ALTHESAP;
                                    fisEx.fis!.value.FUARADI =
                                        Ctanim.kullanici!.FUARADI;
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
                                                  sepettenMiGeldin: false,
                                                  varsayilan: vs != null
                                                      ? vs
                                                      : cari.cariAltHesaplar
                                                          .first,
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
    void altHesapDegistirFiseEkle(FisHareket element,CariAltHesap seciliAltHesap) {
    List<StokKart> stok = [];
    bool barkodMu = false;
    for (var el in stokKartEx.searchList) {
      if (el.KOD == element.STOKKOD) {
        stok.add(el);
      } else if (el.BARKOD1 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN1! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN1!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD1!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT1! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD1!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT1;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK1;
               stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      } else if (el.BARKOD2 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN2! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN2!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD2!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT2! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD2!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT2;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK2;
               stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      } else if (el.BARKOD3 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN3! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN3!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD3!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT3! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD3!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT3;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK3;
               stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      } else if (el.BARKOD4 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN4! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN4!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD4!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT4! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD4!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT4;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK4;
               stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      } else if (el.BARKOD5 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN5! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN5!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD5!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT5! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD5!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT5;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK5;
               stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      } else if (el.BARKOD6 == element.STOKKOD) {
        stok.add(el);
        barkodMu = true;
        if (stok.first.BARKODCARPAN6! > 0) {
          stok.first.guncelDegerler!.carpan = stok.first.BARKODCARPAN6!;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD6!;
        } else {
          stok.first.guncelDegerler!.carpan = 1.0;
          stok.first.guncelDegerler!.guncelBarkod = stok.first.KOD!;
        }
        if (stok.first.BARKODFIYAT6! > 0) {
          stok.first.guncelDegerler!.guncelBarkod = stok.first.BARKOD6!;
          stok.first.guncelDegerler!.fiyat = stok.first.BARKODFIYAT6;
          stok.first.guncelDegerler!.iskonto1 = stok.first.BARKODISK6;
          stok.first.guncelDegerler!.iskonto2 = 0;
          stok.first.guncelDegerler!.iskonto3 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto4 = 0;
          stok.first.guncelDegerler!.iskonto5 = 0;
          stok.first.guncelDegerler!.iskonto6 = 0;
          stok.first.guncelDegerler!.seciliFiyati = "Barkod"; // hata verebilir
          stok.first.guncelDegerler!.fiyatDegistirMi = false;
          stok.first.guncelDegerler!.netfiyat =
              stok.first.guncelDegerler!.hesaplaNetFiyat();
          if (!Ctanim.fiyatListesiKosul
              .contains(stok.first.guncelDegerler!.seciliFiyati)) {
            Ctanim.fiyatListesiKosul
                .add(stok.first.guncelDegerler!.seciliFiyati!);
          }
        }
      }
    }
    if (stok.isEmpty) {
      listeler.listDahaFazlaBarkod
          .where((dahaFazla) => dahaFazla.KOD == element.STOKKOD);
    }
  if(barkodMu == false){
        SatisTipiModel satisTipiModel =
        SatisTipiModel(ID: -1, TIP: "a", FIYATTIP: "", ISK1: "", ISK2: "");

    List<dynamic> gelenFiyatVeIskonto = stokKartEx.fiyatgetir(
        stok.first,
        fisEx.fis!.value.CARIKOD!,
        Ctanim.satisFiyatListesi.first,
        satisTipiModel,
        Ctanim.seciliStokFiyatListesi,
        seciliAltHesap!.ALTHESAPID);

    stok.first.guncelDegerler!.guncelBarkod = element.STOKKOD;
    stok.first.guncelDegerler!.carpan = 1;
    stok.first.guncelDegerler!.fiyat =
        double.parse(gelenFiyatVeIskonto[0].toString());

    stok.first.guncelDegerler!.iskonto1 =
        double.parse(gelenFiyatVeIskonto[1].toString());

    stok.first.guncelDegerler!.iskonto2 =
        double.parse(gelenFiyatVeIskonto[4].toString());

    stok.first.guncelDegerler!.iskonto3 =
        double.parse(gelenFiyatVeIskonto[5].toString());

    stok.first.guncelDegerler!.iskonto4 =
        double.parse(gelenFiyatVeIskonto[6].toString());

    stok.first.guncelDegerler!.iskonto5 =
        double.parse(gelenFiyatVeIskonto[7].toString());

    stok.first.guncelDegerler!.iskonto6 =
        double.parse(gelenFiyatVeIskonto[8].toString());

    stok.first.guncelDegerler!.seciliFiyati = gelenFiyatVeIskonto[2].toString();
    stok.first.guncelDegerler!.fiyatDegistirMi = gelenFiyatVeIskonto[3];

    stok.first.guncelDegerler!.netfiyat =
        stok.first.guncelDegerler!.hesaplaNetFiyat();
    //fiyat listesi koşul arama fonksiyonua gönderiliyor orda ekleme yapsanda buraya eklemez giyatListesiKosulu cTanima ekle !
    if (!Ctanim.fiyatListesiKosul
        .contains(stok.first.guncelDegerler!.seciliFiyati)) {
      Ctanim.fiyatListesiKosul.add(stok.first.guncelDegerler!.seciliFiyati!);
    }


  }

    double tempFiyat = 0;

    tempFiyat = stok.first.guncelDegerler!.fiyat!;

    double KDVTUtarTemp =
        stok.first.guncelDegerler!.fiyat! * (1 + (stok.first.SATIS_KDV!));

    //  fisEx.fis!.value.fisStokListesi.remove(element);

    fisEx.fiseStokEkle(
      // belgeTipi: widget.belgeTipi,
      altHesapDegistirMi: true,
      malFazlasi: element.MALFAZLASI,
      ALTHESAP: seciliAltHesap!.ALTHESAP!,
      urunListedenMiGeldin: true,
      stokAdi: stok.first.ADI!,
      KDVOrani: double.parse(stok.first.SATIS_KDV.toString()),
      birim: element.BIRIM!,
      birimID: 1,
      dovizAdi: stok.first.ACIKLAMA!,
      dovizId: stok.first.ID!,
      burutFiyat: tempFiyat,
      iskonto: stok.first.guncelDegerler!.iskonto1!,
      iskonto2: stok.first.guncelDegerler!.iskonto2!,
      iskonto3: stok.first.guncelDegerler!.iskonto3!,
      iskonto4: stok.first.guncelDegerler!.iskonto4!,
      iskonto5: stok.first.guncelDegerler!.iskonto5!,
      iskonto6: stok.first.guncelDegerler!.iskonto6!,
      miktar: element.MIKTAR!,
      stokKodu: stok.first.guncelDegerler!.guncelBarkod!,
      Aciklama1: '',
      KUR: element.KUR!,
      TARIH: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      UUID: fisEx.fis!.value.UUID!,
    );
  }
}
