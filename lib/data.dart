// receive data from internet and show them in the UI
// here we are using a format JSON to receive the data

import 'dart:convert';

class Document {
  // ours class that we'll use to work with it
  final Map<String, Object?> _json;
  Document() : _json = jsonDecode(documentJson);

  (String, {DateTime modified}) getMetadata() {
    // the function that is getting the data
    if (_json
        case {
          'metadata': {
            'title': String title,
            'modified': String localModified,
          }
        }) {
      return (title, modified: DateTime.parse(localModified));
    }
    throw const FormatException("Unexpected JSON");
  }

  List<Block> getBlock() {
    // the function that is getting the block data into the JSON form
    if (_json case {'blocks': List blocksJson}) {
      return <Block>[
        for (var blocksJson in blocksJson) Block.fromJson(blocksJson)
      ];
    } else {
      throw const FormatException("Unexpected JSON format");
    }
  }
}

// our JSON data
const documentJson = ''' 
{
  "metadata":{
    "title":"My Document",
    "modified": "2023-01-05"
  },
  "blocks": [
    {
    "type":"h1",
    "text":"Chapter 1"
    },
    {
    "type": "p",
    "text":"Lorem ipsum dolor sit amet, consecteteur adipiscing elit."
    },
    {
      "type":"checkbox",
      "checked":true,
      "text":"Learn Dart 3"
    }
  ]
}
''';

// here if we want to seal a class so that the information should be
//automaticaly traete well we use the custom class that is permit us to just fix them the ways we want
sealed class Block {
  Block();
  factory Block.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'type': 'h1', 'text': String text} => HeaderBlock(text),
      {'type': 'p', 'text': String text} => ParagraphBlock(text),
      {'type': 'checkbox', 'text': String text, 'checked': bool checked} =>
        CheckboxBlock(checked, text),
      _ => throw const FormatException("Unexpected Json format")
    };
  }
}

// our custom class to receive data and custom them

class HeaderBlock extends Block {
  final String text;
  HeaderBlock(this.text);
}

class ParagraphBlock extends Block {
  final String text;
  ParagraphBlock(this.text);
}

class CheckboxBlock extends Block {
  final String text;
  final bool isChecked;
  CheckboxBlock(this.isChecked, this.text);
}
