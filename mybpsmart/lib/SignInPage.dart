import 'package:flutter/material.dart';
import './Auth_Service.dart';
import './HomePage.dart';
import './SignUpPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'PhoneAuthPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();

  get app => null;

  bool hide = true;
  void buttonHandler() => setState(() => hide = !hide);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign In",
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            buttonitem("assets/google.svg", "Google", 25, () {
              authClass.googleSignIn(context);
            }),
            SizedBox(
              height: 15,
            ),
            buttonitem("assets/phone.svg", "Phone", 30, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (builder) => PhoneAuthPage()));
            }),
            SizedBox(
              height: 15,
            ),
            Text(
              "Or",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 15,
            ),
            textItem("Email", _emailController, false),
            SizedBox(
              height: 15,
            ),
            textItem("Password", _pwdController, true),
            SizedBox(
              height: 30,
            ),
            colorButton(),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "I don't have an account ",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => SignUpPage()),
                        (route) => false);
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Forgot password?",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      )),
    );
  }

  Widget colorButton() {
    return InkWell(
        onTap: () async {
          try {
            firebase_auth.UserCredential userCredential =
                await firebaseAuth.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _pwdController.text);
            print(userCredential.user!.email);
            setState(() {
              circular = false;
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => HomePage()),
                (route) => false);
          } catch (e) {
            final snackbar = SnackBar(content: Text(e.toString()));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            setState(() {
              circular = false;
            });
          }
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 90,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [
                  Color(0xfffd746c),
                  Color(0xffff9068),
                  Color(0xfffd746c)
                ])),
            child: Center(
              child: circular
                  ? CircularProgressIndicator()
                  : Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
            )));
  }

  Widget buttonitem(
      String imagepath, String buttonName, double size, Function onTap) {
    return InkWell(
        onTap: () => onTap(),
        child: Container(
          width: MediaQuery.of(context).size.width - 60,
          height: 60,
          child: Card(
            color: Colors.black,
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(width: 1, color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  imagepath,
                  height: size,
                  width: size,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  buttonName,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                )
              ],
            ),
          ),
        ));
  }

  Widget textItem(
      String labeltext, TextEditingController controller, bool obscuretext) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        style: TextStyle(fontSize: 17, color: Colors.white),
        controller: controller,
        obscureText: (obscuretext) ? hide : false,
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: TextStyle(fontSize: 17, color: Colors.white),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(width: 1.5, color: Colors.amber)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(width: 1, color: Colors.grey)),
          suffixIcon: (obscuretext)
              ? (hide)
                  ? IconButton(
                      onPressed: buttonHandler,
                      icon: Icon(Icons.visibility),
                    )
                  : IconButton(
                      onPressed: buttonHandler,
                      icon: Icon(Icons.visibility_off),
                    )
              : null,
        ),
      ),
    );
  }
}
