import 'package:flutter/material.dart';

import 'student.dart';
import 'about.dart';
import 'dialogadditem.dart';
import 'storage.dart';

// created by: Taylor Marsh
//ITEC 4550
// updated 11/15/21

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Grizzly Roulette'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late List<Student> items;
  Storage storage = Storage();

  // List<Student> items = [
  //   Student("Charlie", false),
  //   Student("Lucy", false),
  //   Student("Linus", false),
  //   Student("Snoopy", false),
  //   Student("Bob", true),
  // ];

  var _picked = '';

  @override
  void initState() {
    super.initState();
    //set items = the result of readStudents()
    items = [];
    storage.readStudents().then((List<Student> students) {
      setState(() {
        items.addAll(students);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text('Edit List'),
            ),
            ListTile(
              title: const Text('Add Name'),
              onTap: () async {
                Student newStudent = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DialogAddItem(),
                        fullscreenDialog: true));
                setState(() {
                  if (newStudent != null) {
                    items.add(newStudent);
                    storage.writeStudents(items);
                  }
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text('Sort'),
              onTap: () {
                setState(() {
                  items.sort((a, b) {
                    storage.writeStudents(items);
                    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
                  }
                  );
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: const Text('Shuffle'),
              onTap: () {
                // Shuffle List
                setState(() {
                  items.shuffle();
                  storage.writeStudents(items);
                });
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Clear'),
              onTap: () {
                // Clear List
                setState(() {
                  items.clear();
                  storage.writeStudents(items);
                });
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (option) {
              handleSelection(option, context);
            },
            itemBuilder: (BuildContext context) {
              return {'Settings ...', 'OCR ...', 'About ...'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('assets/images/bbuildingwavy.jpg')),
            Text(
              _picked,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                      key: Key(item.name),
                      onDismissed: (direction) {
                        setState(() {
                          items.removeAt(index);
                          storage.writeStudents(items);
                        });
                      },
                      child: ListTile(
                        title: Text(items[index].name),
                        onTap: () {
                          setState(() {
                            print('${items[index].name} tapped');
                            bool curr = items[index].hidden;
                            items[index].hidden = !curr;
                            storage.writeStudents(items);
                          });
                        },
                        trailing: Icon((items[index].hidden)
                            ? Icons.visibility_off
                            : null),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pick,
        tooltip: 'Increment',
        child: Icon(Icons.sync),
      ),
    );
  }

  void _pick() {
    setState(() {
      // option 1
      // bool success = false;
      // while (!success) {
      //   items.shuffle();
      //   if (items.first.hidden != true) {
      //     _picked = items.first.name;
      //     success = true;
      //   }
      // }

      // option 2 - undesirable inf loop
      // while (true) {
      //   items.shuffle();
      //   if (items.first.hidden != true) {
      //     _picked = items.first.name;
      //     break;
      //   }
      // }

      // option 3
      var _visible = items.where((e) => !e.hidden).toList();
      _picked =
          _visible.isEmpty ? '' : (_visible.toList()..shuffle()).first.name;
      if (_picked.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: new Text("No items are selectable"),
          duration: Duration(seconds: 1),
        ));
      }
      print('$_picked was selected');
    });
  }
}

void handleSelection(String option, BuildContext context) {
  switch (option) {
    case 'Settings ...':
      print('Settings ... was clicked');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: new Text("Settings(/OCR) coming soon"),
        duration: Duration(seconds: 1),
      ));
      break;
    case 'About ...':
      print('About ... was clicked');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AboutRoute()));
      break;
    case 'OCR ...':
      print('OCR ... was clicked');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: new Text("Settings(/OCR) coming soon"),
        duration: Duration(seconds: 1),
      ));
      break;
  }
}
