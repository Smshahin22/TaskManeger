import 'package:flutter/material.dart';

import 'package:task_manager/data/network_utils.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/utils/snackbar_message.dart';
import 'package:task_manager/ui/utils/text_styles.dart';
import 'package:task_manager/ui/widgets/app_elevated_button.dart';
import 'package:task_manager/ui/widgets/app_text_field_widget.dart';
import 'package:task_manager/ui/widgets/screen_background_widget.dart';
import 'package:task_manager/ui/widgets/user_profile_widget.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

  final TextEditingController  subjectETController = TextEditingController();
  final TextEditingController descriptionETController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
           const UserProfileWidget(),
            Expanded(
                child: ScreenBackground(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          children: [
                           const SizedBox(height: 24,),
                            Text('Add New Task', style: screenTitleTextStyle,),
                            const SizedBox(height: 24,),

                            AppTextFieldWidget(
                              hintText: 'Subject',
                              controller: subjectETController,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Enterr your task subject..! ';
                                }
                                return null;
                              },
                            ),

                            const  SizedBox(height: 8,),

                            AppTextFieldWidget(
                              hintText: 'Description',
                              controller: descriptionETController,
                              maxLines: 5,
                              validator: (value) {
                                if(value?.isEmpty ?? true) {
                                  return 'Enter your task description..!';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16,),
                            if (_inProgress)
                              const Center(
                                child: CircularProgressIndicator(),
                              )
                            else
                            AppElevatedButton(
                                child: const Icon(Icons.arrow_circle_right_outlined),
                                onTap: () async{
                                  if(_formKey.currentState!.validate()) {
                                    _inProgress = true;
                                    setState(() {});


                                  
                                  final result = await NetworkUtils().postMethod(
                                    Urls.createNewTaskUrl,

                                    body: {
                                      "title": subjectETController.text.trim(),
                                      "description":descriptionETController.text.trim(),
                                      "status":"New"
                                    }
                                  );
                                  _inProgress = false;
                                  setState(() {});
                                  if(result != null &&
                                      result['status'] == 'success') {
                                    subjectETController.clear();
                                    descriptionETController.clear();
                                    showSnackBarMessage(context, 'New task add successfull');
                                  }else {
                                   showSnackBarMessage(context, 'New task add failed!, Try again!', true);
                                  }
                                  Navigator.pop(context);
                                }
                                }
                                )
                ],
              ),
                      ),
                    ),
                  ),
            ))
          ],
        ),
      ),
    );
  }



}
