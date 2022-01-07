class User {
  final String name;
  final String? password;
  final String? playerid;
  final String? profileurl;

  User({required this.name, this.password, this.playerid, this.profileurl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json["user_name_unique"],
        password: json["user_password"],
        playerid: json["player_id"],
        profileurl: json["user_profile_url"]);
  }
}
