import 'dart:async';

import 'package:flutter/material.dart';
import 'package:markdown_editor/action.dart';
import 'package:markdown_editor/customize_physics.dart';
import 'package:markdown_editor/edit_perform.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class MdEditorState extends State<MdEditor> with AutomaticKeepAliveClientMixin {
  final _titleEditingController = TextEditingController(text: '');
  final _textEditingController = TextEditingController(text: '');
  var _editPerform;
  SharedPreferences _pres;

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
    ActionType type,
    String text,
    int index, [
    int cursorPosition,
  ]) {
    final _tempKey = 'markdown_editor_${type.toString()}';
    _pres.setInt(_tempKey, (_pres.getInt(_tempKey) ?? 0) + 1);
    debugPrint('$_tempKey   ${_pres.getInt(_tempKey)}');

    var position =
        cursorPosition ?? _textEditingController.selection.base.offset;

    if (position < 0) {
      print('WRAN: The insert position value is $position');
      return;
    }

    var startText = _textEditingController.text.substring(0, position);
    var endText = _textEditingController.text.substring(position);

    var str = startText + text + endText;
    _textEditingController.value = TextEditingValue(
        text: str,
        selection: TextSelection.collapsed(
            offset: startText.length + text.length - index));

    if (widget.textChange != null) widget.textChange();

    _editPerform.change(_textEditingController.text);
  }

  /// 获取光标位置
  int _getCursorPosition() {
    if (_textEditingController.text.isEmpty) return 0;
    if (_textEditingController.selection.base.offset < 0)
      return _textEditingController.text.length;
    return _textEditingController.selection.base.offset;
  }

  Future<void> _initSharedPreferences() async {
    _pres = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
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
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            child: Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black87
                    : const Color(0xFFF0F0F0),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black87
                          : const Color(0xAAF0F0F0)),
                ],
              ),
              child: FutureBuilder(
                future: _pres == null ? _initSharedPreferences() : null,
                builder: (con, snap) {
                  final widgets = <ActionImage>[];

                  widgets.add(ActionImage(
                    type: ActionType.undo,
                    color: widget.actionIconColor,
                    tap: (t, s, i, [p]) {
                      _editPerform.undo();
                    },
                  ));
                  widgets.add(ActionImage(
                    type: ActionType.redo,
                    color: widget.actionIconColor,
                    tap: (t, s, i, [p]) {
                      _editPerform.redo();
                    },
                  ));

                  // sort
                  if (snap.connectionState == ConnectionState.done ||
                      snap.connectionState == ConnectionState.none)
                    widgets.addAll(
                        _getSortActionWidgets().map((sort) => sort.widget));

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widgets,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Sort action buttons by used count.
  List<_SortActionWidget> _getSortActionWidgets() {
    final sortWidget = <_SortActionWidget>[];
    final key = 'markdown_editor';
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.image.toString()}'),
      widget: ActionImage(
        type: ActionType.image,
        color: widget.actionIconColor,
        tap: _disposeText,
        imageSelect: widget.imageSelect,
        getCursorPosition: _getCursorPosition,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.link.toString()}') ?? 9,
      widget: ActionImage(
        type: ActionType.link,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.fontBold.toString()}'),
      widget: ActionImage(
        type: ActionType.fontBold,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.fontItalic.toString()}'),
      widget: ActionImage(
        type: ActionType.fontItalic,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.textQuote.toString()}'),
      widget: ActionImage(
        type: ActionType.textQuote,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.list.toString()}'),
      widget: ActionImage(
        type: ActionType.list,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.h4.toString()}'),
      widget: ActionImage(
        type: ActionType.h4,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.h5.toString()}'),
      widget: ActionImage(
        type: ActionType.h5,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.h1.toString()}'),
      widget: ActionImage(
        type: ActionType.h1,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.h2.toString()}'),
      widget: ActionImage(
        type: ActionType.h2,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));
    sortWidget.add(_SortActionWidget(
      sortValue: _pres.get('${key}_${ActionType.h3.toString()}'),
      widget: ActionImage(
        type: ActionType.h3,
        color: widget.actionIconColor,
        tap: _disposeText,
      ),
    ));

    sortWidget.sort((a, b) => (b.sortValue ?? 0).compareTo(a.sortValue ?? 0));

    return sortWidget;
  }

  @override
  bool get wantKeepAlive => true;
}

class _SortActionWidget {
  final ActionImage widget;
  final int sortValue;

  _SortActionWidget({
    @required this.widget,
    @required this.sortValue,
  });
}
