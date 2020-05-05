
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:todotask/components/bottomdisplaytext.dart';
import 'package:todotask/components/roundedbutton.dart';
import 'package:todotask/model/apiresponse.dart';
import 'package:todotask/screens/homepage.dart';
import 'package:todotask/services/authservice.dart';
import 'package:todotask/utils/constants.dart';
import 'package:get_it/get_it.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //global for form
  final _formKey = GlobalKey<FormState>();

  //get the api response instance
  ApiResponse<bool> _signUpResponse;
  //Get the instance of the Auth service from service locator(getIt)
  AuthService _authService = GetIt.I<AuthService>();

  //input controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Color colorTheme= Color.fromRGBO(73, 83, 153, 1);

  //boolean for container height
  bool isError = false;
  //boolean for loader
  bool isLoading = false;
  //boolean for password visibility
  bool isVisible = true;
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
          body: isLoading?SpinKitChasingDots(
            color: colorTheme,
            size: 50,
          ):Stack(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/2.2,
                  child:FlareActor(
                    "assets/flares/background_flow.flr",
                    animation: "Flow",
                    fit: BoxFit.fitWidth,
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.10),
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.6,bottom: 40.0),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 4.0),
                            child: Container(
                              height: isError?70:55,
                              child: TextFormField(
                                  controller: nameController,
                                  validator: (username) =>
                                  username.isEmpty ? 'please enter username' : null,
                                  style: kTaskTextStyle,
                                  onChanged: (value) {
                                    // updateTitle();
                                  },
                                  decoration:
                                  kTaskTextFormField.copyWith(
                                      prefixIcon: Icon(Icons.person_outline,color: colorTheme,),
                                      hintText: 'Enter username')),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 4.0),
                            child: Container(
                              height: isError?70:55,
                              child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
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
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 30.0),
                            child: Container(
                              height: isError?70:55,
                              child: TextFormField(
                                obscureText: isVisible,
                                controller: passwordController,
                                validator: (password) =>
                                password.isEmpty ? 'password length min. should be 6 characters' : null,
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
                          RoundedButton(colorTheme: colorTheme,buttonName: 'Sign Up',onPressed: () async{
                            if(_formKey.currentState.validate()){
                              setState(() {
                                isLoading = true;
                              });
                              _signUpResponse = await _authService.createAccountWithEmailAndPassword(name: nameController.text,email: emailController.text, password: passwordController.text);
                              if(_signUpResponse.data){
                                //logic for clearing the input fields after registration success
                                emailController.clear();
                                passwordController.clear();
                                nameController.clear();
                                Navigator.pop(context);
                                Toast.show(_signUpResponse.message, context,duration: 2);
                                setState(() {
                                  isLoading = false;
                                });
                              }else{
                                if(_signUpResponse.message == 'email is already exists'){
                                  Toast.show('email is already exists', context,duration: 2);
                                }else{
                                  Toast.show('Something went wrong please try again later', context,duration: 2);
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
                          },),
                          BottomDisplayText(colorTheme: colorTheme,displayText: 'Already have an Account?  ',actionText: 'Sign in',textGestureRecognizer: TapGestureRecognizer()..onTap =(){
                            Navigator.pop(context);
                          },),
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





