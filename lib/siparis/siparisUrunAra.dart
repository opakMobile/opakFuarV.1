import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opak_fuar/model/stokModel.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/siparis/siparisTamamla.dart';

class SiparisUrunAra extends StatefulWidget {
  const SiparisUrunAra({super.key});

  @override
  State<SiparisUrunAra> createState() => _SiparisUrunAraState();
}

class _SiparisUrunAraState extends State<SiparisUrunAra> {
  bool aramaModu = true;
  bool okumaModu = false;
  String seciliAltHesap = "Peşin";
  List<String> altHesaplar = [
    "Peşin",
    "Nakit",
    "Kredi Kartı",
    "Sezon",
    "Ara Ödeme"
  ];

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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SiparisTamamla()));
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios),
                        ),
                      )
                    ],
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.05,
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
                  Divider(
                    thickness: 1.5,
                    color: Colors.black87,
                  ),
                  okumaModu == true
                      ? SingleChildScrollView(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.builder(
                              itemCount: Listeler.StokModelListesi.length,
                              itemBuilder: (context, index) {
                                StokModel stokModel =
                                    Listeler.StokModelListesi[index];
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
                                            Text(stokModel.stokAdi),
                                            Text(stokModel.stokBarkodu +
                                                "  " +
                                                "KDV " +
                                                stokModel.kdv.toString()),
                                          ],
                                        ),
                                        Card(
                                          elevation: 10,
                                          child: TextButton.icon(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.recycling,
                                                size: 12,
                                                color: Colors.blue,
                                              ),
                                              label: Text(
                                                "Değiştir",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  color: Colors.blue,
                                                ),
                                              )),
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
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    stokModel.iskonto
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
                                                    stokModel.malFazlasi
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
                                                  child: Text(
                                                    stokModel.miktar
                                                        .toStringAsFixed(2),
                                                  ),
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
                                                    stokModel.birim,
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
                                                    stokModel.fiyat
                                                        .toStringAsFixed(2),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Card(
                                            elevation: 10,
                                            child: TextButton.icon(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.delete,
                                                  size: 12,
                                                  color: Colors.red,
                                                ),
                                                label: Text(
                                                  "Sil",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.red,
                                                  ),
                                                )),
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
                                                  fontSize: 11,
                                                  color: Colors.orange),
                                            ),
                                            Text(
                                              stokModel.fiyat
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
                                              stokModel.fiyat
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
                                              stokModel.fiyat
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
                                              stokModel.fiyat
                                                  .toStringAsFixed(2),
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
                      : SingleChildScrollView(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.builder(
                              itemCount: Listeler.StokModelListesi.length,
                              itemBuilder: (context, index) {
                                StokModel stokModel =
                                    Listeler.StokModelListesi[index];

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
                                            Text(stokModel.stokAdi),
                                            Text(stokModel.stokBarkodu +
                                                "  " +
                                                "KDV " +
                                                stokModel.kdv.toString()),
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
                                            child: TextFormField(
                                              autocorrect: true,
                                              //controller: t1,
                                              onEditingComplete: () {},

                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: "1",
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
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
                                                    stokModel.iskonto
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
                                                    stokModel.malFazlasi
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
                                                  child: Text(
                                                    stokModel.miktar
                                                        .toStringAsFixed(2),
                                                  ),
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
                                                    stokModel.birim,
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
                                                    stokModel.fiyat
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
                                              onPressed: () {},
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
