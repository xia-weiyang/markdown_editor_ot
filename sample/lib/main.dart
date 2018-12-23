import 'package:flutter/material.dart';
import 'package:markdown_editor/markdown_editor.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: MarkdownEditor(
          initText: """
Markdown是一种可以使用普通文本编辑器编写的标记语言，通过简单的标记语法，它可以使普通文本内容具有一定的格式。更多介绍请参考[百度百科](https://baike.baidu.com/item/markdown/3245829?fr=aladdin)。

<br><br><br><br>

###  1.标题

行首加井号表示不同级别的标题(H1-H6),例如：# H1,## H2,### H3,#### H4(注意：#号后边应有英文空格)。
#  一级标题
##  二级标题
###  三级标题
####  四级标题
#####  五级标题
######  六级标题

 
###  2. 文本

+ 普通文本

直接输入的文字就是普通文本。

+ 单行文本

        使用两个Tab(或八个空格)符实现单行文本.

+ 多行文本

        多行文本和
        单行文本异曲同工，只要在
        每行行首加两个Tab(或八个空格)。

+ 文字高亮

如果你想使一段话中部分文字高亮显示，来起到突出强调的作用，那么可以把它用 \`  \`包围起来，``注意``这不是单引号，而是``Tab``上方，``数字1``左边的按键（注意使用``英文``输入法）。

+ 斜体和粗体

使用 * 或 ** 将文字包围起来表示斜体和粗体。
这是 *斜体*，这是 **粗体**。

###  3. 外链接

使用 \\[描述](链接地址) 为文字增加外链接。
这是去往 [旧时光网站](http://jiushig.com) 的链接。


###  4. 插入图像
使用 !\\[描述](图片链接地址) 插入图像，仅仅比链接前面多了一个!号。
插入图片示例：

![旧时光](http://jiushig.oss-cn-shenzhen.aliyuncs.com/oldtime/oldtime_wallpaper.png)


###  5. 文字引用

行首使用 > 表示文字引用。

单个引用：

> 野火烧不尽，春风吹又生。

当然，你也可以 使用多个>>

>我用了一个
>> 我用了两个


###  6. 列表

使用 *，+，- 表示无序列表。

- 无序列表项 一
- 无序列表项 二
- 无序列表项 三

行首加四个空格表示二级列表，以此类推。

+ 编程语言
    + 脚本语言
        + Python

使用数字和点表示有序列表。

1. 有序列表项 一
2. 有序列表项 二
3. 有序列表项 三 


**Markdown还有很多强大的功能，如有疑问，就在下方评论区发出来和大家一起讨论吧。**
          """,
          padding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }
}
