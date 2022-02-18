import 'package:flutter/material.dart';
import 'student.dart';
import 'storage.dart';

// created by: R Lutz
//ITEC 4550
// updated 11/15/21

class DialogAddItem extends StatefulWidget {
  @override
  _DialogAddItemState createState() => new _DialogAddItemState();
}

class _DialogAddItemState extends State<DialogAddItem> {
  bool _canSave = false;
  late Student _data;
  Storage storage = Storage();

  void _setCanSave(bool save) {
    if (save != _canSave) setState(() => _canSave = save);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: AppBar(title: const Text('Add Student Name'), actions: <Widget>[
        TextButton(
            child: new Text('ADD',
                style: theme.textTheme.bodyText2!.copyWith(
                    color: _canSave
                        ? Colors.white
                        : new Color.fromRGBO(255, 255, 255, 0.4))),
            onPressed: _canSave
                ? () {
              Navigator.of(context).pop(_data);
            }
                : null)
      ]),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          children: <Widget>[
            new TextField(
              decoration: const InputDecoration(
                labelText: "Enter Name",
              ),
              onChanged: (String value) {
                _data = Student(value, false);
                _setCanSave(value.isNotEmpty);
              },
            ),
          ].toList(),
        ),
      ),
    );
  }
}
