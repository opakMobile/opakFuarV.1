import 'package:flutter/material.dart';
import 'package:opak_fuar/model/fisHareket.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';

class okumaModuList extends StatelessWidget {
  const okumaModuList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,

        //!! Sepet Listesi Buraya Gelecek
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120),
          child: ListView.builder(
            itemCount: fisEx.fis!.value.fisStokListesi.length,
            itemBuilder: (context, index) {
              FisHareket stokModel = fisEx.fis!.value.fisStokListesi[index];
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
                              onPressed: () {},
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
                              "M.Fazlası",
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
                                child: Text("MF"),
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
                                  "Adet",
                                  // stokModel.BIRIMID.toString()!,
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
                                onPressed: () {},
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
                              stokModel.NETTOPLAM!.toStringAsFixed(2),
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
                              stokModel.KDVTUTAR!.toStringAsFixed(2),
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
                              width: MediaQuery.of(context).size.width ,
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
            },
          ),
        ),
      ),
    );
  }
}