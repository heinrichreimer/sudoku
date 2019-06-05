import 'package:sudoku/sudoku/sudoku.dart';
import 'package:test_api/test_api.dart';

void main() {
  group("A sudoku", () {
    test("Loading from a map.", () {
      Sudoku sudoku = Sudoku.map({Position(row: 3, column: 5): Digit.FOUR});
      var cell = sudoku.getCell(row: 3, column: 5);
      expect(cell.digit, Digit.FOUR);
      expect(cell.position.row, 3);
      expect(cell.position.column, 5);
    });
  });
}
