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

  @override
  void initState() {
    super.initState();
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

  Future<void> _downloadAudio() async {
    // Download the audio file
    var response = await http.get(Uri.parse(audioUrl));
    print('hello');
    if (response.statusCode == 200) {
      // Save the audio to a temporary file
      print('downloaded');
      final audioData = response.bodyBytes;
      final appDir = await getApplicationDocumentsDirectory();
      audioFilePath = '${appDir.path}/audio1.wav';
      print(audioFilePath);
      final tempFile = File(audioFilePath!);
      try {
        await tempFile.writeAsBytes(audioData);
        print('File written successfully');
        MotionToast toast = MotionToast.success(
          // title: const Text(
          //   'Info',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          description: const Text(
            'downloaded',
            style: TextStyle(fontSize: 12),
          ),
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromRight,
          dismissable: true,
          position: MotionToastPosition.bottom,
        );
        toast.show(context);
      } catch (e) {
        print('Error writing file: $e');
      }
    } else {
      print('not downloaded');
    }

    runCurl();
  }

  void _playAudio() async {
    if (audioFilePath != null) {
      try {
        await audioPlayer.play(DeviceFileSource(audioFilePath!));
        Duration pos = (await audioPlayer.getCurrentPosition())!;
        setState(() {
          // Update the slider value when starting audio
          position = pos;
        });
        MotionToast toast = MotionToast.success(
          // title: const Text(
          //   'Info',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          description: const Text(
            'playing',
            style: TextStyle(fontSize: 12),
          ),
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromRight,
          dismissable: true,
          position: MotionToastPosition.bottom,
        );
        toast.show(context);
      } catch (e) {
        print(e);
        MotionToast toast = MotionToast.success(
          // title: const Text(
          //   'Info',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          description: Text(
            'erorr : $e',
            style: TextStyle(fontSize: 12),
          ),
          layoutOrientation: ToastOrientation.ltr,
          animationType: AnimationType.fromRight,
          dismissable: true,
          position: MotionToastPosition.bottom,
        );
        toast.show(context);
      }
    }
    // audioPlayer.play(AssetSource('bubbling1.wav'));
  }

  void _pauseAudio() {
    audioPlayer.pause();
  }

  void _stopAudio() {
    audioPlayer.stop();
    position = Duration();
  }

  void _seekAudio(double value) {
    audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  void runCurl() async {
    String curlCommand =
        'curl -s -u "tsimisd@warmconnect.in:8U324433D1" "https://files.warmconnect.in/tsimisd/CALL_RECORDINGS/Nov2023/06/1699272594.81976364824_08433910811_919870145601_2023_11_06.wav" -o /data/user/0/com.example.play_audio/app_flutter/output.wav';

    try {
      ProcessResult result = await Process.run('sh', ['-c', curlCommand]);

      if (result.exitCode == 0) {
        print('Command output: ${result.stdout}');
      } else {
        print('Command failed with exit code ${result.exitCode}');
        print('Error: ${result.stderr}');
      }
    } catch (error) {
      print('Error: $error');
    }
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
              onPressed: _downloadAudio,
              child: Text("Download"),
            ),
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
              value: position.inSeconds.toDouble(),
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _seekAudio(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
