
class CariAltHesap {

  String? ALTHESAP = "";
  int ALTHESAPID = 0;
  int? DOVIZID;
  String? VARSAYILAN =""; 
  String? ZORUNLU ="";

  CariAltHesap({ required this.ALTHESAP,required this.DOVIZID,required this.VARSAYILAN,required this.ALTHESAPID,required this.ZORUNLU});

  CariAltHesap.fromJson(Map<String, dynamic> json) {

    ALTHESAPID = int.parse(json['ALTHESAPID'].toString());
    ALTHESAP = json['ALTHESAP'];
    DOVIZID = int.parse(json['DOVIZID'].toString());
    VARSAYILAN = json['VARSAYILAN'];
    ZORUNLU = json['ZORUNLU'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['ALTHESAPID'] = ALTHESAPID;
    data['ALTHESAP'] = ALTHESAP;
    data['DOVIZID'] = DOVIZID;
    data['VARSAYILAN'] = VARSAYILAN;
    data['ZORUNLU'] = ZORUNLU;
    return data;
  }
   CariAltHesap.clone(CariAltHesap other) {

    ALTHESAPID = other.ALTHESAPID;
    ALTHESAP = other.ALTHESAP;
    DOVIZID = other.DOVIZID;
    VARSAYILAN = other.VARSAYILAN;
    ZORUNLU = other.ZORUNLU;
  }
}
