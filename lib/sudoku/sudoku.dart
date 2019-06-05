import 'package:meta/meta.dart';
import 'package:sudoku/util.dart';

enum Digit { ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE }

abstract class Progress {
  bool get isCorrect;

  bool get isComplete;
}

abstract class Sudoku implements Progress {
  static const int SIZE = 9;
  static const int CELL_COUNT = SIZE * SIZE;

  List<Digit> get _digits;

  List<Set<Digit>> get _notes;

  factory Sudoku() => _Sudoku();

  factory Sudoku.cells(Set<Cell> cells) => _Sudoku.cells(cells);

  factory Sudoku.map(Map<Position, Digit> cells) => _Sudoku.map(cells);

  Cell getCell(int x, int y);

  Row getRow(int y);

  Column getColumn(int x);

  Block getBlock(int x, int y);
}

@immutable
class _Sudoku implements Sudoku {
  static const int SIZE = 9;
  static const int CELL_COUNT = SIZE * SIZE;

  static int _getIndex(int row, int column) => row * SIZE + column;

  static int _getIndexForPosition(Position position) =>
      _getIndex(position.y, position.x);

  @override
  final List<Digit> _digits = List.filled(CELL_COUNT, null);
  @override
  final List<Set<Digit>> _notes = List.filled(CELL_COUNT, Set());

  _Sudoku.cells(Set<Cell> cells) {
    for (Cell cell in cells) {
      this._digits[_getIndexForPosition(cell.position)] = cell.digit;
      this._notes[_getIndexForPosition(cell.position)] = cell.notes;
    }
  }

  _Sudoku.map(Map<Position, Digit> cells) {
    for (var entry in cells.entries) {
      this._digits[_getIndexForPosition(entry.key)] = entry.value;
    }
  }

  @override
  Cell getCell(int x, int y) => _Cell(this, Position(x, y));

  @override
  Row getRow(int y) => _Row(this, y);

  Iterable<Row> get _rows => Iterable.generate(9, (i) => getRow(i));

  @override
  Column getColumn(int x) => _Column(this, x);

  Iterable<Column> get _columns => Iterable.generate(9, (i) => getColumn(i));

  @override
  Block getBlock(int x, int y) => _Block(this, x, y);

  Iterable<Block> get _blocks =>
      Iterable.generate(9, (i) => getBlock(i % 3, i ~/ 3));

  @override
  bool get isComplete {
    return !_rows.any((row) => !row.isComplete) &&
        !_columns.any((column) => !column.isComplete) &&
        !_blocks.any((block) => !block.isComplete);
  }

  @override
  bool get isCorrect {
    return !_rows.any((row) => !row.isCorrect) &&
        !_columns.any((column) => !column.isCorrect) &&
        !_blocks.any((block) => !block.isCorrect);
  }
}

abstract class Cell {
  Position get position;

  Digit digit;

  Set<Digit> get notes;
}

@immutable
class _Cell implements Cell {
  final Sudoku _sudoku;
  @override
  final Position position;

  _Cell(this._sudoku, this.position);

  @override
  Digit get digit => _sudoku._digits[_Sudoku._getIndexForPosition(position)];

  @override
  set digit(Digit _digit) =>
      _sudoku._digits[_Sudoku._getIndexForPosition(position)] = _digit;

  @override
  Set<Digit> get notes =>
      _sudoku._notes[_Sudoku._getIndexForPosition(position)];
}

@immutable
class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);
}

@immutable
abstract class Group implements Progress {
  Iterable<Digit> get digits;

  Iterable<Digit> get _nonEmptyDigits => digits.where((digit) => digit != null);

  @override
  bool get isCorrect => isDistinct(_nonEmptyDigits);

  @override
  bool get isComplete =>
      isCorrect && _nonEmptyDigits.length == Digit.values.length;
}

abstract class Row extends Group {
  static const int WIDTH = Sudoku.SIZE;

  int get y;

  Cell getCell(int x);
}

@immutable
class _Row with Group implements Row {
  final Sudoku _sudoku;
  @override
  final int y;

  _Row(this._sudoku, this.y);

  @override
  Cell getCell(int x) => _sudoku.getCell(x, y);

  @override
  Iterable<Digit> get digits =>
      Iterable.generate(Row.WIDTH, (x) => getCell(x).digit);
}

abstract class Column extends Group {
  static const int HEIGHT = Sudoku.SIZE;

  int get x;

  Cell getCell(int y);
}

@immutable
class _Column with Group implements Column {
  final Sudoku _sudoku;
  @override
  final int x;

  _Column(this._sudoku, this.x);

  @override
  Cell getCell(int y) => _sudoku.getCell(x, y);

  @override
  Iterable<Digit> get digits =>
      Iterable.generate(Column.HEIGHT, (y) => getCell(y).digit);
}

abstract class Block extends Group {
  static const int DIVISIONS = 3;
  static const int SIZE = Sudoku.SIZE ~/ DIVISIONS;
  static const int CELL_COUNT = SIZE * SIZE;

  int get x;

  int get y;

  Cell getCell(int x, int y);
}

@immutable
class _Block with Group implements Block {
  final Sudoku _sudoku;
  @override
  final int x;
  @override
  final int y;

  _Block(this._sudoku, this.x, this.y);

  @override
  Cell getCell(int x, int y) =>
      _sudoku.getCell(Block.SIZE * x + x, Block.SIZE * y + y);

  @override
  Iterable<Digit> get digits =>
      Iterable.generate(Block.CELL_COUNT, (index) {
        int x = index % Block.DIVISIONS;
        int y = index ~/ Block.DIVISIONS;
        return getCell(x, y).digit;
      });
}
