import 'dart:convert';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

main() async {
  await test();
  runApp(const MyApp());
}

const String _doSsaUrl = 'corearoadbike.com';
List<Map<String, dynamic>> _keywords = [];

void Init() {
  _keywords = [];
  test();
}

test() async {
  var url = Uri.https(_doSsaUrl, '/board/board.php', {'t_id': 'Menu01Top6'});

// Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  print('Response status: ${response.statusCode}');

  dom.Document documnet = parser.parse(response.body);

  var keywordElements = documnet.querySelectorAll('table');

  List<dom.Element?> lstTable = [];

  for (var element in keywordElements) {
    if (element.querySelector('.list_title_B') != null &&
        element.querySelector('.list_content_B') != null &&
        element.querySelector('.list_title_B')?.nodes.length == 7) {
      lstTable.add(element);

      var contentTxt =
          element.querySelector('.list_content_B')?.nodes[0].toString();
      var strFirstIndex = contentTxt?.indexOf('1. 판매');
      var strSecondIndex = contentTxt?.indexOf('2. 사이즈');
      var strThirdIndex = contentTxt?.indexOf('3. 사용기간');
      var strFourthIndex = contentTxt?.indexOf('4. 물건상세설명');

      String? price, size, useDate, detailDesc;

      if (strFirstIndex == -1 || strSecondIndex == -1) {
        price = '';
      } else {
        price = contentTxt?.substring(strFirstIndex!, strSecondIndex).trim().replaceAll('&gt;', '>');
      }

      if (strSecondIndex == -1 || strThirdIndex == -1) {
        size = '';
      } else {
        size = contentTxt?.substring(strSecondIndex!, strThirdIndex).trim();
      }

      if (strThirdIndex == -1 || strFourthIndex == -1) {
        useDate = '';
      } else {
        useDate = contentTxt?.substring(strThirdIndex!, strFourthIndex).trim();
      }

      if (strFourthIndex == -1) {
        detailDesc = '';
      } else {
        detailDesc = contentTxt?.substring(strFourthIndex!).trim();
      }

      var strTime = element
          .querySelector('tr > .list_title_B')
          ?.parentNode
          ?.nodes[3]
          .nodes[1]
          .toString();

      var title = element.querySelector('.list_title_B')?.nodes[4].attributes['title'];
      var time = strTime?.substring(strTime.indexOf('|') + 1, strTime.lastIndexOf('|')).trim();

      var contains = false;

      for(var item in _keywords){
        if(item['title'] == title && item['time'] == time) {
          contains = true;
          break;
        }
      }

      if(contains){
        continue;
      }

      _keywords.add({
        'title' : title,
        'img': element.querySelector('img')?.attributes['src'],
        'url': element.querySelector('a')?.attributes['href']?.substring(1),
        'price': price,
        'size': size,
        'use_date': useDate,
        'detail_desc': detailDesc,
        'time': time
      });
    }
  }
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
      home: const MyHomePage(title: 'Used Bike List'),
    );
  }
}

class BikeTile extends StatelessWidget {
  BikeTile(this._bikeInfo);

  final Map<String, dynamic> _bikeInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
    // leading: Image.network('https://$_doSsaUrl' + _bikeInfo['img']),

      leading: Image.network('https://corearoadbike.com/data/file/Menu01Top6/view/1668159635078_Bl1Qj.jpg',
        height: 500,
        fit: BoxFit.contain,),
      // leading: ExtendedImage.network(
      //   'https://' + _doSsaUrl + _bikeInfo['img'],
      //   width: 100,
      //   cache: true,
      // ),
      title: Text(_bikeInfo['title']),
      subtitle: Text(_bikeInfo['time']+'\n'+_bikeInfo['price']+'\n'+_bikeInfo['size']+'\n'+_bikeInfo['use_date']+'\n'+_bikeInfo['detail_desc']),
      onTap: (){
      //  html.window.open('https://$_doSsaUrl' + _bikeInfo['url'], 'new tab');
        js.context.callMethod('open', ['https://$_doSsaUrl' + '/board' + _bikeInfo['url']]);
      },
      //trailing: PersonHandIcon(_bikeInfo.isLeftHand),
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

class UsingseparatedBuilderListConstructing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _keywords.length,
        itemBuilder: (BuildContext context, int index) {
          return BikeTile(_keywords[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        });
  }
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: const FloatingActionButton(
        onPressed: Init,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
