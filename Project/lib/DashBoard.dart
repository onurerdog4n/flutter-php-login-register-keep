import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:php_mysql_login_register/main.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GetStorage().remove("userId");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
        child: Text("cıkıs"),
      ),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(child: Text('Dashboard')),
    );
  }
}
