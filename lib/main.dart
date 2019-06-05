import 'package:flutter/material.dart';
import 'package:sudoku/sudoku/sudoku.dart' as model;
import 'package:sudoku/widget/sudoku.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SudokuPage(title: 'Flutter Demo Home Page'),
    );
  }
}

@immutable
class SudokuPage extends StatelessWidget {
  final String title;

  const SudokuPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SudokuBody(),
    );
  }
}

@immutable
class SudokuBody extends StatelessWidget {
  final sudoku = model.Sudoku.map({
    model.Position(row: 3, column: 5): model.Digit.FIVE,
    model.Position(row: 1, column: 6): model.Digit.NINE,
    model.Position(row: 2, column: 5): model.Digit.THREE,
    model.Position(row: 3, column: 1): model.Digit.SEVEN,
  });

  @override
  Widget build(BuildContext context) {
    return Sudoku(
      sudoku: sudoku,
      onCellTap: (row, column) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Tapped cell (${column + 1}, ${row + 1})"),
          ),
        );
      },
    );
  }
}

