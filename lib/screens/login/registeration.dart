import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stagesonic_video/Widgets/BoxShadowWidget.dart';
import 'package:stagesonic_video/Widgets/InputTextWidget.dart';
import 'package:stagesonic_video/screens/home/main.dart';
import 'package:stagesonic_video/screens/login/login_screen.dart';
import 'package:stagesonic_video/model/User.dart';

class Registeration extends StatefulWidget {
  @override
  _RegisterationState createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users');
  bool rememberpwd = false;
  bool sec = true;
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
                        BoxShadowWidget(
                            height: 50,
                            width: 350,
                            child:  InputTextWidget(
                                controller: _usernameController,
                                style: inputTextStyle,
                                label: const Text("Username"),
                                prefixIcon: const Icon(Icons.email_outlined, color: Colors.black,),
                                isObscure: false)),
                        const SizedBox(
                          height: 100,
                        ),
                        BoxShadowWidget(
                            height: 50,
                            width: 350,
                            child:  InputTextWidget(
                                controller: _emailController,
                                style: inputTextStyle,
                                label: const Text("Email"),
                                prefixIcon: const Icon(Icons.email_outlined, color: Colors.black,),
                                isObscure: false)),
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
                            )
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        BoxShadowWidget(
                            height: 40,
                            width: 350,

                            child: TextButton(
                              onPressed: (){

                                FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim()
                                ).then((credential) {
                               if(credential.user?.uid != null) {
                                 MyUser user = MyUser(
                                     id: credential.user?.uid,
                                     email: _emailController.text.trim(),
                                     password: _passwordController.text.trim(),
                                     username: _usernameController.text.trim(), // Der Name ist zunächst leer
                                     profileImageUrl: '', // Das Profilbild ist zunächst leer
                                     videos: [] // Die Liste der Videos ist zunächst leer
                                 );
                                 dbRef.child('${user.id}').set(user.toJson());
                                 Navigator.pushReplacement(
                                   context,
                                   MaterialPageRoute(builder: (context) =>  const MyHomePage(title: "title")),
                                 );
                               }
                                }).onError( (error, stackTrace) async {
                                 _showErrorDialog(error.toString(), 5);
                                });


                              },
                              child: const Text("SIGN UP" , style: TextStyle(
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
                          const Text("have we met? " , style: TextStyle(color: Colors.black,fontStyle: FontStyle.italic)),
                          TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>   LoginScreen()),
                                );
                              },
                              child: const Text("Login..",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic
                                ),)
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
