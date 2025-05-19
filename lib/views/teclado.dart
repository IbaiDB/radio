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
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                children: [
                  // Primera fila
                  buildButton("*", Colors.grey, () => onKeyPressed("*"), 1, 1),
                  buildButton("/", Colors.grey, () => onKeyPressed("/"), 1, 1),
                  buildButton("#", Colors.grey, () => onKeyPressed("#"), 1, 1),
                  buildButton("DEL", Colors.blue, onBackspace, 1, 1),

                  // Segunda fila
                  buildButton("7", Colors.grey, () => onKeyPressed("7"), 1, 1),
                  buildButton("8", Colors.grey, () => onKeyPressed("8"), 1, 1),
                  buildButton("9", Colors.grey, () => onKeyPressed("9"), 1, 1),
                  buildButton("X", Colors.red, () {
                    Navigator.pop(context); // Cierra la pantalla actual
                  }, 1, 2), // ocupa 2 filas

                  // Tercera fila
                  buildButton("4", Colors.grey, () => onKeyPressed("4"), 1, 1),
                  buildButton("5", Colors.grey, () => onKeyPressed("5"), 1, 1),
                  buildButton("6", Colors.grey, () => onKeyPressed("6"), 1, 1),

                  // Cuarta fila
                  buildButton("1", Colors.grey, () => onKeyPressed("1"), 1, 1),
                  buildButton("2", Colors.grey, () => onKeyPressed("2"), 1, 1),
                  buildButton("3", Colors.grey, () => onKeyPressed("3"), 1, 1),
                  buildButton("OK", Colors.green, () {
                    Navigator.pop(context, input);
                  }, 1, 2), // ocupa 2 filas

                  // Quinta fila
                  buildButton("ABC", Colors.lightBlue, () {
                    print("ABC pressed");
                  }, 1, 1),
                  buildButton("0", Colors.grey, () => onKeyPressed("0"), 1, 1),
                  buildButton(".", Colors.grey, () => onKeyPressed("."), 1, 1),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButton(String label, Color color, VoidCallback onPressed,
      int crossAxisCellCount, int mainAxisCellCount) {
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
