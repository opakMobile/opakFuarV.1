import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/model/stokKartModel.dart';
import 'package:opak_fuar/pages/CustomAlertDialog.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/siparis/fisHareketDuzenle.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';
import 'package:opak_fuar/sabitler/listeler.dart';

class okumaModuList extends StatefulWidget {
  const okumaModuList({
    super.key,
    required this.seciliAltHesap,
    required this.sepetteAra,
    required this.editinControllerText,
  });
  final String seciliAltHesap;
  final bool sepetteAra;
  final String editinControllerText;

  @override
  State<okumaModuList> createState() => _okumaModuListState();
}

class _okumaModuListState extends State<okumaModuList> {
  FocusNode myFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var result = fisEx.fis!.value!.fisStokListesi
        .where((value) => value.ALTHESAP == widget.seciliAltHesap);
    return Column(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height < 650
                ? MediaQuery.of(context).size.height * 0.465
                : MediaQuery.of(context).size.height * 0.480,

            //!! Sepet Listesi Buraya Gelecek
            child: result.isEmpty
                ? Center(
                    child: Text("Bu alt hesaba ait ürün bulunmamaktadır."),
                  )
                : ListView.builder(
                    itemCount: fisEx.fis!.value.fisStokListesi.length,
                    itemBuilder: (context, index) {
                      FisHareket stokModel =
                          fisEx.fis!.value.fisStokListesi[index];
                      if (widget.sepetteAra == true &&
                          widget.editinControllerText != "") {
                        StokKart bulunanStok =
                            Ctanim.harekettenStokBul(stokModel);
                        if (bulunanStok.KOD!.toLowerCase().contains(
                                widget.editinControllerText.toLowerCase()) ||
                            bulunanStok.BARKOD1! ==
                                widget.editinControllerText ||
                            bulunanStok.BARKOD2! ==
                                widget.editinControllerText ||
                            bulunanStok.BARKOD3! ==
                                widget.editinControllerText ||
                            bulunanStok.BARKOD4! ==
                                widget.editinControllerText ||
                            bulunanStok.BARKOD5! ==
                                widget.editinControllerText ||
                            bulunanStok.BARKOD6! ==
                                widget.editinControllerText ||
                            bulunanStok.ADI!.toLowerCase().contains(
                                widget.editinControllerText.toLowerCase())) {
                          return okumaModuUrunListe(context, stokModel);
                        } else {
                          return Container();
                        }
                      } else {
                        print("SEPETE ARA PASİF");
                        return stokModel.ALTHESAP == widget.seciliAltHesap
                            ? okumaModuUrunListe(context, stokModel)
                            : Container();
                      }
                    },
                  ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.04,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Satış Toplamı:",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                    child: Text(
                  Ctanim.donusturMusteri(
                      fisEx.fis!.value.ARA_TOPLAM.toString()),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column okumaModuUrunListe(BuildContext context, FisHareket stokModel) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      stokModel.STOKADI!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                Text(stokModel.STOKKOD! +
                    "  " +
                    "KDV " +
                    stokModel.KDVORANI.toString()),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.19,
              child: Card(
                elevation: 10,
                child: TextButton(
                    onPressed: () {
                      //alt hesap
                      double gelenMiktar =
                          double.parse(stokModel.MIKTAR.toString());

                      List<StokKart> stok = listeler.listStok
                          .where((stok) =>
                              stok.KOD! == stokModel.STOKKOD ||
                              stok.BARKOD1 == stokModel.STOKKOD ||
                              stok.BARKOD2 == stokModel.STOKKOD ||
                              stok.BARKOD3 == stokModel.STOKKOD ||
                              stok.BARKOD4 == stokModel.STOKKOD ||
                              stok.BARKOD5 == stokModel.STOKKOD ||
                              stok.BARKOD6 == stokModel.STOKKOD)
                          .toList();
                      if (stok.isEmpty) {
                        listeler.listDahaFazlaBarkod.where(
                            (element) => element.KOD == stokModel.STOKKOD);
                      }

                      if (stok.first.KOD! == stokModel.STOKKOD) {
                        stok.first.guncelDegerler!.carpan = 1;
                        stok.first.guncelDegerler!.guncelBarkod =
                            stok.first.KOD;
                      } else if (stok.first.BARKOD1 == stokModel.STOKKOD) {
                        stok.first.guncelDegerler!.carpan =
                            stok.first.BARKODCARPAN1;
                        stok.first.guncelDegerler!.guncelBarkod =
                            stok.first.BARKOD1;
                      } else if (stok.first.BARKOD2 == stokModel.STOKKOD) {
                        stok.first.guncelDegerler!.carpan =
                            stok.first.BARKODCARPAN2;
                        stok.first.guncelDegerler!.guncelBarkod =
                            stok.first.BARKOD2;
                      } else if (stok.first.BARKOD3 == stokModel.STOKKOD) {
                        stok.first.guncelDegerler!.carpan =
                            stok.first.BARKODCARPAN3;
                        stok.first.guncelDegerler!.guncelBarkod =
                            stok.first.BARKOD3;
                      } else if (stok.first.BARKOD4 == stokModel.STOKKOD) {
                        stok.first.guncelDegerler!.carpan =
                            stok.first.BARKODCARPAN4;
                        stok.first.guncelDegerler!.guncelBarkod =
                            stok.first.BARKOD4;
                      } else if (stok.first.BARKOD5 == stokModel.STOKKOD) {
                        stok.first.guncelDegerler!.carpan =
                            stok.first.BARKODCARPAN5;
                        stok.first.guncelDegerler!.guncelBarkod =
                            stok.first.BARKOD5;
                      } else if (stok.first.BARKOD6 == stokModel.STOKKOD) {
                        stok.first.guncelDegerler!.carpan =
                            stok.first.BARKODCARPAN6;
                        stok.first.guncelDegerler!.guncelBarkod =
                            stok.first.BARKOD6;
                      }
                      Ctanim.urunAraFocus = false;

                      showDialog(
                          context: context,
                          builder: (context) {
                            return fisHareketDuzenle(
                              urunDuzenlemeyeGeldim: true,
                              malFazlasi: (stokModel.MALFAZLASI).toDouble(),
                              okutulanCarpan: 1,
                              altHesap: stokModel.ALTHESAP!,
                              gelenStokKart: stok.first,
                              gelenMiktar: gelenMiktar,
                              fiyat: stokModel.BRUTFIYAT!,
                              isk1: stokModel.ISK!,
                              isk2: stokModel.ISK2!,
                              isk3: stokModel.ISK3!,
                              isk4: stokModel.ISK4!,
                              isk5: stokModel.ISK5!,
                              isk6: stokModel.ISK6!,
                            );
                          }).then((value) {
                        FocusScope.of(context).requestFocus(myFocusNode);
                        setState(() {
                          // Ctanim.genelToplamHesapla(fisEx);
                        });
                      });
                    },
                    child: Text(
                      "Değiştir",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    )),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "İskonto",
                    style: TextStyle(fontSize: 13),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        stokModel.ISK!.toStringAsFixed(2),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "MF",
                    style: TextStyle(fontSize: 13),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(stokModel.MALFAZLASI.toString()),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    "Miktar",
                    style: TextStyle(fontSize: 13),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(stokModel.MIKTAR!.toStringAsFixed(2)),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text("Birim", style: TextStyle(fontSize: 13)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        stokModel.BIRIM.toString()!,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text("Fiyat", style: TextStyle(fontSize: 13)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        stokModel.BRUTFIYAT!.toStringAsFixed(2),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.19,
                child: Card(
                  elevation: 10,
                  child: TextButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                align: TextAlign.left,
                                title: 'İşlem Onayı',
                                message:
                                    '${stokModel.STOKADI} siparişten silinecek. İşleme devam etmek istiyor musunuz?',
                                onPres: () async {
                                  Navigator.pop(context);
                                },
                                buttonText: 'İptal',
                                secondButtonText: "Devam Et",
                                onSecondPress: () async {
                                  fisEx.fis?.value.altHesapToplamlar
                                      .removeWhere((item) {
                                    String a = "";
                                    for (var element in item.STOKKODLIST!) {
                                      if (element == stokModel.STOKKOD) {
                                        a = element;
                                      }
                                    }
                                    return a == stokModel.STOKKOD!;
                                  });

                                  fisEx.fis?.value.fisStokListesi.removeWhere(
                                      (item) =>
                                          item.STOKKOD == stokModel.STOKKOD! &&
                                          item.ALTHESAP == stokModel.ALTHESAP!);
                                          print(fisEx.fis?.value.fisStokListesi.length);

                                  await Fis.empty().fisHareketSil(
                                      fisEx.fis!.value.ID!,
                                      stokModel.STOKKOD!,
                                      stokModel.ALTHESAP!);
                                  setState(() {
                                    Ctanim.genelToplamHesapla(fisEx);
                                    print("ARA TOPLAM DEĞİŞTİ : " +
                                        fisEx.fis!.value!.ARA_TOPLAM!
                                            .toString());
                                  });
                                  Navigator.pop(context);
                                  setState(() {
                                    
                                  });
                                },
                              );
                            });
                      },
                      child: Text(
                        "Sil",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
        //! Toplam, İskonto, KDV, Genel Toplam
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Text(
                    "Toplam: ",
                    style: TextStyle(fontSize: 11, color: Colors.orange),
                  ),
                  Text(
                    stokModel.BRUTTOPLAMFIYAT!.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "İskonto: ",
                    style: TextStyle(fontSize: 11, color: Colors.orange),
                  ),
                  Text(
                    stokModel.ISKONTOTOPLAM!.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "KDV: ",
                    style: TextStyle(fontSize: 11, color: Colors.orange),
                  ),
                  Text(
                    stokModel.KDVTOPLAM!.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Genel Toplam: ",
                    style: TextStyle(fontSize: 11, color: Colors.orange),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      stokModel.KDVDAHILNETTOPLAM!.toStringAsFixed(2),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1.5,
          color: Colors.black87,
        )
      ],
    );
  }
}
