import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:php_mysql_login_register/main.dart';
import 'package:http/http.dart' as http;

Future<List<Data>> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://onurerdogan.com.tr/demo/mobilservis/vericek.php?userId=' +
          GetStorage().read("userId")));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    if (jsonResponse.length == 0) {
      throw 'Gösterilecek Veri Yok';
    } else {
      return jsonResponse.map((data) => new Data.fromJson(data)).toList();
    }
  } else {
    throw Exception('Veriler çekilirken bir hata oluştu!');
  }
}

class Data {
  final String userId;
  final String id;
  final String title;

  Data({this.userId, this.id, this.title});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'],
      id: json['id'],
      title: json['icerik'],
    );
  }
}

class DashBoard extends StatefulWidget {
  DashBoard({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<DashBoard> {
  Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter API and ListView Example',
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            GetStorage().remove("userId");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
          child: Text("cıkıs"),
        ),
        body: Center(
          child: FutureBuilder<List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Data> data = snapshot.data;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 75,
                        color: Colors.white,
                        child: Center(
                          child: Text(data[index].title),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
