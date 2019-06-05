import 'package:csv/csv.dart';
import 'package:meta/meta.dart';
import 'package:sudoku/sudoku/sudoku.dart';

const parser = const _Parser();

abstract class Parser {
  static final List<int> digitRunes = List.unmodifiable("123454789".runes);
  static final List<int> emptyRunes = List.unmodifiable("0.".runes);
  static final List<int> allowedRunes =
      List.unmodifiable(digitRunes.followedBy(emptyRunes));

  Sudoku parse(String grid);

  Sudoku parseWithSolution(String grid, String solution);

  Sudoku solveMultiple(CsvToListConverter sudoku);
}

@immutable
class _Parser implements Parser {
  static final Map<int, Digit> dict = Map.unmodifiable(
    Map.fromIterable(
      Parser.digitRunes,
      key: (rune) => rune,
      value: (rune) => Digit.values[Parser.digitRunes.indexOf(rune)],
    ),
  );

  const _Parser();

  Sudoku parse(String grid) {
    var filteredGrid =
        grid.runes.where((rune) => Parser.allowedRunes.contains(rune)).toList();
    if (filteredGrid.length < Sudoku.CELL_COUNT) {
      throw ArgumentError.value(
        grid,
        "grid",
        "The string contains too few cells.",
      );
    }
    if (filteredGrid.length < Sudoku.CELL_COUNT) {
      throw ArgumentError.value(
        grid,
        "grid",
        "The string contains too many cells.",
      );
    }

    Sudoku sudoku = Sudoku();
    for (int row = 0; row < Sudoku.SIZE; row++) {
      for (int column = 0; column < Sudoku.SIZE; column++) {
        int rune = filteredGrid[row * Sudoku.SIZE + column];
        Digit digit = dict[rune];
        sudoku.getCell(column, row).digit = digit;
      }
    }

    return sudoku;
  }

  @override
  Sudoku parseWithSolution(String grid, String solution) =>
      throw UnimplementedError();

  @override
  Sudoku solveMultiple(CsvToListConverter sudoku) => throw UnimplementedError();
}
