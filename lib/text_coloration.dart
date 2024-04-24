library text_coloration;

import 'package:flutter/material.dart';

class TilteColorationWidget extends StatelessWidget {
  final String title;
  final String textToColor;
  final Color textColor;
  final TextStyle defaultTextStyleColor;
  final int maxlines;
  final TextDirection textDirection;
  final Size size;
  const TilteColorationWidget({
    super.key,
    required this.title,
    required this.textToColor,
    required this.textColor,
    required this.defaultTextStyleColor,
    this.maxlines = 1,
    this.textDirection = TextDirection.ltr,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TitleColorationPainter(
        title: title,
        textToColor: textToColor,
        textColor: textColor,
        defaultTextStyleColor: defaultTextStyleColor,
        maxlines: maxlines,
        textDirection: textDirection,
      ),
      isComplex: true,
      willChange: false,
      size: size,
    );
  }
}

class TitleColorationPainter extends CustomPainter {
  final String title;
  final String textToColor;
  final Color textColor;
  final TextStyle defaultTextStyleColor;
  final int maxlines;
  final TextDirection textDirection;
  const TitleColorationPainter({
    required this.title,
    required this.textToColor,
    required this.textColor,
    required this.defaultTextStyleColor,
    this.maxlines = 1,
    this.textDirection = TextDirection.ltr,
  });

  @override
  void paint(Canvas canvas, Size size) {
    List<TextSpan> textsSpanTitle = [];

    List<String> searchWords = textToColor.toLowerCase().split(" ");
// 2. remove duplicated searchable text
    searchWords = Set<String>.from(searchWords).toList();

// 3. organize filter by length for more precision
// et save  existing  filters in title
    searchWords.sort((a, b) => b.length.compareTo(a.length));
    searchWords = searchWords
        .where((searchWord) =>
            searchWord.trim().isNotEmpty &&
            title.toLowerCase().contains(searchWord))
        .map((searchWord) => searchWord.toLowerCase())
        .toList();

// 4. organize  filters with their position in title
    searchWords.sort((a, b) => title
        .toLowerCase()
        .indexOf(a)
        .compareTo(title.toLowerCase().indexOf(b)));
    String titleName = title.toLowerCase();
    searchWords.sort((a, b) {
      if (searchWords.indexOf(a) > 0) {
        titleName =
            titleName.replaceFirst(searchWords[searchWords.indexOf(a) - 1], "");
      }
      return (titleName.indexOf(a) == titleName.indexOf(b))
          ? b.length.compareTo(a.length)
          : titleName.indexOf(a).compareTo(titleName.indexOf(b));
    });

    String mtitle = title;
    while (mtitle.isNotEmpty) {
      // 5. delete  filters where their are not exist in the title anymore
      searchWords = searchWords
          .where((searchWord) =>
              searchWord.length <= mtitle.length &&
              mtitle.toLowerCase().contains(searchWord))
          .toList();
      if (searchWords.isNotEmpty &&
          mtitle.toLowerCase().indexOf(searchWords.first) == 0) {
        textsSpanTitle.add(
          TextSpan(
            text: mtitle.substring(0, searchWords.first.length),
            style: defaultTextStyleColor.copyWith(
              color: textColor,
            ),
          ),
        );
        mtitle = mtitle.substring(searchWords.first.length);
        searchWords.removeAt(0);
      } else if (searchWords.isNotEmpty &&
          mtitle.toLowerCase().indexOf(searchWords.first) != 0) {
        textsSpanTitle.add(
          TextSpan(
            text: mtitle.substring(
                0, mtitle.toLowerCase().indexOf(searchWords.first)),
            style: defaultTextStyleColor,
          ),
        );
        mtitle =
            mtitle.substring(mtitle.toLowerCase().indexOf(searchWords.first));
      } else {
        textsSpanTitle.add(
          TextSpan(
            text: mtitle.substring(0),
            style: defaultTextStyleColor,
          ),
        );
        mtitle = "";
      }
    }
    final mainTitle = TextSpan(
      //text: textsSpanTitle.first.text,
      style: textsSpanTitle.first.style!.copyWith(
        height: 1.0,
      ),
      children: textsSpanTitle.toList(),
    );
    final painter = TextPainter(
      text: mainTitle,
      textDirection: textDirection,
      maxLines: maxlines,
      ellipsis: "...",
    );
    painter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    painter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant TitleColorationPainter oldDelegate) {
    return title != oldDelegate.title ||
        textToColor != oldDelegate.textToColor ||
        textColor != oldDelegate.textColor ||
        maxlines != oldDelegate.maxlines ||
        defaultTextStyleColor != oldDelegate.defaultTextStyleColor;
  }
}
