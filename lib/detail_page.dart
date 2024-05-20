import 'dart:io';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String email;
  final String contact;
  final String experience;
  final String imagePath;

  const DetailPage({
    Key? key,
    required this.email,
    required this.contact,
    required this.experience,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Email: $email',
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text('Contact: $contact',
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text('Experience: $experience',
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            imagePath.isNotEmpty
                ? Image.file(File(imagePath))
                : const Text('No image selected.'),
          ],
        ),
      ),
    );
  }
}
