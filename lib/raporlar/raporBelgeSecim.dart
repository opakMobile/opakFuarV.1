import 'dart:math';
import 'package:flutter/material.dart';
import 'package:opak_fuar/model/raporModel.dart';

import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';

class RaporBelgeSecim extends StatefulWidget {
  RaporBelgeSecim({required this.baslik,});

  final String baslik;

  @override
  State<RaporBelgeSecim> createState() => _RaporBelgeSecimState();
}

class _RaporBelgeSecimState extends State<RaporBelgeSecim> {
  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
  }

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
                 //   UcCizgi(),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.baslik,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Müşteri Sayısı",
                          style: TextStyle(
                              fontSize: 12,),
                        ),
                        Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  height: MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "47",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                      ],
                    ),
                    Spacer(),
                   Column(
                     children: [
                        Text(
                            "Toplam Satış",
                            style: TextStyle(
                                fontSize: 12,),
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
                  ],
                ),
                // ! Cari Listesi
                SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: ListView.builder(
                      itemCount: listeler.listRapor.length,
                      itemBuilder: (context, index) {
                        RaporModel model = listeler.listRapor[index];
                       
                        String harf1 = Ctanim.cariIlkIkiDon(model.CARIADI!)[0];
                        String harf2 = Ctanim.cariIlkIkiDon(model.CARIADI!)[1];
                     
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
                                model.CARIADI.toString(),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child:
                                    Text(model.IL.toString()),
                              ),
                              onTap: () {
                                
                              },
                              trailing: Container(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  height: MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Center(
                                      child: TextButton(
                                    onPressed: () {},
                                   child: Text("İncele",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold)),
                                  )),
                                ),
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
