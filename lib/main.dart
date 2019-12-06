import 'package:flutter/material.dart';
import 'package:gcm_factory/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  File _image;


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
                          fontFamily: 'Bebas Neue',
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
                              "Close",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Bebas Neue',
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
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _image == null
                    ? Padding(
                        padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*30),
                        child:Text(" SELECT A IMAGE TO CREATE A MEME ",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Bebas Neue',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            backgroundColor: Colors.black54
                          ),
                        )
                      )
                      : Stack(
                        alignment: Alignment.topCenter,
                          children: <Widget>[ 
                            Card(
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  _memeTextDown(),
                                  Image.file(_image,),
                                  _memeTextUp(),
                                ],
                              ),
                            ),
                          ],
                        ),
                            // Padding(
                            //   padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*1),
                            //   child:Text(" ROLL DOWN TO CREATE A MEME ",
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //       fontFamily: 'Bebas Neue',
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.black87.withOpacity(0.6),
                            //     ),
                            //   )
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*7),
                            //   child:Image.asset("images/logogc.png",
                            //     color: Colors.pinkAccent.shade700,
                            //   )                        
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*12),
                            //   child:Text(" MEME FACTORY ",
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //       fontFamily: 'Bebas Neue',
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.pinkAccent.shade700,
                            //     ),
                            //   )
                            // ),
                          //],
                        //),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.black54,
                        textColor: Colors.white,
                        splashColor: Colors.pinkAccent,
                        hoverColor: Colors.pinkAccent,
                        child: Text("Gallery",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Bebas Neue',
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
                            fontFamily: 'Bebas Neue',
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
                            child: Text("Download",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Bebas Neue',
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            onPressed: () { 
                              if((_controllerUp.text).length<=100 && (_controllerDown.text).length<=100){
                                //_screenshot();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Ops! You exceded the limit of characteres"),
                                      content: Text("The limit of characteres are 100 in each Input Field. Please erase some letters."),
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
    return Container(
      alignment: Alignment.topCenter,
            child: Text(_controllerUp.text,
              style: TextStyle(
                fontFamily: 'Bebas Neue',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
    );
  }

  Widget _memeTextDown(){
    return Container(
      alignment: Alignment.bottomCenter,
            child: Text(_controllerDown.text,
              style: TextStyle(
                fontFamily: 'Bebas Neue',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
    );
  }

//BUILD APP

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return _coreApp();
  }
}