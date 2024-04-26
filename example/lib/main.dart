import 'package:flutter/material.dart';
import 'package:text_coloration/text_coloration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: TextColorationExamples(),
        ),
      ),
    );
  }
}

class TextColorationExamples extends StatelessWidget {
  const TextColorationExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 20; i++) ...[
            TextColorationWidget(
              searchedTextStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textToStyled: "simply dummy text",
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s ",
              defaultTextStyleColor: const TextStyle(color: Colors.black),
              //maxlines: 6,
            ),
            const Text("---"),
            const SizedBox(
              height: 5,
            )
          ],
          TextColorationWidget(
            searchedTextStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textToStyled: "simply dummy text 1500s",
            text:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s ",
            defaultTextStyleColor: const TextStyle(color: Colors.black),
            //maxlines: 10,
            //size: Size(double.maxFinite, 60),
          ),
          const Text("---"),
          const SizedBox(
            height: 5,
          ),
          const Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s")
        ],
      ),
    );
  }
}
