import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/sudoku/sudoku.dart' as model;
import 'package:sudoku/widget/util.dart';

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
        return Cell(
          cell: block.getCell(row, column),
        );
      },
      divider: BorderSide(
        color: Colors.amberAccent /*Theme.of(context).dividerColor*/,
        width: 1,
      ),
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
    return SquareGrid(
      size: 3,
      generator: (row, column) {
        return Block(
          block: sudoku.getBlock(row, column),
        );
      },
      divider: BorderSide(
        color: Colors.redAccent /*Theme.of(context).dividerColor*/,
        width: 2,
      ),
    );
  }
}
