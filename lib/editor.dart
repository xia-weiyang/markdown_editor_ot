import 'package:flutter/material.dart';

class MdEditor extends StatefulWidget {
  MdEditor({
    Key key,
    this.titleStyle,
  }) : super(key: key);

  final TextStyle titleStyle;

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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              hintText: '标题',
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
              hintText: '请输入内容',
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
