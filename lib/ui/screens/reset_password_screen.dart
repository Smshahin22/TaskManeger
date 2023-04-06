import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/text_styles.dart';
import 'package:task_manager/ui/widgets/screen_background_widget.dart';


import '../../data/network_utils.dart';
import '../../data/urls.dart';
import '../utils/snackbar_message.dart';

import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field_widget.dart';
import 'login.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email,otp;
  const ResetPasswordScreen({Key? key, required this.email, required this.otp}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final TextEditingController _passwordETController = TextEditingController();
  final TextEditingController _cPasswordETController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Set Password", style: screenTitleTextStyle),
                  const SizedBox(height: 8),
                  Text(
                    'Minimum length of password must be 6 with letters and number combination',
                    style: screenSubTitleTextStyle,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  AppTextFieldWidget(
                    obscureText: true,
                    controller: _passwordETController,
                    hintText: 'Password',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AppTextFieldWidget(
                    obscureText: true,
                    hintText: 'Confirm Password',
                    controller: _cPasswordETController,
                    validator: (String? value) {
                      if ((value?.isEmpty ?? true) ||
                          ((value ?? '') != _passwordETController.text)) {
                        return 'Password mismatch';
                      }
                      return null;
                    },

                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppElevatedButton(
                    onTap: () async {
                      if(_formKey.currentState!.validate()){
                        final response = await NetworkUtils().postMethod(
                            Urls.resetPasswordUrl,
                            body: {
                              'email':widget.email,
                              'OTP':widget.otp,
                              'password':_passwordETController.text,
                            }
                        );
                        if (response !=null && response['status']=='success'){
                          if(mounted) {
                            showSnackBarMessage(context, 'password reset successful');
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()), (
                                route) => false);
                          }
                        }else{
                          if(mounted){
                            showSnackBarMessage(context,
                                'password reset failed!Try again',true);
                          }
                        }
                      }
                    },
                    child: const Text('Confirm'),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(" Have account?"),
                      TextButton(
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          })
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
