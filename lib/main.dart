import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isloading = true;
  File _image;
  List _output;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isloading=true;
    
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cat & Dog Detector"),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      
    );
  }

  chooseImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null) return null;
    setState(() {
      _isloading =true;
      _image = image;
    });
    runModelOnImage(image);
  }

  runModelOnImage(File image){
    Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.5,
    );
    setState(() {
      _isloading=false;
      _image=image;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt"
    );
  }
}

