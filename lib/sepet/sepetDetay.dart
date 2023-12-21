import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import '../model/stokKartModel.dart';
import '../sabitler/sabitmodel.dart';

class SepetDetay extends StatefulWidget {
  const SepetDetay({super.key});

  @override
  State<SepetDetay> createState() => _SepetDetayState();
}

class _SepetDetayState extends State<SepetDetay> {
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
                onPressed: () {},
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
                    alignment: Alignment.topRight,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.05,
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
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Ömer Akkaya Dağıtım Matbaa Kırtasiye Gıda San. Tic. Ltd. Şti.',
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
                        itemCount: listeler.listStok.length,
                        itemBuilder: (context, index) {
                          StokKart stokModel = listeler.listStok[index];
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
                                            stokModel.ADI!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      Text(stokModel.KOD! +
                                          "  " +
                                          "KDV " +
                                          stokModel.SATIS_KDV.toString()),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.19,
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
                                            child: Text("1"),
                                          ),
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
                                              stokModel.OLCUBIRIM1!,
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
                                              stokModel.SFIYAT1!
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Toplam: ",
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.orange),
                                      ),
                                      Text(
                                        stokModel.SFIYAT1!.toStringAsFixed(2),
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
                                            fontSize: 11, color: Colors.orange),
                                      ),
                                      Text(
                                        stokModel.SFIYAT1!.toStringAsFixed(2),
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
                                            fontSize: 11, color: Colors.orange),
                                      ),
                                      Text(
                                        stokModel.SATIS_KDV!.toStringAsFixed(2),
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
                                            fontSize: 11, color: Colors.orange),
                                      ),
                                      Text(
                                        stokModel.SFIYAT1!.toStringAsFixed(2),
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
