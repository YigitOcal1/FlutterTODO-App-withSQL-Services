import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'todo.dart';
import 'home.dart';
import 'createuser.dart';

Future<User> loginUser(String name, String password) async {
  if (name == "" || password == "") {
    AlertDialog(
        title: const Text('AlertDialog '), content: const Text(' ERROR'));
  }
  Map<String, dynamic> data = {
    "user_name_unique": name,
    "user_password": password
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
    print("body decode deneme   " + jsonDecode(response.body).toString());
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to get user.');
  }
}

class User {
  final String name;
  final String? password;
  final String? playerid;
  final String? profileurl;

  User({required this.name, this.password, this.playerid, this.profileurl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['pro'].toString(),
        password: json["user_password"],
        playerid: json["user_player_id"],
        profileurl: json["user_profile_url"]);
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  Future<User>? _futureUser;

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.amberAccent[100],
        appBar: AppBar(
          backgroundColor: (Colors.orange[300]),
          title: Text('Login'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(title: 'Home')));
              },
              icon: Icon(Icons.home),
              //tooltip: 'Go to home',
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateUserPage()));
                },
                icon: Icon(Icons.app_registration_rounded)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: Icon(Icons.login)),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    minimumSize: Size(85.0, 40.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0))),
                child: Text('BACK'),
              ),
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureUser == null) ? buildColumn() : buildFutureBuilder(),
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
          decoration: InputDecoration(hintText: 'Enter Username'),
          //scrollPadding: EdgeInsets.all(100.0),
        ),
        TextField(
          controller: _controller2,
          decoration: InputDecoration(hintText: 'Enter Password'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.cyanAccent,
              minimumSize: Size(155.0, 45.0),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(100.0))),
          onPressed: () {
            setState(() {
              _futureUser = loginUser(_controller.text, _controller2.text);
            });
          },
          child: Text('Login'),
        ),
      ],
    );
  }

  FutureBuilder<User> buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AlertDialog(
            title: const Text('AlertDialog'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Successfully logged in'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TodoPage()),
                  );
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: const Text('AlertDialog'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Login failed.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(title: 'Home')),
                  );
                },
              ),
            ],
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
