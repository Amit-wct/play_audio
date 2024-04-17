import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:play_audio/player.dart';
import 'dart:async';

import 'package:play_audio/player2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Player(
          // url: 'https://www2.cs.uic.edu/~i101/SoundFiles/gettysburg10.wav'
          ),
    );
  }
}
