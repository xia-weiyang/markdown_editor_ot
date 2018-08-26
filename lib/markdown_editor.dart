library markdown_editor;

import 'package:flutter/material.dart';
import 'package:markdown_editor/editor.dart';
import 'package:markdown_editor/preview.dart';

class MarkdownText {
  const MarkdownText(this.title, this.text);

  final String title;
  final String text;
}

enum PageType { editor, preview }

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

  /// Get edited Markdown title and text
  MarkdownText getMarkDownText() {
    return MarkdownText(
        editorKey.currentState.getTitle(), editorKey.currentState.getText());
  }

  /// Change current [PageType]
  void setCurrentPage(PageType type) {
    _controller.index = type.index;
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: PageType.values.length);
    _controller.addListener(() {
      if (_controller.index == PageType.preview.index) {
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
