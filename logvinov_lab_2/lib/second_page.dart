import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Bacon> fetchBacon(String url) async {
  print(url);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Bacon.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Bacon');
  }
}

class Bacon {
  final String text;

  const Bacon({required this.text});

  factory Bacon.fromJson(List<dynamic> json) {
    return Bacon(text: json.join(" "));
  }
}

class TextPage extends StatefulWidget {
  final String? type;
  final int? sentences;

  const TextPage({Key? key, required this.type, required this.sentences})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TextPage> {
  late Future<Bacon> futureBacon;

  @override
  void initState() {
    super.initState();
    futureBacon = fetchBacon('https://baconipsum.com/api/?type=' +
        widget.type.toString() +
        '&sentences=' +
        widget.sentences.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Bacon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Your Text'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Column(
            children: [
              FutureBuilder<Bacon>(
                future: futureBacon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!.text,
                      textAlign: TextAlign.justify,
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(
                width: 10.0,
                height: 30.0,
              ),
              BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          )),
        ),
      ),
    );
  }
}
