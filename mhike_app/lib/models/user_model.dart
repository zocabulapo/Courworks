class User {
  String userid;
  String username;
  String email;
  String password;

  User({
    required this.userid,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userid: map['userid'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
    );
  }
}
