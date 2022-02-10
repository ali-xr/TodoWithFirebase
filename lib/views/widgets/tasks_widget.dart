import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task_model.dart';

import 'add_task_widget.dart';
import 'delete_task_widget.dart';

class TasksWidget extends StatefulWidget {
  final DateTime date;
  const TasksWidget({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  State<TasksWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<TasksWidget> {
  Stream<List<TaskModel>> _readTasks() => FirebaseFirestore.instance
      .collection('tasks')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((docs) => TaskModel.fromJson(docs.id, docs.data()))
          .toList());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 8.0,
            offset: const Offset(5.0, 5.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Habits List',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddTaskWidget(
                      date: widget.date,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.green,
                  size: 28.0,
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: _readTasks(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (snapshot.hasData) {
                  List<TaskModel> tasks = snapshot.data!;

                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text('Task is not available'),
                    );
                  } else {
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) => _buildTaskItemWidget(
                        tasks[index],
                        index + 1,
                      ),
                    );
                  }
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Column _buildTaskItemWidget(TaskModel task, int index) {
    bool isCompleted = false;

    for (DateTime date in task.completedDates) {
      if (date.year == widget.date.year &&
          date.month == widget.date.month &&
          date.day == widget.date.day) {
        isCompleted = true;
        break;
      }
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '$index. ${task.title}: ${task.description}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            Checkbox(
              value: isCompleted,
              onChanged: (value) {
                if (isCompleted) {
                  FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(task.id)
                      .update(
                    {
                      "completed_dates": FieldValue.arrayRemove(
                          [Timestamp.fromDate(widget.date)]),
                    },
                  );
                } else {
                  FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(task.id)
                      .update(
                    {
                      "completed_dates": FieldValue.arrayUnion(
                        [Timestamp.fromDate(widget.date)],
                      ),
                    },
                  );
                }
              },
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => DeleteTaskWidget(
                    task: task,
                  ),
                );
              },
              icon: const Icon(
                Icons.clear,
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
