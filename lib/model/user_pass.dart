class UserModel {
  String? username;
  String? password;
  bool? isSave;

  UserModel(){
    username = username;
    password = password;
    isSave = isSave;
  }

  UserModel.fromJson(dynamic json) {
    username = json["username"];
    password = json["password"];
    isSave = json["isSave"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["username"] = username;
    map["password"] = password;
    map["isSave"] = isSave;
    return map;
  }
}