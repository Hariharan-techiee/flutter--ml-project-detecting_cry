import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ContributePage extends StatelessWidget {
  Future<void> _pickVoiceFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        File file = File(result.files.first.path!);
        // Use the file as needed (upload or process the file)
        await _uploadFileToFirebaseStorage(file);
      } else {
        // User canceled the file picking
        print("User canceled file picking");
      }
    } catch (e) {
      print("Error picking voice file: $e");
      // Handle the error
    }
  }

  Future<void> _uploadFileToFirebaseStorage(File file) async {
    try {
      String fileName = DateTime.now().toUtc().toIso8601String();
      String subfolder = 'donate'; // Specify the subfolder name
      String filePath = '$subfolder/$fileName';

      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(filePath);

      await storageReference.putFile(file);
      print("File uploaded to Firebase Storage: $filePath");
    } catch (e) {
      print("Error uploading file to Firebase Storage: $e");
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contribute',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/qr.jpg', // Replace with your image asset
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement the logic for contributing money
                // You can navigate to a payment screen or perform other actions
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              child: Text(
                'Donate By Scanning',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickVoiceFile,
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              child: Text(
                'Contribute Voice',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContributePage(),
  ));
}
