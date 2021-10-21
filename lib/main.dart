import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'video_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent,
    ),
  );
  runApp(
    MyApp(), // Wrap your app
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  final List<String> _ids = [
    'h_BbMPeZmjM',
  ];
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        loop: false,
        autoPlay: false,
      ),
    )
      ..addListener(listener);
  }
  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }
  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }
  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        onReady: () {
          _isPlayerReady = false;
        },
        onEnded: (data) {
          _isPlayerReady = false;
          _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
        },
      ),
      builder: (context, player) =>
      SafeArea(
    child:
          Scaffold(
            body: Column(
              children: [
                SizedBox(height: 16),
                Text("Get started with our \n step-by-step guide.",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(height: 26),
                Expanded(
                  child: player,
                ),
                Padding(
                  padding:EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text('1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                          ),
                          ),

                        ),
                      ),
                      SizedBox(width: 8),
                      Text("Postez votre message\nen vocal",
                        style: TextStyle(
                          fontSize: 21,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: (){print("i'm here");},
                        child: Row(
                          children: [
                            Text("Passer",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 21,
                              ),
                            ),
                            Image.asset("assets/passer.png",
                              width: 16,
                              height: 16,
                            )
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              ],
            ),

          ),
    ));
  }

 }
