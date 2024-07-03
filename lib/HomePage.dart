import 'package:flutter/material.dart';
import 'Api.dart';
import 'SideDrawer.dart';
import 'LoginPage.dart';

class HomePage extends StatelessWidget {
  @override

  final url_image = 'assets/Industry4medical.png';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Strona główna", textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
        backgroundColor: Color(0xff007084),
        foregroundColor: Color(0xffffffff),
        shadowColor: Color(0xff65bcc9),
        toolbarHeight: 100,
        centerTitle: true,
      ),
      drawer: SideDrawer(),
      body: Column(
        children: <Widget>[
          Image.asset(
            url_image,
          ),
          SizedBox(
            height: 18,
          ),
          Align(
            //alignment: Alignment.bottomCenter,
            child: ElevatedButton(
            onPressed: () async {
              await API.logout();
              // Navigate back to first route when tapped.
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage())
              );
            },
            style: (ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Color(0xff007084),
                onSurface: Color(0xff007084),
                shadowColor: Color(0xff65bcc9))),
            child: Text('Wyloguj'),),
          )
        ]
      ),
    );
  }
}