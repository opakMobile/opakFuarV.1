import 'package:flutter/material.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';

class CariFormPage extends StatefulWidget {
  CariFormPage({required this.yeniKayit});

  bool yeniKayit = true;
  @override
  State<CariFormPage> createState() => _CariFormPageState();
}

class _CariFormPageState extends State<CariFormPage> {
  bool AliciMusteri = false;
  bool AliciBayi = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(120.0),
            child: Stack(
              children: [
                appBarDizayn(context),
                // ! Üst Kısım
              ],
            )),
        bottomNavigationBar: bottombarDizayn(context),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1.2,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      // ! Üst Kısım
                      Row(
                        children: [
                        //  UcCizgi(),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios),
                          )
                        ],
                      ),

                      // ! Form
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05),
                        child: Form(
                          child: Column(
                            children: [
                              // ! Müşteri / Şirket İsmi Giriniz
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: Center(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label:
                                          Text('Müşteri / Şirket İsmi Giriniz'),
                                    ),
                                  ),
                                ),
                              ),
                              // ! Adres Bilgileri Giriniz
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Center(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      label: Text('Adres Bilgileri Giriniz'),
                                    ),
                                  ),
                                ),
                              ),
                              // ! Yetkili Kişi Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text('Yetkili Kişi Giriniz'),
                                  ),
                                ),
                              ),
                              // ! Ülke Seçiniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text('Ülke Seçiniz'),
                                  ),
                                ),
                              ),
                              // ! Şehir Seçiniz ve İlçe Seçiniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          label: Text('Şehir Seçiniz'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          label: Text('İlçe Seçiniz'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ! Vergi Dairesi Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text("Vergi Dairesi Giriniz"),
                                  ),
                                ),
                              ),
                              // ! Vergi Numarası Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text("Vergi Numarası Giriniz"),
                                  ),
                                ),
                              ),
                              // ! Cep Telefonu Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text("Cep Telefonu Giriniz"),
                                  ),
                                ),
                              ),
                              // ! Mail Adresi Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text("Mail Adresi Giriniz"),
                                  ),
                                ),
                              ),
                              // ! Açıklama Giriniz
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    label: Text("Açıklama Giriniz"),
                                  ),
                                ),
                              ),
                              // ! Alıcı Müşteri veya Bayi
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.black54),
                                        ),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                value: AliciMusteri,
                                                onChanged: (value) {
                                                  setState(() {
                                                    //   AliciMusteri = value;
                                                  });
                                                }),
                                            Text("Alıcı Müşteri"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border:
                                              Border.all(color: Colors.black54),
                                        ),
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                value: AliciBayi,
                                                onChanged: (value) {
                                                  setState(() {
                                                    //   AliciBayi = value;
                                                  });
                                                }),
                                            Text(" Bayi"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ! Kaydet Butonu sil Değiştir
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              widget.yeniKayit == false
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {},
                                            icon: Icon(Icons.delete),
                                            label: Text("Sil"),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {},
                                            icon: Icon(Icons.save),
                                            label: Text("Kaydet"),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.01,
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {},
                                            icon: Icon(Icons.edit),
                                            label: Text("Değiştir"),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                       height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: Center(
                                        child: ElevatedButton.icon(
                                          onPressed: () {},
                                          icon: Icon(Icons.save),
                                          label: Text("Kaydet"),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                            onPrimary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                            ),
                                     
                                        ),
                                      ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
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
