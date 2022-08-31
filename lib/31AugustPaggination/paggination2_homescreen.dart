import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Paggination2HomeScreen extends StatefulWidget {
  const Paggination2HomeScreen({Key? key}) : super(key: key);

  @override
  State<Paggination2HomeScreen> createState() => _Paggination2HomeScreenState();
}

class _Paggination2HomeScreenState extends State<Paggination2HomeScreen> {
  final String _baseUrl = "https://jsonplaceholder.typicode.com/photos";
  int _page = 1;
  final int _limit = 10;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List _posts = [];

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final res = await http.get(
        Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"),
      );
      if (res.statusCode == 200) {
        setState(() {
          _posts = jsonDecode(res.body);
        });
        log('receivedData : ${jsonDecode(res.body)}');
      }
    } catch (e) {
      if (kDebugMode) {
        log('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page++;

      try {
        final res = await http.get(
          Uri.parse('$_baseUrl?_page=$_page&_limit=$_limit'),
        );

        log('url : $_baseUrl?_page=$_page&_limit=$_limit');
        if (res.statusCode == 200) {
          final List fetchedPost = jsonDecode(res.body);
          if (fetchedPost.isNotEmpty) {
            setState(() {
              _posts.addAll(fetchedPost);
            });
          } else {
            setState(() {
              _hasNextPage = false;
            });
          }
        }
      } catch (e) {
        if (kDebugMode) {
          log('something went wrong');
        }
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // the controller for listyView
  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Paggination',
          style: TextStyle(
            color: Colors.black.withOpacity(0.52),
            fontSize: 20,
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      body: _isFirstLoadRunning
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.black.withOpacity(0.25),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _controller
                      ..addListener(() async {
                        if (_controller.position.pixels >
                            _controller.position.maxScrollExtent) {
                          _loadMore();
                        }
                      }),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.065),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID : ${_posts.elementAt(index)['id']}',
                          ),
                          Text(
                            'AlbumID : ${_posts.elementAt(index)['albumId']}',
                          ),
                          Text(
                            'Title : ${_posts.elementAt(index)['title']}',
                            textAlign: TextAlign.justify,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Image.network(
                                  _posts.elementAt(index)['url'],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Image.network(
                                  _posts.elementAt(index)['thumbnailUrl'],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // when the _loadMore running
                if (_isLoadMoreRunning == true)
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.amberAccent,
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),

                if (_hasNextPage == false)
                  SafeArea(
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      color: Colors.orangeAccent,
                      child: const Text('you get all'),
                    ),
                  )
              ],
            ),
    );
  }
}
