import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> getLocalFilePath(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/$fileName';
}

Future<File> saveFile(String fileName, List<int> bytes) async {
  final path = await getLocalFilePath(fileName);
  final file = File(path);
  return file.writeAsBytes(bytes);
}
