import 'package:flutter/rendering.dart';

class AltHesapToplamModel{
  int? FISID = 0;
  String? ALTHESAPADI="";
  List<String>? STOKKODLIST = [];
  double? TOPLAM=0;
  
    AltHesapToplamModel(this.ALTHESAPADI,this.STOKKODLIST,this.TOPLAM);
    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ALTHESAPADI'] = ALTHESAPADI;
    data['TOPLAM'] = TOPLAM;
    return data;
  }
    AltHesapToplamModel.empty()
      : this(
            "",
            [],
            0
   
      );

  
}