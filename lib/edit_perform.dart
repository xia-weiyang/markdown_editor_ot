import 'package:flutter/material.dart';

/// 撤销与前进
class EditPerform {
  EditPerform(this._textEditingController)
      : assert(_textEditingController != null);

  /// 最大的存储长度
  final _maxLength = 50;

  var _undoList = <_EditData>[];
  var _redoList = <_EditData>[];

  final TextEditingController _textEditingController;

  void change(text) {
    if (_textEditingController.text != null &&
        _textEditingController.text != '') {
      if (_undoList.isNotEmpty) {
        if (_textEditingController.text == _undoList.last.text) return;
      }
      if (_undoList.length >= _maxLength) _undoList.removeAt(0);
      _undoList.add(_EditData(_textEditingController.text,
          _textEditingController.selection.baseOffset));
      _redoList.clear();
    }
  }

  /// 撤销
  void undo() {
//    print(_undoList);
    if (_undoList.isNotEmpty) {
      _redoList.add(_undoList.last);
      _undoList.removeLast();
      if (_undoList.isNotEmpty) {
        _textEditingController.text = _undoList.last.text;
        _textEditingController.selection = TextSelection(
            extentOffset: _undoList.last.position,
            baseOffset: _undoList.last.position);
      } else {
        _textEditingController.text = '';
      }
    }
  }

  /// 恢复
  void redo() {
//    print(_redoList);
    if (_redoList.isNotEmpty) {
      _textEditingController.text = _redoList.last.text;
      _undoList.add(_redoList.last);
      _redoList.removeLast();
      _textEditingController.selection = TextSelection(
          extentOffset: _undoList.last.position,
          baseOffset: _undoList.last.position);
    }
  }
}

class _EditData {
  final String text;
  final int position;

  _EditData(this.text, this.position);

  @override
  String toString() {
    return 'text:$text position:$position';
  }
}
