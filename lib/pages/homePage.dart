import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opak_fuar/cari/cariIslemlerPage.dart';
import 'package:opak_fuar/db/veriTabaniIslemleri.dart';
import 'package:opak_fuar/model/ShataModel.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/model/kullaniciModel.dart';
import 'package:opak_fuar/pages/CustomAlertDialog.dart';
import 'package:opak_fuar/pages/LoadingSpinner.dart';
import 'package:opak_fuar/pages/ver%C4%B1GondermeHataDiyalog.dart';
import 'package:opak_fuar/raporlar/raporlar.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import 'package:opak_fuar/sabitler/sharedPreferences.dart';
import 'package:opak_fuar/sepet/sepetCariList.dart';
import 'package:opak_fuar/siparis/siparisCariList.dart';
import 'package:opak_fuar/webServis/base.dart';
import 'package:uuid/uuid.dart';
import '../controller/fisController.dart';
import '../model/fis.dart';
import '../model/fuarModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BaseService bs = BaseService();
  FisController fisEx = Get.find();

 


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
        bottomNavigationBar: bottombarDizayn(context,
            button: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.38,
                    child: Center(
                      child: Text(
                        "Fuar : " + Ctanim.kullanici!.FUARADI! == "" ? "Fuar Seçilmedi" : Ctanim.kullanici!.FUARADI!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.deepOrange,)
                        /*GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),*/
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.38,
                    child: Center(
                      child: Text(
                        "Kullanıcı : " + Ctanim.kullanici!.KULLANICIADI!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                        /* GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        )*/TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    //  "Versiyon : 1.0.5", //pdf mf ekle , alt hesap bi tık hızlı ol
                    // "Versiyon : 1.0.6", // carigüncellme sorunu, cari gönder ayır
                    // "Versiyon : 1.0.7", // pazar günü çeşitli güncellemeler
                    //  "Versiyon : TEST", // cari güncelleme sorunu
                    //  "Versiyon : 1.0.8", // veriGonderme base64 e çekildi
                    // "Versiyon : 1.0.9" ,// misyon kamera ürün arama
                    // "Versiyon : 1.1.0", // urunAra focus ,pdfFast,seçili fis gönder
                    //"Versiyon:1.1.1" ,// cariArama düzenleme, saciklama9
                    //"Versiyon 1.1.2", // sacikla9 daki 0.0 hatası
                    // "Versiyon : 1.1.3", // alt hesap değişince boş arama yapıldı
                    // "Versiyon : 1.1.4", // focus düzenlemeleri
                    // "Versiyon : 1.1.5", // mal fazlası eklendi
                    // "Versiyon: 1.1.6", // malfazlası değiştirme eklendi for temat
                    //"Versiyon: 1.1.7", // tablette ürün arama düzeltilmesi for südor
                    // "Versiyon:1.1.8",//MF HESABI DÜZELTİLDİ (BENCE BOZULDU)
                    // "Versiyon: 1.1.9", // artık pdf den önce kayıt yapılıyor
                    // "Versiyon: 1.2.0", // cari eklemede koda tarih saat eklendi
                    // "Versiyon: 1.2.1", // mal fazlası 0 gelirseeeee.....
                    // "Versiyon: 1.2.2", // mal fazlası üste yuvarlama
                    //  "Versiyon: 2.0.0", // ilk fuar sonrası güncellemeler (althesap change vs vs)
                    //  "Versiyon:2.0.1", //local pdf düzenleme sepette var
                    //  "Versiyon:2.0.2", // kullancı adı yazdık
                    //  "Versiyon:2.0.3" ,// fişharekt düzenle birim taşması
                    //  "Versiyon: 2.0.4", // stok güncellemeye koşul güncelleme de eklendi
                    // "Versiyon:2.0.5" ,// kamera açınca fiş kaydetme
                   // "Versiyon:2.0.6", //fuaradi eklendi
                   // "Versiyon:2.0.7", // faur adı dropdown oldu falan fişman
                   // "Versiyon:2.0.8", // sepet çıkıışı fiş kaydetme,
                  //  "Versiyon:2.0.9",//fuar güncelleme,pdf wp
                 //   "Versiyon:2.1.0",// bayi seçili parametreli
                 //   "Versiyon:2.1.1",// bayi seçili gelmede değişme hatası
                    "Versiyon:2.1.2",// il ilçe eklendi
                    

                    style: TextStyle(fontSize: 7),
                  ),
                ],
              ),
            ),
            buttonVarMi: true),
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
                    onTap: () async {
                      fisEx.list_tum_fis.clear();
                      await fisEx.listTumFisleriGetir();
                      
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SepetCariList(
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
                                      size: MediaQuery.of(context).size.height *
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
                  /*
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
                  */
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

class verilerGuncelle extends StatefulWidget {
  verilerGuncelle({
    super.key,
    required this.bs,
  });

  final BaseService bs;

  @override
  State<verilerGuncelle> createState() => _verilerGuncelleState();
}

class _verilerGuncelleState extends State<verilerGuncelle> {
  final FisController fisEx = Get.find();

  XFile? _selectedImage;

  Future<void> _pickImage() async {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });

    if (_selectedImage != null) {
      // Resmi veritabanına kaydet
      final imagePath = _selectedImage!.path;
      await VeriIslemleri().insertImage(imagePath);
      showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              pdfSimgesi: false,
              align: TextAlign.center,
              title: 'Başarılı',
              message: 'Logo Değiştirildi',
              onPres: () async {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              buttonText: 'Tamam',
            );
          });

      setState(() {});
    } else {
      setState(() {});
    }
  }

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
                          _pickImage();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.image,
                              size: 30,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Logomu Degistir ",
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
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextButton(
                        onPressed: () async {
                          if (listeler.listCari
                              .any((element) => element.AKTARILDIMI == "H")) {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    align: TextAlign.left,
                                    title: 'Uyarı',
                                    message:
                                        'Henüz gönderilmemiş cariler mevcut. Lütfen güncellemeden önce carileri gönderin.',
                                    onPres: () async {
                                      Navigator.pop(context);
                                    },
                                    buttonText: 'Tamam',
                                  );
                                });
                          } else {
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
                            await widget.bs.tumVerileriGuncelle();

                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
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
                                      "Fuar Verileri Güncelleniyor. Lütfen Bekleyiniz...",
                                );
                              },
                            );
                            await widget.bs.getFuar(sirket: Ctanim.sirket!);

                            Navigator.pop(context);
                            Navigator.pop(context);
                          
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.store_mall_directory,
                              size: 30,
                              color: Colors.purple,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Fuarları Güncelle",
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
                          if (listeler.listCari
                              .any((element) => element.AKTARILDIMI == "H")) {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    align: TextAlign.left,
                                    title: 'Uyarı',
                                    message:
                                        'Henüz gönderilmemiş cariler mevcut. Lütfen güncellemeden önce carileri gönderin.',
                                    onPres: () async {
                                      Navigator.pop(context);
                                    },
                                    buttonText: 'Tamam',
                                  );
                                });
                          } else {
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
                            await widget.bs.cariVerileriGuncelle();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
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
                          await widget.bs.stokVerileriGuncelle();
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
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return LoadingSpinner(
                                color: Colors.black,
                                message:
                                    "Stok Miktarı ve Bakiye Güncelleniyor. Lütfen Bekleyiniz...",
                              );
                            },
                          );
                          await widget.bs.stokVerileriGuncelle();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.wifi_protected_setup_outlined,
                              size: 30,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text("Stok Miktarı ve Bakiye Güncelle",
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
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return LoadingSpinner(
                                color: Colors.black,
                                message:
                                    "Sabit parametreler güncelleniyor.Lütfen Bekleyiniz...",
                              );
                            },
                          );
                          await widget.bs.getKullanicilar(
                              IP: Ctanim.IP,
                              kullaniciKodu: Ctanim.kullanici!.KOD!,
                              sirket: Ctanim.sirket!);

                          await KullaniciModel.saveUser(Ctanim.kullanici!);

                          Navigator.pop(context);
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return CustomAlertDialog(
                                  align: TextAlign.left,
                                  title: 'İşlem Başarılı',
                                  message:
                                      'Veriler başarıyla gönderildi. Tekrar giriş yapınız.',
                                  onPres: () async {
                                    Navigator.pop(context);
                                  },
                                  buttonText: 'Tamam',
                                );
                              });
                        },
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
                                    "Cariler Gönderiliyor. Lütfen Bekleyiniz...",
                              );
                            },
                          );
                          String hataTopla = "";

                          for (var element in listeler.listCari
                              .where((element) => element.AKTARILDIMI == "H")
                              .toList()) {
                            if (element.AKTARILDIMI == "H") {
                              Map<String, dynamic> jsonListesi =
                                  element.toJson();

                              SHataModel gelenHata = await widget.bs
                                  .cariGuncelle(
                                      jsonDataList: jsonListesi,
                                      sirket: Ctanim.sirket!);
                              if (gelenHata.Hata == "true") {
                                hataTopla = hataTopla +
                                    "\n" +
                                    element.ADI! +
                                    " Carisi Gönderilemedi. Hata mesajı:" +
                                    gelenHata.HataMesaj!;
                              } else {
                                element.AKTARILDIMI = "E";
                                await VeriIslemleri()
                                    .cariEkle(element, guncellemeMi: true);
                                //await VeriIslemleri().cariGetir();
                                listeler.listCari.add(element);
                              }
                            }
                          }
                          if (hataTopla != "") {
                            Navigator.pop(context);
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return VeriGondermeHataDialog(
                                    align: TextAlign.left,
                                    title: 'Hata',
                                    message:
                                        'Web Servise Veri Gönderilirken Bazı Hatalar İle Karşılaşıldı:\n' +
                                            hataTopla,
                                    onPres: () async {
                                      Navigator.pop(context);
                                    },
                                    buttonText: 'Tamam',
                                  );
                                });
                          } else {
                            Navigator.pop(context);
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    align: TextAlign.left,
                                    title: 'İşlem Başarılı',
                                    message: 'Cariler başarıyla gönderildi.',
                                    onPres: () async {
                                      Navigator.pop(context);
                                    },
                                    buttonText: 'Tamam',
                                  );
                                });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.send,
                              size: 30,
                              color: Colors.green,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Yeni Carileri Gönder",
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
                /*
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
                                    "IP Güncelleniyor. Lütfen Bekleyiniz...",
                              );
                            },
                          );
                          String lisans =
                              await SharedPrefsHelper.lisansNumarasiGetir();

                          List<String> donenAPIler =
                              await widget.bs.makeSoapRequest(lisans);
                          if (donenAPIler.length > 1) {
                            await SharedPrefsHelper.IpKaydet(donenAPIler[1]);
                          } else {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    align: TextAlign.left,
                                    title: 'Hata',
                                    message: 'İp çekilemedi',
                                    onPres: () async {
                                      Navigator.pop(context);
                                    },
                                    buttonText: 'Tamam',
                                  );
                                });
                          }

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
                              child: Text("IP Güncelle",
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
                */
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextButton(
                        onPressed: () async {
                          if (listeler.listCari
                              .any((element) => element.AKTARILDIMI == "H")) {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    align: TextAlign.left,
                                    title: 'Uyarı',
                                    message:
                                        'Henüz gönderilmemiş cariler mevcut. Lütfen güncellemeden önce carileri gönderin.',
                                    onPres: () async {
                                      Navigator.pop(context);
                                    },
                                    buttonText: 'Tamam',
                                  );
                                });
                          } else {
                            String hataTopla = "";
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return LoadingSpinner(
                                  color: Colors.black,
                                  message:
                                      "Siparişler Gönderiliyor. Lütfen Bekleyiniz...",
                                );
                              },
                            );

                            await fisEx.listGidecekFisGetir();
                            if (fisEx.list_fis_gidecek.length > 0) {
                              for (int j = 0;
                                  j < fisEx.list_fis_gidecek.length;
                                  j++) {
                                if (fisEx.list_fis_gidecek[j].ACIKLAMA4 != "" &&
                                    fisEx.list_fis_gidecek[j].ACIKLAMA5 != "") {
                                  if (fisEx.list_fis_gidecek[j].fisStokListesi
                                          .length >
                                      0) {
                                    List<String> althesaplar = [];
                                    for (int i = 0;
                                        i <
                                            fisEx.list_fis_gidecek[j]
                                                .fisStokListesi.length;
                                        i++) {
                                      if (!althesaplar.contains(fisEx
                                          .list_fis_gidecek[j]
                                          .fisStokListesi[i]
                                          .ALTHESAP)) {
                                        althesaplar.add(fisEx
                                            .list_fis_gidecek[j]
                                            .fisStokListesi[i]
                                            .ALTHESAP!);
                                      }
                                    }
                                    List<Fis> parcaliFisler = [];

                                    for (var element in althesaplar) {
                                      var uuidx = Uuid();
                                      String neu = uuidx.v1();

                                      print("Baba fiş UUID:" +
                                          fisEx.list_fis_gidecek[j].UUID!);
                                      Fis fis = Fis.empty();
                                      fis = Fis.fromFis(
                                          fisEx.list_fis_gidecek[j], []);
                                      fis.USTUUID = fis.UUID;
                                      fis.UUID = neu;
                                      print(
                                          "Yavru fiş USTUUID:" + fis.USTUUID!);
                                      print("Yavru fiş UUID:" + fis.UUID!);
                                      fis.SIPARISSAYISI = althesaplar.length;
                                      fis.KALEMSAYISI = 0;
                                      fis.ALTHESAP = element;
                                      for (int k = 0;
                                          k <
                                              fisEx.list_fis_gidecek[j]
                                                  .fisStokListesi.length;
                                          k++) {
                                        if (fisEx.list_fis_gidecek[j]
                                                .fisStokListesi[k].ALTHESAP ==
                                            element) {
                                          // ha bura
                                          FisHareket yavruFishareket =
                                              FisHareket.fromFishareket(fisEx
                                                  .list_fis_gidecek[j]
                                                  .fisStokListesi[k]);
                                          yavruFishareket.UUID = fis.UUID;
                                          print("Baba fişHAR UUID:" +
                                              fisEx.list_fis_gidecek[j]
                                                  .fisStokListesi[k].UUID!);
                                          print("Yavru fişHAR UUID:" +
                                              yavruFishareket.UUID!);

                                          fis.fisStokListesi
                                              .add(yavruFishareket);
                                          fis.KALEMSAYISI =
                                              fis.KALEMSAYISI! + 1;
                                        }
                                      }

                                      parcaliFisler.add(fis);
                                    }
                                    fisEx.list_fis_gidecek[j].AKTARILDIMI =
                                        true;
                                    Fis.empty().fisEkle(
                                        belgeTipi: "YOK",
                                        fis: fisEx.list_fis_gidecek[j]);
                                    String genelHata = "";
                                    List<Map<String, dynamic>> listeFisler = [];
                                    for (var element in parcaliFisler) {
                                      listeFisler.add(element.toJson2());
                                    }
                                    SHataModel gelenHata = await widget.bs
                                        .ekleSiparisFuar(
                                            UstUuid: listeFisler[0]["USTUUID"],
                                            jsonDataList: listeFisler,
                                            sirket: Ctanim.sirket!,
                                            pdfMi: "H"
                                            );
                                    if (gelenHata.Hata == "true") {
                                      genelHata += gelenHata.HataMesaj!;
                                    }
                                    if (genelHata != "") {
                                      fisEx.list_fis_gidecek[j].AKTARILDIMI =
                                          false;
                                      Fis.empty().fisEkle(
                                          belgeTipi: "YOK",
                                          fis: fisEx.list_fis_gidecek[j]);
                                      hataTopla = hataTopla +
                                          "\n" +
                                          fisEx.list_fis_gidecek[j].CARIADI! +
                                          " ait belge gönderilemedi.\n Hata Mesajı :" +
                                          genelHata +
                                          "\n";
                                    }
                                  } else {
                                    hataTopla = hataTopla +
                                        "\n" +
                                        fisEx.list_fis_gidecek[j].CARIADI! +
                                        " ait " +
                                        "belge gönderilemedi.\nHata Mesajı :" +
                                        "Fis Stok Listesi Boş\n";
                                  }
                                } else {
                                  hataTopla = hataTopla +
                                      "\n" +
                                      fisEx.list_fis_gidecek[j].CARIADI! +
                                      " ait " +
                                      "sipariş gönderilemedi. " +
                                      "Bayi seçimi yapılmamış\n";
                                }
                              }

                              if (hataTopla != "") {
                                Navigator.pop(context);
                                widget.bs.printWrapped(hataTopla);
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return VeriGondermeHataDialog(
                                        align: TextAlign.left,
                                        title: 'Hata',
                                        message:
                                            'Web Servise Veri Gönderilirken Bazı Hatalar İle Karşılaşıldı:\n' +
                                                hataTopla,
                                        onPres: () async {
                                          Navigator.pop(context);
                                        },
                                        buttonText: 'Tamam',
                                      );
                                    });
                              } else {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        align: TextAlign.left,
                                        title: 'İşlem Başarılı',
                                        message:
                                            'Siparişler başarıyla gönderildi.',
                                        onPres: () async {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        buttonText: 'Tamam',
                                      );
                                    });
                              }

                              fisEx.list_fis_gidecek.clear();

                              print("Liste Temizlendi : " +
                                  fisEx.list_fis_gidecek.length.toString());
                            } else {
                              Navigator.pop(context);
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      align: TextAlign.left,
                                      title: 'Boş Liste',
                                      message: 'Gönderilecek Sipariş Yok',
                                      onPres: () async {
                                        Navigator.pop(context);
                                      },
                                      buttonText: 'Tamam',
                                    );
                                  });
                            }
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.backup,
                              size: 30,
                              color: Colors.red,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Kaydedilen Siparisleri Gönder",
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
