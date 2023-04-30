import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'reminder.dart';
import 'package:intl/intl.dart';

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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  if (!isSameDay(_selectedDay, selectedDay)) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    List<Reminder> remindersForSelectedDay = widget.reminders
        .where((reminder) => isSameDay(reminder.date, selectedDay))
        .toList();

    if (remindersForSelectedDay.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Reminders for ${DateFormat('yMd').format(selectedDay)}"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: remindersForSelectedDay.length,
              itemBuilder: (context, index) {
                final reminder = remindersForSelectedDay[index];
                return ListTile(
                  title: Text(reminder.title),
                  subtitle: Text(reminder.description),
                  trailing: Text(DateFormat('hh:mm a').format(reminder.date)),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("CLOSE"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Calendar'),
    ),
    body: Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: _onDaySelected,
          eventLoader: (day) {
            return widget.reminders
                .where((reminder) => isSameDay(reminder.date, day))
                .toList();
          },
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(color: Colors.white),
            todayDecoration: BoxDecoration(
              color: Colors.blueGrey,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          ),
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.reminders.where((reminder) => isSameDay(reminder.date, _selectedDay)).length,
            itemBuilder: (context, index) {
              final reminder = widget.reminders.where((r) => isSameDay(r.date, _selectedDay)).toList()[index];
              return ListTile(
                title: Text(reminder.title),
                subtitle: Text(reminder.description),
                trailing: Text(DateFormat('hh:mm a').format(reminder.date)),
              );
            },
          ),
        ),
      ],
    ),
  );
}
}
