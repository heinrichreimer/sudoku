import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class Square extends AspectRatio {
  const Square({
    Key key,
    Widget child,
  }) : super(key: key, aspectRatio: 1, child: child);
}

@immutable
class DividerBox extends StatelessWidget {
  final Axis axis;
  final BorderSide border;

  const DividerBox({this.border, this.axis});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: axis == Axis.horizontal ? border : BorderSide.none,
          left: axis == Axis.vertical ? border : BorderSide.none,
        ),
      ),
    );
  }
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
    this.divider: BorderSide.none,
  }) : super(key: key);

  Widget buildRow(BuildContext context, int row) {
    return Row(
        children: List.generate(2 * size - 1, (column) {
          if (column.isOdd) {
            return DividerBox(
              border: divider,
              axis: Axis.vertical,
            );
          } else {
            return Flexible(
              child: Square(
                child: generator(row ~/ 2, column ~/ 2),
              ),
            );
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Square(
      child: Column(
        children: List.generate(2 * size - 1, (row) {
          if (row.isOdd) {
            return DividerBox(
              border: divider,
              axis: Axis.horizontal,
            );
          } else {
            return Flexible(
              child: buildRow(context, row),
            );
          }
        }),
      ),
    );
  }
}
