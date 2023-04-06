import 'package:flutter/material.dart';
import 'package:task_manager/data/network_utils.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/screens/otp_verification_screen.dart';
import 'package:task_manager/ui/utils/snackbar_message.dart';
import 'package:task_manager/ui/utils/text_styles.dart';
import 'package:task_manager/ui/widgets/app_elevated_button.dart';
import 'package:task_manager/ui/widgets/app_text_field_widget.dart';
import 'package:task_manager/ui/widgets/screen_background_widget.dart';

class VerifyWithEmailScreen extends StatefulWidget {
  const VerifyWithEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyWithEmailScreen> createState() => _VerifyWithEmailScreenState();
}

class _VerifyWithEmailScreenState extends State<VerifyWithEmailScreen> {

  TextEditingController emailETController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Email Address',
                    style: screenTitleTextStyle,),
                  const  SizedBox(height: 6,),
                  Text('A 6 digits verification pin will sent to your email address',
                    style: screenSubTitleTextStyle),

                  const SizedBox(height: 24,),

                  AppTextFieldWidget(
                      hintText: 'Email',
                      controller: emailETController),
                  const  SizedBox(height: 16,),

                  AppElevatedButton(
                      child: const Icon(Icons.arrow_circle_right_outlined),
                      onTap: () async{
                        final response = await NetworkUtils().getMethod(
                            Urls.recoverVerifyEmailUrl(emailETController.text.trim(),
                            ),
                        );
                        if(response != null && response['status'] == 'success'){
                          if(mounted) {
                          showSnackBarMessage(context, 'Otp successfully send your email..!');
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) =>  OtpVerificationScreen(email: emailETController.text.trim(),),
                          ),
                          );
                        }
                        }else {
                          if(mounted) {
                            showSnackBarMessage(context, 'Otp sent failed, Try again!', true);
                          }
                        }
                      }),
                 const SizedBox(height: 16,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     const Text('Have account?'),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: const Text('Sign in',style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),))
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
