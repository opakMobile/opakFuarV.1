class RaporModel {
  int? ID;
  String? UUID;
  String? CARIADI;
  int? SATIRSAYISI;
  String? IL;
  double? TOPLAMTUTAR;

  RaporModel({this.ID, this.UUID, this.CARIADI, this.SATIRSAYISI, this.IL, this.TOPLAMTUTAR});

  // 'fromJson' methodu, JSON formatındaki veriyi alarak RaporModel nesnesine dönüştürür.
  factory RaporModel.fromJson(Map<String, dynamic> json) {
    return RaporModel(
      ID: int.parse(json['ID'].toString()),
      UUID: json['UUID'],
      CARIADI: json['CARIADI'],
      SATIRSAYISI: int.parse(json['SATIRSAYISI'].toString()),
      IL: json['IL'],
      TOPLAMTUTAR: double.parse(json['TOPLAMTUTAR'].toString()),

    );
  }

  // 'toJson' methodu, RaporModel nesnesini JSON formatına dönüştürür.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = this.ID;
    data['UUID'] = this.UUID;
    data['CARIADI'] = this.CARIADI;
    data['SATIRSAYISI'] = this.SATIRSAYISI;
    data['IL'] = this.IL;
    data['TOPLAMTUTAR'] = this.TOPLAMTUTAR;

    return data;
  }
}

