import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/socketService.dart';
import 'package:radio/views/teclado.dart';

class Inview extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const Inview({
    super.key,
    required this.navigatorKey,
  });

  @override
  State<Inview> createState() => InviewState();
}

class InviewState extends State<Inview> {
  String? l0, l1, l2, l3, l4, l5, l6, l7, lA, t0, t8, t9;
  final TextEditingController t2 = TextEditingController();
  final TextEditingController t3 = TextEditingController();
  final TextEditingController t4 = TextEditingController();
  final TextEditingController t5 = TextEditingController();
  final TextEditingController t6 = TextEditingController();
  final TextEditingController t7 = TextEditingController();
  final TextEditingController tA = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late SocketProvider socketProvider;

  @override
  void initState() {
    super.initState();

    focusear(_focusNode);

    print("🟢 Inview se ha inicializado y está esperando datos...");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketProvider = context.read<SocketProvider>();
      socketProvider.removeListener(_socketListener);
      socketProvider.addListener(_socketListener);
      // 2️⃣ Ejecutar _socketListener() inmediatamente si hay un mensaje previo
      if (socketProvider.lastMessage != null) {
        print("📩 Mensaje previo encontrado: ${socketProvider.lastMessage}");

        if (socketProvider.lastMessage.contains("|IN|")) {
          dividirLabels(socketProvider.lastMessage.split('\n'));
          _socketListener();
        }
      }
    });
  }

  void _socketListener() {
    try {
      if (!mounted) {
        print("⚠️ InView está desmontado, ignorando mensaje");
        return;
      }
      if (socketProvider.lastMessage.contains("|IN|")) {
        dividirLabels(socketProvider.lastMessage.split('\n'));
        focusear(_focusNode);
        t3.clear();
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

      if (line.contains("l0")) setState(() => l0 = lastPart);
      if (line.contains("l1")) setState(() => l1 = lastPart);
      if (line.contains("l2") && !line.contains("|l2||"))
        setState(() => l2 = lastPart);
      if (line.contains("l3")) setState(() => l3 = lastPart);
      if (line.contains("l4") && !line.contains("|l4||"))
        setState(() => l4 = lastPart);
      if (line.contains("l5") && !line.contains("|l5||"))
        setState(() => l5 = lastPart);
      if (line.contains("l6") && !line.contains("|l6||"))
        setState(() => l6 = lastPart);
      if (line.contains("l7")) setState(() => l7 = lastPart);
      if (line.contains("t0")) setState(() => t0 = lastPart);
      if (line.contains("t2")) setState(() => t2.text = lastPart);
      if (line.contains("t3") && !line.contains("|t3||"))
        setState(() => t3.text = lastPart);
      if (line.contains("t4")) setState(() => t4.text = lastPart);
      if (line.contains("t5")) setState(() => t5.text = lastPart);
      if (line.contains("t6")) setState(() => t6.text = lastPart);
      if (line.contains("t7")) setState(() => t7.text = lastPart);
      if (line.contains("t8")) setState(() => t8 = lastPart);
      if (line.contains("t9") && !line.contains("|t9||"))
        setState(() => t9 = lastPart);
      if (line.contains("lA") && !line.contains("|lA||"))
        setState(() => lA = lastPart);
      if (line.contains("tA") && !line.contains("|tA||"))
        setState(() => tA.text = lastPart);
      //if (line.contains("l+")) setState(() => lMas = lastPart);
    }
  }

  Future lanzarteclado() async {
    String? txt;
    txt = t3.text;
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => KeyboardScreenView(
                txt: txt,
              )),
    );
    if (resultado != null) {
      setState(() {
        t3.text = resultado;
      });
      socketProvider.sendMessage(resultado);
    } else {
      return '';
    }
  }

  @override
  void dispose() {
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
                            height: 30,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical:
                                      1), // Solo el TextField tiene padding
                              child: TextField(
                                controller: t2,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                onSubmitted: (value) =>
                                    socketProvider.sendMessage(t2.text),
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
                        t8 ?? "",
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
                              lanzarteclado();
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
                                l3 ?? "",
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
                            height: 30,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical:
                                      1), // Solo el TextField tiene padding

                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                focusNode: _focusNode,
                                controller: t3,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                onSubmitted: (value) =>
                                    socketProvider.sendMessage(t3.text),
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
                              l4 ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Color del texto negro
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Sin padding extra
                          SizedBox(
                            height: 30,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical:
                                      1), // Solo el TextField tiene padding
                              child: TextField(
                                controller: t4,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                onSubmitted: (value) =>
                                    socketProvider.sendMessage(t2.text),
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
                            height: 30,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical:
                                      1), // Solo el TextField tiene padding
                              child: TextField(
                                controller: t5,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                onSubmitted: (value) =>
                                    socketProvider.sendMessage(t2.text),
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
                        t9 ?? "",
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
                              lA ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Color del texto negro
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Sin padding extra
                          SizedBox(
                            height: 30,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical:
                                      1), // Solo el TextField tiene padding
                              child: TextField(
                                controller: tA,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                onSubmitted: (value) =>
                                    socketProvider.sendMessage(t2.text),
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
                            ),
                          ),
                          // Sin padding extra
                          SizedBox(
                            height: 30,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical:
                                      1), // Solo el TextField tiene padding
                              child: TextField(
                                controller: t6,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                onSubmitted: (value) =>
                                    socketProvider.sendMessage(t2.text),
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
                            height: 30,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical:
                                      1), // Solo el TextField tiene padding
                              child: TextField(
                                controller: t7,
                                enabled: false,
                                style: TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                onSubmitted: (value) =>
                                    socketProvider.sendMessage(t2.text),
                              ),
                            ),
                          ),
                        ],
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

  Widget rowText(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: TextStyle(fontSize: 16)),
          Text(right, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
