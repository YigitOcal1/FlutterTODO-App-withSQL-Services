import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<User> getUser(String name) async {
  Map<String, dynamic> data = {
    "user_name_unique": name,
  };

  var bodyEncode = jsonEncode(data);

  final response =
      await http.post(Uri.parse("https://mobiloby.com/******/*********"),
          headers: {
            "Content-Type": "application/json; charset=utf-8",
            "Accept": "application/json",
          },
          body: bodyEncode);

  print("Status code:   " + response.statusCode.toString());
  //print("Response body:   " + response.body.toString());

  if (response.statusCode == 200) {
    print("Response body:   " + response.body.toString());

    //print("body decode deneme   " + jsonDecode(response.body).toString());
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get user.');
  }
}

class User {
  final String name;
  final String? password;
  final String? playerid;
  final String? profileurl;
  final String? pro;

  User({
    required this.name,
    this.password,
    this.playerid,
    this.profileurl,
    this.pro,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        pro: json["pro"].toString(),
        name: json["pro"].toString(),
        password: json["user_password"].toString(),
        playerid: json["user_player_id"].toString(),
        profileurl: json["user_profile_url"].toString());
  }
}

class GetUserPage extends StatefulWidget {
  GetUserPage({Key? key}) : super(key: key);

  @override
  _GetUserPageState createState() => _GetUserPageState();
}

class _GetUserPageState extends State<GetUserPage> {
  final TextEditingController _controller = TextEditingController();
  Future<User>? _futureUser;

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.lightGreenAccent,
        appBar: AppBar(
          title: Text('Get User'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    minimumSize: Size(85.0, 40.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('BACK'),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: (_futureUser == null) ? buildColumn() : buildFutureBuilder(),
          ),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'Enter User Unique Name'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey,
              minimumSize: Size(135.0, 40.0),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(50.0))),
          onPressed: () {
            setState(() {
              _futureUser = getUser(_controller.text);
            });
          },
          child: Text('Get User'),
        ),
      ],
    );
  }

  FutureBuilder<User> buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        //print(_futureUser);
        if (snapshot.hasData) {
          return Text(
            snapshot.data!.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return CircularProgressIndicator();
      },
    );
  }
}
