library markdown_editor;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:markdown_core/builder.dart';
import 'package:markdown_editor_ot/src/action.dart';
import 'package:markdown_editor_ot/src/editor.dart';
import 'package:markdown_editor_ot/src/preview.dart';

class MarkdownText {
  const MarkdownText(this.title, this.text);

  final String title;
  final String text;
}

enum PageType { editor, preview }

class MarkdownEditor extends StatefulWidget {
  MarkdownEditor({
    Key? key,
    this.padding = const EdgeInsets.all(0.0),
    this.initTitle,
    this.initText,
    this.hintTitle,
    this.hintText,
    this.onTapLink,
    this.imageSelect,
    this.tabChange,
    this.textChange,
    this.actionIconColor = Colors.grey,
    this.cursorColor,
    this.titleTextStyle,
    this.textStyle,
    this.hintTitleTextStyle,
    this.hintTextStyle,
    this.appendBottomWidget,
    this.physics,
    this.splitWidget,
    required this.imageWidget,
    this.titleFocusNode,
    this.textFocusNode,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final String? initTitle;
  final String? initText;
  final String? hintTitle;
  final String? hintText;

  /// see [MdPreview.onTapLink]
  final TapLinkCallback? onTapLink;

  /// see [ImageSelectCallback]
  final ImageSelectCallback? imageSelect;

  /// When page change to [PageType.preview] or [PageType.editor]
  final TabChange? tabChange;

  /// When title or text changed
  final VoidCallback? textChange;

  /// Change icon color, eg: color of font_bold icon.
  final Color? actionIconColor;

  /// Change cursor color
  final Color? cursorColor;

  final ScrollPhysics? physics;

  final TextStyle? titleTextStyle;
  final TextStyle? textStyle;
  final TextStyle? hintTitleTextStyle;
  final TextStyle? hintTextStyle;

  final Widget? appendBottomWidget;
  final Widget? splitWidget;

  final WidgetImage imageWidget;

  final FocusNode? titleFocusNode, textFocusNode;

  @override
  State<StatefulWidget> createState() => MarkdownEditorWidgetState();
}

class MarkdownEditorWidgetState extends State<MarkdownEditor>
    with SingleTickerProviderStateMixin {
  final GlobalKey<MdEditorState> _editorKey = GlobalKey();
  late TabController _controller;
  String _previewText = '';

  /// Get edited Markdown title and text
  MarkdownText getMarkDownText() {
    return MarkdownText(
        _editorKey.currentState?.getTitle() ?? '', _editorKey.currentState?.getText() ?? '');
  }

  /// Change current [PageType]
  void setCurrentPage(PageType type) {
    _controller.index = type.index;
  }

  MdEditorState? getMdEditorState(){
    return _editorKey.currentState;
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: PageType.values.length);
    _controller.addListener(() {
      if (_controller.index == PageType.preview.index) {
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _previewText = _editorKey.currentState?.getText() ?? '';
          });
        });
      }
      if (widget.tabChange != null) {
        widget.tabChange!(_controller.index == PageType.editor.index
            ? PageType.editor
            : PageType.preview);
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
      physics: widget.physics,
      children: <Widget>[
        MdEditor(
          key: _editorKey,
          padding: widget.padding,
          initText: widget.initText,
          initTitle: widget.initTitle,
          hintText: widget.hintText,
          hintTitle: widget.hintTitle,
          titleStyle: widget.titleTextStyle,
          textStyle: widget.textStyle,
          hintTitleStyle: widget.hintTitleTextStyle,
          hintTextStyle: widget.hintTextStyle,
          imageSelect: widget.imageSelect,
          textChange: widget.textChange,
          actionIconColor: widget.actionIconColor,
          cursorColor: widget.cursorColor,
          appendBottomWidget: widget.appendBottomWidget,
          splitWidget: widget.splitWidget,
          titleFocusNode: widget.titleFocusNode,
          textFocusNode: widget.textFocusNode,
          physics: widget.physics,
        ),
        MdPreview(
          text: _previewText,
          padding: widget.padding,
          onTapLink: widget.onTapLink,
          widgetImage: widget.imageWidget,
          textStyle: widget.textStyle,
          physics: widget.physics,
        ),
      ],
    );
  }
}

typedef void TabChange(PageType type);
