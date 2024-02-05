import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

double safeConvertToDouble(String input) {
  input = input.replaceAll(',', '.');
  List<String> parts = input.split('.');
  if (parts.length >= 3) {
    input = '${parts[0]}.${parts[1]}';
  }

  try {
    return double.parse(input);
  } catch (e) {
    return 0.0;
  }
}

String formatDateWithoutTime(DateTime dateTime) {
  final formatter = DateFormat('dd.MM.yyyy');
  return formatter.format(dateTime);
}

void showInputDialog(BuildContext context, String value, Function func) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController nameController = TextEditingController();
      nameController.text = value;
      return AlertDialog(
        title: Text('Name'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'Name'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              //value = nameController.text;
              func(nameController.text);
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void saveJson(BuildContext context, String filename, String jsonString) async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  if (selectedDirectory != null) {
    showInputDialog(context, 'transaction', (name) {
      String filePath = path.join(selectedDirectory, "$name.json");
      File(filePath).writeAsStringSync(jsonString);
    });
  }
}

Future<String?> loadJson() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path!);
    return file.readAsString();
  } else {
    return null;
  }
}
