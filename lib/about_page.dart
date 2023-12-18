// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  _launchEmail() async {
    const email = 'mailto:haran07966@gmail.com';
    if (await canLaunch(email)) {
      await launch(email);
    } else {
      throw 'Could not launch $email';
    }
  }

  _launchLinkedIn() async {
    const linkedInUrl = 'https://www.linkedin.com/in/hari-haran-k-5aa27b227/';
    if (await canLaunch(linkedInUrl)) {
      await launch(linkedInUrl);
    } else {
      throw 'Could not launch $linkedInUrl';
    }
  }

  Widget _buildAnimatedImage(String imagePath, Function() onTap) {
    return InkWell(
      onTap: () {
        onTap();
        // You can add more animations here if needed
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1, end: 0.9),
        duration: Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Image.asset(
          imagePath,
          width: 50, // Adjust the width as needed
          height: 50, // Adjust the height as needed
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About WHY CRY', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 9, 9, 9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About the App:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'WHY CRY is an app designed to detect the reasons behind a baby\'s cry using machine learning. The app analyzes acoustic features to determine if the baby is hungry, tired, experiencing belly pain, etc. The machine learning model, based on random forest, is implemented to make these predictions.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 24),
              Text(
                'About the Creator:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 120,
                      backgroundImage: AssetImage('assets/images/hari.jpg'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Hariharan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Studying at CIT College',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    Text(
                      'B.Tech in Artificial Intelligence and Data Science',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    Text(' '), // Empty space
                    Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Set color to black
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedImage(
                            'assets/images/email.jpeg', _launchEmail),
                        SizedBox(width: 16),
                        _buildAnimatedImage(
                            'assets/images/linkedin.jpeg', _launchLinkedIn),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Note:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'This app is in the growing stage due to a lack of enough data. Once we have enough data, we can push this app to work for all regions.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
