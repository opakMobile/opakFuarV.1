import 'package:flutter/material.dart';
import 'package:opak_fuar/model/cariAltHesapModel.dart';
import 'package:opak_fuar/model/fis.dart';
import 'package:opak_fuar/sabitler/Ctanim.dart';
import 'package:opak_fuar/siparis/siparisTamamla.dart';
import 'package:opak_fuar/siparis/siparisUrunAra.dart';

class AltHesapOnaylaVeDegistir extends StatefulWidget {
  const AltHesapOnaylaVeDegistir(
      {super.key,
      required this.listCariAltHesap,
      required this.gelenAltHesap,
      required this.hepsiMi});
  final List<CariAltHesap> listCariAltHesap;
  final CariAltHesap? gelenAltHesap;
  final bool? hepsiMi;

  @override
  State<AltHesapOnaylaVeDegistir> createState() =>
      _AltHesapOnaylaVeDegistirState();
}

class _AltHesapOnaylaVeDegistirState extends State<AltHesapOnaylaVeDegistir> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seciliAltHesap = widget.listCariAltHesap.first;
  }

  CariAltHesap? seciliAltHesap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Alt Hesap Onayla ve Değiştir '),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CariAltHesap>(
                value: seciliAltHesap,
                items: widget.listCariAltHesap.map((CariAltHesap banka) {
                  return DropdownMenuItem<CariAltHesap>(
                    value: banka,
                    child: Text(
                      banka.ALTHESAP!,
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (CariAltHesap? selected) async {
                  setState(() {
                    seciliAltHesap = selected;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Kapat'),
        ),
        TextButton(
          onPressed: () async {
            if (widget.hepsiMi == false) {
              for (var element in fisEx.fis!.value.fisStokListesi) {
                if (element.AltHesapDegistir == true) {
                  element.ALTHESAP = seciliAltHesap!.ALTHESAP;
                }
              }
            }else{  
               for (var element in fisEx.fis!.value.fisStokListesi) {
                if (element.ALTHESAP == widget.gelenAltHesap!.ALTHESAP) {
                  element.ALTHESAP = seciliAltHesap!.ALTHESAP;
                }
              }

            }

            fisEx.fis!.value.AKTARILDIMI = false;
            await Fis.empty().fisEkle(fis: fisEx.fis!.value, belgeTipi: "YOK");
            Ctanim.genelToplamHesapla(fisEx);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text('Tamam'),
        ),
      ],
    );
  }
}
