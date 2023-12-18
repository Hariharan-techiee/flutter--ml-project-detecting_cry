// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'package:firebase_storage/firebase_storage.dart';

void main() async {
  runApp(MaterialApp(home: RecordPage()));
}

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _hasRecording = false;
  bool _isRecordingInitialized = false;
  String? _path;
  bool _isPlaying = false;
  bool _isPaused = false;
  late Future<String> _predictionResultFuture;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initRecorder();
    _predictionResultFuture =
        Future.value(""); // Initialize with an empty string
  }

  _initRecorder() async {
    try {
      await _recorder!.openRecorder();
      await _player!.openPlayer();
      await _player!.setVolume(1.0);
      setState(() {
        _isRecordingInitialized = true;
      });
    } catch (e) {
      print("Error Happened: $e");
    }
  }

  Future<String> _sendForPrediction(String? filePath) async {
    if (filePath == null) {
      print('File path is null. Cannot send for prediction.');
      return 'Error: File path is null';
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'http://ec2-51-20-44-219.eu-north-1.compute.amazonaws.com:8080/predict'),
      );
      var file = await http.MultipartFile.fromPath(
        'audio',
        filePath,
        contentType: MediaType('audio', 'wav'),
      );
      request.files.add(file);

      var response = await request.send();

      if (response.statusCode == 200) {
        String predictionResult = await response.stream.bytesToString();
        print('Prediction response: $predictionResult');
        return predictionResult;
      } else {
        print('Prediction request failed with status: ${response.statusCode}');
        return 'Error: Prediction request failed';
      }
    } catch (e) {
      print('Error sending prediction request: $e');
      return 'Error: $e';
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecordingInitialized) {
      print('Ryecorder not initialized');
      return;
    }

    PermissionStatus status = await Permission.microphone.request();

    if (status.isGranted) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/myAudio.wav';
        await _recorder!.startRecorder(toFile: path);
        setState(() {
          _isRecording = true;
          _path = path;
        });
      } catch (e) {
        print('Error on Start Recording: $e');
      }
    } else {
      print('Microphone Permission not Granted');
    }
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
      _hasRecording = true;

      _predictionResultFuture = _sendForPrediction(_path);
      _uploadToFirebaseStorage(
          _path!, _predictionResultFuture); // Upload to Firebase Storage
    });
  }

  Future<void> _uploadToFirebaseStorage(
      String filePath, Future<String> predictionResultFuture) async {
    if (filePath == null) {
      print('File path is null. Cannot upload to Firebase Storage.');
      return;
    }

    try {
      File file = File(filePath);
      String predictionResult = await predictionResultFuture;

      // Extracting the prediction value from the result
      String prediction = '';
      if (predictionResult.isNotEmpty) {
        try {
          final Map<String, dynamic> resultJson = json.decode(predictionResult);
          prediction = resultJson['prediction'] ?? '';
        } catch (e) {
          print('Error decoding prediction JSON: $e');
        }
      }

      // Use prediction as the folder path if available
      String folderPath = prediction.isNotEmpty ? '$prediction/' : '';

      // Use prediction in the file name if available, else use DateTime.now()
      String fileName = prediction.isNotEmpty
          ? '${DateTime.now()}_$prediction.wav'
          : '${DateTime.now()}.wav';

      print('File name: $fileName');

      Reference ref = FirebaseStorage.instance.ref('$folderPath$fileName');

      UploadTask uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'audio/wav',
        ),
      );

      await uploadTask;

      String downloadURL = await ref.getDownloadURL();
      print('File uploaded to: $downloadURL');
    } catch (e) {
      print('Error uploading to Firebase Storage: $e');
    }
  }

  Future<void> _playRecording() async {
    if (_path != null) {
      await _player!.startPlayer(
        fromURI: _path!,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'WHYCRY',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/baby.jpeg', // Make sure to put your image in the correct path
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            if (_isRecording)
              ElevatedButton(
                onPressed: _stopRecording,
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                ),
                child: const Text('Stop Recording'),
              )
            else
              ElevatedButton(
                onPressed: _startRecording,
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                ),
                child: const Text('Start Recording'),
              ),
            if (_hasRecording && !_isPlaying)
              ElevatedButton(
                onPressed: _playRecording,
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                ),
                child: const Text('Play Recording'),
              ),
            // ... (Your existing buttons)
            FutureBuilder<String>(
              future: _predictionResultFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Container(
                    margin: EdgeInsets.all(16.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 30, 30, 31),
                      border: Border.all(
                          color: const Color.fromARGB(255, 20, 21, 21)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'Prediction Result: ${snapshot.data}',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pausePlayer() async {
    await _player!.pausePlayer();
    setState(() {
      _isPaused = true;
    });
  }

  Future<void> _resumePlayer() async {
    await _player!.resumePlayer();
    setState(() {
      _isPaused = false;
    });
  }

  // ignore: unused_element
  Future<void> _stopPlayer() async {
    await _player!.stopPlayer();
    setState(() {
      _isPlaying = false;
      _isPaused = false;
    });
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _player!.closePlayer();
    super.dispose();
  }
}
