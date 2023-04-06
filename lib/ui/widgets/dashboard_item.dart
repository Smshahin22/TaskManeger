import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  const DashboardItem({
    Key? key, required this.numberOfTask, required this.typeOfTask,
  }) : super(key: key);
  final int numberOfTask;
  final String typeOfTask;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(numberOfTask.toString(), style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),),
            const SizedBox(height: 8,),
            FittedBox(child: Text(typeOfTask))
          ],
        ),
      ),
    );
  }
}
