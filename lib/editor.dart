import 'package:flutter/material.dart';
import 'package:markdown_editor/action.dart';

class MdEditor extends StatefulWidget {
  MdEditor({
    Key key,
    this.titleStyle,
    this.padding = const EdgeInsets.all(0.0),
    this.initTitle,
    this.initText,
    this.hintTitle,
    this.hintText,
  }) : super(key: key);

  final TextStyle titleStyle;
  final EdgeInsetsGeometry padding;
  final String initTitle;
  final String initText;
  final String hintTitle;
  final String hintText;

  @override
  State<StatefulWidget> createState() => MdEditorState();
}

class MdEditorState extends State<MdEditor> {
  final _titleEditingController = TextEditingController(text: '');
  final _textEditingController = TextEditingController(text: '');
  var _maxLines = 7;

  String getTitle() {
    return _titleEditingController.value.text;
  }

  String getText() {
    return _textEditingController.value.text;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initText != null && widget.initText.isNotEmpty) _maxLines = null;
    _titleEditingController.text = widget.initTitle ?? '';
    _textEditingController.text = widget.initText ?? '';
  }

  void _disposeText(String text, int index) {
    _textEditingController.text += text;
    _textEditingController.selection = TextSelection.collapsed(
        offset: _textEditingController.text.length - index);
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
                    controller: _titleEditingController,
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
                    maxLines: _maxLines,
                    controller: _textEditingController,
                    onChanged: (text) {
                      if (_maxLines != null &&
                          text != null &&
                          text.length > _maxLines) {
                        setState(() {
                          _maxLines = null;
                        });
                      }
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
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 50.0,
                child: Ink(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    boxShadow: [
                      BoxShadow(color: const Color(0xAAF0F0F0)),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      ActionImage(
                        type: ActionType.image,
                        tap: _disposeText,
                      ),
                      ActionImage(
                        type: ActionType.link,
                        tap: _disposeText,
                      ),
                      ActionImage(
                        type: ActionType.fontBold,
                        tap: _disposeText,
                      ),
                      ActionImage(
                        type: ActionType.fontItalic,
                        tap: _disposeText,
                      ),
                      ActionImage(
                        type: ActionType.textQuote,
                        tap: _disposeText,
                      ),
                      ActionImage(
                        type: ActionType.link,
                        tap: _disposeText,
                      ),
                      ActionImage(
                        type: ActionType.h4,
                        tap: _disposeText,
                      ),
                      ActionImage(
                        type: ActionType.h5,
                        tap: _disposeText,
                      ),
                      ActionImage(
                        type: ActionType.h1,
                        tap: _disposeText,
                      ),
                      ActionImage(
                        type: ActionType.h2,
                        tap: _disposeText,
                      ),
                      ActionImage(
                        type: ActionType.h3,
                        tap: _disposeText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
