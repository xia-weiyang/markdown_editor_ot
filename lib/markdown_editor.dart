library markdown_editor;

import 'package:flutter/material.dart';
import 'package:markdown_editor/editor.dart';
import 'package:markdown_editor/preview.dart';

class MarkdownEditor extends StatefulWidget {
  MarkdownEditor({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MarkdownEditorWidgetState();
}

class MarkdownEditorWidgetState extends State<MarkdownEditor>
    with SingleTickerProviderStateMixin {
  final GlobalKey<MdEditorState> editorKey = GlobalKey();
  TabController _controller;
  String previewText = '';

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
    _controller.addListener(() {
      if (_controller.index == 1) {
        setState(() {
          previewText = editorKey.currentState.getText();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: _controller,
      children: <Widget>[
        SafeArea(
          child: MdEditor(
            key: editorKey,
          ),
        ),
        SafeArea(
          child: MdPreview(
            text: previewText,
          ),
        ),
      ],
    );
  }
}
