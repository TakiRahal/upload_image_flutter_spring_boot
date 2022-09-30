import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:upload_images/add-item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      routes: {
      '/': (context) => MyHomePage(title: 'Default'),
      '/home': (context) => MyHomePage(title: 'Default'),
      '/add': (context) => AddItemPage()
      },
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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

class _MyHomePageState extends State<MyHomePage> {
  dynamic pageOffers;

  Future<dynamic> fetchOffers() async {
    var url = Uri.parse('http://192.168.110.96:8080/api/offer/list');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print('jsonResponse ${jsonResponse}');
      setState(() {
        this.pageOffers = jsonResponse;

        print('pageOffers ${this.pageOffers['totalElements']}');
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }


  @override
  void initState() {
    fetchOffers();
    super.initState();
  }

  String getFullUrl(num offerId, String nameImage){
    return 'http://192.168.110.96:8080/api/offer/image/${offerId}/${nameImage}';
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
          itemCount: this.pageOffers != null ? this.pageOffers['totalElements'] : 0,
          itemBuilder: (item, index) {
            if( this.pageOffers==null ){
              return Text('Loading');
            }
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Image.network(getFullUrl(this.pageOffers['content'][index]['id'], this.pageOffers['content'][index]['imagesOffer'][0]['name']), width: 100,),
                ),
                Column(
                  children: [
                    Text(
                      this.pageOffers['content'][index]['title'],
                      style: TextStyle(color: Colors.red, fontSize: 25),
                    ),
                    Text(this.pageOffers['content'][index]['description'])
                  ],
                )

              ],
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(
            context,
            '/add'
          ).then((_) {
            print('callback');
            fetchOffers();
          });
//          Navigator.of(context).push(MaterialPageRoute(
//              builder: (BuildContext context) => AddItemPage()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
