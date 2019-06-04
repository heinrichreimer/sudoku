import 'dart:collection';

import 'package:meta/meta.dart';

import 'sudoku.dart';

@immutable
abstract class Change {
  final Position position;

  factory Change.digit(Position position, Digit digit) = DigitChange;

  factory Change.note(Position position, Digit note) = NoteChange;

  Change(this.position);
}

@immutable
class DigitChange extends Change {
  final Digit digit;

  DigitChange(Position position, this.digit) : super(position);
}

@immutable
class NoteChange extends Change {
  final Digit digit;

  NoteChange(Position position, this.digit) : super(position);
}

class Session implements Progress {
  final Sudoku initialSudoku;
  final Queue<Change> backStack = Queue();
  final Queue<Change> undoneStack = Queue();

  Session(this.initialSudoku);

  void undo() {
    Change undoneChange = backStack.removeLast();
    undoneStack.addLast(undoneChange);
  }

  void redo() {
    Change redoneChange = undoneStack.removeLast();
    backStack.addLast(redoneChange);
  }

  Sudoku get sudoku {
    // Take initial sudoku and apply all changes.
    throw UnimplementedError();
  }

  @override
  bool get isComplete => sudoku.isComplete;

  @override
  bool get isCorrect => sudoku.isCorrect;
}
