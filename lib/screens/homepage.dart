
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_cv/model/user_model.dart';
import 'package:auto_cv/riverpod/simple_state_provider.dart';
import 'package:auto_cv/riverpod/user_profilelist_provider.dart';
import 'package:auto_cv/utils/export_excel.dart';
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

import '../widgets/circular_progress.dart';

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

  /// request to LLM
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



  Future<String> _extractAllText(Uint8List fileBytes) async {
    //Load the existing PDF document.
    PdfDocument document =
    PdfDocument(inputBytes: fileBytes);

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
      type: FileType.any,
      allowMultiple: true,
    );


    var loadingState= ref.read(loadingProvider.notifier);

    if (result != null) {
      loadingState.state= true;
      for (var file in result.files) {

        var extractedString = "";
        try {
          // PDF -> text
          if(Platform.isMacOS) {
            print("Reading ${file.path}");
            var bytesFile= (await _readDocumentData(file.path!)) as Uint8List;
            extractedString= await _extractAllText(bytesFile);
          }else{ // on Web
             _extractAllText(file.bytes!);
          }

        }catch(e) {
          print(e.toString());
          continue;
        }
        ref.read(fileProvider.notifier).state = extractedString;

        String requestMessage=
        //"\"$text\" \nRead this resume and extract name, headline, number, email, location, years of experience by prgramming skills in json format?";
        "\"$extractedString\" \nRead this resume and extract name, headline, number, email, location, Github link, skillsFrontend(String List), skillsBackend(String List), experienceYear(double) in json format?";

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
      loadingState.state= false;
    } else {
      // User canceled the file picking process
      print(" User canceled the file picking process");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileRef= ref.watch(fileProvider);
    final responseRef= ref.watch(responseProvider);
    final loadingRef= ref.watch(loadingProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Auto CV", style: Theme.of(context).textTheme.titleLarge),
          actions: [
      IconButton(
      icon: const Icon(Icons.import_export),
          onPressed: () {

            var listOfUsers= ref.read(userProfileListProvider.notifier).state;
            ExportUtil.exportUserModelsToExcel(listOfUsers, "./");
          },
        ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            // when it is loading show progress.
            loadingRef ? CircularFullProgress() : const SizedBox(),
            SingleChildScrollView(
              child: Column(
                children: [
                  const CVTable(),
                  Text(
                    responseRef.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> _openFilePicker(ref),
        tooltip: 'pick files',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

