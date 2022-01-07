import 'package:flutter/material.dart';
import 'getuser.dart';
import 'createuser.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _currentWidget = Container();
  var _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  void _loadScreen() {
    switch (_currentIndex) {
      case 0:
        return setState(() => _currentWidget = HomePage(title: 'home'));
      case 1:
        return setState(() => _currentWidget = LoginPage());
      case 2:
        return setState(() => _currentWidget = CreateUserPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Todo App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(title: 'Home')));
                },
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Login'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Register'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateUserPage()));
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.tealAccent,
        appBar: AppBar(
          backgroundColor: (Colors.blue[300]),
          title: Text('Home'),
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(Icons.menu_rounded)),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(title: 'Home')));
              },
              icon: Icon(Icons.home),
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
                icon: Icon(Icons.login))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrangeAccent,
                    minimumSize: Size(155.0, 45.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100.0))),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.pinkAccent,
                    minimumSize: Size(155.0, 45.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100.0))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateUserPage()));
                },
                child: Text('Register'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.yellowAccent,
                    minimumSize: Size(155.0, 45.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(100.0))),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GetUserPage()));
                },
                child: Text('Get User'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.tealAccent,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _loadScreen();
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.login), label: 'login'),
            BottomNavigationBarItem(
                icon: Icon(Icons.app_registration), label: 'register')
          ],
        ),
      ),
    );
  }
}
