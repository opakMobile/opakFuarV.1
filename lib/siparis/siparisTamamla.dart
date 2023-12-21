import 'package:flutter/material.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';

class SiparisTamamla extends StatefulWidget {
  const SiparisTamamla({super.key});

  @override
  State<SiparisTamamla> createState() => _SiparisTamamlaState();
}

class _SiparisTamamlaState extends State<SiparisTamamla> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
        bottomNavigationBar: bottombarDizayn(context,
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
            buttonVarMi: true),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.78,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Peşin",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 5.0, top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height: 3,
                                      color: Colors.red,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height: 3,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "K.Kartı",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 5.0, top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height: 3,
                                      color: Colors.blue,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height: 3,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ara Ödeme",
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 5.0, top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height: 3,
                                      color: Colors.green,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height: 3,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sezon",
                                style: TextStyle(
                                  color: Colors.orange,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 5.0, top: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height: 3,
                                      color: Colors.orange,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      height: 3,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //! Cart
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text("Satış Toplamı"),
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
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text("İskonto Toplamı"),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "1.456.568,45 TL",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("KDV Toplamı"),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "1.456.568,45 TL",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text("Sipariş Toplamı"),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            height: MediaQuery.of(context).size.height * 0.05,
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
                    ),
                  ),
                  // ! sipariş açıklaması
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.17,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: TextFormField(
                        maxLines: 8,
                        decoration: InputDecoration(
                          /* contentPadding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * 0.05,
                            ),*/

                          hintText: 'Sipariş Açıklaması',
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
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: TextFormField(
                        maxLines: 8,
                        decoration: InputDecoration(
                          /* contentPadding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * 0.05,
                            ),*/

                          hintText: 'Bayi Seçimi',
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
