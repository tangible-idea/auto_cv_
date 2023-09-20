
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_cv/model/user_model.dart';
import 'package:auto_cv/riverpod/simple_state_provider.dart';
import 'package:auto_cv/riverpod/user_profilelist_provider.dart';
import 'package:auto_cv/widgets/data_table.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dart_pdf_reader/dart_pdf_reader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key, required this.title}) {
    initGPT();
  }

  final String title;

  Future<List<int>> _readDocumentData(String name) async {
    File inputFile= File(name);
    Uint8List bytes = inputFile.readAsBytesSync();
    return bytes;
  }

  OpenAI? openAI;
  Future<void> initGPT() async {
    openAI = OpenAI.instance.build(
        token: dotenv.get("API_KEY", fallback: ""),
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 15)),
        enableLog: true);

  }

  Future<String> chatComplete(String messageRequest) async {

    final request = ChatCompleteText(messages: [
      Messages(role: Role.system, content: messageRequest)
    ], maxToken: 8096, model: GptTurbo16k0631Model());


    String resume= "";
    final response = await openAI?.onChatCompletion(request: request);
    for (var element in response!.choices) {
      //print("data -> ${element.message?.content}");
      resume += element.message!.content;
    }
    return resume;
  }



  Future<String> _extractAllText(String filePath) async {
    //Load the existing PDF document.
    PdfDocument document =
    PdfDocument(inputBytes: await _readDocumentData(filePath));

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract all the text from the document.
    String text = extractor.extractText();

    //Display the text.
    //print(text);
    return text;
  }

  /// Select a file to extract.
  void _openFilePicker(WidgetRef ref) async {


    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ["pdf"],
        allowMultiple: true,
    );

    if (result != null) {
      for (var file in result.files) {
        var text= await _extractAllText(file.path!);
        ref.read(fileProvider.notifier).state = text;

        String requestMessage=
        //"\"$text\" \nRead this resume and extract name, headline, number, email, location, years of experience by prgramming skills in json format?";
        "\"$text\" \nRead this resume and extract name, headline, number, email, location, skillsFrontend(String List), skillsBackend(String List), experienceYear(int) in json format?";

        var result= await chatComplete(requestMessage);
        var replacedResult= result.replaceAll('\n', '');
        ref.read(responseProvider.notifier).state = result;

        print(replacedResult);
        var userData= userModelFromJson(replacedResult);
        // add user models to state.
        ref.read(userProfileListProvider.notifier).addUserModel(
            userData
        );
      }
    } else {
      // User canceled the file picking process
      print(" User canceled the file picking process");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileRef= ref.watch(fileProvider);
    final reponseRef= ref.watch(responseProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("title"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text(
              //   fileRef.toString(),
              //   style: Theme.of(context).textTheme.bodySmall,
              // ),
              const CVTable(),
              Text(
                reponseRef.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
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

