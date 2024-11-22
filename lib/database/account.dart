import 'package:hive_flutter/hive_flutter.dart';
part 'account.g.dart';

@HiveType(typeId: 1)
class Account extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? serverUrl;
  @HiveField(2)
  String? port;
  @HiveField(3)
  String? serverProtocol;
  @HiveField(4)
  String? username;
  @HiveField(5)
  String? password;
  @HiveField(6)
  DateTime? createdAt;
  @HiveField(7)
  DateTime? expiresAt;

  Account({
    this.name,
    this.serverUrl,
    this.port,
    this.serverProtocol,
    this.username,
    this.password,
    this.createdAt,
    this.expiresAt,
  });

  @override
  String toString() {
    return 'Account{name: $name, serverUrl: $serverUrl, port: $port, serverProtocol: $serverProtocol, username: $username, password: $password, createdAt: $createdAt, expiresAt: $expiresAt}';
  }
}
