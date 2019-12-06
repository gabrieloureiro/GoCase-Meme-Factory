import 'package:flutter/material.dart';
import 'package:gcm_factory/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
import 'dart:io';

void main() => runApp(Home());

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoCase Meme Factory',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}


_launchURL(String url) async {
  String url1 = url;
  if (await canLaunch(url1)) {
    await launch(url1);
  } else {
    throw 'Could not launch $url1';
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  
}

class _HomeState extends State<HomeScreen> {

  TextEditingController _controllerUp = TextEditingController();
  TextEditingController _controllerDown = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController(); 
  File _image;
  static GlobalKey screen = GlobalKey();


  Future _getImage(bool ofCamera) async {

    File _selectedImage;
    if(ofCamera == true){ //Imagem da camera
      _selectedImage = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
    }
    else { //Imagem da galeria
      _selectedImage = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
    }
    setState(() {
      _image = _selectedImage;
    });

  }

  // _screenshot() async{
  //   RenderRepaintBoundary boundary = screen.currentContext.findRenderObject();
  //   ui.Image image = await boundary.toImage();
  //   ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  //   // var filepath = await ImagePicker.saveFile(
  //   //   fileData: byteData.buffer.asUint8List()
  //   // );

  // }  

  //WIDGETS

  Widget _coreApp(){
    return Scaffold(
      backgroundColor: Color(0xffef89bf).withOpacity(0.85),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        title: Image.asset(
          "images/logogc.png",
          width: SizeConfig.blockSizeHorizontal*30,
          height: SizeConfig.blockSizeVertical*30,
        ),
      centerTitle: true,
      ),
      endDrawer: _drawerRight(context),
      body:_body()
    );
  }

  Widget _drawerRight(BuildContext context){
  return Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text("Developer"),
                trailing: Icon(MdiIcons.githubCircle),
                onTap: (){
                  showDialog(
                    context : context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Developer"),
                        titleTextStyle: TextStyle(
                          color : Colors.pinkAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 70,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _launchURL("https://www.linkedin.com/in/gabrieloureiro/");

                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          ExactAssetImage('images/gabriel.jpeg'),
                                      minRadius: 40,
                                      maxRadius: 40,                     
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "FECHAR",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                  );
                },
              ),
              ListTile(
                title: Text("Website"),
                trailing: Icon(MdiIcons.web),
                onTap: (){
                  _launchURL("http://www.gocase.com.br");
                },
              ),
            ],
        )
      );
}

  Widget _body(){
    return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          RepaintBoundary(
            key: screen,
            child: Container(
              width: SizeConfig.blockSizeHorizontal*115,
              height: SizeConfig.blockSizeVertical*57.5,
              color: Colors.transparent,             
            ),
          ),
          Container(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: SizeConfig.blockSizeVertical*1,
                  ),
                  _image == null
                    ? Container()
                      : Stack(
                          children: <Widget>[ 
                            Image.file(_image,
                              width: SizeConfig.blockSizeHorizontal*115,
                              height: SizeConfig.blockSizeVertical*57.5,
                            ),
                            _memeTextUp(),
                            _memeTextDown()
                          ],
                        ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical*1.5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.black54,
                        textColor: Colors.white,
                        splashColor: Colors.pinkAccent,
                        hoverColor: Colors.pinkAccent,
                        child: Text("Gallery",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () => _getImage(false),
                      ),
                      RaisedButton(
                        color: Colors.black54,
                        textColor: Colors.white,
                        splashColor: Colors.pinkAccent,
                        hoverColor: Colors.pinkAccent,
                        child: Text("Camera",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () => _getImage(true),
                      ),
                    ],
                  ),
                  _generator()
                ],
              ),
            ),
          ),
        ],
      );
  }

  Widget _generator(){
    return Container(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal*5,
          vertical: SizeConfig.blockSizeVertical,
        ),
        child: Column(
          children: <Widget>[
            _image == null
              ? Container()
                : Column(
                    children: <Widget>[
                      TextField(
                        controller: _controllerUp,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*3.3),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(25, 16, 32, 16),
                            hintText: "Enter the up text here",
                            filled: true,
                            fillColor: Colors.white,
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),                                                                                      
                            suffixIcon: const Icon(
                              Icons.text_fields,
                              color: Color(0xffef89bf),
                            )
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical*2.5,
                      ),
                      TextField(
                        controller: _controllerDown,
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal*3.3),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(25, 16, 32, 16),
                            hintText: "Enter the down text here",
                            filled: true,
                            fillColor: Colors.white,
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),                                                                                      
                            suffixIcon: const Icon(
                              Icons.text_fields,
                              color: Color(0xffef89bf),
                            )
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical*1.5,
                      ),
                      Row(
                        
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[ 
                          RaisedButton(
                            color: Colors.black54,
                            textColor: Colors.white,
                            splashColor: Colors.pinkAccent,
                            hoverColor: Colors.pinkAccent,
                            child: Text("Generate",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            onPressed: () { 
                              if((_controllerUp.text).length<=31 && (_controllerDown.text).length<=31){
                                _memeTextUp();
                                _memeTextDown();
                                //_screenshot();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Ops! You exceded the limit of characteres"),
                                      content: Text("The limit of characteres are 31. Please erase some letters."),
                                      titleTextStyle: TextStyle(
                                        color : Color(0xffef89bf),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "Close",
                                            style: TextStyle(
                                              color: Color(0xffef89bf),
                                            ),
                                            ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              }
                            }
                          ),
                        ]
                      )           
                    ],
                  )
                ]
              )
          )
        );          
  }
  
  Widget _memeTextUp(){
    return Stack(
      children: <Widget>[
        Center(
          child: Text(_controllerUp.text,
            style: TextStyle(
              fontFamily: 'Bebas Neue',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        )
      ],
    );
  }

  Widget _memeTextDown(){
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*54),
          child:Center(
            child: Text(_controllerDown.text,
              style: TextStyle(
                fontFamily: 'Bebas Neue',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          )
        ),
      ],
    );
  }

//BUILD APP

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return _coreApp();
  }
}