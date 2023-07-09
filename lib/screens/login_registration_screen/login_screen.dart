import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stagesonic_video/Widgets/BoxShadow_widget.dart';
import 'package:stagesonic_video/Widgets/inputText_widget.dart';
import 'package:stagesonic_video/screens/login_registration_screen/registeration.dart';


import '../../main.dart';
import '../watchOther_screen/watch_other_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberpwd = false;
  bool hide = true;
  var visable = const Icon(
    Icons.visibility,
    color: Color(0xff4c5166),
  );
  Icon visableOff = const Icon(
    Icons.visibility_off,
    color: Color(0xff4c5164),
  );
  TextStyle inputTextStyle = const TextStyle(color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        const Text(
                          "Welcome Back! ☺️",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                        BoxShadowWidget(
                          boxRadius: 50,
                            height: 60,
                            width: 350,
                            onClicked: () {  },
                            backgroundColor: Colors.grey[300]!,
                            child: InputTextWidget(
                                controller: _emailController,
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Colors.black,
                                ),
                                label: const Text("Email"),
                                style: inputTextStyle,
                                isObscure: false,
                              keyboardType: TextInputType.emailAddress
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        BoxShadowWidget(
                          boxRadius: 50,
                            height: 60,
                            width: 350,
                            onClicked: () {  },
                            backgroundColor: Colors.grey[300]!,
                            child: InputTextWidget(
                                controller: _passwordController,
                                label: const Text("Password"),
                                style: inputTextStyle,
                                prefixIcon: visable,
                                isObscure: true,
                              keyboardType: TextInputType.visiblePassword,
                            )),
                        const SizedBox(
                          height: 60,
                        ),
                        BoxShadowWidget(
                            height: 60,
                            width: 350,
                            onClicked: () async {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password:
                                  _passwordController.text.trim())
                                  .then((value) => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const StartScreen()),
                              ))
                                  .onError((error, stackTrace) =>
                                  _showErrorDialog(
                                      " ${error.toString()}", 5));
                            },
                            backgroundColor: Colors.grey[300]!,
                            child: const Center(
                              child: Text('Log In', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),),
                            ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("haven't we met yet before? ",
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Registeration()),
                                  );
                                },
                                child: const Text("SIGN UP.." , style: TextStyle(color: Colors.deepPurple),))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRememberassword() {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: rememberpwd,
                checkColor: Colors.blueGrey,
                activeColor: Colors.white,
                onChanged: (value) {
                  setState(() {});
                },
              )),
          const Text(
            "Remember me",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildForgetPassword() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text("Forget Password !",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        onPressed: () {},
      ),
    );
  }

  void _showErrorDialog(String errorMessage, int duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: duration), () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          title: Text(errorMessage),
          content: Text(errorMessage),
        );
      },
    );
  }
}
