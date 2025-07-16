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
  bool isAlpha1 = true;
  bool isMayus = false;
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                input,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                overflow:
                    TextOverflow.visible, // para que el scroll funcione bien
                softWrap: false,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: isNumeric
                  ? EdgeInsets.all(2)
                  : EdgeInsets.only(top: 8, right: 2, left: 2),
              child: isNumeric
                  ? StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: buildNumericKeys(),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return StaggeredGrid.count(
                          crossAxisCount: 5,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                          children: buildAlphaNumericKeys(),
                        );
                      },
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
    if (isAlpha1) {
      if (isMayus) {
        return [
          //*************************************** ALPHANUM1 Y MAYÚSCULA **************************************************
          buildButton("Q", Colors.grey, () => onKeyPressed("Q"), 1, 1),
          buildButton("W", Colors.grey, () => onKeyPressed("W"), 1, 1),
          buildButton("E", Colors.grey, () => onKeyPressed("E"), 1, 1),
          buildButton("R", Colors.grey, () => onKeyPressed("R"), 1, 1),
          buildButton("DEL", Colors.blue, onBackspace, 1, 1),
          buildButton("A", Colors.grey, () => onKeyPressed("A"), 1, 1),
          buildButton("S", Colors.grey, () => onKeyPressed("S"), 1, 1),
          buildButton("D", Colors.grey, () => onKeyPressed("D"), 1, 1),
          buildButton("F", Colors.grey, () => onKeyPressed("F"), 1, 1),
          buildButton("X", Colors.red, () {
            Navigator.pop(context);
          }, 1, 2),
          buildButton("Z", Colors.grey, () => onKeyPressed("Z"), 1, 1),
          buildButton("X", Colors.grey, () => onKeyPressed("X"), 1, 1),
          buildButton("C", Colors.grey, () => onKeyPressed("C"), 1, 1),
          buildButton("V", Colors.grey, () => onKeyPressed("V"), 1, 1),
          buildButton("B", Colors.grey, () => onKeyPressed("B"), 1, 1),
          buildButton("N", Colors.grey, () => onKeyPressed("N"), 1, 1),
          buildButton(">", Colors.grey, () => onKeyPressed(">"), 1, 1),
          buildButton("<", Colors.grey, () => onKeyPressed("<"), 1, 1),
          buildButton("OK", Colors.green, () {
            Navigator.pop(context, input);
          }, 1, 2),
          buildButton("MIN", Colors.purple, () {
            setState(() {
              isMayus = false;
            });
          }, 1, 1),
          buildButton(":", Colors.grey, () => onKeyPressed(":"), 1, 1),
          buildButton("_", Colors.grey, () => onKeyPressed("_"), 1, 1),
          buildButton("-", Colors.grey, () => onKeyPressed("-"), 1, 1),
          buildButton("123", Colors.lightBlue, () {
            setState(() {
              isNumeric = true;
            });
          }, 1, 1),
          buildButton(".", Colors.grey, () => onKeyPressed("."), 1, 1),
          buildButton(",", Colors.grey, () => onKeyPressed(","), 1, 1),
          buildButton(";", Colors.grey, () => onKeyPressed(";"), 1, 1),
          buildButton("->", Colors.purple, () {
            setState(() {
              isAlpha1 = false;
            });
          }, 1, 1),
        ];
      } else {
        return [
          //*************************************** ALPHANUM1 Y MINÚSCULA **************************************************
          buildButton("q", Colors.grey, () => onKeyPressed("q"), 1, 1),
          buildButton("w", Colors.grey, () => onKeyPressed("w"), 1, 1),
          buildButton("e", Colors.grey, () => onKeyPressed("e"), 1, 1),
          buildButton("r", Colors.grey, () => onKeyPressed("r"), 1, 1),
          buildButton("DEL", Colors.blue, onBackspace, 1, 1),
          buildButton("a", Colors.grey, () => onKeyPressed("a"), 1, 1),
          buildButton("s", Colors.grey, () => onKeyPressed("s"), 1, 1),
          buildButton("d", Colors.grey, () => onKeyPressed("d"), 1, 1),
          buildButton("f", Colors.grey, () => onKeyPressed("f"), 1, 1),
          buildButton("X", Colors.red, () {
            Navigator.pop(context);
          }, 1, 2),
          buildButton("z", Colors.grey, () => onKeyPressed("z"), 1, 1),
          buildButton("x", Colors.grey, () => onKeyPressed("x"), 1, 1),
          buildButton("c", Colors.grey, () => onKeyPressed("c"), 1, 1),
          buildButton("v", Colors.grey, () => onKeyPressed("v"), 1, 1),
          buildButton("b", Colors.grey, () => onKeyPressed("b"), 1, 1),
          buildButton("n", Colors.grey, () => onKeyPressed("n"), 1, 1),
          buildButton(">", Colors.grey, () => onKeyPressed(">"), 1, 1),
          buildButton("<", Colors.grey, () => onKeyPressed("<"), 1, 1),
          buildButton("OK", Colors.green, () {
            Navigator.pop(context, input);
          }, 1, 2),
          buildButton("MAY", Colors.purple, () {
            setState(() {
              isMayus = true;
            });
          }, 1, 1),
          buildButton(":", Colors.grey, () => onKeyPressed(":"), 1, 1),
          buildButton("_", Colors.grey, () => onKeyPressed("_"), 1, 1),
          buildButton("-", Colors.grey, () => onKeyPressed("-"), 1, 1),
          buildButton("123", Colors.lightBlue, () {
            setState(() {
              isNumeric = true;
            });
          }, 1, 1),
          buildButton(".", Colors.grey, () => onKeyPressed("."), 1, 1),
          buildButton(",", Colors.grey, () => onKeyPressed(","), 1, 1),
          buildButton(";", Colors.grey, () => onKeyPressed(";"), 1, 1),
          buildButton("->", Colors.purple, () {
            setState(() {
              isAlpha1 = false;
            });
          }, 1, 1),
        ];
      }
    } else {
      if (isMayus) {
        //*************************************** ALPHANUM2 Y MAYÚSCULA **************************************************
        return [
          buildButton("T", Colors.grey, () => onKeyPressed("T"), 1, 1),
          buildButton("Y", Colors.grey, () => onKeyPressed("Y"), 1, 1),
          buildButton("U", Colors.grey, () => onKeyPressed("U"), 1, 1),
          buildButton("I", Colors.grey, () => onKeyPressed("I"), 1, 1),
          buildButton("DEL", Colors.blue, onBackspace, 1, 1),
          buildButton("G", Colors.grey, () => onKeyPressed("G"), 1, 1),
          buildButton("H", Colors.grey, () => onKeyPressed("H"), 1, 1),
          buildButton("J", Colors.grey, () => onKeyPressed("J"), 1, 1),
          buildButton("K", Colors.grey, () => onKeyPressed("K"), 1, 1),
          buildButton("X", Colors.red, () {
            Navigator.pop(context);
          }, 1, 2),
          buildButton("O", Colors.grey, () => onKeyPressed("O"), 1, 1),
          buildButton("P", Colors.grey, () => onKeyPressed("P"), 1, 1),
          buildButton("L", Colors.grey, () => onKeyPressed("L"), 1, 1),
          buildButton("Ñ", Colors.grey, () => onKeyPressed("Ñ"), 1, 1),
          buildButton("M", Colors.grey, () => onKeyPressed("M"), 1, 1),
          buildButton("/", Colors.grey, () => onKeyPressed("/"), 1, 1),
          buildButton("+", Colors.grey, () => onKeyPressed("+"), 1, 1),
          buildButton("=", Colors.grey, () => onKeyPressed("="), 1, 1),
          buildButton("OK", Colors.green, () {
            Navigator.pop(context, input);
          }, 1, 2),
          buildButton("MIN", Colors.purple, () {
            setState(() {
              isMayus = false;
            });
          }, 1, 1),
          buildButton("[", Colors.grey, () => onKeyPressed("["), 1, 1),
          buildButton("]", Colors.grey, () => onKeyPressed("]"), 1, 1),
          buildButton("(", Colors.grey, () => onKeyPressed("("), 1, 1),
          buildButton("123", Colors.lightBlue, () {
            setState(() {
              isNumeric = true;
            });
          }, 1, 1),
          buildButton("{", Colors.grey, () => onKeyPressed("{"), 1, 1),
          buildButton("}", Colors.grey, () => onKeyPressed("}"), 1, 1),
          buildButton(")", Colors.grey, () => onKeyPressed(")"), 1, 1),
          buildButton("<-", Colors.purple, () {
            setState(() {
              isAlpha1 = true;
            });
          }, 1, 1),
        ];
      } else {
        //*************************************** ALPHANUM2 Y MINÚSCULA **************************************************
        return [
          buildButton("t", Colors.grey, () => onKeyPressed("t"), 1, 1),
          buildButton("y", Colors.grey, () => onKeyPressed("y"), 1, 1),
          buildButton("u", Colors.grey, () => onKeyPressed("u"), 1, 1),
          buildButton("i", Colors.grey, () => onKeyPressed("i"), 1, 1),
          buildButton("DEL", Colors.blue, onBackspace, 1, 1),
          buildButton("g", Colors.grey, () => onKeyPressed("g"), 1, 1),
          buildButton("h", Colors.grey, () => onKeyPressed("h"), 1, 1),
          buildButton("j", Colors.grey, () => onKeyPressed("j"), 1, 1),
          buildButton("k", Colors.grey, () => onKeyPressed("k"), 1, 1),
          buildButton("X", Colors.red, () {
            Navigator.pop(context);
          }, 1, 2),
          buildButton("o", Colors.grey, () => onKeyPressed("o"), 1, 1),
          buildButton("p", Colors.grey, () => onKeyPressed("p"), 1, 1),
          buildButton("l", Colors.grey, () => onKeyPressed("l"), 1, 1),
          buildButton("ñ", Colors.grey, () => onKeyPressed("ñ"), 1, 1),
          buildButton("m", Colors.grey, () => onKeyPressed("m"), 1, 1),
          buildButton("/", Colors.grey, () => onKeyPressed("/"), 1, 1),
          buildButton("+", Colors.grey, () => onKeyPressed("+"), 1, 1),
          buildButton("=", Colors.grey, () => onKeyPressed("="), 1, 1),
          buildButton("OK", Colors.green, () {
            Navigator.pop(context, input);
          }, 1, 2),
          buildButton("MAY", Colors.purple, () {
            setState(() {
              isMayus = true;
            });
          }, 1, 1),
          buildButton("[", Colors.grey, () => onKeyPressed("["), 1, 1),
          buildButton("]", Colors.grey, () => onKeyPressed("]"), 1, 1),
          buildButton("(", Colors.grey, () => onKeyPressed("("), 1, 1),
          buildButton("123", Colors.lightBlue, () {
            setState(() {
              isNumeric = true;
            });
          }, 1, 1),
          buildButton("{", Colors.grey, () => onKeyPressed("{"), 1, 1),
          buildButton("}", Colors.grey, () => onKeyPressed("}"), 1, 1),
          buildButton(")", Colors.grey, () => onKeyPressed(")"), 1, 1),
          buildButton("<-", Colors.purple, () {
            setState(() {
              isAlpha1 = true;
            });
          }, 1, 1),
        ];
      }
    }
  }

  StaggeredGridTile buildButton(
    String label,
    Color color,
    VoidCallback onPressed,
    int crossAxisCellCount,
    int mainAxisCellCount, [
    double? cellHeight, // <- parámetro opcional
  ]) {
    final Widget content = _buildButtonContent(label, color, onPressed);

    return StaggeredGridTile.count(
      crossAxisCellCount: crossAxisCellCount,
      mainAxisCellCount: mainAxisCellCount,
      child: cellHeight != null
          ? SizedBox(
              height: cellHeight * mainAxisCellCount,
              child: content,
            )
          : content,
    );
  }

  Widget _buildButtonContent(
      String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(2),
      ),
      onPressed: onPressed,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
