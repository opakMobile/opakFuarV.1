import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';


class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function onPres;
  final TextAlign align;
  final String buttonText;
  final String? secondButtonText;
  final Function? onSecondPress;
  final bool? pdfSimgesi;
  final Color? textColor;

  CustomAlertDialog({
    required this.title,
    required this.message,
    required this.onPres,
    required this.buttonText,
    this.secondButtonText,
    this.onSecondPress,
    this.pdfSimgesi,
    this.textColor,
    required this.align,
  });

  /*
  isim
  yekili
  
  */

  @override
  Widget build(BuildContext context) {
   
    return AlertDialog(
      title: Text(title,style: TextStyle(color: textColor!=null ? textColor : Colors.black),),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 3.0),
              child:
                  SingleChildScrollView(child: Container(child: Text(message, textAlign: align, style: TextStyle(fontSize: 16)))),
            ),
            pdfSimgesi == true
                ? GestureDetector(
                    onTap: () {
                      onPres();
                    },
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        'assets/pdf.png',
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onPres();
          },
          child: Text(buttonText),
        ),
        if (secondButtonText != null && onSecondPress != null)
          TextButton(
            onPressed: () {
              onSecondPress!();
            },
            child: Text(secondButtonText!),
          ),
      ],
    );
  }
}
