import 'package:flutter/material.dart';
import 'package:text_coloration/text_coloration.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: SafeArea(
        child: IndexedStack(
          index: index,
          children: const [
            TextColorationExamples(),
            TextExample(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        index: index,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  const BottomNav({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onTap,
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
          child: TextColorationWidget.words(
            searchedTextStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            words: const ['simply', 'dummy', 'text', 'lorem', 'ipsum'],
            text:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s ",
            defaultTextStyleColor: const TextStyle(color: Colors.black),
            //maxlines: 6,
          ),
        );
      },
      itemCount: 150,
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
            padding: const EdgeInsets.only(
              bottom: 16,
            ),
            child: TextColorationWidget.link(
              urlTextStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
              ),
              urlAction: () {
                launchUrl(
                  Uri.parse('https://pub.dev/packages/text_coloration'),
                );
              },
              url: 'https://pub.dev/packages/text_coloration',
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry <<https://pub.dev/packages/text_colorations>>.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s ",
              defaultTextStyleColor: const TextStyle(color: Colors.black),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 16,
            ),
            child: TextColorationWidget.link(
              urlTextStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
              ),
              urlAction: () {
                launchUrl(
                  Uri.parse('https://pub.dev/packages/text_coloration'),
                );
              },
              url: 'https://pub.dev/packages/text_coloration',
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry <<https://pub.dev/packages/text_coloration>>.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy text of the printing and typesetting industry <<https://pub.dev/packages/text_coloration>>.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s ",
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
