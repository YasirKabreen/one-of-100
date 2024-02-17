import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:one_off_100/firebase_options.dart';
import 'package:one_off_100/gallery.dart';
import 'package:one_off_100/signin.dart';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _imageFile;
  final picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> uploadImage() async {
    try {
      if (_imageFile == null) return;

      // Upload image to Firebase Storage
      await Firebase.initializeApp();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now()}.png');
      await ref.putFile(_imageFile!);

      // Retrieve the download URL for the uploaded image
      String imageUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Images')
          .add({'url': imageUrl, 'time': DateTime.now().microsecond});
      // Do something with the imageUrl, like storing it in a database
      print('Image uploaded. URL: $imageUrl');
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Image Picker & Firebase Storage',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                        height: 400,
                        width: 400,
                      )
                    : const Text('No image selected'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () => pickImage(ImageSource.gallery),
                      child: const Text('Pick Image from Gallery'),
                    ),
                    ElevatedButton(
                      onPressed: () => pickImage(ImageSource.camera),
                      child: const Text('Take a Picture'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: uploadImage,
                  child: const Text('Upload Image to Firebase'),
                ),
                // Additional content
                SizedBox(height: 20),
                // Add some empty space at the bottom
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Gallery()));
                  },
                  child: const Text('Gallery'),
                ),
              ]),
        ),
      ),
    );
  }
}
