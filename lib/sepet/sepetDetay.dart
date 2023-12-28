import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/siparis/fisHareketDuzenle.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../model/cariModel.dart';
import '../model/stokKartModel.dart';
import '../sabitler/sabitmodel.dart';

class SepetDetay extends StatefulWidget {
  SepetDetay({required this.cari});

  late Cari cari;

  @override
  State<SepetDetay> createState() => _SepetDetayState();
}

class _SepetDetayState extends State<SepetDetay> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Fis.empty().fisEkle(fis: fisEx.fis!.value!, belgeTipi: "YOK");
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
                onPressed: () {
                  Fis.empty().fisEkle(fis: fisEx.fis!.value!, belgeTipi: "YOK");
                },
                child: Text(
                  "Siparişi Yazdır",
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

                            ///!!!!! buraaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                            /*     setState(() {
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
                  Padding(
                    padding: const EdgeInsets.all(5.0),
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
                  Divider(
                    thickness: 1.5,
                    color: Colors.black87,
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        itemCount: fisEx.fis!.value!.fisStokListesi.length,
                        itemBuilder: (context, index) {
                          FisHareket stokModel =
                              fisEx.fis!.value!.fisStokListesi[index];
                              
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.19,
                                    child: Card(
                                      elevation: 10,
                                      child: TextButton(
                                          onPressed: () {
                                            //alt hesap
                                            double gelenMiktar = double.parse(
                                                stokModel.MIKTAR.toString());
                                            List<StokKart> stok = listeler
                                                .listStok
                                                .where((stok) =>
                                                    stok.KOD! ==
                                                    stokModel.STOKKOD)
                                                .toList();
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return fisHareketDuzenle(
                                                    altHesap:
                                                        stokModel.ALTHESAP!,
                                                    gelenStokKart: stok.first,
                                                    gelenMiktar: gelenMiktar,
                                                    fiyat: stokModel.NETFIYAT!,
                                                    isk1: stokModel.ISK!,
                                                  );
                                                }).then((value) {
                                              setState(() {
                                                Ctanim.genelToplamHesapla(
                                                    fisEx);
                                              });
                                            });
                                          },
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
                                            border:
                                                Border.all(color: Colors.grey),
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
                                          "M.Fazlası",
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
                                            border:
                                                Border.all(color: Colors.grey),
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
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Center(
                                              child: Text(
                                            stokModel.MIKTAR!
                                                .toStringAsFixed(2),
                                          )),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("Birim",
                                            style: TextStyle(fontSize: 13)),
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
                                            border:
                                                Border.all(color: Colors.grey),
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
                                        Text("Fiyat",
                                            style: TextStyle(fontSize: 13)),
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
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: Center(
                                            child: Text(
                                              stokModel.BRUTFIYAT!
                                                  .toStringAsFixed(2),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.19,
                                      child: Card(
                                        elevation: 10,
                                        child: TextButton(
                                            onPressed: () {
                                              fisEx.fis?.value.altHesapToplamlar
                                                  .removeWhere((item) {
                                                String a = "";
                                                for (var element
                                                    in item.STOKKODLIST!) {
                                                  if (element ==
                                                      stokModel.STOKKOD) {
                                                    a = element;
                                                  }
                                                }

                                                return a == stokModel.STOKKOD!;
                                              });
                                              fisEx.fis?.value.fisStokListesi
                                                  .removeWhere((item) =>
                                                      item.STOKKOD ==
                                                      stokModel.STOKKOD!);
                                                      setState(() {
                                                        
                                                      });
                                            },
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
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Toplam: ",
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.orange),
                                        ),
                                        Text(
                                          stokModel.BRUTTOPLAMFIYAT!
                                              .toStringAsFixed(2),
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
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.orange),
                                        ),
                                        Text(
                                          stokModel.ISKONTOTOPLAM!
                                              .toStringAsFixed(2),
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
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.orange),
                                        ),
                                        Text(
                                          stokModel.KDVTOPLAM!
                                              .toStringAsFixed(2),
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
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.orange),
                                        ),
                                        Text(
                                          stokModel.KDVDAHILNETTOPLAM!
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
