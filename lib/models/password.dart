class Password {
  String name;
  String? username;
  String hash;
  String? password;
  Password(
      {required this.name, this.username, required this.hash, this.password});

  static Password fromMap(Map<String, dynamic> map) {
    return Password(
        name: map["name"],
        username: map["username"],
        hash: map["hash"],
        password: map["password"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "username": username,
      "hash": hash,
      "password": password
    };
  }
}
