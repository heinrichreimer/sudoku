import 'package:sudoku/sudoku.dart';
import 'package:test_api/test_api.dart';

void main() {
  group("A sudoku", () {
    test("Loading from a map.", () {
      Sudoku sudoku = Sudoku.map({Position(3, 5): Digit.FOUR});
      var cell = sudoku.getCell(3, 5);
      expect(cell.digit, Digit.FOUR);
      expect(cell.position.x, 3);
      expect(cell.position.y, 5);
    });
  });
}
