import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/auth_utils.dart';
import 'package:task_manager/data/network_utils.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/utils/snackbar_message.dart';
import 'package:task_manager/ui/widgets/screen_background_widget.dart';
import '../utils/text_styles.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final TextEditingController _emailETController = TextEditingController();
  final TextEditingController _firstNameETController = TextEditingController();
  final TextEditingController _lastNameETController = TextEditingController();
  final TextEditingController _mobileETController = TextEditingController();
  final TextEditingController _passwordETController = TextEditingController();

   XFile? pickedImage;
  String? base64Image;

  @override
  void initState() {
    super.initState();
    _emailETController.text = AuthUtils.email ?? '';
    _firstNameETController.text = AuthUtils.firstName ?? '';
    _lastNameETController.text = AuthUtils.lastName ?? '';
    _mobileETController.text = AuthUtils.mobile ?? '';
  }

  void updateProfile() async{
    _inProgress = true;
    setState(() {});
    if(pickedImage != null) {
      _inProgress = false;
      setState(() {});
    List<int> imageBytes = await pickedImage!.readAsBytes();
    print(imageBytes);
    base64Image = base64Encode(imageBytes);
    print(base64Image);
    }

    Map<String, String>  bodyParams = {
      'firstName': _firstNameETController.text.trim(),
      'lastName': _lastNameETController.text.trim(),
      'mobile': _mobileETController.text.trim(),
      'photo': base64Image ?? ''
    };

    if(_passwordETController.text.isNotEmpty) {
     bodyParams['password'] = _passwordETController.text;
    }



    final result = await NetworkUtils().postMethod(Urls.profileUpdateUrl, body: bodyParams);
    if(result != null && result['status'] == 'success'){
      Navigator.pop(context);
      showSnackBarMessage(context, 'Successful Profile Update!');
    }else{
      showSnackBarMessage(context, 'Error Profile Update!');
    }
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _inProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: ScreenBackground(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 24,),
                            Text('Update Profile', style: screenTitleTextStyle,),
                            const SizedBox(height: 24,),

                            InkWell(
                              onTap: () async{
                                pickImage();
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8)
                                      )
                                    ),
                                    child: const Text('photo'),
                                  ),
                                  Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: Text(pickedImage?.name ?? '',
                                        maxLines: 1, style: const TextStyle(
                                            overflow: TextOverflow.ellipsis
                                          ),),
                                      ))

                                ],
                              ),
                            ),

                            const SizedBox(height: 8,),
                            AppTextFieldWidget(
                              hintText: 'Email',
                              controller: _emailETController,
                              readOnly: true,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Enter your valid email..';
                                }
                                return null;
                              },
                            ),
                            const  SizedBox(height: 8,),

                            AppTextFieldWidget(
                              hintText: 'First name',
                              controller: _firstNameETController,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Enter your first name..';
                                }
                                return null;
                              },
                            ),
                            const  SizedBox(height: 8,),

                            AppTextFieldWidget(
                              hintText: 'Last name',
                              controller: _lastNameETController,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Enter your last name..';
                                }
                                return null;
                              },
                            ),
                            const  SizedBox(height: 8,),

                            AppTextFieldWidget(
                                hintText: 'Mobile',
                                controller: _mobileETController,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Enter your mobile number..';
                                }
                                return null;
                              },
                            ),
                            const  SizedBox(height: 8,),

                            AppTextFieldWidget(
                              hintText: 'Password',
                              obscureText: true,
                              controller: _passwordETController,
                            ),
                            const  SizedBox(height: 8,),

                            const SizedBox(height: 16,),

                            if (_inProgress)
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                ),
                              )
                            else
                            AppElevatedButton(child: const Icon(
                                Icons.arrow_circle_right_outlined),
                                onTap: (){
                              if(_formKey.currentState!.validate()){
                                updateProfile();
                              }else{
                                showSnackBarMessage(context, 'Empty filled!');
                              }

                            })
                          ],),
                      ),
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  void pickImage() async {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title:const Text('Upload Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async{
                pickedImage  = await ImagePicker()
                    .pickImage(source: ImageSource.camera);
                if(pickedImage != null) {
                  setState(() {});
                }
                Navigator.pop(context);
              },
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
            ),
            ListTile(
              onTap:  () async{
                pickedImage  = await ImagePicker()
                    .pickImage(source: ImageSource.gallery);
                if(pickedImage != null) {
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              leading: const Icon(Icons.browse_gallery),
              title: const Text('Gallery'),

            )
          ],
        ),

      );
    });
  }
}
