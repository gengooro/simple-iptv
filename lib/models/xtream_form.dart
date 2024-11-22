class XtreamForm {
  String? name;
  String? server;
  String? username;
  String? password;

  XtreamForm({this.name, this.server, this.username, this.password});

  XtreamForm.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    server = json['server'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['server'] = server;
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}
