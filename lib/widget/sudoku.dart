import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/sudoku/sudoku.dart' as model;
import 'package:sudoku/widget/square.dart';

@immutable
class Cell extends StatelessWidget {
  final model.Cell cell;

  const Cell({
    Key key,
    @required this.cell,
  }) : super(key: key);

  int get _row => cell.position.x + 1;

  int get _column => cell.position.y + 1;

  int get _digit {
    var digit = cell.digit;
    if (digit == null) {
      return null;
    } else {
      return digit.index + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Square(
      child: Center(
        child: Text("($_row,$_column)\n${_digit?.toString() ?? "❌"}"),
      ),
    );
  }
}

@immutable
class SquareGrid extends StatelessWidget {
  final int size;
  final Widget Function(int row, int column) generator;

  SquareGrid({
    Key key,
    @required this.size,
    @required this.generator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Square(
      child: GridView.count(
        crossAxisCount: size,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(size * size, (index) {
          int row = index ~/ size;
          int column = index % size;
          return generator(row, column);
        }),
      ),
    );
  }
}

@immutable
class Block extends StatelessWidget {
  final model.Block block;

  const Block({
    Key key,
    @required this.block,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SquareGrid(
      size: 3,
      generator: (row, column) {
        return Container(
          child: Cell(
            cell: block.getCell(row, column),
          ),
          decoration: BoxDecoration(
            border: Border.all(),
          ),
        );
      },
    );
  }
}

@immutable
class Sudoku extends StatelessWidget {
  final model.Sudoku sudoku;

  const Sudoku({
    Key key,
    @required this.sudoku,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Container(
      child: GridView.count(
        crossAxisCount: 9,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(9 * 9, (index) {
          int row = index ~/ 9;
          int column = index % 9;

          double calculateBorderWidth(int position) {
            if (position + 1 == 9) {
              return 0;
            } else if ((position + 1) % 3 == 0) {
              return 2;
            } else {
              return 0.5;
            }
          }

          Color calculateBorderColor(int position) {
            if (position + 1 == 9) {
              return Colors.transparent;
            } else if ((position + 1) % 3 == 0) {
              return Theme.of(context).hintColor;
            } else {
              return Theme.of(context).dividerColor;
            }
          }

          BorderSide calculateBorderSide(int position) {
            return BorderSide(
              width: calculateBorderWidth(position),
              color: calculateBorderColor(position),
            );
          }

          return Container(
            child: Cell(
              cell: model.Cell(
                model.Position(
                  row,
                  column,
                ),
                null,
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                left: calculateBorderSide(9 - 1 - column),
                right: calculateBorderSide(column),
                top: calculateBorderSide(9 - 1 - row),
                bottom: calculateBorderSide(row),
              ),
            ),
          );
        }),
      ),
    );
    return SquareGrid(
      size: 3,
      generator: (row, column) {
        return Block(
          block: sudoku.getBlock(row, column),
        );
      },
    );
  }
}
