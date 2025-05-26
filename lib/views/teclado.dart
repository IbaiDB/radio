import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class KeyboardScreenView extends StatefulWidget {
  String? txt;

  KeyboardScreenView({super.key, this.txt});

  @override
  _KeyboardScreenViewState createState() => _KeyboardScreenViewState();
}

class _KeyboardScreenViewState extends State<KeyboardScreenView> {
  String input = "";
  bool isNumeric = true;
  @override
  void initState() {
    if (widget.txt != null) {
      setState(() {
        input += widget.txt!;
      });
    }
    super.initState();
  }

  void onKeyPressed(String value) {
    setState(() {
      input += value;
    });
  }

  void onBackspace() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  void onClear() {
    setState(() {
      input = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 255, 186),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              input,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(2),
              child: isNumeric
                  ? StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: buildNumericKeys(),
                    )
                  : StaggeredGrid.count(
                      crossAxisCount: 6,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      children: buildAlphaNumericKeys(),
                    ),
            ),
          )
        ],
      ),
    );
  }

  List<StaggeredGridTile> buildNumericKeys() {
    return [
      buildButton("*", Colors.grey, () => onKeyPressed("*"), 1, 1),
      buildButton("/", Colors.grey, () => onKeyPressed("/"), 1, 1),
      buildButton("#", Colors.grey, () => onKeyPressed("#"), 1, 1),
      buildButton("DEL", Colors.blue, onBackspace, 1, 1),
      buildButton("7", Colors.grey, () => onKeyPressed("7"), 1, 1),
      buildButton("8", Colors.grey, () => onKeyPressed("8"), 1, 1),
      buildButton("9", Colors.grey, () => onKeyPressed("9"), 1, 1),
      buildButton("X", Colors.red, () {
        Navigator.pop(context);
      }, 1, 2),
      buildButton("4", Colors.grey, () => onKeyPressed("4"), 1, 1),
      buildButton("5", Colors.grey, () => onKeyPressed("5"), 1, 1),
      buildButton("6", Colors.grey, () => onKeyPressed("6"), 1, 1),
      buildButton("1", Colors.grey, () => onKeyPressed("1"), 1, 1),
      buildButton("2", Colors.grey, () => onKeyPressed("2"), 1, 1),
      buildButton("3", Colors.grey, () => onKeyPressed("3"), 1, 1),
      buildButton("OK", Colors.green, () {
        Navigator.pop(context, input);
      }, 1, 2),
      buildButton("ABC", Colors.lightBlue, () {
        setState(() {
          isNumeric = false;
        });
      }, 1, 1),
      buildButton("0", Colors.grey, () => onKeyPressed("0"), 1, 1),
      buildButton(".", Colors.grey, () => onKeyPressed("."), 1, 1),
    ];
  }

  List<StaggeredGridTile> buildAlphaNumericKeys() {
    return [
      buildButton("q", Colors.grey, () => onKeyPressed("q"), 1, 2),
      buildButton("w", Colors.grey, () => onKeyPressed("w"), 1, 2),
      buildButton("e", Colors.grey, () => onKeyPressed("e"), 1, 2),
      buildButton("r", Colors.grey, () => onKeyPressed("r"), 1, 2),
      buildButton("t", Colors.grey, () => onKeyPressed("t"), 1, 2),
      buildButton("DEL", Colors.blue, onBackspace, 1, 2),
      buildButton("a", Colors.grey, () => onKeyPressed("a"), 1, 2),
      buildButton("s", Colors.grey, () => onKeyPressed("s"), 1, 2),
      buildButton("d", Colors.grey, () => onKeyPressed("d"), 1, 2),
      buildButton("f", Colors.grey, () => onKeyPressed("f"), 1, 2),
      buildButton("g", Colors.grey, () => onKeyPressed("g"), 1, 2),
      buildButton("X", Colors.red, () {
        Navigator.pop(context);
      }, 1, 3),
      buildButton("->", Colors.grey, () => {}, 1, 2),
      buildButton("z", Colors.grey, () => onKeyPressed("z"), 1, 2),
      buildButton("x", Colors.grey, () => onKeyPressed("x"), 1, 2),
      buildButton("c", Colors.grey, () => onKeyPressed("c"), 1, 2),
      buildButton("v", Colors.grey, () => onKeyPressed("v"), 1, 2),
      buildButton("MAY", Colors.grey, () => {}, 1, 2),
      buildButton(">", Colors.grey, () => onKeyPressed(">"), 1, 2),
      buildButton(";", Colors.grey, () => onKeyPressed(";"), 1, 2),
      buildButton(":", Colors.grey, () => onKeyPressed(":"), 1, 2),
      buildButton("_", Colors.grey, () => onKeyPressed("_"), 1, 2),
      buildButton("OK", Colors.green, () {
        Navigator.pop(context, input);
      }, 1, 2),
      buildButton("123", Colors.lightBlue, () {
        setState(() {
          isNumeric = true;
        });
      }, 1, 2),
      buildButton("<", Colors.grey, () => onKeyPressed("<"), 1, 2),
      buildButton(",", Colors.grey, () => onKeyPressed(","), 1, 2),
      buildButton(".", Colors.grey, () => onKeyPressed("."), 1, 2),
      buildButton("-", Colors.grey, () => onKeyPressed("-"), 1, 2),
    ];
  }

  StaggeredGridTile buildButton(String label, Color color,
      VoidCallback onPressed, int crossAxisCellCount, int mainAxisCellCount) {
    return StaggeredGridTile.count(
      crossAxisCellCount: crossAxisCellCount,
      mainAxisCellCount: mainAxisCellCount,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.all(2),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
