import 'package:flutter/material.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';

class CariDetayPage extends StatefulWidget {
  const CariDetayPage({super.key});

  @override
  State<CariDetayPage> createState() => _CariDetayPageState();
}

class _CariDetayPageState extends State<CariDetayPage> {
  List<Map> aaa = [
    {
      "id": "1",
      "name": "Mustafa",
      "surname": "Yüce",
      "bakiye": "1000",
      "tarih": "12.12.2021",
    },
    {
      "id": "2",
      "name": "Turan",
      "surname": "Kaya",
      "bakiye": "2000",
      "tarih": "12.12.2021",
    },
    {
      "id": "1",
      "name": "Mustafa",
      "surname": "Yüce",
      "bakiye": "1000",
      "tarih": "12.12.2021",
    },
    {
      "id": "2",
      "name": "Turan",
      "surname": "Kaya",
      "bakiye": "2000",
      "tarih": "12.12.2021",
    },
    {
      "id": "1",
      "name": "Mustafa",
      "surname": "Yüce",
      "bakiye": "1000",
      "tarih": "12.12.2021",
    },
    {
      "id": "2",
      "name": "Turan",
      "surname": "Kaya",
      "bakiye": "2000",
      "tarih": "12.12.2021",
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
      "tarih": "12.12.2021",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
        bottomNavigationBar: bottombarDizayn(context),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
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
              // ! Firma Adı
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
                color: Colors.red,
                child: Center(
                  child: Text(
                    'Firma Adı',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: MediaQuery.of(context).size.height * 0.01),
                child: Column(
                  children: [
                    // ! Sipariş Toplamı
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Sipariş Toplamı",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(
                                  child: Text(
                                "1.566.47,00 TL",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: ListView.builder(
                          itemCount: aaa.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // ! Tarih / Firma
                                Card(
                                  elevation: 3,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.height *
                                        0.09,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0, right: 8.0, top: 8.0),
                                          child: Text(
                                              "Tarih" +
                                                  aaa[index]["tarih"]
                                                      .toString() +
                                                  "Bakiye" +
                                                  aaa[index]["bakiye"]
                                                      .toString() +
                                                  "Ad" +
                                                  aaa[index]["name"]
                                                      .toString() +
                                                  "Soyad" +
                                                  aaa[index]["surname"]
                                                      .toString() +
                                                  "Id" +
                                                  aaa[index]["id"].toString() +
                                                  "dasdasdasdsadasdasdasdasdasdsa",
                                              maxLines: 3,
                                              style: TextStyle(
                                                fontSize: 14,
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 5.0),
                                            child: Text(
                                                aaa[index]["name"].toString()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // ! İncele
                                Card(
                                  elevation: 3,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.09,
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "İncele",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    // ! Sipariş al butonu7
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.save,
                        size: 30,),
                        label: Text("Kaydet",
                        style: TextStyle(
                          fontSize: 20,
                        
                        ),),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
