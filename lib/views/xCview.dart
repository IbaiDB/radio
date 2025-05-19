import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radio/socketService.dart';
import 'package:radio/views/teclado.dart';

class Xcview extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const Xcview({
    super.key,
    required this.navigatorKey,
  });

  @override
  State<Xcview> createState() => XcviewState();
}

class XcviewState extends State<Xcview> {
  String? l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, lA, t0, t1, tA, t3, t6, t7;

  final TextEditingController? t2 = TextEditingController();
  final TextEditingController? t5 = TextEditingController();
  //final TextEditingController? t6 = TextEditingController();
  final TextEditingController? t4 = TextEditingController();
  final TextEditingController? t8 = TextEditingController();
  final TextEditingController? t9 = TextEditingController();

  final FocusNode _focusNodet2 = FocusNode();
  final FocusNode _focusNodet5 = FocusNode();
  final FocusNode _focusNodet4 = FocusNode();
  final FocusNode _focusNodet6 = FocusNode();
  final FocusNode _focusNodet8 = FocusNode();
  final FocusNode _focusNodet7 = FocusNode();
  final FocusNode _focusNodet9 = FocusNode();

  bool enviart4 = false;
  bool enviart5 = false;
  bool enviart6 = false;
  bool enviart8 = false;
  bool enviart7 = false;
  bool enviart9 = false;
  bool enviart2 = false;
  bool enviart3 = false;
  bool segundaPantalla = false;
  bool ccActivo = false;
  late SocketProvider socketProvider;
  int optSeleccionada = 0;
  List<String>? opciones = [];
  List<String> vacio = [""];
  List<bool> isSelected = [true, false];
  late bool incluir;

  @override
  void initState() {
    super.initState();

    print("🟢 Xcview se ha inicializado y está esperando datos...");

    incluir = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketProvider = Provider.of<SocketProvider>(context, listen: false);
      socketProvider.addListener(socketListener);

      if (socketProvider.lastMessage.contains("|XC|")) {
        print('✅ Mensaje S0 confirmado en Xcview');
        dividirLabels(socketProvider.lastMessage.split('\n'));
        socketListener();
      }
    });
  }

  void focusear(FocusNode f) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(f);
      }
    });
  }

  void socketListener() {
    try {
      if (!mounted) {
        print("⚠️ Xnview está desmontado, ignorando mensaje");
        return;
      }

      if (socketProvider.lastMessage.contains("|XC|") &&
              !socketProvider.lastMessage.contains(
                  "|CC|") /*&&
           !socketProvider.lastMessage.contains("|SO|")*/
          ) {
        if (socketProvider.lastMessage.contains("|XC|DI|t4||") &&
            !_focusNodet4.hasFocus) {
          focusear(_focusNodet4);
          enviart4 = true;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XC|DI|t4|Todos|") &&
            !_focusNodet4.hasFocus) {
          focusear(_focusNodet4);
          enviart4 = true;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XC|DI|t6|") &&
            !_focusNodet6.hasFocus) {
          focusear(_focusNodet6);
          enviart4 = false;
          enviart8 = false;
          enviart9 = false;
          enviart6 = true;
          enviart7 = false;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XC|DI|t7|") &&
            !_focusNodet7.hasFocus) {
          focusear(_focusNodet7);
          enviart4 = false;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = true;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XC|DI|t8|") &&
            !_focusNodet8.hasFocus) {
          focusear(_focusNodet8);
          enviart4 = false;
          enviart8 = true;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XC|DI|t9|") &&
            !_focusNodet9.hasFocus) {
          focusear(_focusNodet9);
          enviart4 = false;
          enviart8 = false;
          enviart9 = true;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XC|DI|t2|") &&
            !_focusNodet2.hasFocus) {
          focusear(_focusNodet2);
          enviart4 = false;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = true;
          t2?.clear();
          t9?.clear();
          t4?.clear();
          t5?.clear();
          t8?.clear();
          opciones?.clear();
        }
        dividirLabels(socketProvider.lastMessage.split('\n'));
      }
    } catch (e) {
      print(e);
    }
  }

  void dividirLabels(List<String> lines) {
    print("🔍 Procesando líneas:");
    for (String line in lines) {
      line = line.trim().replaceAll(RegExp(r'[^\x20-\x7E|]'), '');
      List<String> parts = line.split('|');
      String lastPart = parts.reversed
          .firstWhere((part) => part.isNotEmpty, orElse: () => "Error")
          .trim();

      if (line.contains("|CT|l0|") && !line.contains("|l0||"))
        setState(() => l0 = lastPart);
      if (line.contains("l1") && !line.contains("|l1||"))
        setState(() => l1 = lastPart);
      if (line.contains("l2") && !line.contains("|l2||"))
        setState(() => l2 = lastPart);
      if (line.contains("l3") && !line.contains("|l3||"))
        setState(() => l3 = lastPart);
      if (line.contains("l4") && !line.contains("|l4||"))
        setState(() => l4 = lastPart);
      if (line.contains("l5") && !line.contains("|l5||"))
        setState(() => l5 = lastPart);
      if (line.contains("l6") && !line.contains("|l6||"))
        setState(() => l6 = lastPart);
      if (line.contains("l7") && !line.contains("|l7||"))
        setState(() => l7 = lastPart);
      if (line.contains("l8") && !line.contains("|l8||"))
        setState(() => l8 = lastPart);
      if (line.contains("l9") && !line.contains("|l9||"))
        setState(() => l9 = lastPart);
      if (line.contains("t0") && !line.contains("|t0||"))
        setState(() => t0 = lastPart);
      if (line.contains("t1") && !line.contains("|t1||"))
        setState(() => t1 = lastPart);
      if (line.contains("t2") && !line.contains("|t2||"))
        setState(() => t2?.text = lastPart);
      if (line.contains("t3") &&
          !line.contains("|t3||") &&
          line.contains("|CT|")) setState(() => t3 = lastPart);
      if (line.contains("t4") && !line.contains("|t4||"))
        setState(() => t4?.text = lastPart);
      if (line.contains("t5") && !line.contains("|t5||"))
        setState(() => t5?.text = lastPart);
      if (line.contains("t6") && !line.contains("|t6||"))
        setState(() => t6 = lastPart);
      if (line.contains("t7") && !line.contains("|t7||"))
        setState(() => t7 = lastPart);
      if (line.contains("t8") && !line.contains("|t8||"))
        setState(() => t8?.text = lastPart);
      if (line.contains("t9") && !line.contains("|t9||"))
        setState(() => t9?.text = lastPart);
      //if (line.contains("lA") && !line.contains("|lA||"))
      setState(() => lA = lastPart);
      //if (line.contains("l+")) setState(() => lMas = lastPart);

      ///////////////////////////////////AHORA FILTRO PARA LIMPIAR LOS TEXTOS////////////////////////////////////////////

      if (line.contains("|CT|l0||")) setState(() => l0 = "");
      if (line.contains("|l1||")) setState(() => l1 = "");
      if (line.contains("|l2||")) setState(() => l2 = "");
      if (line.contains("|l3||")) setState(() => l3 = "");
      if (line.contains("|l4||")) setState(() => l4 = "");
      if (line.contains("|l5||")) setState(() => l5 = "");
      if (line.contains("|l6||")) setState(() => l6 = "");
      if (line.contains("|l7||")) setState(() => l7 = "");
      if (line.contains("|l8||")) setState(() => l8 = "");
      if (line.contains("|l9||")) setState(() => l9 = "");
      if (line.contains("|t0||")) setState(() => t0 = "");
      if (line.contains("|t1||")) setState(() => t1 = "");
      if (line.contains("|t2||")) setState(() => t2?.text = "");
      if (line.contains("|t3||")) setState(() => t3 = "");
      if (line.contains("|t4||")) setState(() => t4?.text = "");
      if (line.contains("|t5||")) setState(() => t5?.text = "");
      if (line.contains("|t6||")) setState(() => t6 = "");
      if (line.contains("|t7||")) setState(() => t7 = "");
      if (line.contains("|t8||")) setState(() => t8?.text = "");
      if (line.contains("|t9||")) setState(() => t9?.text = "");
      //if (line.contains("|lA||")) setState(() => lA = "");

      if (line.contains("|CL|lA|")) {
        setState(() {
          opciones?.add(lastPart.split(";")[0]);
        });
      }
      if (line.contains("|EL|lA|")) {
        setState(() {
          opciones?.remove(lastPart.split(";")[0]);
        });
      }
    }
  }

  void filtrarTextField() {
    if (enviart8) {
      if (incluir) {
        if (t8 != null && t8!.text.trim() != "") {
          socketProvider.sendMessage("+${t8!.text}");
        } else {
          focusear(_focusNodet8);
        }
      } else {
        if (t8 != null && t8!.text.trim() != "") {
          socketProvider.sendMessage("-${t8!.text}");
        } else {
          focusear(_focusNodet8);
        }
      }
    } else if (enviart9) {
      if (t9 != null && t9!.text.trim() != "") {
        socketProvider.sendMessage(t9!.text);
      } else {
        focusear(_focusNodet9);
      }
    } else if (enviart2) {
      if (t2 != null && t2!.text.trim() != "") {
        socketProvider.sendMessage(t2!.text);
      } else {
        focusear(_focusNodet2);
      }
    } else if (enviart5) {
      if (t5 != null && t5!.text.trim() != "") {
        socketProvider.sendMessage(t5!.text);
      } else {
        focusear(_focusNodet5);
      }
    }
  }

  Future lanzarteclado() async {
    String? txt;
    if (enviart4) {
      txt = t4?.text;
    } else if (enviart8) {
      txt = t8?.text;
    } else if (enviart9) {
      txt = t9?.text;
    } else if (enviart2) {
      txt = t2?.text;
    }
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => KeyboardScreenView(
                txt: txt,
              )),
    );
    if (resultado != null) {
      setState(() {
        if (enviart4) {
          t4?.text = resultado;
        } else if (enviart8) {
          t8?.text = resultado;
        } else if (enviart9) {
          t9?.text = resultado;
        } else if (enviart2) {
          t2?.text = resultado;
        }
      });
      if (incluir) {
        socketProvider.sendMessage("+$resultado");
      } else {
        socketProvider.sendMessage("-$resultado");
      }
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    socketProvider.removeListener(socketListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900], // Mismo color de fondo
          centerTitle: true,
          automaticallyImplyLeading: false, // Centra el texto en el AppBar
          title: Padding(
            padding:
                EdgeInsets.symmetric(vertical: 10), // Igual que el Container
            child: Text(
              l0 ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          toolbarHeight:
              40, // Ajusta la altura para que se parezca más al Container
        ),
        body: Column(
          children: [
            // Espacio entre el texto superior y los botones
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Centra los botones en la pantall
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (enviart2) {
                              lanzarteclado();
                            }
                          },
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey, // Fondo gris
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)), // Borde negro
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 1),
                            alignment: Alignment
                                .center, // Opcional: añade padding interno
                            child: Text(
                              l2 ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Color del texto negro
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Sin padding extra
                        SizedBox(
                          width: 150,
                          height: 30,
                          child: GestureDetector(
                            onTap: () {},
                            child: AbsorbPointer(
                              child: TextField(
                                focusNode: _focusNodet2,
                                controller: t2,
                                readOnly: !enviart2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                ),
                                style: TextStyle(fontSize: 16),
                                onSubmitted: (value) => filtrarTextField(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.grey, // Fondo gris
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)) // Borde negro
                              ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                          alignment: Alignment
                              .center, // Opcional: añade padding interno
                          child: Text(
                            l9 ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Color del texto negro
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Sin padding extra
                        SizedBox(
                          width: 150,
                          height: 30,
                          child: GestureDetector(
                            onTap: () {},
                            child: AbsorbPointer(
                              child: TextField(
                                focusNode: _focusNodet9,
                                controller: t9,
                                readOnly: !enviart9,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                ),
                                style: TextStyle(fontSize: 16),
                                onSubmitted: (value) => filtrarTextField(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //width: double.infinity, // Ocupa todo el ancho
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    color: const Color.fromARGB(
                        255, 0, 110, 9), // Espaciado interior
                    child: Text(
                      t3 ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Tamaño del texto
                        fontWeight: FontWeight.bold, // Estilo en negrita
                      ),
                      textAlign: TextAlign.center, // Centra el texto
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    padding: EdgeInsets.all(14),
                    itemCount: opciones?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                            ),
                            child: Text(
                              opciones?[index] ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey, // Fondo gris
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5)), // Borde negro
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                          alignment: Alignment
                              .center, // Opcional: añade padding interno
                          child: Text(
                            l4 ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Color del texto negro
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 30,
                          child: GestureDetector(
                            onTap: () {},
                            child: AbsorbPointer(
                              child: TextField(
                                focusNode: _focusNodet4,
                                controller: t4,
                                readOnly: !enviart4,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                ),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.grey, // Fondo gris
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)) // Borde negro
                              ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                          alignment: Alignment
                              .center, // Opcional: añade padding interno
                          child: Text(
                            l5 ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black, // Color del texto negro
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Sin padding extra
                        SizedBox(
                          width: 150,
                          height: 30,
                          child: GestureDetector(
                            onTap: () {},
                            child: AbsorbPointer(
                              child: TextField(
                                focusNode: _focusNodet5,
                                controller: t5,
                                readOnly: !enviart5,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                ),
                                style: TextStyle(fontSize: 16),
                                //onSubmitted: (value) => ,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.blue[900], // Fondo opcional
                    ),
                    height: 30,
                    width: 293,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Primer "radio button"
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              incluir = true; // Marca este como seleccionado
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 20, // Tamaño del círculo grande
                                width: 20,
                                // Tamaño del círculo grande
                                decoration: BoxDecoration(
                                  color: Colors.white, // Fondo transparente
                                  shape: BoxShape.circle, // Forma circular
                                  border: Border.all(
                                    color: incluir
                                        ? Colors.white
                                        : Colors.white, // Color del borde
                                    width: 2,

                                    // Grosor del borde
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    height: 14, // Tamaño del círculo pequeño
                                    width: 14, // Tamaño del círculo pequeño
                                    decoration: BoxDecoration(
                                      color: incluir
                                          ? Colors.black
                                          : Colors
                                              .transparent, // Color del círculo pequeño cuando está seleccionado
                                      shape: BoxShape.circle, // Forma circular
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      8), // Espaciado entre el círculo y el texto
                              Text(
                                t6 ?? "", // Texto al lado del círculo
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white, // Color del texto negro
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20), // Espaciado entre los dos botones
                        // Segundo "radio button"
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              incluir = false; // Marca este como seleccionado
                            });
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 20, // Tamaño del círculo grande
                                width: 20, // Tamaño del círculo grande
                                decoration: BoxDecoration(
                                  color: Colors.white, // Fondo transparente
                                  shape: BoxShape.circle, // Forma circular
                                  border: Border.all(
                                    color: !incluir
                                        ? Colors.white
                                        : Colors.white, // Color del borde
                                    width: 2, // Grosor del borde
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    height: 14, // Tamaño del círculo pequeño
                                    width: 14, // Tamaño del círculo pequeño
                                    decoration: BoxDecoration(
                                      color: !incluir
                                          ? Colors.black
                                          : Colors
                                              .transparent, // Color del círculo pequeño cuando está seleccionado
                                      shape: BoxShape.circle, // Forma circular
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      8), // Espaciado entre el círculo y el texto
                              Text(
                                t7 ?? "", // Texto al lado del círculo
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white, // Color del texto negro
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (enviart8) {
                              lanzarteclado();
                            }
                          },
                          child: Container(
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.grey, // Fondo gris
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5)) // Borde negro
                                ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3),
                            alignment: Alignment
                                .center, // Opcional: añade padding interno
                            child: Text(
                              l8 ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Color del texto negro
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Sin padding extra
                        SizedBox(
                          width: 150,
                          height: 30,
                          child: GestureDetector(
                            onTap: () {},
                            child: AbsorbPointer(
                              child: TextField(
                                focusNode: _focusNodet8,
                                controller: t8,
                                readOnly: !enviart8,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                ),
                                style: TextStyle(fontSize: 16),
                                onSubmitted: (value) => filtrarTextField(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1),
            Container(
              width: double.infinity, // Ocupa todo el ancho
              padding: EdgeInsets.symmetric(vertical: 5),
              color: Colors.blue[900], // Espaciado interior
              child: Text(
                l1 ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18, // Tamaño del texto
                  fontWeight: FontWeight.bold, // Estilo en negrita
                ),
                textAlign: TextAlign.center, // Centra el texto
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCustomButton(
      String text, String imagePath, VoidCallback onPressed) {
    return Flexible(
        fit: FlexFit.loose,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white, // Color de fondo del botón
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onPressed,
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }
}
