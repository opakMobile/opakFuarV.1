import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:opak_fuar/cari/cariDetayPage.dart';
import 'package:opak_fuar/cari/cariFormPage.dart';
import 'package:opak_fuar/model/cariModel.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/sabitler/listeler.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';
import '../db/veriTabaniIslemleri.dart';
import '../siparis/siparisUrunAra.dart';

class CariListePage extends StatefulWidget {
  CariListePage({required this.islem});

  final bool islem;
  @override
  State<CariListePage> createState() => _CariListePageState();
}

class _CariListePageState extends State<CariListePage> {
  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cariEx.searchCari("");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                // ! Search Bar
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Aranacak Kelime( Ünvan/ Kod / İl/ İlçe)',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: ((value) => cariEx.searchCari(value)),
                  ),
                ),
                // ! Cari Listesi
                SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Obx(() => ListView.builder(
                          itemCount: cariEx.searchCariList.length,
                          itemBuilder: (context, index) {
                            Cari cari = cariEx.searchCariList[index];
                            String harf1 = Ctanim.cariIlkIkiDon(cari.ADI!)[0];
                            String harf2 = Ctanim.cariIlkIkiDon(cari.ADI!)[0];
                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: randomColor(),
                                    child: Text(
                                      harf1 + harf2,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    cari.ADI.toString(),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(cari.IL!.toString()),
                                  ),
                                  onTap: () async {
                                    if (widget.islem) {
                                      // cariye gidecek bilgisine
                                      fisEx.list_fis_cari_ozel.clear();
                                      /*
                                      await fisEx.listCariFisGetir(
                                          cariEx.searchCariList[index].ADI!);
                                          */
                                       double genelToplam = await fisEx.cariToplamGetir( cariEx
                                                        .searchCariList[index].KOD!);  
                                                        
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CariDetayPage(
                                                    cari: cariEx
                                                        .searchCariList[index],
                                                    genelToplam: genelToplam,
                                                  )));
                                    } else {
                                      // cari listesine gidecek
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CariFormPage(
                                                    yeniKayit: false,
                                                    cari: cariEx
                                                        .searchCariList[index],
                                                  )));
                                    }
                                  },
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.black87,
                                )
                              ],
                            );
                          },
                        )),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
