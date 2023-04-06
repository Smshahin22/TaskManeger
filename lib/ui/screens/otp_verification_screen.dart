
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/data/network_utils.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/screens/login.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/utils/snackbar_message.dart';
import 'package:task_manager/ui/widgets/app_elevated_button.dart';
import 'package:task_manager/ui/widgets/screen_background_widget.dart';

import '../utils/text_styles.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  final TextEditingController otpPinETController = TextEditingController();

  final GlobalKey<FormState> _foromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SafeArea(
              child: Form(
                key: _foromKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Otp Verification',
                    style: screenTitleTextStyle,),

                   const SizedBox(height: 8,),

                    Text('A 6 digits verification pin will sent to your email address', style: screenSubTitleTextStyle,),
                    const SizedBox(height: 24,),

                    PinCodeTextField(
                      controller: otpPinETController,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.slide,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.red,
                        selectedFillColor: Colors.white,
                        selectedColor: Colors.green,

                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      onCompleted: (v){
                        log('Completed');
                      },
                      onChanged: (value){
                        log(value);
                        setState(() {});
                      },
                      appContext: context,
                      beforeTextPaste: (text){
                        log('Allowing to paste $text');
                        return true;
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter 6 digit verification code that's are already send on your email";
                        } else {
                          return null;
                        }
                      },
                    ),
                   const SizedBox(
                      height: 16,
                    ),
                    AppElevatedButton(
                      child: const Text("Verify"),
                        onTap: () async{
                        if (_foromKey.currentState?.validate() ?? true) {
                            final response = await NetworkUtils().getMethod(Urls.recoverVerifyOTPUrl(
                                widget.email,
                                otpPinETController.text
                            ),
                            );
                            if(response != null && response['status'] == 'success' ) {
                              if(mounted) {
                                showSnackBarMessage(context, 'Otpverification successful');
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(
                                  email: widget.email,
                                  otp: otpPinETController.text,
                                )
                                ),
                                );
                              }
                            }else{
                              if(mounted) {
                                showSnackBarMessage(context, 'Otp verification failed?');
                              }
                            }
                          }
                          }
                          ),

                          const SizedBox(
                          height: 16,
                          ),

                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          const Text('Have account?'),
                          TextButton(onPressed: (){
                          Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(builder: (
                          context)=> const LoginScreen()), (route) => false);
                          }, child: const Text('Sign in', style: TextStyle(
                          color: Colors.green)
                        )
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
