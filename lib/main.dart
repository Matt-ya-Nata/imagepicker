import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Recognizer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: const MyHomePage(
        title: 'Object Recogniser',
      ),
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
  late ImageLabeler labeler;

  @override
  void initState() {
    super.initState();
    // Properly initialize the ImagePicker
    imagePicker = ImagePicker();
    ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.60);
    labeler = ImageLabeler(options: options);
  }

  // Image choosing method
  chooseImage() async {
    XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      image = File(selectedImage.path);
      performImageLabeling();
      setState(() {
        image;
      });
    }
  }

  // Image capturing method
  captureImage() async {
    XFile? selectedImage =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      image = File(selectedImage.path);
      performImageLabeling();
      setState(() {
        image;
      });
    }
  }

  //Method to pass image to image labeling model
  String results = "";
  performImageLabeling() async {
    results = "";
    InputImage inputImage = InputImage.fromFile(image!);

    final List<ImageLabel> labels = await labeler.processImage(inputImage);

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      print(text + "    " + confidence.toString());
      results += text + "   " + confidence.toStringAsFixed(2) + "\n";
    }

    setState(() {
      results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade400,
        centerTitle: true, // Center the title
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                color: Colors.grey,
                margin: EdgeInsets.all(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: image == null
                      ? const Icon(
                          Icons.image,
                          size: 150,
                        )
                      : Image.file(image!),
                ),
              ),
              Card(
                margin: EdgeInsets.all(10),
                color: Colors.indigo.shade400,
                child: Container(
                  height: 100,
                  child: Row(
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.image,
                          size: 50,
                        ),
                        onTap: () {
                          chooseImage();
                        },
                      ),
                      InkWell(
                        child: Icon(
                          Icons.camera,
                          size: 50,
                        ),
                        onTap: () {
                          captureImage();
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ),
              ),
              Card(
                color: Colors.grey,
                child: Container(
                  child: Text(results,style: TextStyle(fontSize:24),),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                ),
                margin: EdgeInsets.all(10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
