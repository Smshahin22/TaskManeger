import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/deleted_task.dart';
import 'package:task_manager/ui/widgets/screen_background_widget.dart';


import '../../data/models/task_model.dart';
import '../../data/network_utils.dart';
import '../../data/urls.dart';
import '../utils/snackbar_message.dart';
import '../widgets/task_list_item.dart';

class ProgressTasksScreen extends StatefulWidget {
  const ProgressTasksScreen({Key? key}) : super(key: key);

  @override
  State<ProgressTasksScreen> createState() => _ProgressTasksScreenState();
}

class _ProgressTasksScreenState extends State<ProgressTasksScreen> {
  TaskModel progressTaskModel = TaskModel();
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    getAllProgressTasks();
  }

  Future<void> getAllProgressTasks() async{
    inProgress = true;
    setState(() {});
    final response = await NetworkUtils().getMethod(Urls.progressTaskUrl);
    if (response != null) {
      progressTaskModel = TaskModel.fromJson(response);
    } else {
      if(mounted){
      showSnackBarMessage(context, 'Unable to fetch completed task!, Try Again');
    }
    }
    inProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: inProgress ? const Center(
          child: CircularProgressIndicator(),
        ) : RefreshIndicator(
          onRefresh: () async {
            getAllProgressTasks();
          },
          child: ListView.builder(
              itemCount: progressTaskModel.data?.length ?? 0,
              itemBuilder: (context, index){
                return TaskListItem(
                  type: 'Progress',
                  date: progressTaskModel.data?[index].createdDate ?? 'unKnown',
                  description: progressTaskModel.data?[index].description ?? 'unKnown',
                  subject: progressTaskModel.data?[index].title ?? 'unKnown',
                  onDeletePress: (){
                    onTaskDeleted(context, progressTaskModel.data?[index].title,
                    progressTaskModel.data?[index].sId, (){
                      getAllProgressTasks();
                        }
                    );
                  },
                  onEditPress: (){

                  },colors: Colors.green,
                );}),
        )
    );
  }

}