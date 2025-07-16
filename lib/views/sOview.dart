import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radio/socketService.dart';

class S0View extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const S0View({
    super.key,
    required this.navigatorKey,
  });

  @override
  State<S0View> createState() => S0ViewState();
}

List<GlobalKey> itemKeys = [];

class S0ViewState extends State<S0View> {
  String? l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, lA, t0, t1, t5, tA;

  final TextEditingController? t3 = TextEditingController();
  final TextEditingController? t4 = TextEditingController();
  final TextEditingController? t6 = TextEditingController();
  final TextEditingController? t7 = TextEditingController();
  final TextEditingController? t8 = TextEditingController();
  final TextEditingController? t9 = TextEditingController();
  int optSeleccionada = 0;
  List<String>? opciones = [];
  List<String> vacio = [""];
  FocusNode focu = FocusNode();
  String? enviar;
  bool dobleBack = true;
  bool noenviando = true;
  late SocketProvider socketProvider;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    print("🟢 S0View se ha inicializado y está esperando datos...");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketProvider = Provider.of<SocketProvider>(context, listen: false);
      socketProvider.addListener(socketListener);

      if (socketProvider.lastMessage.contains("|SO|")) {
        print('✅ Mensaje S0 confirmado en S0View');
        dividirLabels(socketProvider.lastMessage.split('\n'));
        pintarOpciones(socketProvider.lastMessage.split('\n'));
      }
    });
  }

  void socketListener() {
    final message = socketProvider.lastMessage;
    if (message.contains("|SO|")) {
      print('✅ Mensaje S0 confirmado en S0View');
      dividirLabels(socketProvider.lastMessage.split('\n'));
      pintarOpciones(socketProvider.lastMessage.split('\n'));
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

      if (line.contains("l0") &&
          !line.contains("|l0||") &&
          !line.contains("|CL|")) setState(() => l0 = lastPart);
      if (line.contains("l1") && !line.contains("|l1||"))
        setState(() => l1 = lastPart);
      if (line.contains("l2") && !line.contains("|l2||"))
        setState(() => l2 = lastPart);
      if (line.contains("l3") && !line.contains("|l3||"))
        setState(() => l3 = lastPart);
      if (line.contains("l4") && !line.contains("|l4||"))
        setState(() => l4 = lastPart);
      if (line.contains("t3") && !line.contains("|t3||"))
        setState(() => t3?.text = lastPart);
      //if (line.contains("l5")) setState(() => l5 = lastPart);
      //if (line.contains("l+")) setState(() => lMas = lastPart);
    }
  }

  void pintarOpciones(List<String> lines) {
    print("🔍 Procesando líneas:");

    if (opciones != null && opciones!.isNotEmpty) {
      opciones!.clear();
    }
    for (String line in lines) {
      line = line.trim().replaceAll(RegExp(r'[^\x20-\x7E|]'), '');
      List<String> parts = line.split('|');
      String lastPart = parts.reversed
          .firstWhere((part) => part.isNotEmpty, orElse: () => "Error")
          .trim();
      if (line.contains("CL") && line.contains(";")) {
        String optBuena =
            lastPart.split(";")[1] + " - " + lastPart.split(";")[0];
        setState(() {
          opciones?.add(optBuena);
          optSeleccionada = 0;
          itemKeys = List.generate(opciones!.length, (_) => GlobalKey());
        });
      }
    }
  }

  void filtrarOPT() {
    if (opciones != null && opciones!.isNotEmpty) {
      enviar = opciones?[optSeleccionada].split("-")[0].trim();
      final socketProviderEnv = context.read<SocketProvider>();
      socketProviderEnv.sendMessage(enviar!);
    }
  }

  void scrollToSelectedItem() {
    if (optSeleccionada >= 0 &&
        itemKeys.isNotEmpty &&
        optSeleccionada < itemKeys.length) {
      final key = itemKeys[optSeleccionada];
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: Duration(milliseconds: 300),
          alignment: 0.5,
          curve: Curves.easeInOut,
        );
      }
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
                padding: EdgeInsets.symmetric(
                    vertical: 10), // Igual que el Container
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
            body: KeyboardListener(
              focusNode: focu,
              autofocus: true,
              onKeyEvent: (event) {
                if (event is KeyDownEvent) {
                  final key = event.logicalKey;
                  switch (key) {
                    case LogicalKeyboardKey.enter:
                      filtrarOPT();
                      break;
                    case LogicalKeyboardKey.arrowDown:
                      if (opciones != null &&
                          optSeleccionada >= 0 &&
                          opciones!.length - 1 > optSeleccionada) {
                        setState(() {
                          optSeleccionada += 1;
                        });
                        scrollToSelectedItem();
                      }

                      break;

                    case LogicalKeyboardKey.arrowUp:
                      if (opciones != null &&
                          optSeleccionada > 0 &&
                          opciones!.length > optSeleccionada) {
                        setState(() {
                          optSeleccionada -= 1;
                        });
                        scrollToSelectedItem();
                      }

                      break;
                  }
                }
              },
              child: Column(
                children: [
                  // Espacio entre el texto superior y los botones
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centra los botones en la pantalla
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 8)),
                            Image.asset(
                              'assets/Seleccionar.ico',
                              width: 60,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l2 ?? "",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(14),
                          itemCount: opciones?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              child: GestureDetector(
                                onDoubleTap: () {
                                  if (noenviando) {
                                    noenviando = false;
                                    filtrarOPT();
                                  }
                                },
                                onTap: () {
                                  setState(() {
                                    optSeleccionada = index;
                                    l5 = opciones?[optSeleccionada];
                                  });
                                },
                                child: Container(
                                  key: itemKeys[index],
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: optSeleccionada == index
                                        ? const Color.fromARGB(255, 0, 34, 94)
                                        : Colors.grey[300],
                                    //borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    opciones?[index] ?? "",
                                    style: TextStyle(
                                      color: optSeleccionada == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: const Color.fromARGB(255, 0, 90, 5),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                width: double.infinity,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  (opciones != null &&
                                          optSeleccionada >= 0 &&
                                          optSeleccionada < opciones!.length)
                                      ? opciones![optSeleccionada]
                                      : vacio[0],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
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
                                l3 ?? "",
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
                                    controller: t3,
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
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
            )));
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
