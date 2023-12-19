import 'dart:math';
import 'package:flutter/material.dart';
import 'package:opak_fuar/cari/cariDetayPage.dart';
import 'package:opak_fuar/cari/cariFormPage.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';

class CariListePage extends StatefulWidget {
  CariListePage({required this.islem});

  final bool islem;
  @override
  State<CariListePage> createState() => _CariListePageState();
}

class _CariListePageState extends State<CariListePage> {
  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
  }

  List<Map> deneme = [
    {
      "id": "1",
      "name": "Mustafa",
      "surname": "Yüce",
      "bakiye": "1000",
    },
    {
      "id": "2",
      "name": "Turan",
      "surname": "Kaya",
      "bakiye": "2000",
    },
    {
      "id": "1",
      "name": "Mustafa",
      "surname": "Yüce",
      "bakiye": "1000",
    },
    {
      "id": "2",
      "name": "Turan",
      "surname": "Kaya",
      "bakiye": "2000",
    },
    {
      "id": "1",
      "name": "Mustafa",
      "surname": "Yüce",
      "bakiye": "1000",
    },
    {
      "id": "2",
      "name": "Turan",
      "surname": "Kaya",
      "bakiye": "2000",
    },
    {
      "id": "1",
      "name": "Mustafa",
      "surname": "Yüce",
      "bakiye": "1000",
    },
    {
      "id": "2",
      "name": "Turan",
      "surname": "Kaya",
      "bakiye": "2000",
    },
    {
      "id": "1",
      "name": "Mustafa",
      "surname": "Yüce",
      "bakiye": "1000",
    },
    {
      "id": "2",
      "name": "Turan",
      "surname": "Kaya",
      "bakiye": "2000",
    },
    {
      "id": "1",
      "name": "Mustafa",
      "surname": "Yüce",
      "bakiye": "1000",
    },
    {
      "id": "2",
      "name": "Turan",
      "surname": "Kaya",
      "bakiye": "2000",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
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
                    UcCizgi(),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                // ! Search Bar
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
                // ! Cari Listesi
                SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: ListView.builder(
                      itemCount: deneme.length,
                      itemBuilder: (context, index) {
                        String trim = deneme[index]["name"].toString().trim();
                        String harf1 = "";
                        String harf2 = "";
                        harf1 = trim[0];
                        if (trim.length == 1) {
                          harf2 = "K";
                        } else {
                          harf2 = trim[1];
                        }
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
                                deneme[index]["name"].toString(),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child:
                                    Text(deneme[index]["surname"].toString()),
                              ),
                              onTap: () {
                                if (widget.islem) {
                                  // cariye gidecek bilgisine
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CariDetayPage()));
                                } else {
                                  // cari listesine gidecek
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CariFormPage(
                                                yeniKayit: false,
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
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
