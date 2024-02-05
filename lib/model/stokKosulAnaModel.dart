class StokKosulAnaModel {
  int? ID = 0;
  String? ADI = "";

  StokKosulAnaModel({required this.ID, required this.ADI});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = ID;
    data['ADI'] =ADI ;
    return data;
  }

  StokKosulAnaModel.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    ADI = json['ADI'].toString();
  }
}
