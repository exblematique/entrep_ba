import 'package:ba_locale/model/design.dart';
import 'package:flutter/material.dart';

class Manual extends StatefulWidget {
  @override
  ManualState createState() => ManualState();
}

class ManualState extends State<Manual> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Centre d'aide"),
          centerTitle: true
      ),
      body: Builder(builder: (BuildContext context) {
        return Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InputDesign("Manual", controller: null),
            ],
          ),
        );
      }),
    );
  }
}