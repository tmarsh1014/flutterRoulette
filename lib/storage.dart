// thanks - https://flutter.io/docs/cookbook/persistence/reading-writing-files

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'student.dart';

// created by: R Lutz
//ITEC 4550
// updated 11/15/21

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/names.txt');
  }

  Future<List<Student>> readStudents() async {
    List<Student> names = [];
    try {
      final file = await _localFile;
      await file.readAsLines().then((List<String> lines) {
        for (int i = 0; i < lines.length; i++) {
          List<String> tokens = lines[i].split(',');

          bool vis = tokens[1] == 'true' ? true : false;
          names.add(new Student(tokens[0], vis));
        }
      });
      // Read the file
    } catch (e) {
      print('Whoa Nellie: ' + e.toString());
    }
    return names; // will be empty list if file was not found
  }

  Future<File> writeStudents(List<Student> names) async {

    final file = await _localFile;  // Write the file
    var sink = file.openWrite(mode: FileMode.write);
    for (int i = 0; i < names.length; i++) {
      //print(' ' + names[i].name + ' ' + "$names[i].hidden");
      var line = names[i].name + ',' + (names[i].hidden ? 'true' : 'false') +
          '\n';
      sink.write(line);
    }
    await sink.flush();
    await sink.close();

    return file;
  }
}