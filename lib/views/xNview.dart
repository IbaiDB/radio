import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/socketService.dart';
import 'package:radio/views/teclado.dart';

class Xnview extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  Xnview({
    super.key,
    required this.navigatorKey,
  });

  @override
  State<Xnview> createState() => XnviewState();
}

class XnviewState extends State<Xnview> {
  String? l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, lA, t0, t1, tA, t4, t7;

  final TextEditingController? t2 = TextEditingController();
  final TextEditingController? t3 = TextEditingController();
  final TextEditingController? t5 = TextEditingController();
  final TextEditingController? t6 = TextEditingController();
  //final TextEditingController? t7 = TextEditingController();
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
    print("🟢 Xnview se ha inicializado y está esperando datos...");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketProvider = context.read<SocketProvider>();

      // 1️⃣ Eliminar listener para evitar duplicados
      socketProvider.removeListener(_socketListener);
      socketProvider.addListener(_socketListener);

      // 2️⃣ Ejecutar _socketListener() inmediatamente si hay un mensaje previo
      if (socketProvider.lastMessage != null) {
        print("📩 Mensaje previo encontrado: ${socketProvider.lastMessage}");

        if (socketProvider.lastMessage.contains("|XN|") &&
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
        print("⚠️ Xnview está desmontado, ignorando mensaje");
        return;
      }

      if (socketProvider.lastMessage.contains("|XN|") &&
              !socketProvider.lastMessage.contains(
                  "|CC|") /*&&
           !socketProvider.lastMessage.contains("|SO|")*/
          ) {
        if (socketProvider.lastMessage.contains("|XN|DI|t4||") &&
            !_focusNodet4.hasFocus) {
          focusear(_focusNodet4);
          enviart4 = true;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XN|DI|t4|Todos|") &&
            !_focusNodet4.hasFocus) {
          focusear(_focusNodet4);
          enviart4 = true;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XN|DI|t6|") &&
            !_focusNodet6.hasFocus) {
          focusear(_focusNodet6);
          enviart4 = false;
          enviart8 = false;
          enviart9 = false;
          enviart6 = true;
          enviart7 = false;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XN|DI|t7|") &&
            !_focusNodet7.hasFocus) {
          focusear(_focusNodet7);
          enviart4 = false;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = true;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XN|DI|t8|") &&
            !_focusNodet8.hasFocus) {
          focusear(_focusNodet8);
          enviart4 = false;
          enviart8 = true;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XN|DI|t9|") &&
            !_focusNodet9.hasFocus) {
          focusear(_focusNodet9);
          enviart4 = false;
          enviart8 = false;
          enviart9 = true;
          enviart6 = false;
          enviart7 = false;
          enviart2 = false;
        } else if (socketProvider.lastMessage.contains("|XN|DI|t2|") &&
            !_focusNodet2.hasFocus) {
          focusear(_focusNodet2);
          enviart4 = false;
          enviart8 = false;
          enviart9 = false;
          enviart6 = false;
          enviart7 = false;
          enviart2 = true;
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
    int i = 0;

    while (i < lines.length) {
      String line = lines[i].trim().replaceAll(RegExp(r'[^\x20-\x7E|]'), '');

      // Mientras la línea no tenga un '|' al final, une más líneas
      while (!line.endsWith('|') && i + 1 < lines.length) {
        i++;
        line += '\n' + lines[i].trim();
      }

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
        setState(() => t3?.text = lastPart);
      if (line.contains("t4") && !line.contains("|t4||"))
        setState(() => t4 = lastPart);
      if (line.contains("t5") && !line.contains("|t5||"))
        setState(() => t5?.text = lastPart);
      if (line.contains("t6") && !line.contains("|t6||"))
        setState(() => t6?.text = lastPart);
      if (line.contains("t7") && !line.contains("|t7||"))
        setState(() => t7 = lastPart);
      if (line.contains("t8") && !line.contains("|t8||"))
        setState(() => t8?.text = lastPart);
      if (line.contains("t9") && !line.contains("|t9||"))
        setState(() => t9?.text = lastPart);
      if (line.contains("lA") && !line.contains("|lA||"))
        setState(() => lA = lastPart);

      // Limpieza: si está en formato vacío "|t0||" entonces borra
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
      if (line.contains("|t3||")) setState(() => t3?.text = "");
      if (line.contains("|t4||")) setState(() => t4 = "");
      if (line.contains("|t5||")) setState(() => t5?.text = "");
      if (line.contains("|t6||")) setState(() => t6?.text = "");
      if (line.contains("|t7||")) setState(() => t7 = "");
      if (line.contains("|t8||")) setState(() => t8?.text = "");
      if (line.contains("|t9||")) setState(() => t9?.text = "");
      if (line.contains("|lA||")) setState(() => lA = "");

      i++; // Avanza a la siguiente línea
    }
  }

  void filtrarTextField() {
    if (enviart6) {
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
    } else if (enviart3) {
      if (t3 != null && t3!.text.trim() != "") {
        socketProvider.sendMessage(t3!.text);
      } else {
        focusear(_focusNodet3);
      }
    }
  }

  Future lanzarteclado() async {
    String? txt;
    if (enviart5) {
      txt = t5?.text;
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
        if (enviart5) {
          t5?.text = resultado;
        } else if (enviart8) {
          t8?.text = resultado;
        } else if (enviart9) {
          t9?.text = resultado;
        } else if (enviart2) {
          t2?.text = resultado;
        }
        socketProvider.sendMessage(resultado);
      });
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
                          GestureDetector(
                            onTap: () {
                              lanzarteclado();
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
                              onTap: () {
                                () => ();
                              },
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
                              l3 ?? "",
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
                                  focusNode: _focusNodet3,
                                  controller: t3,
                                  readOnly: !enviart3,
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
                        t4 ?? "",
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
                    Container(
                      width: double.infinity, // Ocupa todo el ancho
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.blue[900], // Espaciado interior
                      child: Text(
                        t7 ?? "",
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
                                horizontal: 20,
                                vertical: 3), // Opcional: añade padding interno
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
                      width: double.infinity, // Ocupa todo el ancho
                      height: 60,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      color: Colors.blue[900], // Espaciado interior
                      child: Scrollbar(
                        thumbVisibility:
                            true, // Muestra la barra siempre que sea necesario
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            t1 ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
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
