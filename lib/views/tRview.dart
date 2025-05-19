import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/socketService.dart';
import 'package:radio/views/teclado.dart';

class Trview extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  Trview({
    super.key,
    required this.navigatorKey,
  });

  @override
  State<Trview> createState() => TrviewState();
}

class TrviewState extends State<Trview> {
  String? l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, lA, t0, t1, tA, t3, t5;

  late StreamSubscription<String> _streamSubscription;
  final TextEditingController? t2 = TextEditingController();
  final TextEditingController? t4 = TextEditingController();
  //final TextEditingController? t5 = TextEditingController();
  final TextEditingController? t6 = TextEditingController();
  final TextEditingController? t7 = TextEditingController();
  final TextEditingController? t8 = TextEditingController();
  final TextEditingController? t9 = TextEditingController();
  final FocusNode _focusNodet4 = FocusNode();
  final FocusNode _focusNodet5 = FocusNode();
  final FocusNode _focusNodet6 = FocusNode();
  final FocusNode _focusNodet8 = FocusNode();
  final FocusNode _focusNodet7 = FocusNode();
  final FocusNode _focusNodet9 = FocusNode();
  final FocusNode _focusNodet2 = FocusNode();
  final FocusNode _focusNodet3 = FocusNode();
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

  @override
  void initState() {
    super.initState();
    print("🟢 Trview se ha inicializado y está esperando datos...");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketProvider = context.read<SocketProvider>();

      // 1️⃣ Eliminar listener para evitar duplicados
      socketProvider.removeListener(_socketListener);
      socketProvider.addListener(_socketListener);

      // 2️⃣ Ejecutar _socketListener() inmediatamente si hay un mensaje previo
      if (socketProvider.lastMessage != null) {
        print("📩 Mensaje previo encontrado: ${socketProvider.lastMessage}");

        if (socketProvider.lastMessage.contains("|TR|") &&
            !socketProvider.lastMessage.contains("|CC|") &&
            !socketProvider.lastMessage.contains("|SO|")) {
          dividirLabels(socketProvider.lastMessage.split('\n'));

          // Llamamos manualmente al listener para procesar el mensaje
          _socketListener();
        }
      }
    });
  }

  void _socketListener() {
    try {
      if (!mounted) {
        print("⚠️ PrView está desmontado, ignorando mensaje");
        return;
      }

      if (socketProvider.lastMessage.contains("|TR|") &&
              !socketProvider.lastMessage.contains(
                  "|CC|") /*&&
           !socketProvider.lastMessage.contains("|SO|")*/
          ) {
        if (socketProvider.lastMessage.contains("|TR|DI|t4||")) {
          focusear(_focusNodet4);
          enviart4 = true;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
          enviart3 = false;
          enviart5 = false;
        } else if (socketProvider.lastMessage.contains("|TR|DI|t4|Todos|")) {
          focusear(_focusNodet4);
          enviart4 = true;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
          enviart3 = false;
          enviart5 = false;
        } else if (socketProvider.lastMessage.contains("|TR|DI|t6|")) {
          focusear(_focusNodet6);
          enviart4 = false;
          enviart8 = false;
          enviart9 = false;
          enviart6 = true;
          enviart7 = false;
          enviart2 = false;
          enviart3 = false;
          enviart5 = false;
        } else if (socketProvider.lastMessage.contains("|TR|DI|t7|")) {
          focusear(_focusNodet7);
          enviart4 = false;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = true;
          enviart2 = false;
          enviart3 = false;
          enviart5 = false;
        } else if (socketProvider.lastMessage.contains("|TR|DI|t8|")) {
          focusear(_focusNodet8);
          enviart4 = false;
          enviart8 = true;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
          enviart3 = false;
          enviart5 = false;
        } else if (socketProvider.lastMessage.contains("|TR|DI|t9|")) {
          focusear(_focusNodet9);
          enviart4 = false;
          enviart8 = false;
          enviart9 = true;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
          enviart3 = false;
          enviart5 = false;
        } else if (socketProvider.lastMessage.contains("|TR|DI|t2|")) {
          focusear(_focusNodet2);
          enviart4 = false;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = true;
          enviart3 = false;
          enviart5 = false;
        } else if (socketProvider.lastMessage.contains("|TR|DI|t5|")) {
          focusear(_focusNodet5);
          enviart4 = false;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
          enviart3 = false;
          enviart5 = true;
        }
        dividirLabels(socketProvider.lastMessage.split('\n'));
      }
    } catch (e) {
      print(e);
    }
  }

  void focusear(FocusNode f) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(f);
      }
    });
  }

  void dividirLabels(List<String> lines) {
    print("🔍 Procesando líneas:");
    for (String line in lines) {
      line = line.trim().replaceAll(RegExp(r'[^\x20-\x7E|]'), '');
      List<String> parts = line.split('|');
      String lastPart = parts.reversed
          .firstWhere((part) => part.isNotEmpty, orElse: () => "Error")
          .trim();

      if (line.contains("l0") && !line.contains("|l0||"))
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
      if (line.contains("t3") && !line.contains("|t3||"))
        setState(() => t3 = lastPart);
      if (line.contains("t4") && !line.contains("|t4||"))
        setState(() => t4?.text = lastPart);
      if (line.contains("t5") && !line.contains("|t5||"))
        setState(() => t5 = lastPart);
      if (line.contains("t6") && !line.contains("|t6||"))
        setState(() => t6?.text = lastPart);
      if (line.contains("t7") && !line.contains("|t7||"))
        setState(() => t7?.text = lastPart);
      if (line.contains("t8") && !line.contains("|t8||"))
        setState(() => t8?.text = lastPart);
      if (line.contains("t9") && !line.contains("|t9||"))
        setState(() => t9?.text = lastPart);
      if (line.contains("lA") && !line.contains("|lA||"))
        setState(() => lA = lastPart);
      //if (line.contains("l+")) setState(() => lMas = lastPart);

      ///////////////////////////////////AHORA FILTRO PARA LIMPIAR LOS TEXTOS////////////////////////////////////////////

      if (line.contains("|l0||")) setState(() => l0 = "");
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
      if (line.contains("|t5||")) setState(() => t5 = "");
      if (line.contains("|t6||")) setState(() => t6?.text = "");
      if (line.contains("|t7||")) setState(() => t7?.text = "");
      if (line.contains("|t8||")) setState(() => t8?.text = "");
      if (line.contains("|t9||")) setState(() => t9?.text = "");
      if (line.contains("|lA||")) setState(() => lA = "");
    }
  }

  void filtrarTextField() {
    if (enviart4) {
      if (t4 != null && t4!.text.trim() != "") {
        socketProvider.sendMessage(t4!.text);
      } else {
        focusear(_focusNodet4);
      }
    } else if (enviart6) {
      if (t6 != null && t6!.text.trim() != "") {
        socketProvider.sendMessage(t6!.text);
      } else {
        focusear(_focusNodet6);
      }
    } else if (enviart8) {
      if (t8 != null && t8!.text.trim() != "") {
        socketProvider.sendMessage(t8!.text);
      } else {
        focusear(_focusNodet8);
      }
    } else if (enviart7) {
      if (t7 != null && t7!.text.trim() != "") {
        socketProvider.sendMessage(t7!.text);
      } else {
        focusear(_focusNodet7);
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
    }
  }

  Future lanzarteclado() async {
    String? txt;
    if (enviart4) {
      txt = t4?.text;
    } else if (enviart6) {
      txt = t6?.text;
    } else if (enviart8) {
      txt = t8?.text;
    } else if (enviart7) {
      txt = t7?.text;
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
        } else if (enviart6) {
          t6?.text = resultado;
        } else if (enviart8) {
          t8?.text = resultado;
        } else if (enviart7) {
          t7?.text = resultado;
        } else if (enviart9) {
          t9?.text = resultado;
        } else if (enviart2) {
          t2?.text = resultado;
        }
      });
      socketProvider.sendMessage(resultado);
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    socketProvider.removeListener(_socketListener);
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
                  EdgeInsets.symmetric(vertical: 20), // Igual que el Container
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
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Espacio entre el texto superior y los botones
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Centra los botones en la pantalla
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 1),
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
                    Container(
                      width: double.infinity, // Ocupa todo el ancho
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.blue[900], // Espaciado interior
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (enviart4) {
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
                                l4 ?? "",
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
                                  focusNode: _focusNodet4,
                                  controller: t4,
                                  readOnly: !enviart4,
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
                      width: double.infinity, // Ocupa todo el ancho
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.blue[900], // Espaciado interior
                      child: Text(
                        t5 ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18, // Tamaño del texto
                          fontWeight: FontWeight.bold, // Estilo en negrita
                        ),
                        textAlign: TextAlign.center, // Centra el texto
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 1),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3),
                            alignment: Alignment
                                .center, // Opcional: añade padding interno
                            child: Text(
                              l6 ?? "",
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
                                  focusNode: _focusNodet6,
                                  controller: t6,
                                  readOnly: !enviart6,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey, // Fondo gris
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)), // Borde negro
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 3),
                            alignment: Alignment
                                .center, // Opcional: añade padding interno
                            child: Text(
                              l7 ?? "",
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
                                  focusNode: _focusNodet7,
                                  controller: t7,
                                  readOnly: !enviart7,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey, // Fondo gris
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)), // Borde negro
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
                                        EdgeInsets.symmetric(horizontal: 8),
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
                      width: double.infinity, // Ocupa todo el ancho
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.blue[900], // Espaciado interior
                      child: Text(
                        t1 ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18, // Tamaño del texto
                          fontWeight: FontWeight.bold, // Estilo en negrita
                        ),
                        textAlign: TextAlign.center, // Centra el texto
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (enviart9) {
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
                                  horizontal: 20,
                                  vertical:
                                      3), // Opcional: añade padding interno
                              child: Text(
                                l9 ?? "",
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
                      width: double.infinity, // Ocupa todo el ancho
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.blue[900], // Espaciado interior
                      child: Text(
                        t0 ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18, // Tamaño del texto
                          fontWeight: FontWeight.bold, // Estilo en negrita
                        ),
                        textAlign: TextAlign.center, // Centra el texto
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔹 `Align` asegura que el `Container` esté en la parte inferior
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
              ),
            ],
          ),
        ));
  }
}
