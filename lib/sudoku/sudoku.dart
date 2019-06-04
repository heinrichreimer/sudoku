import 'package:meta/meta.dart';
import 'package:sudoku/util.dart';

enum Digit { ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE }

abstract class Progress {
  bool get isCorrect;

  bool get isComplete;
}

@immutable
class Sudoku implements Progress {
  final List<Cell> cells = List.generate(9 * 9, (i) {
    return Cell(
        Position(i % 9, i ~/ 9), null
    );
  });

  Sudoku.cells(Set<Cell> cells) {
    for (Cell cell in cells) {
      this.cells[cell.position.y + 9 * cell.position.x] = cell;
    }
  }

  Sudoku.map(Map<Position, Digit> cells) {
    for (var entry in cells.entries) {
      this.cells[entry.key.y + 9 * entry.key.x] = Cell(entry.key, entry.value);
    }
  }

  Cell getCell(int x, int y) {
    return cells[y + 9 * x];
  }

  Row getRow(int y) => Row(this, y);

  Iterable<Row> get _rows => Iterable.generate(9, (i) => getRow(i));

  Column getColumn(int x) => Column(this, x);

  Iterable<Column> get _columns => Iterable.generate(9, (i) => getColumn(i));

  Block getBlock(int x, int y) => Block(this, x, y);

  Iterable<Block> get _blocks =>
      Iterable.generate(9, (i) => getBlock(i % 3, i ~/ 3));

  @override
  bool get isComplete => !cells.any((cell) => cell.digit == null);

  @override
  bool get isCorrect {
    return !_rows.any((row) => !row.isCorrect) &&
        !_columns.any((column) => !column.isCorrect) &&
        !_blocks.any((block) => !block.isCorrect);
  }
}

@immutable
class Cell {
  final Position position;
  final Digit digit;

  const Cell(this.position, this.digit);
}

@immutable
class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);
}

@immutable
abstract class Group implements Progress {
  final Iterable<Cell> cells;

  Iterable<Cell> get _nonEmptyCells {
    return cells.where((cell) => cell.digit != null);
  }

  Group(this.cells);

  @override
  bool get isCorrect {
    var digits = _nonEmptyCells.map((cell) => cell.digit);
    return isDistinct(digits);
  }

  @override
  bool get isComplete {
    return isCorrect && _nonEmptyCells.length == Digit.values.length;
  }
}

@immutable
class Row extends Group {
  final Sudoku _sudoku;
  final int _y;

  Row(this._sudoku, this._y)
      : super(_sudoku.cells.where((cell) => cell.position.y == _y));

  Cell getCell(int x) {
    return _sudoku.getCell(x, _y);
  }
}

@immutable
class Column extends Group {
  final Sudoku _sudoku;
  final int _x;

  Column(this._sudoku, this._x)
      : super(_sudoku.cells.where((cell) => cell.position.x == _x));

  Cell getCell(int y) {
    return _sudoku.getCell(_x, y);
  }
}

@immutable
class Block extends Group {
  final Sudoku _sudoku;
  final int _x;
  final int _y;

  Block(this._sudoku, this._x, this._y)
      : super(_sudoku.cells.where((cell) {
          return cell.position.x >= 3 * _x &&
              cell.position.x < 3 * _x + 3 &&
              cell.position.y >= 3 * _y &&
              cell.position.y < 3 * _y + 3;
        }));

  Cell getCell(int x, int y) {
    return _sudoku.getCell(3 * _x + x, 3 * _y + y);
  }
}
