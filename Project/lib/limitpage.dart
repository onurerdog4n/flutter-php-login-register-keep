import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class LPage extends StatefulWidget {
  @override
  _LPState createState() => _LPState();
}

class _LPState extends State<LPage> {
  String apiUrl =
      "https://onurerdogan.com.tr/demo/mobilservis/veri-page.php?sayfa=1&userId=" +
          GetStorage().read("userId");
  int pageNo = 1;
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List albums = List();
  void _fetchData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List albumList = List();
        var resultBody;
        pageNo = pageNo + 1; // resetting and incrementing page
        apiUrl =
            "https://onurerdogan.com.tr/demo/mobilservis/veri-page.php?sayfa=$pageNo&userId=" +
                GetStorage().read("userId");
        resultBody = jsonDecode(response.body);
        for (int i = 0; i < resultBody.length; i++) {
          albumList.add(resultBody[i]);
        }
        setState(() {
          isLoading = false;
          albums.addAll(albumList);
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    this._fetchData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList() {
    return albums.length == 0
        ? Center(
            child: Container(
              child: Text(
                'Veri Yok',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          )
        : ListView.builder(
            itemCount: albums.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == albums.length) {
                return _buildProgressIndicator();
              } else {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text((albums[index]['icerik'])),
                      onTap: () {
                        print(albums[index]);
                      },
                    ),
                  ),
                );
              }
            },
            controller: _scrollController,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
