import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioPlayer audioPlayer = AudioPlayer();
  String audioUrl =
      'https://www.dwsamplefiles.com/?dl_id=531'; // Replace with your API URL
  String? audioFilePath;
  Duration duration = Duration();
  Duration position = Duration();
  double sliderpos = 0.0;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((event) {});
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        audioPlayer.stop();
        position = Duration();
      });
    });

    audioPlayer.onDurationChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });
  }

  void toastmsg(String msg) {
    MotionToast toast = MotionToast.success(
      description: Text(
        '$msg',
        style: TextStyle(fontSize: 12),
      ),
      layoutOrientation: ToastOrientation.ltr,
      animationType: AnimationType.fromRight,
      dismissable: true,
      position: MotionToastPosition.bottom,
    );
    toast.show(context);
  }

  void _playAudio() async {
    try {
      // await audioPlayer.play(DeviceFileSource(audioFilePath!));
      await audioPlayer.play(
          UrlSource('https://www2.cs.uic.edu/~i101/SoundFiles/preamble10.wav'));

      Duration pos = (await audioPlayer.getCurrentPosition())!;
      setState(() {
        // Update the slider value when starting audio
        // position = pos;
        sliderpos = pos.inSeconds.toDouble();
      });
      toastmsg('playing');
    } catch (e) {
      print(e);

      toastmsg('erorr : $e');
    }
  }

  void _pauseAudio() {
    audioPlayer.pause();
    print('paused');
  }

  void _stopAudio() {
    audioPlayer.stop();
  }

  void _seekAudio(double value) {
    audioPlayer.seek(Duration(seconds: value.toInt()));
    setState(() {
      position = Duration(seconds: value.toInt());
      sliderpos = position.inSeconds.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Player"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _playAudio,
              child: Text("Play"),
            ),
            ElevatedButton(
              onPressed: _pauseAudio,
              child: Text("Pause"),
            ),
            ElevatedButton(
              onPressed: _stopAudio,
              child: Text("Stop"),
            ),
            Slider(
              value: sliderpos,
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _seekAudio(value);
                  sliderpos = value;
                });
                print(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
