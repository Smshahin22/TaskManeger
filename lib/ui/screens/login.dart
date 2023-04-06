
import 'package:flutter/material.dart';
import 'package:task_manager/data/auth_utils.dart';
import 'package:task_manager/data/network_utils.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/screens/main_%20bottom_nav_bar.dart';
import 'package:task_manager/ui/screens/signup_screen.dart';
import 'package:task_manager/ui/screens/verify_with_email_screen.dart';
import 'package:task_manager/ui/utils/snackbar_message.dart';
import 'package:task_manager/ui/utils/text_styles.dart';
import 'package:task_manager/ui/widgets/screen_background_widget.dart';
import '../widgets/app_elevated_button.dart';


class LoginScreen extends StatefulWidget {
  const  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailETController = TextEditingController();
  final TextEditingController _passwordETController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _inProgress = false;

  Future<void> login() async {
    _inProgress = true;
    setState(() {});
    final result = await NetworkUtils().postMethod(Urls.loginUrl,
        body: {
          'email' : _emailETController.text.trim(),
          'password' : _passwordETController.text
        },

        onUnAuthorize: () {
          showSnackBarMessage(context, 'Invalid username or password',true);
        }
    );
    _inProgress = false;
    setState(() {});

    if (result != null && result['status'] == 'success') {
     await AuthUtils.saveUserData(
         result['data']['firstName'],
         result['data']['lastName'],
         result['token'],
         result['data']['photo'],
         result['data']['mobile'],
       result['data']['email']
     );

     if(mounted){
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (
          context)=> const MainBottomNavBar()), (route) => false);
    }
    }
}

  bool _isVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Get stared with', style: screenTitleTextStyle),
                  const SizedBox(height: 3,),
                Text('A new experience, something we haven’t tried before...', style: screenSubTitleTextStyle,),

                const SizedBox(
                    height: 10
                ),
                 const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _emailETController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                        ),
                      hintText: "Email",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                    ),
                    validator: (value){
                      bool emailValid =
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value!);

                      if(value!.isEmpty) {
                        return "Enter your email";
                      }
                       else if(!emailValid){
                        return "Enter valid email";
                      }
                    },

                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  TextFormField(
                    controller: _passwordETController,
                    obscureText: !_isVisibility,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isVisibility = !_isVisibility;
                          });
                        },
                        icon: _isVisibility ? const Icon(Icons.visibility, color: Colors.black,) : const Icon(Icons.visibility_off, color: Colors.grey,),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),

                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                      ),
                      hintText: "Password",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20)
                    ),

                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter Password";
                      }else if(_passwordETController.text.length <6) {
                        return "password Length should me more then 6 characters";
                      }
                    },

                  ),


                 const SizedBox(
                    height: 15,
                  ),

                  if (_inProgress)
                   const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ) else
                  AppElevatedButton(
                    onTap: () {
                      if(_formkey.currentState!.validate()) {
                        login();
                    }else{
                        showSnackBarMessage(context, 'Empty username or password..', );
                      }
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),

                 const SizedBox(
                    height: 24,
                  ),

                  Center(
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifyWithEmailScreen()));
                      },
                      child: const Text('Forgot Password?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpScreen() ));
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),))
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

