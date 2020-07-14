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

  bool _isloading;
  File _image;
  List _output;

  @override
  void initState() {
    super.initState();
    _isloading=true;
    loadModel().then((value){
      setState(() {
        _isloading=false;
      });
    });
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cat & Dog Detector"),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      body: _isloading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) : Container(
        padding: EdgeInsets.only(top:50),
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null ? Container() : Image.file(
                _image,
                width: MediaQuery.of(context).size.width-20,
          
              ),
              SizedBox(height: 20,),
              _output == null ? Text("") : Text(
                "${_output[0]["label"]}",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          chooseImage();
        },
        child: Icon(
          Icons.image,
        ),
      ),
    );
  }

  chooseImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image == null) return null;
    setState(() {
      _isloading =true;
      _image = image;
    });
    runModelOnImage(image);
  }

  runModelOnImage(File image) async{
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.5,
    );
    setState(() {
      _isloading=false;
      _output=output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt"
    );
  }
}

