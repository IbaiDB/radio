import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radio/socketService.dart';

class CcView extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const CcView({super.key, required this.navigatorKey});

  @override
  State<CcView> createState() => CcViewState();
}

class CcViewState extends State<CcView> {
  String? l0, l1, l5, l6, l7, l8, l9, lA, t0, tA, t1;

  final TextEditingController? t2 = TextEditingController();
  final TextEditingController? l2 = TextEditingController();
  final TextEditingController? l3 = TextEditingController();
  final TextEditingController? l4 = TextEditingController();
  final TextEditingController? t3 = TextEditingController();
  final TextEditingController? t4 = TextEditingController();
  final TextEditingController? t6 = TextEditingController();
  final TextEditingController? t5 = TextEditingController();
  final TextEditingController? t7 = TextEditingController();
  final TextEditingController? t8 = TextEditingController();
  final TextEditingController? t9 = TextEditingController();
  int optSeleccionada = 0;
  List<String>? opciones = [];
  List<String> vacio = [""];
  FocusNode focu = FocusNode();
  String? enviar;
  bool dobleBack = true;
  bool l2Off = false;
  bool l3Off = false;
  bool l4Off = false;
  late Color bcColor;
  late bool isTF3;

  bool isSiDisabled = false;
  bool isNoDisabled = false;

  bool isSiSelected = false;
  bool isNoSelected = false;

  late SocketProvider socketProvider;
  @override
  void initState() {
    super.initState();

    bcColor = const Color.fromARGB(255, 255, 0, 0);
    isSiDisabled = false;
    isNoDisabled = false;

    isSiSelected = false;
    isNoSelected = false;
    isTF3 = false;

    print("🟢 CcView se ha inicializado y está esperando datos...");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketProvider = Provider.of<SocketProvider>(context, listen: false);
      socketProvider.addListener(_socketListener);

      if (socketProvider.lastMessage.contains("|CC|")) {
        dividirLabels(socketProvider.lastMessage.split("\n"));
        _socketListener();
      }
    });
  }

  void _socketListener() {
    final message = socketProvider.lastMessage;
    if (message.contains("|CC|")) {
      isSiDisabled = false;
      isNoDisabled = false;
      isSiSelected = false;
      isNoSelected = false;
      if (message.contains("|tf|1|")) {
        setState(() {
          l2Off = true;
          l3Off = true;
          l4Off = true;
          bcColor = const Color.fromARGB(255, 14, 135, 0);
          isTF3 = false;
        });
      } else if (message.contains("|tf|2|")) {
        setState(() {
          l2Off = false;
          l3Off = false;
          l4Off = false;
          isTF3 = false;
        });
      } else if (message.contains("|tf|3|")) {
        setState(() {
          l2Off = false;
          l3Off = false;
          l4Off = true;
          bcColor = const Color.fromARGB(255, 255, 0, 0);
          isTF3 = true;
        });
      }
      dividirLabels(message.split("\n"));
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

      if (mounted) {
        if (line.contains("l0") &&
            !line.contains("|l0||") &&
            !line.contains("|CL|")) setState(() => l0 = lastPart);
        if (line.contains("l1") && !line.contains("|l1||"))
          setState(() => l1 = lastPart);
        if (line.contains("l2") && !line.contains("|l2||"))
          setState(() => l2?.text = lastPart);
        if (line.contains("l3") && !line.contains("|l3||"))
          setState(() => l3?.text = lastPart);
        if (line.contains("l4") && !line.contains("|l4||"))
          setState(() => l4?.text = lastPart);
        if (line.contains("CT") &&
            line.contains("t1") &&
            !line.contains("|t1||")) setState(() => t1 = lastPart);
        if (line.contains("t3") && !line.contains("|t3||"))
          setState(() => t3?.text = lastPart);
        if (line.contains("t2") && !line.contains("|t2||"))
          setState(() => t2?.text = lastPart);
        if (line.contains("t4") && !line.contains("|t4||"))
          setState(() => t4?.text = lastPart);
        if (line.contains("CT") &&
            line.contains("t5") &&
            !line.contains("|t5||")) setState(() => t5?.text = lastPart);
      }
      //if (line.contains("l5")) setState(() => l5 = lastPart);
      //if (line.contains("l+")) setState(() => lMas = lastPart);
    }
  }

  @override
  void dispose() {
    socketProvider.removeListener(_socketListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = context.read<SocketProvider>();
    void selectSi() async {
      if (isSiDisabled) return;

      socketProvider.sendMessage("S");

      setState(() {
        isSiSelected = true;
        isSiDisabled = true;
      });

      await Future.delayed(Duration(seconds: 2)); // Espera 2 segundos
    }

    void selectNo() async {
      if (isNoDisabled) return;

      socketProvider.sendMessage("N");

      setState(() {
        isNoSelected = true;
        isNoDisabled = true;
      });

      await Future.delayed(Duration(seconds: 2)); // Espera 2 segundos
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bcColor,
        body: KeyboardListener(
          focusNode: focu,
          autofocus: true,
          onKeyEvent: (event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {}
          },
          child: Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              t1 ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    //---------------------------------------DIVISIÓN ROW-------------------------------------------------------
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Visibility(
                            visible: l2Off,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 255, 0, 0)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 1),
                                  alignment: Alignment.center,
                                  child: Text(
                                    t2?.text ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
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
                                        controller: l2,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                        ),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                            visible: l3Off,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 255, 0, 0)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 1),
                                  alignment: Alignment.center,
                                  child: Text(
                                    t3?.text ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
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
                                        controller: l3,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                        ),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                            visible: l4Off,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 255, 0, 0)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 1),
                                  alignment: Alignment.center,
                                  child: Text(
                                    t4?.text ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
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
                                        controller: l4,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                        ),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          //--------------------------------------------------------------DIVISIÓN ROW-----------------------------------------------
                          botonAceptar(isTF3, selectSi, selectNo),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            t5?.text ?? "",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget botonAceptar(bool only, VoidCallback onYes, VoidCallback onNo) {
    if (only) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Image.asset(
                isSiSelected ? "assets/Aceptar.ico" : "assets/Si.ico"),
            onPressed: isSiDisabled ? null : onYes,
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Image.asset(
              isSiSelected ? "assets/Aceptar.ico" : "assets/Si.ico"),
          onPressed: isSiDisabled ? null : onYes,
        ),
        IconButton(
          icon: Image.asset(
              isNoSelected ? "assets/Aceptar.ico" : "assets/No.ico"),
          onPressed: isNoDisabled ? null : onNo,
        )
      ],
    );
  }
}
