import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MdPreview extends StatefulWidget {
  MdPreview({
    this.text,
    Key key,
  }) : super(key: key);

  final String text;

  @override
  State<StatefulWidget> createState() => MdPreviewState();
}

class MdPreviewState extends State<MdPreview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MarkdownBody(
        data: widget.text ?? '',
        onTapLink: (href) {
          print(href);
        },
      ),
    );
  }
}
