import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opak_fuar/cari/cariListePage.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';

import 'cariFormPage.dart';

class CariIslemlerPage extends StatefulWidget {
  const CariIslemlerPage({super.key});

  @override
  State<CariIslemlerPage> createState() => _CariIslemlerPageState();
}

class _CariIslemlerPageState extends State<CariIslemlerPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
        bottomNavigationBar: bottombarDizayn(context),
        resizeToAvoidBottomInset: false,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //  UcCizgi(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  // ! Cari Listesi
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CariListePage(
                                    islem: false,
                                  )));
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.17,
                      child: Card(
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 3,
                        child: Container(
                          
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05,
                                right: MediaQuery.of(context).size.width * 0.05,
                                top: MediaQuery.of(context).size.height * 0.01,
                                bottom: MediaQuery.of(context).size.height * 0.01,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size: MediaQuery.of(context).size.height * 0.09,
                                        color: Colors.orange,
                                      ),
                                      Spacer(),
                                      Text(
                                        'Cari Listesi',
                                        maxLines: 2,
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.doppioOne(
                                          fontSize: MediaQuery.of(context).size.height * 0.035,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * 0.03,
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
                  ),
                  // ! Cari Bilgi Raporu
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CariListePage(
                                    islem: true,
                                  )));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 3,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.17,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05,
                              top: MediaQuery.of(context).size.height * 0.01,
                              bottom: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.receipt_long,
                                   size: MediaQuery.of(context).size.height * 0.09,
                                      color: Colors.pink,
                                    ),
                                    Spacer(),
                                    Text(
                                      'Cari Bilgi Raporu',
                                      maxLines: 2,
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.doppioOne(
                                        fontSize: MediaQuery.of(context).size.height * 0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
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
                  // ! Yeni Cari Ekle
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CariFormPage(
                                    yeniKayit: true,
                                  )));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 3,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.17,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05,
                              top: MediaQuery.of(context).size.height * 0.01,
                              bottom: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_add_alt_1_sharp,
                                    size: MediaQuery.of(context).size.height * 0.09,
                                      color: Colors.blue,
                                    ),
                                    Spacer(),
                                    Text(
                                      'Yeni Cari Ekle',
                                      maxLines: 2,
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.doppioOne(
                                        fontSize:MediaQuery.of(context).size.height * 0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
