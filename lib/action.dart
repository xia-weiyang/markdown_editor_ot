import 'dart:async';

import 'package:flutter/material.dart';

///  Action image button of markdown editor.
class ActionImage extends StatefulWidget {
  ActionImage({
    Key key,
    this.type,
    this.tap,
    this.imageSelect,
    this.color,
    this.getCursorPosition,
  })  : assert(color != null),
        super(key: key);

  final ActionType type;
  final TapFinishCallback tap;
  final ImageSelectCallback imageSelect;
  final GetCursorPosition getCursorPosition;

  final Color color;

  @override
  ActionImageState createState() => ActionImageState();
}

class ActionImageState extends State<ActionImage> {
  IconData _getImageIconCode() {
    return _defaultImageAttributes
        .firstWhere((img) => img.type == widget.type)
        ?.iconData;
  }

  void _disposeAction() {
    var firstWhere =
        _defaultImageAttributes.firstWhere((img) => img.type == widget.type);
    if (widget.tap != null && firstWhere != null) {
      if (firstWhere.type == ActionType.image) {
        var cursorPosition = widget?.getCursorPosition();
        if (widget.imageSelect != null) {
          widget.imageSelect().then(
            (str) {
              debugPrint('Image select $str');
              if (str != null && str.isNotEmpty) {
                // 延迟执行它，等待TextFiled获取焦点
                // 否则将无法成功插入文本
                Timer(const Duration(milliseconds: 200), () {
                  widget.tap(widget.type, '![]($str)', 0, cursorPosition);
                });
              }
            },
            onError: print,
          );
          return;
        }
      }
      widget.tap(widget.type, firstWhere.text, firstWhere.positionReverse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      preferBelow: false,
      message: _defaultImageAttributes
          .firstWhere((img) => img.type == widget.type)
          ?.tip,
      child: IconButton(
        icon: Icon(
          _getImageIconCode(),
          color: widget.color,
        ),
        onPressed: _disposeAction,
      ),
    );
  }
}

const _defaultImageAttributes = <ImageAttributes>[
  ImageAttributes(
    type: ActionType.undo,
    tip: '撤销',
    iconData: const IconData(
      0xe907,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.redo,
    tip: '恢复',
    iconData: const IconData(
      0xe874,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.image,
    text: '![]()',
    tip: '图片',
    positionReverse: 3,
    iconData: const IconData(
      0xe7ac,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.link,
    text: '[]()',
    tip: '链接',
    positionReverse: 3,
    iconData: const IconData(
      0xe7d8,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.fontBold,
    text: '****',
    tip: '加粗',
    positionReverse: 2,
    iconData: const IconData(
      0xe757,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.fontItalic,
    text: '**',
    tip: '斜体',
    positionReverse: 1,
    iconData: const IconData(
      0xe762,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.textQuote,
    text: '\n>',
    tip: '文字引用',
    positionReverse: 0,
    iconData: const IconData(
      0xe768,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.list,
    text: '\n- ',
    tip: '无序列表',
    positionReverse: 0,
    iconData: const IconData(
      0xe764,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.h4,
    text: '\n#### ',
    tip: '四级标题',
    positionReverse: 0,
    iconData: const IconData(
      0xe75e,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.h5,
    text: '\n##### ',
    tip: '五级标题',
    positionReverse: 0,
    iconData: const IconData(
      0xe75f,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.h1,
    text: '\n# ',
    tip: '一级标题',
    positionReverse: 0,
    iconData: const IconData(
      0xe75b,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.h2,
    text: '\n## ',
    tip: '二级标题',
    positionReverse: 0,
    iconData: const IconData(
      0xe75c,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
  ImageAttributes(
    type: ActionType.h3,
    text: '\n### ',
    tip: '三级标题',
    positionReverse: 0,
    iconData: const IconData(
      0xe75d,
      fontFamily: 'MyIconFont',
      fontPackage: 'markdown_editor',
    ),
  ),
];

enum ActionType {
  undo,
  redo,
  image,
  link,
  fontBold,
  fontItalic,
  fontDeleteLine,
  textQuote,
  list,
  h1,
  h2,
  h3,
  h4,
  h5,
}

class ImageAttributes {
  const ImageAttributes({
    this.tip = '',
    this.text,
    this.positionReverse,
    @required this.type,
    @required this.iconData,
  })  : assert(iconData != null),
        assert(type != null);

  final ActionType type;
  final IconData iconData;
  final String tip;
  final String text;
  final int positionReverse;
}

/// Call this method after clicking the [ActionImage] and completing a series of actions.
/// [text] Adding text.
/// [position] Cursor position that reverse order.
/// [cursorPosition] Will start insert text at this position.
typedef void TapFinishCallback(
  ActionType type,
  String text,
  int positionReverse, [
  int cursorPosition,
]);

/// Call this method after clicking the ImageAction.
/// return your select image path.
typedef Future<String> ImageSelectCallback();

/// Get the current cursor position.
typedef int GetCursorPosition();
