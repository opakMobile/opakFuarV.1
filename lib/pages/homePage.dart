import 'package:flutter/material.dart';
import 'package:opak_fuar/pages/cariIslemlerPage.dart';
import 'package:opak_fuar/raporlar/raporlar.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                // ! Siparis Al
                GestureDetector(
                  onTap: () {
                    //? siparisAlPage
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
                                    Icons.shopping_cart,
                                    size: 70,
                                  ),
                                  Spacer(),
                                  Text('Siparis Al',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                ],
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
                // ! Cari İşlemleri
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CariIslemlerPage()));
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
                                    Icons.search,
                                    size: 70,
                                  ),
                                  Spacer(),
                                  Text('\t\t\tCari\nİşlemleri',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange)),
                                ],
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
                // ! Sepet İşlemleri
                Card(
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
                                  Icons.shopping_basket,
                                  size: 70,
                                ),
                                Spacer(),
                                Text('\t\t\tSepet\nİşlemleri',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green)),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.375,
                                  height: 3,
                                  color: Colors.green,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.375,
                                  height: 3,
                                  color: Colors.grey,
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
                // ! Raporlar
                GestureDetector(
                  onTap: (){
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RaporlarPage()));
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
                                  ),
                                  Spacer(),
                                  Text('Raporlar',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pink)),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.375,
                                    height: 3,
                                    color: Colors.pink,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.375,
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
