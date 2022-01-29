import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChaptersnoList extends StatefulWidget {
  final String? bookName;
  final String? bookKey;

  const ChaptersnoList({
    Key? key,
    required String this.bookName,
    required this.bookKey, chapter,
  }) : super(key: key);

  @override
  _ChaptersnoListState createState() => _ChaptersnoListState();
}

class _ChaptersnoListState extends State<ChaptersnoList> {
  late Future<List> chaptersnoListFuture;

  Future<List> getChaptersnoList() async {
    var response = await http
        .get(Uri.parse("https://alquranbd.com/api/hadith/bukhari/1"));
    if (response.statusCode == 200) {
      print(response.body);
      List resData = jsonDecode(response.body);
      return resData;
    } else {
      throw Exception("Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chaptersnoListFuture = getChaptersnoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName!),
      ),
      body: Container(
        child: FutureBuilder(
          future: chaptersnoListFuture,
          builder: (BuildContext context, AsyncSnapshot<List> sn) {
            if (sn.hasData) {
              return ListView.builder(
                itemCount: sn.data!.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(sn.data![index]["bookId"]),
                    ),
                    title: Text(sn.data![index]["hadithBengali"]),
                    subtitle: Text(sn.data![index]["hadithArabic"]),
                  ),
                ),
              );
            } else if (sn.hasError) {
              return Text("Problem Loading Data");
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}