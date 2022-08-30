import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PagginationHomePage extends StatefulWidget {
  const PagginationHomePage({Key? key}) : super(key: key);

  @override
  State<PagginationHomePage> createState() => _PagginationHomePageState();
}

class _PagginationHomePageState extends State<PagginationHomePage> {
  final _baseUrl = 'https://jsonplaceholder.typicode.com/comments';
  int _page = 0;
  final int _limit = 10;
  bool _isFirstLoadRunning = false;
  List posts = [];

  bool _haseNextPage = true;
  bool _isLoadingMoreRunning = false;

  void _loadMoreData() async {
    if (_haseNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadingMoreRunning == false) {
      setState(() {
        _isLoadingMoreRunning = true;
      });
      _page++;

      try {
        final res = await http.get(
          Uri.parse(_baseUrl + "?_page=$_page&_limit=$_limit"),
        );
        log('resUrl  : ${_baseUrl + "?_page=$_page&_limit=$_limit"}');
        log('resCode : ${res.statusCode}');
        log('resBody : ${res.body}');
        if (res.statusCode == 200) {
          final fetchPosts = jsonDecode(res.body);
          if (fetchPosts.isNotEmpty) {
            setState(() {
              posts.addAll(fetchPosts);
            });
          } else {
            setState(() {
              _haseNextPage = false;
            });
          }
        }
      } catch (e) {
        if (kDebugMode) {
          log("catchError : $e");
        }
      }
      setState(() {
        _isLoadingMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final res = await http.get(
        Uri.parse(_baseUrl + "?_page=$_page&_limit=$_limit"),
      );
      log('resUrl  : ${_baseUrl + "?_page=$_page&_limit=$_limit"}');
      log('resCode : ${res.statusCode}');
      log('resBody : ${res.body}');
      if (res.statusCode == 200) {
        setState(() {
          posts = jsonDecode(res.body);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        log("catchError : $e");
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMoreData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        elevation: 0.0,
        backgroundColor: Colors.orange,
        title: const Text('Paggination'),
      ),
      body: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 1.2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 17, vertical: 5),
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(6),
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID : ${posts.elementAt(index)['id']}'),
                                Text(
                                    'PosterID : ${posts.elementAt(index)["postId"]}'),
                                Text(
                                  'name : ${posts.elementAt(index)['name']}',
                                  textAlign: TextAlign.justify,
                                ),
                                Text(
                                    "Email : ${posts.elementAt(index)['email']}"),
                                Text(
                                  'Description : ${posts.elementAt(index)['body']}',
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                if (_isLoadingMoreRunning == true)
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: MediaQuery.of(context).viewPadding.bottom + 10,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (_haseNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: Colors.orangeAccent,
                    child: const Center(
                      child: Text('you get all'),
                    ),
                  ),
              ],
            ),
    );
  }
}
