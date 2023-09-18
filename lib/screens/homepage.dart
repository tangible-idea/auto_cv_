
import 'dart:io';

import 'package:auto_cv/riverpod/simple_state_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_text/pdf_text.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;


  void _openFilePicker(WidgetRef ref) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result.files.single.path!;
      // Process the selected file
      print('File selected: $filePath');
      File file= File(filePath);
      PDFDoc doc = await PDFDoc.fromFile(file);
      //print(doc.text);
      //doc.text
      ref.read(fileProvider.notifier).state = await doc.text;


    } else {
      // User canceled the file picking process
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider= ref.watch(fileProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              provider.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> _openFilePicker(ref),
        tooltip: 'file pick',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

