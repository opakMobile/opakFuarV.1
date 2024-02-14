import 'package:flutter/material.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';

class PlasiyerToplam extends StatefulWidget {
  const PlasiyerToplam({super.key, required this.gelenVeri});
  final List<double> gelenVeri;

  @override
  State<PlasiyerToplam> createState() => _PlasiyerToplamState();
}

class _PlasiyerToplamState extends State<PlasiyerToplam> {
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                ),
                

                // ! Cari Listesi
                SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.01),
                          child: Text(
                            "Bekleyen Siparişler:",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02, ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Sipariş Sayısı",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text(
                                        (widget.gelenVeri[0].toInt())
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                    "Toplam Satış",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text(
                                        Ctanim.donusturMusteri(widget
                                                .gelenVeri[1]
                                                .toString()) +
                                            " TL",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*.025,),
                        Divider(thickness: 2,),
                        SizedBox(height: MediaQuery.of(context).size.height*.025,),

                          
                          
                             Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.01),
                          child: Text(
                            "Aktarılan Siparişler:",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02, ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Sipariş Sayısı",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text(
                                        (widget.gelenVeri[2].toInt())
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                    "Toplam Satış",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text(
                                        Ctanim.donusturMusteri(widget
                                                .gelenVeri[3]
                                                .toString()) +
                                            " TL",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                                         SizedBox(height: MediaQuery.of(context).size.height*.025,),
                        Divider(thickness: 2,),
                        SizedBox(height: MediaQuery.of(context).size.height*.025,),
                          
                          
                             Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.01),
                          child: Text(
                            "Tüm Siparişler:",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02, ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Sipariş Sayısı",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text(
                                        (widget.gelenVeri[4].toInt())
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                    "Toplam Satış",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.015,
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                          child: Text(
                                        Ctanim.donusturMusteri(widget
                                                .gelenVeri[5]
                                                .toString()) +
                                            " TL",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                     
                     
                     
                      ],
                    ),
                  ),
                )),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
