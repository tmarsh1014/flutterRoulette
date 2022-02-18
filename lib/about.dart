import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// created by: Taylor Marsh
//ITEC 4550
// updated 11/13/21

class AboutRoute extends StatelessWidget {
  const AboutRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Me"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image(image: AssetImage('assets/images/bbuildingwavy.jpg')),
            SizedBox(height: 20),
            Text('Created by Taylor Marsh',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),),
            SizedBox(height: 20),
            Text('Created for ITEC 4550',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),),
            SizedBox(height: 20),
            Image.asset(
              'assets/images/cat.png',
              height: 300,
              width: 200,),
            SizedBox(height: 20),
            Text('11/13/2021',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}