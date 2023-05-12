import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stagesonic_video/Widgets/BoxShadowWidget.dart';
import 'package:stagesonic_video/Widgets/InputTextWidget.dart';
import 'package:stagesonic_video/screens/home/main.dart';
import 'package:stagesonic_video/screens/login/login_screen.dart';
import 'package:stagesonic_video/screens/login/registeration.dart';

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
                          height: 200,
                        ),
                        const Text(
                          "Hello User! ☺️",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        BoxShadowWidget(
                            height: 50,
                            width: 350,
                            child:  InputTextWidget(
                                controller: _emailController,
                                prefixIcon: const Icon(Icons.email_outlined, color: Colors.black,),
                                label: const Text("Email"),
                                style: inputTextStyle,
                                isObscure: false
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        BoxShadowWidget(
                            height: 50,
                            width: 350,
                            child:  InputTextWidget(
                                controller: _passwordController,
                                label: const Text("Password"),
                                style: inputTextStyle,
                                prefixIcon: visable,
                                isObscure: true
                            )),
                        const SizedBox(
                          height: 60,
                        ),
                        BoxShadowWidget(
                            height: 40,
                            width: 350,

                            child: TextButton(
                              onPressed: () async {
                                FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim()
                                ).then((value) =>
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  const MyHomePage(title: "title")),
                                    )
                                ).onError((error, stackTrace) => _showErrorDialog(" ${error.toString()}", 5));

                              },

                              child: const Text("Log In" , style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),),
                            )
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("haven't we met yet before? " , style: TextStyle(color: Colors.black,)),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>   Registeration()),
                                  );
                                },
                                child: const Text("Registration..")
                            )
                          ],),

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
                  setState(() {

                  });
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
