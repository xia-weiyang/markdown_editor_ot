# markdown_editor

Simple and easy to implement your markdown editor, it uses its own parser.

![show](https://xia-weiyang.github.io/gif/markdown_editor.gif)

If you only need to render, you can refer to [https://github.com/xia-weiyang/markdown_core](https://github.com/xia-weiyang/markdown_core)

``` dart
MarkdownEditor(
      initText: 'initText',
      initTitle: 'initText',
      onTapLink: (link){
        print('点击了链接 $link');
      },
      imageWidget: (imageUrl) {
        return // Your image widget ;
      },
      imageSelect: (){ // Click image select btn
        return // selected image link;
      },
)
```
