
class CariAltHesap {
  String? KOD = "";
  String? ALTHESAP = "";
  int ALTHESAPID = 0;
  int? DOVIZID;
  String? VARSAYILAN =""; 

  CariAltHesap({required this.KOD, required this.ALTHESAP,required this.DOVIZID,required this.VARSAYILAN,required this.ALTHESAPID});

  CariAltHesap.fromJson(Map<String, dynamic> json) {
    KOD = json['KOD'];
    ALTHESAPID = int.parse(json['ALTHESAPID'].toString());
    ALTHESAP = json['ALTHESAP'];
    DOVIZID = int.parse(json['DOVIZID'].toString());
    VARSAYILAN = json['VARSAYILAN'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['KOD'] = KOD;
    data['ALTHESAPID'] = ALTHESAPID;
    data['ALTHESAP'] = ALTHESAP;
    data['DOVIZID'] = DOVIZID;
    data['VARSAYILAN'] = VARSAYILAN;
    return data;
  }
}
