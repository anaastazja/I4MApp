import 'package:flutter/material.dart';
import 'package:industry4medical/HomePage.dart';
import 'package:industry4medical/RegisterPage.dart';
import 'Api.dart';

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Industry4Medical", textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
        backgroundColor: Color(0xff007084),
        foregroundColor: Colors.white,
        shadowColor: Color(0xff007084),
        toolbarHeight: 100,
        centerTitle: true,
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
          color: Color(0xff007084)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Zaloguj się",
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

class LoginForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _LoginForm();
}

class _LoginForm extends State{
  final loginController = TextEditingController(text: 'nickolas.villanueva@test.com');
  final passwordController = TextEditingController(text: 'vkchuCJNX2');
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      //width: screenWidth*0.6,
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [SizedBox(
          width: 250,
          child: TextFormField(
            decoration: InputDecoration(hintText: 'E-mail'),
            controller: loginController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Wpisz swój adres e-mail';
              }
              else if(!value.contains("@")) return "Niepoprawny adres e-mail";
              else
                return null;
            },
          ),
        ),
          SizedBox(
            width: 250,
            child: TextFormField(
            decoration: InputDecoration(hintText: 'Hasło'),
            obscureText: true,
            controller: passwordController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Wpisz hasło!';
              } else
                return null;
            },
          ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Logowanie'),
                      ));
                    var isLogged = await API.login(loginController.text, passwordController.text);
                    if(isLogged){Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage())
                    );}
                    else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text('Błąd'),
                              content: new Text('Błędny e-mail lub hasło'),
                              actions: <Widget>[
                                new TextButton(
                                  child: new Text('Zamknij'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });

                    }

                  };
                  },
                  child: Text('Zaloguj'),
                style: (ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    //minimumSize: Size.fromHeight(20),
                    primary: Color(0xff007084),
                    onSurface: Color(0xff007084),
                    shadowColor: Color(0xff65bcc9)
                )),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage())
                    );
                  },
                  style: (ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      //minimumSize: Size.fromHeight(20),
                      primary: Color(0xff007084),
                      onSurface: Color(0xff007084),
                      shadowColor: Color(0xff65bcc9)
                  )),
                  child: Text('Zarejestruj'))
            ],
          )
        ],
      ),
    );
  }
}
