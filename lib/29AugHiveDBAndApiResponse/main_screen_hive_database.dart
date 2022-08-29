import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sqflite_database/29AugHiveDBAndApiResponse/models/apidata.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';

import 'package:http/http.dart' as http;

class MainScreenHiveDatabase extends StatelessWidget {
  const MainScreenHiveDatabase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('==> : ${Hive.box(settingsBox).get("welcome_shown")}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: const Text('Hive And API'),
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box(settingsBox).listenable(),
        builder: (context, box, child) =>
            box.get('welcome_shown', defaultValue: false)
                ? const HomePage()
                : const WelcomePage(),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('WelcomePage'),
            ElevatedButton(
              onPressed: () async {
                var box = Hive.box(settingsBox);
                box.put("welcome_shown", true);
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HomePage'),
      ),
      body: FutureBuilder<List<ApiData>>(
        future: ApiService().getPost(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text('id : ${snapshot.data!.elementAt(index).id}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ApiService {
  Future<List<ApiData>> getPost() async {
    final res = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    final resJson = jsonDecode(res.body);

    List<ApiData> x = List<ApiData>.from(
      resJson.map(
        (e) => ApiData.fromJson(e),
      ),
    ).toList();

    // store in hive
    Hive.box(apiBox).put('bhuru', x);
    return x;
  }
}
