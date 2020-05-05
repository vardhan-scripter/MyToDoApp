
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:toast/toast.dart';
import 'package:todotask/components/roundedbutton.dart';
import 'package:todotask/model/apiresponse.dart';
import 'package:todotask/screens/password_reset_page.dart';
import 'package:todotask/services/authservice.dart';
import 'package:todotask/utils/constants.dart';
import 'package:get_it/get_it.dart';


class ForgotPasswordPage extends StatefulWidget {
  //controller for email text
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
 final TextEditingController emailController = TextEditingController();

 Color colorTheme= const Color.fromRGBO(73, 83, 153, 1);

  final _formKey = GlobalKey<FormState>();

  bool isError = false;

 bool isLoading = false;
 //get the instance for the AuthService (GetIt)
 AuthService _authService = GetIt.I<AuthService>();
 //get the instance for ApiResponse
 ApiResponse<bool> _forgotPasswordResponse;

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
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2.4,bottom: 40.0),
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 2.0),
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height/14,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: RoundedButton(colorTheme: colorTheme, buttonName: 'Verify', onPressed: () async{
                             if(_formKey.currentState.validate()){
                               setState(() {
                                 isLoading = true;
                               });
                               _forgotPasswordResponse = await _authService.forgotPasswordWithMail(email: emailController.text);
                               if(_forgotPasswordResponse.data){
                                 setState(() {
                                   isLoading = false;
                                 });
                                 Toast.show('${_forgotPasswordResponse.message}', context);
                                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>PasswordResetPage(passwordResetAttributes: PasswordResetAttributes(email: emailController.text))));
                               }else{
                                 Toast.show('${_forgotPasswordResponse.message}', context);
                               }
                             }else{
                               setState(() {
                                 isError = true;
                               });
                             }
                              }
                            ),
                          )
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
