class BanksModel {
  String? cbn;
  String? code;
  String? name;

  BanksModel({this.cbn, this.code, this.name});

  BanksModel.fromJson(Map<String, dynamic> json) {
    cbn = json['cbn'];
    code = json['code'];
    name = json['name'];
  }
}