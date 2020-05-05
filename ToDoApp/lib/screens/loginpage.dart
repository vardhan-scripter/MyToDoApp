
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:todotask/components/bottomdisplaytext.dart';
import 'package:todotask/components/roundedbutton.dart';
import 'package:todotask/model/apiresponse.dart';
import 'package:todotask/screens/forgot_password_page.dart';
import 'package:todotask/screens/homepage.dart';
import 'package:todotask/screens/signuppage.dart';
import 'package:todotask/services/authservice.dart';
import 'package:todotask/utils/constants.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //getting the instance of the AuthService from service locator(getIt)
  AuthService _authService = GetIt.I<AuthService>();
  //get the instance for apiResponse
  ApiResponse<bool> _loginResponse;
  //input controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //global key for the form
  final _formKey = GlobalKey<FormState>();
  //color
  Color colorTheme= Color.fromRGBO(73, 83, 153, 1);
  //boolean for container height
  bool isError = false;
  //boolean for password visibility
  bool isVisible = true;

  //get instance of the shared preferences
  SharedPreferences _prefs;
  //boolean for loading indicator
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    checkSignInStatus();
  }

  checkSignInStatus() async{
    setState(() {
      isLoading = true;
    });
    _prefs = await SharedPreferences.getInstance();
    if(_prefs.getString(TOKEN_ID) != null){
      Navigator.push(context, MaterialPageRoute(builder: (_)=>HomePage()));
      isLoading = false;
    }else{
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: isLoading ? SpinKitChasingDots(
            color: colorTheme,
            size: 50,
          ):Stack(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height/2.0,
                  child:FlareActor(
                    "assets/flares/background_flow.flr",
                    animation: "Flow",
                    fit: BoxFit.fitWidth,
                  )
              ),
               Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.10,),
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.4,bottom: 40.0),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 2.0),
                            child: Container(
                              height: isError?70:55,
                              child: TextFormField(
                                  controller: emailController,
                                  validator: (email) =>
                                  email.isEmpty ? 'please enter valid email' : null,
                                  style: kTaskTextStyle,
                                  onChanged: (value) {
                                   // updateTitle();
                                  },
                                  decoration:
                                  kTaskTextFormField.copyWith(
                                    prefixIcon: Icon(Icons.mail_outline,color: colorTheme,),
                                      hintText: 'Enter your email')),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 30.0),
                            child: Container(
                              height: isError?70:55,
                              child: TextFormField(
                                obscureText: isVisible,
                                controller: passwordController,
                                validator: (password) =>
                                password.isEmpty ? 'Please enter your password.' : null,
                                style: kTaskTextStyle,
                                onChanged: (value) {
                                  //updateTitle();
                                },
                                decoration:
                                kTaskTextFormField.copyWith(
                                  prefixIcon: Icon(Icons.lock_outline,color: colorTheme,),
                                    suffixIcon: IconButton(icon: Icon(isVisible?Icons.visibility_off:Icons.visibility,color: colorTheme), onPressed: (){
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    }),
                                    hintText: 'Enter your password'),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: RichText(text: TextSpan(
                                text: 'Do you  ',style: TextStyle(color: colorTheme,fontSize: 16.0),
                                children: [
                                  TextSpan(
                                    text: 'Forget password?', recognizer: TapGestureRecognizer()..onTap = (){
                                        //Toast.show("Under development", context, duration: 2);
                                    Navigator.push(context, MaterialPageRoute(builder: (_)=>ForgotPasswordPage()));
                                      },
                                    style: TextStyle(
                                      color: colorTheme,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2
                                    )
                                  )
                                ]
                              )),
                            ),
                          ),

                          RoundedButton(colorTheme: colorTheme, buttonName: 'Login', onPressed: () async{
                            if(_formKey.currentState.validate()){
                              setState(() {
                                isLoading = true;
                              });
                              _loginResponse = await _authService.signInWithEmailAndPassword(email: emailController.text,password: passwordController.text);
                              if(_loginResponse.data){
                                setState(() {
                                  isLoading = false;
                                });
                                emailController.clear();
                                passwordController.clear();
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>HomePage()));
                               // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomePage()),(Route<dynamic> route)=>false);
                                Toast.show(_loginResponse.message, context,duration: 2);
                              }else{
                                if(_loginResponse.message == 'Credentials mismatch'){
                                  Toast.show('Incorrect mail or password.', context,duration: 2);
                                }else{
                                  Toast.show("SomeThing went wrong please try again later", context,duration: 2);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }else{
                              setState(() {
                                isError = true;
                              });
                            }
                          }),
                          BottomDisplayText(colorTheme: colorTheme, actionText: 'Sign Up', displayText: 'Don\'t have an account?  ',
                              textGestureRecognizer:TapGestureRecognizer()..onTap = (){
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>SignUpPage()));
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//class MyClipper extends CustomClipper<Path> {
//  @override
//  Path getClip(Size size) {
//    Path p = new Path();
//    p.lineTo(size.width, 0.0);
//    p.lineTo(size.width, size.height * 0.85);
//    p.arcToPoint(
//      Offset(0.0, size.height * 0.85),
//      radius: const Radius.elliptical(50.0, 10.0),
//      rotation: 0.0,
//    );
//    p.lineTo(0.0, 0.0);
//    p.close();
//    return p;
//  }
//
//  @override
//  bool shouldReclip(CustomClipper oldClipper) {
//    return true;
//  }
//}