import 'package:flutter/material.dart';
import 'package:industry4medical/HomePage.dart';

class RegisterPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Industry4Medical"),
        ),
        body: Center(
            child: Container(
              child: Column(
                children: [
                  Logo(),
                  LoginForm()
                ],
              ),
            )
        )
    );
  }
}

class Logo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      height: screenHeight*0.35,
      decoration: new BoxDecoration(
          color: Colors.blue
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Zarejestruj się",
              style:
              TextStyle(
                fontSize: 50,
                color: Colors.white,
              )
          ),
        ],
      ),
    );
  }

}

class LoginForm extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [TextFormField(
          decoration: InputDecoration(hintText: 'E-mail'),
          validator: (value) {
            if (value.isEmpty) {
              return 'enter_login';
            } else
              return null;
          },
        ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Hasło'),
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'enter_password';
              } else
                return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage())
                    );
                  },
                  child: Text('Zaloguj')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage())
                    );
                  },
                  child: Text('Zarejestruj'))
            ],
          )
        ],
      ),
    );
  }
}
