import 'package:flutter/material.dart';

class MdEditor extends StatefulWidget {
  MdEditor({
    Key key,
    this.titleDecoration,
    this.textDecoration,
  }) : super(key: key);

  /// 标题输入框装饰
  final InputDecoration titleDecoration;

  /// 内容文本输入框装饰
  final InputDecoration textDecoration;

  @override
  State<StatefulWidget> createState() => MdEditorState();
}

class MdEditorState extends State<MdEditor> {
  final _titleEditingController = TextEditingController(text: '');
  final _textEditingController = TextEditingController(text: '');

  String getTitle(){
    return _titleEditingController.value.text;
  }

  String getText(){
    return _textEditingController.value.text;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TextField(
            maxLines: 1,
            controller: _titleEditingController,
            decoration: widget.titleDecoration ??
                InputDecoration(
                  hintText: '标题',
                ),
          ),
          TextField(
            maxLines: null,
            controller: _textEditingController,
            decoration: widget.textDecoration ??
                InputDecoration(
                  hintText: '请输入内容',
                ),
          ),
        ],
      ),
    );
  }
}
