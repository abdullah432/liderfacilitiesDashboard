import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/utils/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailC = new TextEditingController();
  TextEditingController pasC = new TextEditingController();
  MediaQueryData _mediaQuery = new MediaQueryData();
  bool errorVisibility = false;
  String errorMsg = 'Invalid Email or Password';
  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    return Center(
        child: Container(
            width: _mediaQuery.size.width / 2,
            height: _mediaQuery.size.height / 1.5,
            child: Form(
              key: _formKey,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: CircleAvatar(
                          radius: 45,
                          child: ClipOval(
                            child: Image.asset('assets/images/logo.png'),
                          )),
                    ),
                    emailTF(),
                    passTF(),
                    errorMessage(),
                    loginBtn()
                  ],
                ),
              ),
            )));
  }

  emailTF() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 50, right: 50),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.25,
              padding: EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
              child: TextFormField(
                // textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
                controller: emailC,
                decoration: InputDecoration(
                    hintText: 'Email',
                    border: InputBorder.none,
                    fillColor: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }

  passTF() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 50, right: 50),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.25,
              padding: EdgeInsets.only(left: 20, top: 3, bottom: 3, right: 14),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 1)]),
              child: TextFormField(
                // textAlign: TextAlign.center,
                validator: validatePassword,
                controller: pasC,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password',
                    border: InputBorder.none,
                    fillColor: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }

  loginBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 30.0),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 5,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25))),
        child: RaisedButton(
          color: Color.fromRGBO(26, 119, 186, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          onPressed: () {
            //remove cursor blink of search textfield
            FocusScope.of(context).requestFocus(new FocusNode());
            validateUser();
          },
          child: Text(
            'Login',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String valule) {
    if (valule.length < 6) {
      return 'Your password need to be atleast 6 characters';
    } else
      return null;
  }

  errorMessage() {
    return Visibility(
        visible: errorVisibility,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              errorMsg,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ));
  }

  void validateUser() async {
    if (_formKey.currentState.validate()) {
      try {
        AuthResult result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailC.text, password: pasC.text);
        FirebaseUser user = result.user;
        if (user.uid != null) {
          DocumentSnapshot documentSnapshot = await Firestore.instance.collection('users').document(user.uid).get();
          print('doc: '+documentSnapshot.data['name']);
          User _userData = User.fromSnapshot(documentSnapshot);
          print('UserData: '+_userData.name);
          if (_userData != null && _userData.isAdmin){
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            debugPrint('before navigate: ' + user.uid.toString());
            return HomePage();
            // return HomePage(_userData);
          }));
          } else {
            setState(() {
            errorMsg = 'Not Admin';
            errorVisibility = true;
          });
          }
          
        } else {
          setState(() {
            errorMsg = 'Invalid Email or Password';
            errorVisibility = true;
          });
          print('error');
        }
      } catch (e) {
        setState(() {
          errorMsg = 'Invalid Email or Password';
          errorVisibility = true;
        });
        print(e.toString());
      }
    }
  }
}
