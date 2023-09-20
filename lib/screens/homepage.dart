
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_cv/riverpod/simple_state_provider.dart';
import 'package:dart_pdf_reader/dart_pdf_reader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  Future<List<int>> _readDocumentData(String name) async {
    File inputFile= File(name);
    Uint8List bytes = inputFile.readAsBytesSync();
    return bytes;
  }



  Future<void> _extractAllText(String filePath, WidgetRef ref) async {
    //Load the existing PDF document.
    PdfDocument document =
    PdfDocument(inputBytes: await _readDocumentData(filePath));

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract all the text from the document.
    String text = extractor.extractText();

    //Display the text.
    print(text);

    ref.read(fileProvider.notifier).state = await text;

  }


  void _openFilePicker(WidgetRef ref) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String filePath = result.files.single.path!;
      // Process the selected file
      print('File selected: $filePath');
      //File inputFile= File(filePath);
      _extractAllText(filePath, ref);

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
        child: SingleChildScrollView(
          child: Text(
            provider.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
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

