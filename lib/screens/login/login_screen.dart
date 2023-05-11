import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stagesonic_video/Widgets/BoxShadowWidget.dart';
import 'package:stagesonic_video/Widgets/InputTextWidget.dart';
import 'package:stagesonic_video/screens/home/main.dart';
import 'package:stagesonic_video/screens/login/login_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                                controller: usernameController,
                                lableString: "Email",

                                isObscure: false)),
                        const SizedBox(
                          height: 40,
                        ),
                        BoxShadowWidget(
                            height: 50,
                            width: 350,
                            child:  InputTextWidget(
                                controller: passwordController,
                                lableString: "Password",

                                isObscure: false)),
                        const SizedBox(
                          height: 60,
                        ),
                        BoxShadowWidget(
                            height: 40,
                            width: 350,

                            child: TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  const MyHomePage(title: "title")),
                                );
                              },
                              child: const Text("Register Now.." , style: TextStyle(
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
                            const Text("haven't we met yet? " , style: TextStyle(color: Colors.black,)),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>   const MyHomePage(title: "title")),
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




}
