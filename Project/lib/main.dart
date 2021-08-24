import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:php_mysql_login_register/register.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'page.dart';
import 'dart:ui';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GetStorage().read("userId") != null ? MainPage() : MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  login() async {
    var url = "https://onurerdogan.com.tr/demo/mobilservis/login.php";
    final res = await http.post(Uri.parse(url),
        body: {"username": user.text, "password": pass.text});
    final data = jsonDecode(res.body);

    //  GetStorage().remove("userId"); //cıkıs

    if (data['msg'] == "Success") {
      GetStorage().write("userId", data['token_id']); //logın

      FlutterToast(context).showToast(
          child: Container(
        alignment: Alignment.center,
        color: Colors.green,
        padding: EdgeInsets.all(10.0),
        child: new Text(
          "Giriş Başarılı",
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
    } else {
      FlutterToast(context).showToast(
          child: Container(
        alignment: Alignment.center,
        color: Colors.red,
        padding: EdgeInsets.all(10.0),
        child: new Text(
          "Kullanıcı adı veya şifre yanlış",
          textDirection: TextDirection.ltr,
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }

  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
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
              'Giriş Yap',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )),
            Center(
              child: Text(
                'Onur App V1 Giriş ekranına hoşgeldiniz',
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Username Field must not be empty';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        labelText: 'Kullanıcı Adı',
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
                          return 'Password Field must not be empty';
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
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 70,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Şifremi unuttum?",
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.grey[600]),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textColor: Colors.white,
                        onPressed: () {
                          print(
                            "Forgot Passworda Clicked",
                          );
                        },
                      ),
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
                        child: Text('Giriş Yap'),
                        color: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textColor: Colors.white,
                        onPressed: () {
                          login();
                        },
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(30),
                      child: Text('Halen kayıtlı değil misin? KAYIT OL'),
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
