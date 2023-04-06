import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_utils.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/widgets/screen_background_widget.dart';

import '../utils/snackbar_message.dart';
import '../widgets/deleted_task.dart';
import '../widgets/status_change_bottom_sheet.dart';
import '../widgets/task_list_item.dart';

class CancelledTasksScreen extends StatefulWidget {
  const CancelledTasksScreen({Key? key}) : super(key: key);

  @override
  State<CancelledTasksScreen> createState() => _CancelledTasksScreenState();
}

class _CancelledTasksScreenState extends State<CancelledTasksScreen> {
  TaskModel cancelledTaskModel = TaskModel();
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    getAllCancelledTasks();
  }

  Future<void> getAllCancelledTasks() async{
    inProgress = true;
    setState(() {});
    final response = await NetworkUtils().getMethod(Urls.cancelledTasksUrl);
    if (response != null) {
      cancelledTaskModel = TaskModel.fromJson(response);
    }else {
      if(mounted){
      showSnackBarMessage(context, 'Unable to fetch completed task!, Try Again');
    }
    }

    setState(() {
      inProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: inProgress ? const Center(
          child: CircularProgressIndicator(),
        ) : RefreshIndicator(
          onRefresh: () async {
            getAllCancelledTasks();
          },
          child: ListView.builder(
              itemCount: cancelledTaskModel.data?.length ?? 0,
              itemBuilder: (context, index){
                return TaskListItem(
                  type: 'Cancelled',
                  date: cancelledTaskModel.data?[index].createdDate ?? 'unKnown',
                  description: cancelledTaskModel.data?[index].description ?? 'unKnown',
                  subject: cancelledTaskModel.data?[index].title ?? 'unKnown',
                  onDeletePress: (){
                    onTaskDeleted(context, cancelledTaskModel.data?[index].title,
                        cancelledTaskModel.data?[index].sId, (){
                          getAllCancelledTasks();
                        }
                    );
                  },
                  onEditPress: (){
                    showChangeTaskStatus(
                        'Cancelled',
                        cancelledTaskModel.data?[index].sId ?? '', () {
                      getAllCancelledTasks();
                    }
                    );
                  },colors: Colors.red,
                );}),
        )
    );
  }
}

