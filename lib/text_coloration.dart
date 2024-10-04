library text_coloration;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// [TextColorationWidget]
///
/// this widget will stylish a part of a [text] depend on  the text searched
/// [textToStyled] where will use [searchedTextStyle] to do that
/// also you should provide the maxlines
class TextColorationWidget extends StatefulWidget {
  final String text;
  final TextStyle searchedTextStyle;
  final TextStyle defaultTextStyleColor;
  final int? maxlines;
  final TextDirection textDirection;
  final TextScaler? textScaler;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final Locale? locale;
  final List<String> _textsToStyled;
  final VoidCallback? _urlAction;
  TextColorationWidget.text({
    super.key,
    required this.text,
    required String textToBeStyled,
    required this.searchedTextStyle,
    required this.defaultTextStyleColor,
    this.maxlines,
    this.textDirection = TextDirection.ltr,
    this.textScaler = TextScaler.noScaling,
    this.strutStyle,
    this.textAlign,
    this.locale,
  })  : _textsToStyled = textToBeStyled.split(' '),
        _urlAction = null,
        assert(defaultTextStyleColor.compareTo(searchedTextStyle) !=
                RenderComparison.identical ||
            defaultTextStyleColor.compareTo(searchedTextStyle) !=
                RenderComparison.layout);
  TextColorationWidget.link({
    super.key,
    required this.text,
    required String url,
    required TextStyle urlTextStyle,
    required VoidCallback urlAction,
    required this.defaultTextStyleColor,
    this.maxlines,
    this.textDirection = TextDirection.ltr,
    this.textScaler = TextScaler.noScaling,
    this.strutStyle,
    this.textAlign,
    this.locale,
  })  : _textsToStyled = [url],
        searchedTextStyle = urlTextStyle,
        _urlAction = urlAction,
        assert(!url.contains(' '),
            'use our construtor `.text` instead of default one'),
        assert(defaultTextStyleColor.compareTo(urlTextStyle) !=
                RenderComparison.identical ||
            defaultTextStyleColor.compareTo(urlTextStyle) !=
                RenderComparison.layout);
  TextColorationWidget.words({
    super.key,
    required this.text,
    required List<String> words,
    required this.searchedTextStyle,
    required this.defaultTextStyleColor,
    this.maxlines,
    this.textDirection = TextDirection.ltr,
    this.textScaler = TextScaler.noScaling,
    this.strutStyle,
    this.textAlign,
    this.locale,
  })  : _textsToStyled = words,
        _urlAction = null,
        assert(words.map((e) => e.contains(" ") || e == ' ').isNotEmpty,
            'words should not contain spaces.'),
        assert(defaultTextStyleColor.compareTo(searchedTextStyle) !=
                RenderComparison.identical ||
            defaultTextStyleColor.compareTo(searchedTextStyle) !=
                RenderComparison.layout);

  @override
  State<StatefulWidget> createState() => _TextColorationState();
}

class _TextColorationState extends State<TextColorationWidget> {
  late List<String> searchedText;
  late List<TextSpan> spans;
  @override
  void initState() {
    super.initState();
    searchedText = widget._textsToStyled.length == 1
        ? widget._textsToStyled
        : searchedTextPreparation(widget.text, widget._textsToStyled);
    spans = colorationSpan(widget.text, searchedText);
  }

  @override
  void didUpdateWidget(covariant TextColorationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._textsToStyled != widget._textsToStyled ||
        oldWidget.text != widget.text) {
      searchedText = widget._textsToStyled.length == 1
          ? widget._textsToStyled
          : searchedTextPreparation(widget.text, widget._textsToStyled);
      setState(() {
        spans = colorationSpan(widget.text, searchedText);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: spans,
      ),
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      style: widget.defaultTextStyleColor,
      maxLines: widget.maxlines,
      locale: widget.locale,
      textScaler: widget.textScaler,
    );
  }

  List<String> searchedTextPreparation(String text, List<String> textToStyle) {
    List<String> searchWords =
        List.from(textToStyle); // textToStyle.toLowerCase().split(" ");
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
            style: widget.searchedTextStyle,
            mouseCursor:
                widget._urlAction != null ? SystemMouseCursors.click : null,
            recognizer: TapGestureRecognizer()
              ..onTap = () => widget._urlAction?.call(),
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
              style: widget.defaultTextStyleColor,
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
            style: widget.defaultTextStyleColor,
          ),
        );
        mtitle = "";
      }
    }
    return textsSpanTitle;
  }
}
