import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:php_mysql_login_register/page.dart';
import 'main.dart';
import 'package:get_storage/get_storage.dart';

main() async {
  await GetStorage.init();
  runApp(Register());
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future register() async {
    var url = "https://onurerdogan.com.tr/demo/mobilservis/register.php";
    var response = await http.post(Uri.parse(url), body: {
      "username": user.text,
      "password": pass.text,
    });
    var data = json.decode(response.body);
    if (data['msg'] == "Error") {
      FlutterToast(context).showToast(
          child: Container(
        alignment: Alignment.center,
        color: Colors.red,
        padding: EdgeInsets.all(10.0),
        child: new Text(
          "Kullanıcı adı kullanılıyor",
          textDirection: TextDirection.ltr,
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else if (data['msg'] == "EmptyError") {
      FlutterToast(context).showToast(
          child: Container(
        alignment: Alignment.center,
        color: Colors.red,
        padding: EdgeInsets.all(10.0),
        child: new Text(
          "Kullanıcı adı veya şifre boş bırakılamaz",
          textDirection: TextDirection.ltr,
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      GetStorage().write("userId", data['token_id']);

      FlutterToast(context).showToast(
          child: Container(
        alignment: Alignment.center,
        color: Colors.green,
        padding: EdgeInsets.all(10.0),
        child: new Text(
          "Kayıt Başarılı",
          textDirection: TextDirection.ltr,
          style: TextStyle(color: Colors.white),
        ),
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(),
        ),
      );
    }
  }

  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              width: 50,
              padding: EdgeInsets.only(bottom: 30),
              child: Image.asset('assets/youtube.png'),
            ),
            Center(
                child: Text(
              'Kayıt Ol',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )),
            Center(
              child: Text(
                'Onur App V1 Kayıt Ol',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 80, left: 40, right: 40),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Kullanıcı adı boş bırakılamaz';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        labelText: 'Kullanıcı adı',
                        border: OutlineInputBorder(),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 10.0),
                      ),
                      controller: user,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .nextFocus(), // move focus to next
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .nextFocus(), // move focus to next
                      obscureText: !_showPassword,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Şifre boş bırakılamaz';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Şifre",
                        border: OutlineInputBorder(),
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 10.0),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _togglevisibility();
                          },
                          child: Container(
                            height: 50,
                            width: 70,
                            padding: EdgeInsets.symmetric(vertical: 13),
                            child: Center(
                              child: Text(
                                _showPassword ? "Gizle" : "Göster",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      controller: pass,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 70,
                        child: Text('Kayıt Ol'),
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textColor: Colors.white,
                        onPressed: () {
                          register();
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(30),
                      child: Text('Zaten üye misin? Giriş Yap'),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
