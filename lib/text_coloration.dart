library text_coloration;

import 'package:flutter/material.dart';

/// [TextColorationWidget]
///
/// this widget will stylish a part of a [text] depend on  the text searched
/// [textToStyled] where will use [searchedTextStyle] to do that
/// also you should provide the maxlines
class TextColorationWidget extends StatelessWidget {
  final String text;
  final String textToStyled;
  final TextStyle searchedTextStyle;
  final TextStyle defaultTextStyleColor;
  final int maxlines;
  final TextDirection textDirection;
  final Size? size;
  final TextScaler? textScaler;
  final StrutStyle? strutStyle;
  TextColorationWidget({
    super.key,
    required this.text,
    required this.textToStyled,
    required this.searchedTextStyle,
    required this.defaultTextStyleColor,
    this.maxlines = 9199999999,
    this.textDirection = TextDirection.ltr,
    this.size,
    this.textScaler = TextScaler.noScaling,
    this.strutStyle,
  }) : assert(defaultTextStyleColor.compareTo(searchedTextStyle) !=
                RenderComparison.identical ||
            defaultTextStyleColor.compareTo(searchedTextStyle) !=
                RenderComparison.layout);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TextColorationPainter(
        text: text,
        textToStyle: textToStyled,
        searchedTextStyle: searchedTextStyle,
        defaultTextStyleColor: defaultTextStyleColor,
        maxlines: maxlines,
        textDirection: textDirection,
        textScaler: textScaler ?? MediaQuery.textScalerOf(context),
        strutStyle: strutStyle ??
            StrutStyle.fromTextStyle(
              DefaultTextStyle.of(context).style.merge(defaultTextStyleColor),
            ),
      ),
      isComplex: true,
      willChange: true,
      size: size ?? Size.zero,
      child: Text(
        text,
        style: defaultTextStyleColor.copyWith(
          color: Colors.transparent,
        ),
        maxLines: maxlines,
      ),
    );
  }
}

class TextColorationPainter extends CustomPainter {
  final String text;
  final String textToStyle;
  final TextStyle searchedTextStyle;
  final TextStyle defaultTextStyleColor;
  final int maxlines;
  final TextDirection textDirection;
  final TextScaler textScaler;
  final StrutStyle? strutStyle;
  const TextColorationPainter({
    required this.text,
    required this.textToStyle,
    required this.searchedTextStyle,
    required this.defaultTextStyleColor,
    this.textScaler = TextScaler.noScaling,
    this.strutStyle,
    this.maxlines = 9199999999,
    this.textDirection = TextDirection.ltr,
  });

  @override
  void paint(Canvas canvas, Size size) {
    List<TextSpan> textsSpanTitle = [];

    List<String> searchWords = searchedTextPreparation(textToStyle);

    String mtitle = text;
    textsSpanTitle = colorationSpan(mtitle, searchWords);
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
      textScaler: textScaler,
      strutStyle: strutStyle,
    );
    painter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    debugPrint(painter.height.toString());
    painter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant TextColorationPainter oldDelegate) {
    return text != oldDelegate.text ||
        searchedTextStyle.compareTo(oldDelegate.searchedTextStyle) !=
            RenderComparison.identical ||
        textToStyle != oldDelegate.textToStyle ||
        maxlines != oldDelegate.maxlines ||
        defaultTextStyleColor != oldDelegate.defaultTextStyleColor;
  }

  List<String> searchedTextPreparation(String textToStyle) {
    List<String> searchWords = textToStyle.toLowerCase().split(" ");
// 2. remove duplicated searchable text
    searchWords = Set<String>.from(searchWords).toList();

// 3. organize filter by length for more precision
// and save  existing  filters in title
    searchWords.sort((a, b) => b.length.compareTo(a.length));
    searchWords = searchWords
        .where((searchWord) =>
            searchWord.trim().isNotEmpty &&
            text.toLowerCase().contains(searchWord))
        .map((searchWord) => searchWord.toLowerCase())
        .toList();

// 4. organize  filters with their position in title
    searchWords.sort((a, b) =>
        text.toLowerCase().indexOf(a).compareTo(text.toLowerCase().indexOf(b)));
    String titleName = text.toLowerCase();
    searchWords.sort((a, b) {
      if (searchWords.indexOf(a) > 0) {
        titleName =
            titleName.replaceFirst(searchWords[searchWords.indexOf(a) - 1], "");
      }
      return (titleName.indexOf(a) == titleName.indexOf(b))
          ? b.length.compareTo(a.length)
          : titleName.indexOf(a).compareTo(titleName.indexOf(b));
    });
    return searchWords;
  }

  List<TextSpan> colorationSpan(
    String text,
    List<String> searchedText,
  ) {
    final textsSpanTitle = <TextSpan>[];
    var mtitle = text;
    var searchWords = List<String>.from(searchedText);
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
            style: searchedTextStyle,
          ),
        );
        mtitle = mtitle.substring(searchWords.first.length);
        //searchWords.removeAt(0);
      } else if (searchWords.isNotEmpty &&
          mtitle.toLowerCase().contains(searchWords.first)) {
        final innerText = mtitle.substring(
          0,
          mtitle.toLowerCase().indexOf(searchWords.first),
        );

        if (searchWords
            .where((searchWord) => innerText.contains(searchWord))
            .isNotEmpty) {
          textsSpanTitle.addAll(
            colorationSpan(
              innerText,
              searchWords,
            ),
          );
        } else {
          textsSpanTitle.add(
            TextSpan(
              text: innerText,
              style: defaultTextStyleColor,
            ),
          );
        }
        mtitle = mtitle.substring(
          mtitle.toLowerCase().indexOf(
                searchWords.first,
              ),
        );
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
    return textsSpanTitle;
  }
}
