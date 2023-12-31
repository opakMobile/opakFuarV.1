import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opak_fuar/pages/homePage.dart';

import '../pages/hesapMakinesi.dart';

appBarDizayn(context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(95.0),
    child: Container(
      width: MediaQuery.of(context).size.width,
      //  height: 90,
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              child: Image.asset('assets/opaklogo2.png'),
            ),
            Text(
              'fair sales',
              style: GoogleFonts.varelaRound(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    ),
  );
}

bottombarDizayn(context, {Widget? button, bool buttonVarMi = false}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 70,
    color: Colors.white,
    child: Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06),
            child: IconButton(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.08,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false);
              },
              icon: Icon(
                Icons.home,
                size: 60,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.0,
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              child: button),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.06),
            child: IconButton(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.07,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return const HesapMakinesi();
                    });
              },
              icon: Icon(
                Icons.calculate,
                color: Colors.orange,
                size: 55,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


/*
Widget UcCizgi() {
  return Align(
    alignment: Alignment.topLeft,
    child: IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.list,
        size: 30,
      ),
    ),
  );
}
*//*
CartYapisi(context, height, String text, Icon icon, Color color) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 3,
    child: Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  icon,
                  Spacer(),
                  Text(text,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color)),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.375,
                    height: 3,
                    color: color,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.375,
                    height: 3,
                    color: Colors.grey,
                  ),
                ],
              )
            ],
          ),
        )),
  );
}
*/