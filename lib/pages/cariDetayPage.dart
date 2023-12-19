import 'package:flutter/material.dart';
import 'package:opak_fuar/sabitler/sabitmodel.dart';

class CariDetayPage extends StatefulWidget {
  const CariDetayPage({super.key});

  @override
  State<CariDetayPage> createState() => _CariDetayPageState();
}

class _CariDetayPageState extends State<CariDetayPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarDizayn(context),
        bottomNavigationBar: bottombarDizayn(context),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              // ! Üst Kısım
              Row(
                children: [
                  UcCizgi(),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              // ! Firma Adı
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
                color: Colors.red,
                child: Center(
                  child: Text(
                    'Firma Adı',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
