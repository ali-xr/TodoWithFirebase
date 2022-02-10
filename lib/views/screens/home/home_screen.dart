import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:todo_app/views/widgets/calendar_widget.dart';
import 'package:todo_app/views/widgets/tasks_widget.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Jiffy _dateConstructor = Jiffy(
    [DateTime.now().year, DateTime.now().month, DateTime.now().day],
  );

  Jiffy _selectedDate = Jiffy(
    [DateTime.now().year, DateTime.now().month, DateTime.now().day],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Habits',
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            CalendarWidget(
              dateTime: _dateConstructor.dateTime,
              selectedDate: _selectedDate.dateTime,
              press: (int date) {
                setState(() {
                  _selectedDate = Jiffy([
                    DateTime.now().year,
                    DateTime.now().month,
                    date,
                  ]);
                });
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: TasksWidget(
                date: _selectedDate.dateTime,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
