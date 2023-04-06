import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/network_utils.dart';
import 'package:task_manager/data/urls.dart';
import 'package:task_manager/ui/utils/snackbar_message.dart';
import 'package:task_manager/ui/widgets/deleted_task.dart';
import 'package:task_manager/ui/widgets/screen_background_widget.dart';
import '../widgets/dashboard_item.dart';
import '../widgets/status_change_bottom_sheet.dart';
import '../widgets/task_list_item.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  TaskModel newTaskModel = TaskModel();
  bool Progressbar = false;


  TaskModel newTakModel = TaskModel();
  TaskModel completeTaskModel = TaskModel();
  TaskModel cancelledTaskModel = TaskModel();
  TaskModel progressTaskModel = TaskModel();


  int? newTaskNumber;
  int? completeTaskNumber;
  int? cancelledTaskNumber;
  int? progressTaskNumber;

  @override
  void initState() {
    super.initState();
    getAllNewTasks();
  }

  Future<void> getAllNewTasks() async {
    Progressbar = true;
    setState(() {});
    final newTaskResponse = await NetworkUtils().getMethod(
      Urls.newTasksUrl,
    );
    final completeTaskResponse = await NetworkUtils().getMethod(
      Urls.completedTasksUrl,
    );
    final cancelledTaskResponse = await NetworkUtils().getMethod(
      Urls.cancelledTasksUrl,
    );
    final progressTaskResponse = await NetworkUtils().getMethod(
      Urls.progressTaskUrl,
    );


  if (newTaskResponse != null && completeTaskResponse != null && cancelledTaskResponse != null && progressTaskResponse != null) {
  newTaskModel = TaskModel.fromJson(newTaskResponse);
  completeTaskModel = TaskModel.fromJson(completeTaskResponse);
  cancelledTaskModel = TaskModel.fromJson(cancelledTaskResponse);
  progressTaskModel = TaskModel.fromJson(progressTaskResponse);
  newTaskNumber = newTaskModel.data?.length??0;
  completeTaskNumber = completeTaskModel.data?.length??0;
  cancelledTaskNumber = cancelledTaskModel.data?.length??0;
  progressTaskNumber = progressTaskModel.data?.length??0;
  } else {
  if(mounted){
  showSnackBarMessage(context, 'Unable to fetch new tasks! try again');
  }
  }
    Progressbar = false;
  setState(() {});
}



  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Column(
          children: [
            Row(
              children:  [
                Expanded(
                  child: DashboardItem(
                    typeOfTask: 'New',
                    numberOfTask: newTaskNumber??0,
                  ),
                ),
                Expanded(
                    child: DashboardItem(
                  typeOfTask: 'Completed',
                  numberOfTask: completeTaskNumber??0,
                ),
                ),

                Expanded(
                  child: DashboardItem(
                    typeOfTask: 'Cancelled',
                    numberOfTask: cancelledTaskNumber??0,
                  ),
                ),

                Expanded(
                  child: DashboardItem(
                    typeOfTask: 'In Progress',
                    numberOfTask: progressTaskNumber??0,
                  ),
                ),

              ],
            ),

            Expanded(
              child: Progressbar ? const Center(
                child: CircularProgressIndicator(),
              ) : RefreshIndicator(
                onRefresh: () async {
                  getAllNewTasks();
                },
                child: ListView.builder(
                    itemCount: newTaskModel.data?.length ?? 0,
                    itemBuilder: (context, index){
                  return TaskListItem(
                    type: 'New',
                    date: newTaskModel.data?[index].createdDate ?? 'unKnown',
                    description: newTaskModel.data?[index].description ?? 'unKnown',
                    subject: newTaskModel.data?[index].title ?? 'unKnown',
                    onDeletePress: (){
                      onTaskDeleted(context, newTaskModel.data?[index].title,
                      newTaskModel.data?[index].sId, (){
                        getAllNewTasks();
                          }
                      );
                    },
                    onEditPress: (){
                      showChangeTaskStatus(
                        'New',
                        newTaskModel.data?[index].sId ?? '', () {
                        getAllNewTasks();
                      },
                      );
                    },colors: Colors.amber,
                  );}),
              )
            )

          ],
    ));
  }


}


