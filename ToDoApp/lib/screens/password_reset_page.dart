
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:todotask/components/bottomdisplaytext.dart';
import 'package:todotask/components/roundedbutton.dart';
import 'package:todotask/model/apiresponse.dart';
import 'package:todotask/services/authservice.dart';
import 'package:todotask/utils/constants.dart';
import 'package:get_it/get_it.dart';

class PasswordResetAttributes{
  final String email;
  PasswordResetAttributes({this.email});
}
class PasswordResetPage extends StatefulWidget {
  final PasswordResetAttributes passwordResetAttributes;
  PasswordResetPage({this.passwordResetAttributes});

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  //controllers for input text
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reEnterPassController = TextEditingController();

  Color colorTheme= const Color.fromRGBO(73, 83, 153, 1);

  final _formKey = GlobalKey<FormState>();
  //boolean for input errors
  bool isError = false;
  //boolean for loading indicator
  bool isLoading = false;
  //boolean for password visibility
  bool isVisible = true;

  AuthService _authService = GetIt.I<AuthService>();
  //get the instance for ApiResponse
  ApiResponse<bool> _resetPasswordResponse;

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
          body:isLoading?Center(
            child: SpinKitChasingDots(
              color: colorTheme,
              size: 50,
            ),
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
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3.1,bottom: 40.0),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 2.0),
                            child: Container(
                              height: isError?70:55,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                  controller: otpController,
                                  validator: (otp) =>
                                  otp.isEmpty ? 'please enter OTP' : otp.length>4 || otp.length<4 ? 'OTP length shoulb be 4 digits':null,
                                  style: kTaskTextStyle,
                                  onChanged: (value) {
                                    // updateTitle();
                                  },
                                  decoration:
                                  kTaskTextFormField.copyWith(
                                      prefixIcon: Icon(Icons.keyboard,color: colorTheme,),
                                      hintText: 'Enter 4 digit OTP')),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/18.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 2.0),
                            child: Container(
                              height: isError?70:55,
                              child: TextFormField(
                                 obscureText: isVisible,
                                  controller: passwordController,
                                  validator: (password) =>
                                  password.isEmpty?'Please Enter password':password.length<6 ? 'password length min should be 6 characters' : null,
                                  style: kTaskTextStyle,
                                  onChanged: (value) {
                                    // updateTitle();
                                  },
                                  decoration:
                                  kTaskTextFormField.copyWith(
                                      prefixIcon: Icon(Icons.lock_outline,color: colorTheme,),
                                      suffixIcon: IconButton(icon: Icon(isVisible?Icons.visibility_off:Icons.visibility,color: colorTheme), onPressed: (){
                                        setState(() {
                                          isVisible = !isVisible;
                                        });
                                      }),
                                      hintText: 'Enter new password')),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 2.0),
                            child: Container(
                              height: isError?70:55,
                              child: TextFormField(
                                  obscureText: isVisible,
                                  controller: reEnterPassController,
                                  validator: (password) =>
                                  password != passwordController.text ? 'password not matched' : null,
                                  style: kTaskTextStyle,
                                  onChanged: (value) {
                                    // updateTitle();
                                  },
                                  decoration:
                                  kTaskTextFormField.copyWith(
                                      prefixIcon: Icon(Icons.lock_outline,color: colorTheme,),
                                      suffixIcon: IconButton(icon: Icon(isVisible?Icons.visibility_off:Icons.visibility,color: colorTheme), onPressed: (){
                                        setState(() {
                                          isVisible = !isVisible;
                                        });
                                      }),
                                      hintText: 'Re-enter new password')),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height/14,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: RoundedButton(colorTheme: colorTheme, buttonName: 'Update', onPressed: () async{
                              if(_formKey.currentState.validate()){
                                setState(() {
                                  isLoading = true;
                                });
                                _resetPasswordResponse = await _authService.resetPasswordWithMail(email: widget.passwordResetAttributes.email,
                                    password: passwordController.text,code: otpController.text);
                                if(_resetPasswordResponse.data){
                                  setState(() {
                                    isLoading=false;
                                  });
                                  Toast.show('${_resetPasswordResponse.message}', context);
                                  Navigator.pop(context);
                                }else{
                                  Toast.show('${_resetPasswordResponse.message}', context);
                                }
                              }else{
                                setState(() {
                                  isError = true;
                                });
                              }
                            }
                            ),
                          ),
                          BottomDisplayText(colorTheme: colorTheme, actionText: 'Go back', displayText: 'You don\'t want to reset?  ',
                              textGestureRecognizer:TapGestureRecognizer()..onTap = (){
                               Navigator.pop(context);
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
