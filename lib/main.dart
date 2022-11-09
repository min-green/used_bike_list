import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

void main() async{
  test();
//  runApp(const MyApp());
}

void test() async{

  //var url = Uri.https('corearoadbike.com', '/board/board.php?t_id=Menu01Top6');
  //var url = Uri.https('corearoadbike.com/board/?g_id=recycle02');
  var url = Uri.https('corearoadbike.com', '/board/board.php', {'t_id':'Menu01Top6'});

// Await the http get response, then decode the json-formatted response.
  // var response = await http.get(url);
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  dom.Document documnet = parser.parse(response.body);

  var keywordElements = documnet.querySelectorAll('table');
  List<Map<String, dynamic>> keywords = [];
  keywordElements[91].querySelector('.list_content_B')?.nodes.toString();
  for (var element in keywordElements){
    var link1 = element.querySelectorAll('.list_title_B');
    var link2 = element.querySelectorAll('.list_content_B');
    var link3 = element.querySelectorAll('.list_content_B > img');

    // var link = element.querySelector('.list_title_B');
    // var rank = element.querySelector('.list_content_B');
    // var img = element.querySelector('.list_content_B > img');

    // keywords.add({
    //   'rank': rank!.text,
    //   'url' : link!.attributes['href'],
    //   'img' : img!.attributes['src']
    // });

    // print(keywords);
  }

  // if (response.statusCode == 200) {
  //   // 만약 서버가 OK 응답을 반환하면, JSON을 파싱합니다.
  //   return Post.fromJson(json.decode(response.body));
  // } else {
  //   // 만약 응답이 OK가 아니면, 에러를 던집니다.
  //   throw Exception('Failed to load post');
  // }
//  print(await http.read(Uri.https('example.com', 'foobar.txt')));
}

// class Post {
//   final int userId;
//   final int id;
//   final String title;
//   final String body;
//
//   Post({required this.userId,required this.id,required this.title,required this.body});
//
//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       userId: json['userId'],
//       id: json['id'],
//       title: json['title'],
//       body: json['body'],
//     );
//   }
// }

void add_person() {
  people.add(Person(10, "q", true));
  people.add(Person(20, "w", false));
  people.add(Person(30, "e", false));
  people.add(Person(40, "r", false));
  people.add(Person(50, "t", true));
  people.add(Person(60, "y", true));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

var people = [];

class Person {
  int age;
  String name;
  bool isLeftHand;

  Person(this.age, this.name, this.isLeftHand);
}

class PersonTile extends StatelessWidget {
  PersonTile(this._person);

  final Person _person;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
          "https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/1YN0/image/ak-gRe29XA2HXzvSBowU7Tl7LFE.png"),
      title: Text(_person.name),
      subtitle: Text("${_person.age}세"),
      trailing: PersonHandIcon(_person.isLeftHand),
    );
  }
}

class PersonHandIcon extends StatelessWidget {
  PersonHandIcon(this._isLeftHand, {super.key});

  bool _isLeftHand = true;

  @override
  Widget build(BuildContext context) {
    if (_isLeftHand)
      return Icon(Icons.arrow_left);
    else
      return Icon(Icons.arrow_right);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class HeaderTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
          "https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/1YN0/image/ak-gRe29XA2HXzvSBowU7Tl7LFE.png"),
    );
  }
}

class ExplicitListConstructing2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        PersonTile(people[0]),
        PersonTile(people[1]),
        PersonTile(people[2]),
        PersonTile(people[3]),
        PersonTile(people[4]),
        PersonTile(people[5]),
      ],
    );
  }
}

class UsingBuilderListConstructing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: people.length,
      itemBuilder: (BuildContext context, int index) {
        return PersonTile(people[index - 1]);
      },
    );
  }
}

class UsingseparatedBuilderListConstructing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: people.length,
        itemBuilder: (BuildContext context, int index) {
          return PersonTile(people[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        });
  }
}

class ExplicitListConstructing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.amber[600],
          child: const Center(child: Text('Entry A')),
        ),
        Container(
          height: 50,
          color: Colors.amber[500],
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          height: 50,
          color: Colors.amber[100],
          child: const Center(child: Text('Entry C')),
        ),
      ],
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    add_person();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: UsingseparatedBuilderListConstructing(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
