import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radio/socketService.dart';

class T1view extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  T1view({
    super.key,
    required this.navigatorKey,
  });

  @override
  State<T1view> createState() => _T1viewState();
}

class _T1viewState extends State<T1view> {
  String? l0, l1, l2, l3, l4, l5, lMas;
  bool btDisable = false;
  bool bt1 = false;
  bool bt2 = false;
  bool bt0 = false;
  final FocusNode teclado = FocusNode();

  @override
  void initState() {
    super.initState();

    print("🟢 T1view se ha inicializado y está esperando datos...");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final socketProvider = context.read<SocketProvider>();
      if (socketProvider.lastMessage != null) {
        if (socketProvider.lastMessage.contains("|T1|")) {
          dividirLabels(socketProvider.lastMessage.split('\n'));
        }
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

      if (line.contains("l0")) setState(() => l0 = lastPart);
      if (line.contains("l1")) setState(() => l1 = lastPart);
      if (line.contains("l2")) setState(() => l2 = lastPart);
      if (line.contains("l3")) setState(() => l3 = lastPart);
      if (line.contains("l4")) setState(() => l4 = lastPart);
      //if (line.contains("l5")) setState(() => l5 = lastPart);
      //if (line.contains("l+")) setState(() => lMas = lastPart);
    }
  }

  @override
  void dispose() {
    teclado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SocketProvider socketService = Provider.of<SocketProvider>(context);
    void select0() {
      socketService.sendMessage('0');
      setState(() {
        btDisable = true;
        bt0 = true;
      });
    }

    void select1() {
      socketService.sendMessage('1');
      setState(() {
        btDisable = true;
        bt1 = true;
      });
    }

    void select2() {
      socketService.sendMessage('2');
      setState(() {
        btDisable = true;
        bt2 = true;
      });
    }

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
          body: KeyboardListener(
            focusNode: teclado,
            autofocus: true,
            onKeyEvent: (KeyEvent event) {
              if (event is KeyDownEvent) {
                final key = event.logicalKey.keyLabel;

                switch (key) {
                  case '0':
                    if (!btDisable) select0();
                    break;
                  case '1':
                    if (!btDisable) select1();
                    break;
                  case '2':
                    if (!btDisable) select2();
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
                    children: [montarMenu(select1, select2, select0)],
                  ),
                ),
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
          ),
        ));
  }

  Widget buildCustomButton(
      String text, String imagePath, VoidCallback onPressed, bool disable) {
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
                onTap: disable ? null : onPressed,
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

  Widget montarMenu(
      VoidCallback select1, VoidCallback select2, VoidCallback select0) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildCustomButton(
              l3 ?? "",
              bt1 ? "assets/Aceptar.ico" : "assets/Mapa.ICO",
              select1,
              btDisable),
          buildCustomButton(
              l4 ?? "",
              bt2 ? "assets/Aceptar.ico" : "assets/Matricula.ico",
              select2,
              btDisable),
          buildCustomButton(
              l2 ?? "",
              bt0 ? "assets/Aceptar.ico" : "assets/MenAnt.ico",
              select0,
              btDisable),
        ],
      ),
    );
  }
}
