import 'package:flutter/material.dart';
import 'package:php_mysql_login_register/DashBoard.dart';
import 'package:php_mysql_login_register/insertdata.dart';
import 'package:get_storage/get_storage.dart';
import 'package:php_mysql_login_register/main.dart';

class MainPage extends StatefulWidget {
  @override
  _Page createState() => _Page();
}

class _Page extends State<MainPage> {
  int index = 0;
  List bodyPages = [
    DashBoard(),
    InsertData(),
    DashBoard(),
    DashBoard(),
    DashBoard(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AppBar Demo'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'Çıkış',
              onPressed: () {
                GetStorage().remove("userId");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (i) {
            setState(() {
              index = i;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.ac_unit,
                color: Colors.black,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.ac_unit,
                color: Colors.black,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.ac_unit,
                color: Colors.black,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.ac_unit,
                color: Colors.black,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.ac_unit,
                color: Colors.black,
              ),
              label: "",
            )
          ],
        ),
        body: bodyPages[index]);
  }
}
