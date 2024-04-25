## text_coloration

![pub](https://img.shields.io/badge/pub-v0.1.0-orange)

## Getting started

Flutter Package: To Search part of the text and colored with color(it can be used in search widgets or even in paragraph)


### Installing

Add the following to your `pubspec.yaml` file:

    dependencies:
      text_coloration: ^0.1.0

## Usage


```dart
        TextColorationWidget(
              searchedTextStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textToStyled: "simply dummy text",
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s ",
              defaultTextStyleColor: const TextStyle(color: Colors.black),
              maxlines: 6,
              //size: Size(double.maxFinite, 48),
        ),  


```

### Preview


<img src="https://github.com/liodali/text_coloration/blob/main/preview_ios.png" alt="text coloration flutter example" width="320" />

<br>
<br>

**Note** I want to give credit to my colleges at Nerium and as well  to thank them to let me use and also helped me to translate the part of their code to dart, they implemented this in our android application 5 years ago or even more 