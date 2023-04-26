import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({super.key});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar'),
      content: Column(
        children: [
          TextField(
            
          ),
          TextField(),
        ],
      ),
    );
  }
}