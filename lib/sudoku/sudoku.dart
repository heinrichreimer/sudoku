import 'package:meta/meta.dart';
import 'package:sudoku/sudoku/parser.dart';
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

  factory Sudoku.parse(String grid) => parser.parse(grid);

  Cell getCell({
    @required int row,
    @required int column,
  });

  Row getRow({
    @required int row,
  });

  Column getColumn({
    @required int column,
  });

  Block getBlock({
    @required int row,
    @required int column,
  });
}

@immutable
class _Sudoku implements Sudoku {
  static const int SIZE = 9;
  static const int CELL_COUNT = SIZE * SIZE;

  static int _getIndex({
    @required int row,
    @required int column,
  }) {
    return row * SIZE + column;
  }

  static int _getIndexForPosition(Position position) =>
      _getIndex(row: position.row, column: position.column);

  @override
  final List<Digit> _digits = List.filled(CELL_COUNT, null);

  @override
  final List<Set<Digit>> _notes = List.unmodifiable(
    List.filled(CELL_COUNT, Set<Digit>()),
  );

  _Sudoku();

  _Sudoku.cells(Set<Cell> cells) {
    for (Cell cell in cells) {
      this._digits[_getIndexForPosition(cell.position)] = cell.digit;
      this._notes[_getIndexForPosition(cell.position)]
        ..clear()
        ..addAll(cell.notes);
    }
  }

  _Sudoku.map(Map<Position, Digit> cells) {
    for (var entry in cells.entries) {
      this._digits[_getIndexForPosition(entry.key)] = entry.value;
    }
  }

  @override
  Cell getCell({
    @required int row,
    @required int column,
  }) {
    return _Cell(
      this,
      Position(
        row: row,
        column: column,
      ),
    );
  }

  @override
  Row getRow({
    @required int row,
  }) {
    return _Row(
      this,
      row: row,
    );
  }

  Iterable<Row> get _rows =>
      Iterable.generate(9, (column) => getRow(row: column));

  @override
  Column getColumn({
    @required int column,
  }) {
    return _Column(
      this,
      column: column,
    );
  }

  Iterable<Column> get _columns =>
      Iterable.generate(9, (row) => getColumn(column: row));

  @override
  Block getBlock({
    @required int row,
    @required int column,
  }) {
    return _Block(
      this,
      row: row,
      column: column,
    );
  }

  Iterable<Block> get _blocks {
    return Iterable.generate(
      9,
          (position) => getBlock(row: position % 3, column: position ~/ 3),
    );
  }

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

  Row get row;

  Column get column;

  Block get block;

  Iterable<Group> get groups;
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

  @override
  Row get row {
    return _Row(
      _sudoku,
      row: position.row,
    );
  }

  @override
  Column get column {
    return _Column(
      _sudoku,
      column: position.column,
    );
  }

  @override
  Block get block {
    return _Block(
      _sudoku,
      row: position.row % Block.DIVISIONS,
      column: position.column % Block.DIVISIONS,
    );
  }

  @override
  Iterable<Group> get groups => [row, column, block];
}

@immutable
class Position {
  final int row;
  final int column;

  const Position({
    @required this.row,
    @required this.column,
  });
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

  int get row;

  Cell getCell({
    @required int column,
  });
}

@immutable
class _Row with Group implements Row {
  final Sudoku _sudoku;
  @override
  final int row;

  _Row(this._sudoku, {this.row});

  @override
  Cell getCell({
    @required int column,
  }) {
    return _sudoku.getCell(row: row, column: column);
  }

  @override
  Iterable<Digit> get digits =>
      Iterable.generate(Row.WIDTH, (column) => getCell(column: column).digit);
}

abstract class Column extends Group {
  static const int HEIGHT = Sudoku.SIZE;

  int get column;

  Cell getCell({
    @required int row,
  });
}

@immutable
class _Column with Group implements Column {
  final Sudoku _sudoku;
  @override
  final int column;

  _Column(this._sudoku, {this.column});

  @override
  Cell getCell({
    @required int row,
  }) {
    return _sudoku.getCell(row: row, column: column);
  }

  @override
  Iterable<Digit> get digits =>
      Iterable.generate(Column.HEIGHT, (row) => getCell(row: row).digit);
}

abstract class Block extends Group {
  static const int DIVISIONS = 3;
  static const int SIZE = Sudoku.SIZE ~/ DIVISIONS;
  static const int CELL_COUNT = SIZE * SIZE;

  int get column;

  int get row;

  Cell getCell({
    @required int row,
    @required int column,
  });
}

@immutable
class _Block with Group implements Block {
  final Sudoku _sudoku;
  @override
  final int row;
  @override
  final int column;

  _Block(this._sudoku, {this.row, this.column});

  @override
  Cell getCell({
    @required int row,
    @required int column,
  }) {
    return _sudoku.getCell(
      row: Block.SIZE * this.row + row,
      column: Block.SIZE * this.column + column,
    );
  }

  @override
  Iterable<Digit> get digits {
    return Iterable.generate(Block.CELL_COUNT, (position) {
      return getCell(
        row: position % Block.DIVISIONS,
        column: position ~/ Block.DIVISIONS,
      ).digit;
    });
  }
}
