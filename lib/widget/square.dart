import 'package:flutter/widgets.dart';

class Square extends AspectRatio {
  const Square({
    Key key,
    Widget child,
  }) : super(key: key, aspectRatio: 1, child: child);
}
