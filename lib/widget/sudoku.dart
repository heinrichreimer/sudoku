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
      child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              "($_row,$_column)",
              style: Theme
                  .of(context)
                  .textTheme
                  .caption
                  .apply(fontSizeDelta: 4),
            ),
          ),
          Center(
            child: Text(
              _digit?.toString() ?? "⨯",
              style: Theme
                  .of(context)
                  .textTheme
                  .subtitle,
            ),
          ),
          SquareGrid(
            size: 3,
            generator: (row, column) {
              var digit = model.Digit.values[3 * row + column];
              return Center(
                child: Text(
                  cell.notes.contains(digit) ? "•" : "⨯",
                  style: Theme
                      .of(context)
                      .textTheme
                      .caption,
                ),
              );
            },
          ),
        ],
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
        width: 1.5,
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
        width: 2.5,
      ),
    );
  }
}
