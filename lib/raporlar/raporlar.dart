import 'package:flutter/material.dart';
import 'package:opak_fuar/pages/cariListePage.dart';
import 'package:opak_fuar/raporlar/raporBelgeSecim.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';



class RaporlarPage extends StatefulWidget {
  const RaporlarPage({super.key});

  @override
  State<RaporlarPage> createState() => _RaporlarPageState();
}

class _RaporlarPageState extends State<RaporlarPage> {
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
            child: Column(
              children: [
                UcCizgi(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                // ! Cari Listesi
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RaporBelgeSecim(
                                  baslik: "Plasiyer Satış Raporu",
                                )));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.13,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                      Icons.receipt_long,
                                    size: 70,
                                    color: Colors.blue,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Plasiyer Satış Raporu',
                                        maxLines: 2,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.375,
                                    height: 3,
                                    color: Colors.blue,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.375,
                                    height: 3,
                                    color: Colors.grey,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                // ! Cari Bilgi Raporu
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RaporBelgeSecim(
                                  baslik: "Bayi Satış Raporu",
                                )));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.13,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 70,
                                    color: Colors.green,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Bayi Satış Raporu',
                                      maxLines: 2,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                  MediaQuery.of(context).size.height * 0.01,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.375,
                                    height: 3,
                                    color: Colors.green,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.375,
                                    height: 3,
                                    color: Colors.grey,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                // ! Yeni Cari Ekle
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RaporBelgeSecim(
                                  baslik: "Alıcı Satış Raporu",
                                )));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.13,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                     Icons.receipt_long,
                                    size: 70,
                                    color: Colors.orange,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Alıcı Satış Raporu',
                                    maxLines: 2,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.375,
                                    height: 3,
                                    color: Colors.orange,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.375,
                                    height: 3,
                                    color: Colors.grey,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                 GestureDetector(
                  onTap: () {
                   Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RaporBelgeSecim(
                                  baslik: "Stok Satış Raporu",
                                )));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.13,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                     Icons.receipt_long,
                                    size: 70,
                                    color: Colors.pink,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Stok Satış Raporu',
                                    maxLines: 2,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                   MediaQuery.of(context).size.height * 0.01,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.375,
                                    height: 3,
                                    color: Colors.pink,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.375,
                                    height: 3,
                                    color: Colors.grey,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
