import 'dart:async';

import 'package:flutter/material.dart';
import './Auth_Service.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  int start = 30;
  bool wait = false;
  String buttonName = "Send";
  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationidFinal = "";
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              textfield(),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 12),
                    )),
                    Text("Enter 6 digit OTP ",
                        style: TextStyle(color: Colors.white, fontSize: 17)),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: Colors.grey,
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              otpField(),
              SizedBox(
                height: 40,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: "send OTP again in ",
                    style: TextStyle(color: Colors.yellowAccent, fontSize: 17)),
                TextSpan(
                    text: "00:$start",
                    style: TextStyle(color: Colors.pinkAccent, fontSize: 17)),
                TextSpan(
                    text: " sec",
                    style: TextStyle(color: Colors.yellowAccent, fontSize: 17))
              ])),
              SizedBox(
                height: 150,
              ),
              InkWell(
                  onTap: () {
                    authClass.signinwithphonenumber(
                        verificationidFinal, smsCode, context);
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 60,
                    decoration: BoxDecoration(
                        color: Color(0xffff9601),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        "Let's go",
                        style: TextStyle(
                            color: Color(0xfffbe2ae),
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 34,
      fieldWidth: 50,
      otpFieldStyle: OtpFieldStyle(
          backgroundColor: Color(0xff1d1d1d), borderColor: Colors.white),
      style: TextStyle(color: Colors.white, fontSize: 17),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsCode = pin;
        });
      },
    );
  }

  Widget textfield() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: phoneController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter your phone number",
            hintStyle: TextStyle(color: Colors.white, fontSize: 17),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 19, horizontal: 8),
            prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                child: Text(
                  "(+60)",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                )),
            suffixIcon: InkWell(
              onTap: wait
                  ? null
                  : () async {
                      startTimer();
                      setState(() {
                        start = 30;
                        wait = true;
                        buttonName = "Resend";
                      });
                      await authClass.verifyPhoneNumber(
                          "+60 ${phoneController.text}", context, setData);
                    },
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Text(
                    buttonName,
                    style: TextStyle(
                        color: wait ? Colors.black : Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  )),
            )),
      ),
    );
  }

  void setData(verificationid) {
    setState(() {
      verificationidFinal = verificationid;
    });
    startTimer();
  }
}
