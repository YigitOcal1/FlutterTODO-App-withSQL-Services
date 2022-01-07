import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'login.dart';

Future<User>? createUser(
    String name, String password, String id, String profileurl) async {
  if (name == "") {
    return User.fromJson(jsonDecode(""));
  } else {
    Map<String, dynamic> data = {
      "user_name_unique": name,
      "user_password": password,
      "player_id": id,
      "user_profile_url": profileurl
    };

    var bodyEncode = jsonEncode(data);

    final response = await http.post(
        Uri.parse("https://mobiloby.com/******/*********"),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Accept": "application/json",
        },
        body: bodyEncode);

    print("Status code:   " + response.statusCode.toString());
    print("Response body:   " + response.body.toString());

    if (response.statusCode == 200) {
      print(response.body.toString());
      print((jsonDecode(response.body)).toString());

      print("afsafas  " + User.fromJson(jsonDecode(response.body)).toString());
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
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
        name: json["user_name_unique"].toString(),
        password: json["user_password"].toString(),
        playerid: json["user_player_id"].toString(),
        profileurl: json["user_profile_url"].toString());
  }
}

class CreateUserPage extends StatefulWidget {
  CreateUserPage({Key? key}) : super(key: key);

  @override
  _CreateUserPageState createState() {
    return _CreateUserPageState();
  }
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  Future<User>? _futureUser;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFD7CCC8),
        appBar: AppBar(
          backgroundColor: (Colors.grey[300]),
          title: Text('Register'),
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
                style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    minimumSize: Size(85.0, 40.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0))),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
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
          decoration: InputDecoration(hintText: 'Enter Name'),
        ),
        TextField(
          controller: _controller2,
          decoration: InputDecoration(hintText: 'Enter Password'),
        ),
        TextField(
          controller: _controller3,
          decoration: InputDecoration(hintText: 'Enter Playerid'),
        ),
        TextField(
          controller: _controller4,
          decoration: InputDecoration(hintText: 'Enter Profileurl'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blueAccent,
              minimumSize: Size(155.0, 45.0),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(100.0))),
          onPressed: () {
            setState(() {
              _futureUser = createUser(_controller.text, _controller2.text,
                  _controller3.text, _controller4.text);
            });
            if (_controller.text == "") {}
          },
          child: Text('Register'),
        ),
      ],
    );
  }

  FutureBuilder<User> buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.hasData == "") {
            return AlertDialog(
              title: const Text('AlertDialog'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Registration is unsuccessful'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else
            return AlertDialog(
              title: const Text('AlertDialog'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Registration successful'),
                    Text(
                        'Now you will moved to home page to be able to login please click the "OK" button')
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
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
                  Text('Error occured during registration.'),
                  Text('Try again.')
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
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
