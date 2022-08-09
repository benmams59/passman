import 'dart:io';
import 'dart:convert';
import 'package:passman/models/password.dart';
import 'package:path_provider/path_provider.dart';

late List<Password> _passwords;
late Directory _tempDir;
bool _initilized = false;
late String? _hash;
String? _secret;

List<Password> get passwords {
  return _passwords;
}

Future<void> initialize() async {
  Directory sysTempDir = await getTemporaryDirectory();
  _tempDir = Directory("${sysTempDir.path}/Passman");

  if (!_tempDir.existsSync()) _tempDir.createSync(recursive: true);
  _passwords = await _getPasswords();
  _initilized = true;
}

bool isHashed() {
  if (_initilized) {
    return _hash == null ? false : true;
  } else {
    throw ("You must initilize the utils before to use any others function.");
  }
}

Future<bool> login(String password) async {
  if (_initilized) {
    return true;
  } else {
    throw ("You must initilize the utils before to use any others function.");
  }
}

Future<List<Password>> _getPasswords() async {
  File file = File("${_tempDir.path}/passwords.json");
  if (!file.existsSync()) {
    file.createSync();
    file.writeAsStringSync(json.encode({"hash": null, "passwords": []}));
  }
  Map<String, dynamic> data =
      json.decode(file.readAsStringSync()) as Map<String, dynamic>;
  List passwords = data["passwords"] as List;
  _hash = data["hash"];
  return List.generate(
      passwords.length, (index) => Password.fromMap(passwords[index]));
}
