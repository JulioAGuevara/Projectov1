import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../main.dart';

class Calendar extends StatefulWidget {
  final List<Reminder> reminders;

  Calendar({required this.reminders});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _reminders = widget.reminders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
        ),
        selectedDayPredicate: (day) {
          return _selectedDay == day;
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          List<Reminder> selectedDayReminders = _reminders.where((reminder) => isSameDay(reminder.date, selectedDay)).toList();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Reminders on ${DateFormat.yMMMd().format(selectedDay)}"),
                content: ListView.builder(
                  itemCount: selectedDayReminders.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final reminder = selectedDayReminders[index];
                    return ListTile(
                      title: Text(reminder.title),
                      subtitle: Text(reminder.description),
                    );
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("CLOSE"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
        ),
        eventLoader: (day) {
          return _reminders.where((reminder) => isSameDay(reminder.date, day)).toList();
        },
      ),
    );
  }
}