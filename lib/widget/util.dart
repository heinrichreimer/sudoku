import 'package:flutter/material.dart';

@immutable
class Square extends AspectRatio {
  const Square({
    Key key,
    Widget child,
  }) : super(key: key, aspectRatio: 1, child: child);
}

@immutable
class SquareGrid extends StatelessWidget {
  final int size;
  final Widget Function(int row, int column) generator;
  final BorderSide divider;

  const SquareGrid({
    Key key,
    @required this.size,
    @required this.generator,
    this.divider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderSide _calculateBorderSide(int position) {
      if (position + 1 == size) {
        return BorderSide.none;
      } else {
        return divider ?? BorderSide.none;
      }
    }

    return Square(
      child: GridView.count(
        crossAxisCount: size,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(size * size, (index) {
          int row = index ~/ size;
          int column = index % size;
          return Container(
            child: generator(row, column),
            decoration: BoxDecoration(
              border: Border(
                left: _calculateBorderSide(size - 1 - column),
                right: _calculateBorderSide(column),
                top: _calculateBorderSide(size - 1 - row),
                bottom: _calculateBorderSide(row),
              ),
            ),
          );
        }),
      ),
    );
  }
}
