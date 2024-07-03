import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industry4medical/ChallangesPage.dart';
import 'package:industry4medical/HomePage.dart';
import 'package:industry4medical/StatisticsPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SideDrawer extends StatelessWidget{

  final url_image = 'assets/Industry4medical.png';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Image.asset(
              url_image,
            ),
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.all(0.0)
          ),
          ListTile(
            title: Text('Statystyki snu'),
            leading: Icon(FontAwesomeIcons.moon),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new StatisticsPage()));
            },
          ),
          ListTile(
            title: Text('Wyzwania'),
            leading: Icon(FontAwesomeIcons.thList),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new ChallengesPage()));
            },
          ),
          ListTile(
            title: Text('Strona główna'),
            leading: Icon(FontAwesomeIcons.signOutAlt),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new HomePage()));
            },
          ),
        ],
      ),
    );
  }
}