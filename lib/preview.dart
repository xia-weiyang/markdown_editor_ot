import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MdPreview extends StatefulWidget {
  MdPreview({
    Key key,
    this.text,
    this.padding = const EdgeInsets.all(0.0),
  }) : super(key: key);

  final String text;
  final EdgeInsetsGeometry padding;

  @override
  State<StatefulWidget> createState() => MdPreviewState();
}

class MdPreviewState extends State<MdPreview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: widget.padding,
        child: MarkdownBody(
          data: widget.text ?? '',
          onTapLink: (href) {
            print(href);
          },
        ),
      ),
    );
  }
}
