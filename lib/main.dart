import 'package:flutter/material.dart';
import 'package:patterns_codelab/data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(document: Document()),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;
  const DocumentScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    var (title, :modified) = document.getMetadata();
    var blocks = document.getBlock();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text('last modified: ${formatDate(modified)}'),
          Expanded(
              child: ListView.builder(
                  itemCount: blocks.length,
                  itemBuilder: (context, index) {
                    return BlockWidget(block: blocks[index]);
                  }))
        ],
      ),
    );
  }
}

// this class is to custom our data showing

class BlockWidget extends StatelessWidget {
  final Block block;
  const BlockWidget({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle;
    textStyle = switch (block) {
      'h1' => Theme.of(context).textTheme.displayMedium,
      'p' || 'checkbox' => Theme.of(context).textTheme.bodyMedium,
      _ => Theme.of(context).textTheme.bodySmall
    };

    return Container(
        margin: const EdgeInsets.all(8),
        child: switch (block) {
          HeaderBlock(:var text) => Text(
              text,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ParagraphBlock(:var text) => Text(text),
          CheckboxBlock(:var text, :var isChecked) => Row(
              children: [
                Checkbox(value: isChecked, onChanged: (_) {}),
                Text(text)
              ],
            )
        });
  }
}

// this function is permit us to custom our date

String formatDate(DateTime dateTime) {
  var today = DateTime.now();
  var difference = dateTime.difference(today);
  return switch (difference) {
    Duration(inDays: 0) => 'today',
    Duration(inDays: 1) => 'tomorrow',
    Duration(inDays: -1) => 'yesterday',
    Duration(inDays: var days) when days > 7 => '${days ~/ 7} week form now',
    Duration(inDays: var days) when days < -7 => '${days.abs() ~/ 7} weeks ago',
    Duration(inDays: var days, isNegative: true) => '${days.abs()} days ago',
    Duration(inDays: var days) => '$days days form now'
  };
}
