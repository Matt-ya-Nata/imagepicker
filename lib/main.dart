import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery/Camera Picker App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: const MyHomePage(title: 'Gallery/Camera Picker App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? image;
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    // Properly initialize the ImagePicker
    imagePicker = ImagePicker();
  }

  // Image choosing method
  chooseImage() async {
    XFile? selectedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      image = File(selectedImage.path);
      setState(() {
        image;
      });
    }
  }

  // Image capturing method
  captureImage() async {
    XFile? selectedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      image = File(selectedImage.path);
      setState(() {
        image;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true, // Center the title
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image == null
                ? const Icon(
              Icons.image,
              size: 150,
            )
                : Image.file(image!),
            ElevatedButton(
              onPressed: () {
                chooseImage();
              },
              onLongPress: () {
                captureImage();
              },
              child: const Text("Choose/Capture"),
            )
          ],
        ),
      ),
    );
  }
}
