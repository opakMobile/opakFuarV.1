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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                          height: MediaQuery.of(context).size.height * 0.12,
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
                                      Icons.shopping_cart,
                                      size: MediaQuery.of(context).size.height *
                                          0.09,
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
                          height: MediaQuery.of(context).size.height * 0.12,
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
                                      size: MediaQuery.of(context).size.height *
                                          0.09,
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
                          height: MediaQuery.of(context).size.height * 0.12,
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
                                      Icons.shopping_basket,
                                      size:MediaQuery.of(context).size.height *
                                          0.09,
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
                          height: MediaQuery.of(context).size.height * 0.12,
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
                                      size: MediaQuery.of(context).size.height *
                                          0.09,
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
                          height: MediaQuery.of(context).size.height * 0.12,
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
                                      Icons.update,
                                      size: MediaQuery.of(context).size.height *
                                          0.09,
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
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
            top: MediaQuery.of(context).size.height * 0.01,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //!!!!!!!!!!!!!!!!!!!!!!!! stok miktar ve bakiye güncelleme
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            "Verileri Güncelle",
                            style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          ),
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
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
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
                            
                           
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Tüm Verileri Güncelle",
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
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
                     
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Sadece Cari Verileri Güncelle",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
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
                           
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Sadece Stok Verileri Güncelle",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.wifi_protected_setup_outlined,
                              size: 30,
                              color: Colors.blue,
                            ),
                           
                            Padding(
                              padding:  EdgeInsets.only(left: 8),
                              child: Text("Stok Miktarı ve Bakiye Güncelleme",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.update,
                              size: 30,
                              color: Colors.amber,
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Sabit Parametreleri Güncelle",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        )),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              Icons.backup,
                              size: 30,
                              color: Colors.red,
                            ),
                           
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Kaydedilen Verileri Gönder",
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
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
