import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:projecto/src/widget/calendar.dart';

void main() => runApp(ReminderApp());

class ReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (context) => ReminderApp());
          case '/calendar':
            return MaterialPageRoute(builder: (context) => Calendar(reminders: [],));
        }
      },
      debugShowCheckedModeBanner: false,
      title: 'Check Mate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReminderList(title: 'Pending Tasks'),
    );
  }
}

class ReminderList extends StatefulWidget {
  ReminderList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ReminderListState createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  List<Reminder> _reminders = [];
  late List<bool> isChecked = [];

  void _addReminder(String title, String description, DateTime date) {
    setState(() {
      _reminders.add(Reminder(title, description, date));
    });
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
               onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Calendar(reminders: _reminders),
                  ),
                );
              },
              icon: Icon(Icons.calendar_month)),
        ],
      ),
      body: ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          bool check = false;
          isChecked.add(check);
          Text titleDim = Text(
            reminder.title,
            style: TextStyle(
                fontWeight: isChecked[index]
                    ? FontWeight.normal
                    : FontWeight.bold,
                decoration: isChecked[index]
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          );
          Text subtitleDim = Text(
            reminder.description,
            style: TextStyle(
                fontWeight: isChecked[index]
                    ? FontWeight.normal
                    : FontWeight.bold,
                decoration: isChecked[index]
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          );

          
          return Card(
            elevation: 2.0,
            child: ListTile(
              leading: Checkbox(
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked[index],
                onChanged: (value) {
                  setState(() {
                    isChecked[index] = value!;
                  });
                },
              ),
              title: titleDim,
              subtitle: subtitleDim,
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _reminders.removeAt(index);
                  });
                },
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ReminderDialog(
                    onAddReminder: (title, description, date) {
                      _addReminder(title, description, date);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          );
        },
     
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ReminderDialog(
              onAddReminder: (title, description, date) {
                _addReminder(title, description, date);
                Navigator.pop(context);
              },
            ),
          );
        },
        tooltip: 'New Reminder',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Reminder {
  final String title;
  final String description;
  final DateTime date;

  Reminder(this.title, this.description, this.date);
}

class ReminderDialog extends StatefulWidget {
  final Function(String, String, DateTime) onAddReminder;

  ReminderDialog({required this.onAddReminder});

  @override
  _ReminderDialogState createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add a new reminder"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Title",
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 5),
              );
              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
            child: Text("Select date"),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text("CANCEL"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("ADD"),
          onPressed: () {
            widget.onAddReminder(
              _titleController.text,
              _descriptionController.text,
              _selectedDate,
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
