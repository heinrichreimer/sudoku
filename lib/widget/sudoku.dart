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
              style:
              Theme
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
  final void Function(int row, int column) onCellTap;

  const Block({
    Key key,
    @required this.block,
    this.onCellTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SquareGrid(
      size: 3,
      generator: (row, column) {
        return InkWell(
          child: Cell(
            cell: block.getCell(row, column),
          ),
          onTap: () => onCellTap(3 * block.y + row, 3 * block.x + column),
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
  final void Function(int row, int column) onCellTap;

  const Sudoku({
    Key key,
    @required this.sudoku,
    this.onCellTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SquareGrid(
      size: 3,
      generator: (row, column) {
        return Block(
          block: sudoku.getBlock(row, column),
          onCellTap: onCellTap,
        );
      },
      divider: BorderSide(
        color: Colors.redAccent /*Theme.of(context).dividerColor*/,
        width: 2.5,
      ),
    );
  }
}
