import 'package:flutter/material.dart';
import 'package:task_manager/data/network_utils.dart';
import 'package:task_manager/data/urls.dart';

void onTaskDeleted(context, taskTitle, taskId, voidCallBack){
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
    title: Text("Delete.?"),
    content: Text("Do you want to deleted this Task?"),
    actions:<Widget> [
      TextButton(
      onPressed: ()=>
          Navigator.pop(context, "Cancle"),
        child: Text("Cancel"),
      ),
      TextButton(
          onPressed: () async{
            final deletedResponse = await NetworkUtils().getMethod(
                Urls.deleteTask(taskId));

                if(deletedResponse!=null){
                  voidCallBack();
                  Navigator.pop(context, "Ok");
            }
          },
          child: const Text("ok"),
      ),
    ],
  )
  );

}