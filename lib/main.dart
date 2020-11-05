import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Feeds>> post;

  @override
  void initState() {
    super.initState();
    post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter REST API Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter REST API Example'),
        ),
        body: new ListView.builder(
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              margin: EdgeInsets.only(left: 8,top: 8,bottom: 8,right: 8),
              child: Padding(
                padding: EdgeInsets.only(left: 16,top: 16,bottom: 16,right: 16),
                child: Center(
                  child:  FutureBuilder<List<Feeds>>(
                    future: post,
                    builder: (context, dataList) {
                      if (dataList.hasData) {
                        return Text("Temp. :- " + dataList.data[index].field1
                            .toString(), style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),); //Text(abc.data);
                      } else if (dataList.hasError) {
                        return Text("${dataList.error}");
                      }
                      // By default, it show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<List<Feeds>> fetchPost() async {
  final response = await http.get(
      'https://api.thingspeak.com/channels/1215324/feeds.json?api_key=your-api-key-here');

  if (response.statusCode == 200) {
    // If the call to the server was successful (returns OK), parse the JSON.
    var res = json.decode(response.body);
    var notes = List<Feeds>();

    for (var resjson in res["feeds"]) {
      notes.add(Feeds.fromJson(resjson));
    }
    return notes;
  } else {
    // If that call was not successful (response was unexpected), it throw an error.
    throw Exception('Failed to load post');
  }
}

class Data {
  Channel channel;
  List<Feeds> feeds;

  Data({this.channel, this.feeds});

  Data.fromJson(Map<String, dynamic> json) {
    channel =
    json['channel'] != null ? new Channel.fromJson(json['channel']) : null;
    if (json['feeds'] != null) {
      feeds = new List<Feeds>();
      json['feeds'].forEach((v) {
        feeds.add(new Feeds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.channel != null) {
      data['channel'] = this.channel.toJson();
    }
    if (this.feeds != null) {
      data['feeds'] = this.feeds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Channel {
  int id;
  String name;
  String description;
  String latitude;
  String longitude;
  String field1;
  String field2;
  String createdAt;
  String updatedAt;
  int lastEntryId;

  Channel(
      {this.id,
        this.name,
        this.description,
        this.latitude,
        this.longitude,
        this.field1,
        this.field2,
        this.createdAt,
        this.updatedAt,
        this.lastEntryId});

  Channel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    field1 = json['field1'];
    field2 = json['field2'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastEntryId = json['last_entry_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['field1'] = this.field1;
    data['field2'] = this.field2;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['last_entry_id'] = this.lastEntryId;
    return data;
  }
}

class Feeds {
  String createdAt;
  int entryId;
  String field1;
  String field2;

  Feeds({this.createdAt, this.entryId, this.field1, this.field2});

  Feeds.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    entryId = json['entry_id'];
    field1 = json['field1'];
    field2 = json['field2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['entry_id'] = this.entryId;
    data['field1'] = this.field1;
    data['field2'] = this.field2;
    return data;
  }
}

