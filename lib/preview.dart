import 'package:flutter/material.dart';
import 'package:markdown_core/builder.dart';
import 'package:markdown_core/markdown.dart';

class MdPreview extends StatefulWidget {
  MdPreview({
    Key key,
    this.text,
    this.padding = const EdgeInsets.all(0.0),
    this.onTapLink,
    this.maxWidth,
    this.widgetImage,
  }) : super(key: key);

  final String text;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final WidgetImage widgetImage;

  /// Call this method when it tap link of markdown.
  /// If [onTapLink] is null,it will open the link with your default browser.
  final TapLinkCallback onTapLink;

  @override
  State<StatefulWidget> createState() => MdPreviewState();
}

class MdPreviewState extends State<MdPreview>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Padding(
        padding: widget.padding,
        child: Markdown(
          data: widget.text ?? '',
          maxWidth: widget.maxWidth ?? MediaQuery.of(context).size.width,
          linkTap: (link) {
            debugPrint(link);
            if (widget.onTapLink != null) {
              widget.onTapLink(link);
            }
          },
          image: widget.widgetImage,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

typedef void TapLinkCallback(String link);
