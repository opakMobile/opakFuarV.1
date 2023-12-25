import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opak_fuar/cari/cariIslemlerPage.dart';
import 'package:opak_fuar/pages/LoadingSpinner.dart';
import 'package:opak_fuar/raporlar/raporlar.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/siparis/siparisCariList.dart';
import 'package:opak_fuar/webServis/base.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BaseService bs = BaseService();

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
            child: Column(
              children: [
                //    UcCizgi(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                // ! Siparis Al
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SiparisCariList(
                                  islem: false,
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
                                    Icons.shopping_cart,
                                    size: 55,
                                  ),
                                  Spacer(),
                                  Text('Sipariş Al',
                                      style: GoogleFonts.doppioOne(
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
                                    size: 55,
                                  ),
                                  Spacer(),
                                  Text('Cari İşlemleri',
                                      style: GoogleFonts.doppioOne(
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SiparisCariList(
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
                                    size: 55,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Sepet İşlemleri',
                                    style: GoogleFonts.doppioOne(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
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
                // ! Raporlar
                GestureDetector(
                  onTap: () {
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
                                    size: 55,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Raporlar',
                                    style: GoogleFonts.doppioOne(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ],
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
                // ! Verileri Güncelle
                GestureDetector(
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) => Center(
                              child: verilerGuncelle(bs: bs),
                            ));
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
                                    Icons.update,
                                    size: 55,
                                  ),
                                  Spacer(),
                                  Text(
                                    'Verileri Güncelle',
                                    style: GoogleFonts.doppioOne(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                    /* TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber),*/
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.375,
                                    height: 3,
                                    color: Colors.amber,
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

class verilerGuncelle extends StatelessWidget {
  const verilerGuncelle({
    super.key,
    required this.bs,
  });

  final BaseService bs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07,
            top: MediaQuery.of(context).size.height * 0.01,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //!!!!!!!!!!!!!!!!!!!!!!!! stok miktar ve bakiye güncelleme
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Verileri Güncelle",
                        style: GoogleFonts.lato(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    Spacer(),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return LoadingSpinner(
                            color: Colors.black,
                            message:
                                "Tüm Veriler Güncelleniyor. Lütfen Bekleyiniz...",
                          );
                        },
                      );

                      await bs.tumVerileriGuncelle();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.update,
                          size: 30,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          "Tüm Verileri Güncelle",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return LoadingSpinner(
                            color: Colors.black,
                            message:
                                "Cari Veriler Güncelleniyor. Lütfen Bekleyiniz...",
                          );
                        },
                      );
                      await bs.cariVerileriGuncelle();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_upload_outlined,
                          size: 30,
                          color: Colors.pink,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text("Sadece Cari Verileri Güncelle",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            )),
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return LoadingSpinner(
                            color: Colors.black,
                            message:
                                "Stok Veriler Güncelleniyor. Lütfen Bekleyiniz...",
                          );
                        },
                      );
                      await bs.stokVerileriGuncelle();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_upload,
                          size: 30,
                          color: Colors.orange,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text("Sadece Stok Verileri Güncelle",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            )),
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.wifi_protected_setup_outlined,
                          size: 30,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Expanded(
                          child: Text("Stok Miktarı ve Bakiye Güncelleme",
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.update,
                          size: 30,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text("Sabit Parametreleri Güncelle",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            )),
                      ],
                    )),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.backup,
                          size: 30,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text("Kaydedilen Verileri Gönder",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            )),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
