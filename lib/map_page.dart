// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Doctor {
  final String name;
  final String specialization;
  final String address;
  final String mapLink;
  final String imageAsset;
  final String phoneNumber;

  Doctor({
    required this.name,
    required this.specialization,
    required this.address,
    required this.mapLink,
    required this.imageAsset,
    required this.phoneNumber,
  });
}

class MapPage extends StatelessWidget {
  final List<Doctor> doctors = [
    Doctor(
      name: 'Dr. John Doe',
      specialization: 'Pediatrician',
      address: '123 Main Street, Cityville',
      mapLink:
          'https://www.google.com/maps/place/Perur,+Coimbatore,+Tamil+Nadu+641010/@10.9755068,76.9050461,15z/data=!3m1!4b1!4m6!3m5!1s0x3ba85eacff7cb4cd:0x6ec7a4a308201e17!8m2!3d10.9754861!4d76.9153459!16z',
      imageAsset: 'assets/images/doc1.jpeg',
      phoneNumber: '+1234567890',
    ),
    Doctor(
      name: 'Dr. Jane Smith',
      specialization: 'Cardiologist',
      address: '456 Oak Avenue, Townburg',
      mapLink:
          'https://www.google.com/maps/place/Perur,+Coimbatore,+Tamil+Nadu+641010/@10.9755068,76.9050461,15z/data=!3m1!4b1!4m6!3m5!1s0x3ba85eacff7cb4cd:0x6ec7a4a308201e17!8m2!3d10.9754861!4d76.9153459!16z',
      imageAsset: 'assets/images/doc2.jpeg',
      phoneNumber: '+9876543210',
    ),
    Doctor(
      name: 'Dr. Lisa Johnson',
      specialization: 'Dermatologist',
      address: '789 Pine Street, Villagetown',
      mapLink:
          'https://www.google.com/maps/place/Perur,+Coimbatore,+Tamil+Nadu+641010/@10.9755068,76.9050461,15z/data=!3m1!4b1!4m6!3m5!1s0x3ba85eacff7cb4cd:0x6ec7a4a308201e17!8m2!3d10.9754861!4d76.9153459!16z',
      imageAsset: 'assets/images/doc3.jpeg',
      phoneNumber: '+1122334455',
    ),
    Doctor(
      name: 'Dr. Robert Wilson',
      specialization: 'Orthopedic Surgeon',
      address: '101 Oak Lane, Suburbia',
      mapLink:
          'https://www.google.com/maps/place/Perur,+Coimbatore,+Tamil+Nadu+641010/@10.9755068,76.9050461,15z/data=!3m1!4b1!4m6!3m5!1s0x3ba85eacff7cb4cd:0x6ec7a4a308201e17!8m2!3d10.9754861!4d76.9153459!16z',
      imageAsset: 'assets/images/doc4.jpeg',
      phoneNumber: '+9988776655',
    ),
    Doctor(
      name: 'Dr. kavi Rose',
      specialization: 'Dermatologist',
      address: '789 Pine Street, Villagetown',
      mapLink:
          'https://www.google.com/maps/place/Perur,+Coimbatore,+Tamil+Nadu+641010/@10.9755068,76.9050461,15z/data=!3m1!4b1!4m6!3m5!1s0x3ba85eacff7cb4cd:0x6ec7a4a308201e17!8m2!3d10.9754861!4d76.9153459!16z',
      imageAsset: 'assets/images/doc5.jpeg',
      phoneNumber: '+7897463456',
    ),
    Doctor(
      name: 'Dr. kavin Henry',
      specialization: 'Dermatologist',
      address: '789 Pine Street, Villagetown',
      mapLink:
          'https://www.google.com/maps/place/Perur,+Coimbatore,+Tamil+Nadu+641010/@10.9755068,76.9050461,15z/data=!3m1!4b1!4m6!3m5!1s0x3ba85eacff7cb4cd:0x6ec7a4a308201e17!8m2!3d10.9754861!4d76.9153459!16z',
      imageAsset: 'assets/images/doc6.jpg',
      phoneNumber: '+6457683456',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'DOCTORS HELP',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              doctors[index].name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Specialization: ${doctors[index].specialization}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Address: ${doctors[index].address}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Phone: ${doctors[index].phoneNumber}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage(doctors[index].imageAsset),
              radius: 30,
            ),
            onTap: () async {
              print('Doctor tapped: ${doctors[index].name}');
              print('Opening map link: ${doctors[index].mapLink}');

              if (await canLaunch(doctors[index].mapLink)) {
                await launch(doctors[index].mapLink);
              } else {
                print('Could not launch map link');
              }
            },
          );
        },
      ),
    );
  }
}
