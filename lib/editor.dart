import 'package:flutter/material.dart';
import 'package:markdown_editor/action.dart';
import 'package:markdown_editor/customize_physics.dart';
import 'package:markdown_editor/edit_perform.dart';

class MdEditor extends StatefulWidget {
  MdEditor({
    Key key,
    this.titleStyle,
    this.padding = const EdgeInsets.all(0.0),
    this.initTitle,
    this.initText,
    this.hintTitle,
    this.hintText,
    this.imageSelect,
    this.textChange,
    this.actionIconColor,
    this.cursorColor,
  }) : super(key: key);

  final TextStyle titleStyle;
  final EdgeInsetsGeometry padding;
  final String initTitle;
  final String initText;
  final String hintTitle;
  final String hintText;

  /// see [ImageSelectCallback]
  final ImageSelectCallback imageSelect;

  final VoidCallback textChange;

  /// Change icon color, eg: color of font_bold icon.
  final Color actionIconColor;

  final Color cursorColor;

  @override
  State<StatefulWidget> createState() => MdEditorState();
}

class MdEditorState extends State<MdEditor> {
  final _titleEditingController = TextEditingController(text: '');
  final _textEditingController = TextEditingController(text: '');
  var _editPerform;

  String getTitle() {
    return _titleEditingController.value.text;
  }

  String getText() {
    return _textEditingController.value.text;
  }

  @override
  void initState() {
    super.initState();
    _titleEditingController.text = widget.initTitle ?? '';
    _textEditingController.text = widget.initText ?? '';

    _editPerform = EditPerform(
      _textEditingController,
      initText: _textEditingController.text,
    );
  }

  void _disposeText(
    String text,
    int index, [
    int cursorPosition,
  ]) {
    if (_textEditingController.selection.base.offset < 0) {
      print(
          'WRAN: The value is ${_textEditingController.selection.base.offset}');
      return;
    }

    var position =
        cursorPosition ?? _textEditingController.selection.base.offset;

    var startText = _textEditingController.text.substring(0, position);
    var endText = _textEditingController.text.substring(position);

    var str = startText + text + endText;
    _textEditingController.value = TextEditingValue(
        text: str,
        selection: TextSelection.collapsed(
            offset: startText.length + text.length - index));
  }

  /// 获取光标位置
  int _getCursorPosition() {
    if (_textEditingController.text.isEmpty) return 0;
    if (_textEditingController.selection.base.offset < 0)
      return _textEditingController.text.length;
    return _textEditingController.selection.base.offset;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: widget.padding,
              child: Column(
                children: <Widget>[
                  TextField(
                    maxLines: 1,
                    cursorColor: widget.cursorColor,
                    cursorWidth: 1.5,
                    controller: _titleEditingController,
                    onChanged: (text) {
                      if (widget.textChange != null) widget.textChange();
                    },
                    style: widget.titleStyle ??
                        TextStyle(
                          fontSize: 20.0,
                          color: const Color(0xFF333333),
                        ),
                    decoration: InputDecoration(
                      hintText: widget.hintTitle ?? '标题',
                      border: InputBorder.none,
                    ),
                  ),
                  Container(
                    height: 1.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDDDDD),
                    ),
                  ),
                  TextField(
                    maxLines: null,
                    minLines: 15,
                    cursorColor: widget.cursorColor,
                    cursorWidth: 1.5,
                    controller: _textEditingController,
                    autofocus: true,
                    scrollPhysics: const CustomizePhysics(),
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.1,
                    ),
                    onChanged: (text) {
                      _editPerform.change(text);
                      if (widget.textChange != null) widget.textChange();
                    },
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? '请输入内容',
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            child: Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black54
                    : Color(0xFFF0F0F0),
                boxShadow: [
                  BoxShadow(color: const Color(0xAAF0F0F0)),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    ActionImage(
                      type: ActionType.undo,
                      color: widget.actionIconColor,
                      tap: (s, i, [p]) {
                        _editPerform.undo();
                      },
                    ),
                    ActionImage(
                      type: ActionType.redo,
                      color: widget.actionIconColor,
                      tap: (s, i, [p]) {
                        _editPerform.redo();
                      },
                    ),
                    ActionImage(
                      type: ActionType.image,
                      color: widget.actionIconColor,
                      tap: _disposeText,
                      imageSelect: widget.imageSelect,
                      getCursorPosition: _getCursorPosition,
                    ),
                    ActionImage(
                      type: ActionType.link,
                      color: widget.actionIconColor,
                      tap: _disposeText,
                    ),
                    ActionImage(
                      type: ActionType.fontBold,
                      color: widget.actionIconColor,
                      tap: _disposeText,
                    ),
                    ActionImage(
                      type: ActionType.fontItalic,
                      color: widget.actionIconColor,
                      tap: _disposeText,
                    ),
                    ActionImage(
                      type: ActionType.textQuote,
                      color: widget.actionIconColor,
                      tap: _disposeText,
                    ),
                    ActionImage(
                      type: ActionType.h4,
                      color: widget.actionIconColor,
                      tap: _disposeText,
                    ),
                    ActionImage(
                      type: ActionType.h5,
                      color: widget.actionIconColor,
                      tap: _disposeText,
                    ),
                    ActionImage(
                      type: ActionType.h1,
                      color: widget.actionIconColor,
                      tap: _disposeText,
                    ),
                    ActionImage(
                      type: ActionType.h2,
                      color: widget.actionIconColor,
                      tap: _disposeText,
                    ),
                    ActionImage(
                      type: ActionType.h3,
                      color: widget.actionIconColor,
                      tap: _disposeText,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
