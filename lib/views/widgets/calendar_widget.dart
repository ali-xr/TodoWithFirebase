import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:todo_app/models/constants.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime dateTime;
  final DateTime selectedDate;
  final Function press;
  const CalendarWidget({
    Key? key,
    required this.dateTime,
    required this.selectedDate,
    required this.press,
  }) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    final Jiffy _dateConstructor = Jiffy(
      [widget.dateTime.year, widget.dateTime.month, widget.dateTime.day],
    );

    final Jiffy _dateOfStart = Jiffy(
      [widget.dateTime.year, widget.dateTime.month, 1],
    );

    final int _date = _dateConstructor.date;

    final int _dayStartOfWeek = _dateOfStart.day;

    final int _dayOfMonth = _dateOfStart.daysInMonth;

    int _calendar_day = 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 18.0,
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
          Text(
            _dateConstructor.format("MMMM y"),
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              weekNames.length,
              (index) => Container(
                width: 38.0,
                height: 32.0,
                alignment: Alignment.center,
                child: Text(
                  weekNames[index],
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: List.generate(
              6,
              (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    7,
                    (index) {
                      _calendar_day++;

                      int date = (_calendar_day - (_dayStartOfWeek - 1));

                      if (date > _dayOfMonth) {
                        return const SizedBox(
                          width: 38.0,
                          height: 32.0,
                        );
                      }

                      return _dayStartOfWeek > _calendar_day
                          ? const SizedBox(
                              width: 38.0,
                              height: 32.0,
                            )
                          : GestureDetector(
                              onTap: () {
                                widget.press(date);
                              },
                              child: Container(
                                width: 38.0,
                                height: 32.0,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: widget.selectedDate.day == date
                                      ? Colors.green
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: _date == date
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _dayStartOfWeek > _calendar_day
                                      ? ""
                                      : date.toString(),
                                  style: TextStyle(
                                    color: widget.selectedDate.day == date
                                        ? Colors.white
                                        : _date == date
                                            ? Colors.blue
                                            : Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
