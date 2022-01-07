import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Todo {
  String? task;
  bool? done;

  Todo({this.task, this.done});

  Todo.fromJson(Map<String, dynamic> json) {
    task = json['task'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task'] = this.task;
    data['done'] = this.done;
    return data;
  }
}

class TodoPage extends StatefulWidget {
  var todos = <Todo>[];

  TodoPage() {
    todos = [];
  }

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  _TodoPageState() {
    load();
  }
  final TextEditingController _controller = TextEditingController();

  void add() {
    if (_controller.text.isEmpty) return;
    setState(() {
      widget.todos.add(Todo(task: _controller.text, done: false));
    });
    _controller.clear();
    save();
  }

  void delete(int index) {
    setState(() {
      widget.todos.removeAt(index);
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Todo> result = decoded.map((e) => Todo.fromJson(e)).toList();
      setState(() {
        widget.todos = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.todos));
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.pinkAccent[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Todo List'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  minimumSize: Size(85.0, 40.0),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(title: 'Home')),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
        body: Column(
          children: [
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                  labelText: "Enter your task",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )),
            ),
            Expanded(
              child: Center(
                child: ListView.builder(
                  itemCount: widget.todos.length,
                  itemBuilder: (context, index) {
                    final item = widget.todos[index];

                    return Dismissible(
                      key: Key(index.toString()),
                      child: CheckboxListTile(
                        title: Text(item.task.toString()),
                        value: item.done,
                        onChanged: (value) {
                          setState(() {
                            delete(index);
                            save();
                          });
                        },
                      ),
                      background: Container(
                        color: Colors.red.withOpacity(0.9),
                      ),
                      onDismissed: (direction) {
                        delete(index);
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: add,
          child: Icon(Icons.add),
          backgroundColor: Colors.blue[300],
        ),
      ),
    );
  }
}
