class FuarModel {
  int? ID;
  String? KOD;
  String? ADI;
  int? SIRA;

  FuarModel({
    this.ID,
    this.KOD,
    this.ADI,
    this.SIRA,
  });

  FuarModel.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    KOD = json['KOD'];
    ADI = json['ADI'];
    SIRA = int.parse(json['SIRA'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = ID;
    data['KOD'] = KOD;
    data['ADI'] = ADI;
    data['SIRA'] = SIRA;
    return data;
  }
}
