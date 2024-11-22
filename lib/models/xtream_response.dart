class XstreamResponse {
  UserInfo? userInfo;
  ServerInfo? serverInfo;

  XstreamResponse({this.userInfo, this.serverInfo});

  XstreamResponse.fromJson(Map<String, dynamic> json) {
    userInfo =
        json['user_info'] != null ? UserInfo.fromJson(json['user_info']) : null;
    serverInfo = json['server_info'] != null
        ? ServerInfo.fromJson(json['server_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }
    if (serverInfo != null) {
      data['server_info'] = serverInfo!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'XstreamResponse(userInfo: $userInfo, serverInfo: $serverInfo)';
  }
}

class UserInfo {
  String? username;
  String? password;
  String? message;
  int? auth;
  String? status;
  String? expDate;
  String? isTrial;
  String? activeCons;
  String? createdAt;
  String? maxConnections;
  List<String>? allowedOutputFormats;

  UserInfo(
      {this.username,
      this.password,
      this.message,
      this.auth,
      this.status,
      this.expDate,
      this.isTrial,
      this.activeCons,
      this.createdAt,
      this.maxConnections,
      this.allowedOutputFormats});

  UserInfo.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    message = json['message'];
    auth = json['auth'];
    status = json['status'];
    expDate = json['exp_date'];
    isTrial = json['is_trial'];
    activeCons = json['active_cons'];
    createdAt = json['created_at'];
    maxConnections = json['max_connections'];
    allowedOutputFormats = json['allowed_output_formats'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['message'] = message;
    data['auth'] = auth;
    data['status'] = status;
    data['exp_date'] = expDate;
    data['is_trial'] = isTrial;
    data['active_cons'] = activeCons;
    data['created_at'] = createdAt;
    data['max_connections'] = maxConnections;
    data['allowed_output_formats'] = allowedOutputFormats;
    return data;
  }

  @override
  String toString() {
    return 'UserInfo(username: $username, password: $password, message: $message, auth: $auth, status: $status, expDate: $expDate, isTrial: $isTrial, activeCons: $activeCons, createdAt: $createdAt, maxConnections: $maxConnections, allowedOutputFormats: $allowedOutputFormats)';
  }
}

class ServerInfo {
  String? url;
  String? port;
  String? httpsPort;
  String? serverProtocol;
  String? rtmpPort;
  String? timezone;
  int? timestampNow;
  String? timeNow;
  bool? process;

  ServerInfo(
      {this.url,
      this.port,
      this.httpsPort,
      this.serverProtocol,
      this.rtmpPort,
      this.timezone,
      this.timestampNow,
      this.timeNow,
      this.process});

  ServerInfo.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    port = json['port'];
    httpsPort = json['https_port'];
    serverProtocol = json['server_protocol'];
    rtmpPort = json['rtmp_port'];
    timezone = json['timezone'];
    timestampNow = json['timestamp_now'];
    timeNow = json['time_now'];
    process = json['process'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['port'] = port;
    data['https_port'] = httpsPort;
    data['server_protocol'] = serverProtocol;
    data['rtmp_port'] = rtmpPort;
    data['timezone'] = timezone;
    data['timestamp_now'] = timestampNow;
    data['time_now'] = timeNow;
    data['process'] = process;
    return data;
  }

  @override
  String toString() {
    return 'ServerInfo(url: $url, port: $port, httpsPort: $httpsPort, serverProtocol: $serverProtocol, rtmpPort: $rtmpPort, timezone: $timezone, timestampNow: $timestampNow, timeNow: $timeNow, process: $process)';
  }
}
