import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:projecto/src/widget/calendar.dart';

void main() => runApp(ReminderApp());

class ReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings){
        switch(settings.name){
          case '/home':
            return MaterialPageRoute(builder: (context)=>ReminderApp());
          case '/calendar':
            return MaterialPageRoute(builder: (context)=>Calendar());
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

  void _addReminder(String title, String description) {
    setState(() {
      _reminders.add(Reminder(title, description));
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
          
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed('/calendar');
          }, icon: Icon(Icons.calendar_month)),
        ]
        ),
      body: ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          bool check = false;
          isChecked.add(check);
          Text titleDim = Text(reminder.title, style: TextStyle(
            fontWeight: isChecked[index] ? FontWeight.normal : FontWeight.bold, decoration: isChecked[index] ? TextDecoration.lineThrough : TextDecoration.none
            ),
          );
          Text subtitleDim = Text(reminder.description, style: TextStyle(
            fontWeight: isChecked[index] ? FontWeight.normal : FontWeight.bold, decoration: isChecked[index] ? TextDecoration.lineThrough : TextDecoration.none
            ),
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
                    onAddReminder: (title, description) {
                      _addReminder(title, description);
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
              onAddReminder: (title, description) {
                _addReminder(title, description);
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

  Reminder(this.title, this.description);
}

class ReminderDialog extends StatefulWidget {
  final Function(String, String) onAddReminder;

  ReminderDialog({required this.onAddReminder});

  @override
  _ReminderDialogState createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

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