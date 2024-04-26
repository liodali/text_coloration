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
      home: const FirstExamplePage(),
    );
  }
}

class FirstExamplePage extends StatefulWidget {
  const FirstExamplePage({super.key});

  @override
  State<StatefulWidget> createState() => _StateFirstExample();
}

class _StateFirstExample extends State<FirstExamplePage> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IndexedStack(
        index: index,
        children: const [
          TextColorationExamples(),
          TextExample(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.color_lens,
            ),
            label: "colored texts",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.text_fields,
            ),
            label: "normal texts",
          ),
        ],
      ),
    );
  }
}

class TextColorationExamples extends StatelessWidget {
  const TextColorationExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, _) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextColorationWidget(
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
        );
      },
      itemCount: 50,
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: false,
    );
  }
}

class TextExample extends StatelessWidget {
  const TextExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextColorationWidget(
              searchedTextStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textToStyled: "simply dummy text",
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s ",
              defaultTextStyleColor: const TextStyle(color: Colors.black),
            ),
          ),
          for (var i = 0; i < 50; i++) ...[
            const Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"),
            const Text("---"),
            const SizedBox(
              height: 5,
            )
          ],
        ],
      ),
    );
  }
}
