import 'package:flutter/material.dart';

import 'SideDrawer.dart';

class SleepRecorderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Śledzenie snu"),
      ),
      drawer: SideDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
            Navigator.pop(context);
          },
          child: Text('Cofnij strone'),
        ),
      ),
    );
  }
}