class LoginRequestModel {
  String? usr;
  String? pwd;

  LoginRequestModel({this.usr, this.pwd});

  Map toJson() {
    final Map data = new Map();
    data['usr'] = this.usr;
    data['pwd'] = this.pwd;
    return data;
  }
}
