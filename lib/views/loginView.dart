import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:radio/dialogProvider.dart';
import 'package:radio/socketService.dart';
import 'package:radio/views/menuConfig.dart';
import 'package:radio/views/teclado.dart';

class LoginView extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  LoginView({required this.navigatorKey});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late FocusNode _userFocusNode;
  final FocusNode _passFocusNode = FocusNode();
  bool bloqueoTextFields = false;
  late DialogProvider dialog;
  late SocketProvider socketProvider;
  bool userTeclado = false;
  bool passTeclado = false;
  bool mostrarControles = false;
  bool conectando = false;
  String cargando = '';
  double barracarga = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _userFocusNode = FocusNode();
    focusear(_userFocusNode);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketProvider = context.read<SocketProvider>();
      dialog = context.read<DialogProvider>();
      socketProvider.removeListener(_socketListener);
      dialog.removeListener(_socketListener);
      socketProvider.addListener(_socketListener);
      dialog.addListener(_socketListener);
      _socketListener();
    });
  }

  void _socketListener() {
    final socketProvider = context.read<SocketProvider>();
    final message = socketProvider.lastMessage;
    bool isDialogOpen = context.read<DialogProvider>().isDialogOpen;
    if (isDialogOpen) {
      print("🛑 Hay un diálogo abierto en MainScreen");
      setState(() {
        conectando = false;
        isDialogOpen = false;
      });
    } else {
      print("✅ No hay diálogos abiertos");
      if (message.contains("Login failed")) {
        if (message.contains("Login username:")) {
          focusear(_userFocusNode);
          setState(() {
            bloqueoTextFields = false;
            _passController.clear();
            _userController.clear();
            userTeclado = true;
            passTeclado = false;
          });
        }
      } else {
        if (message.contains("Login username:") &&
            !message.contains("Authentication is in progress...")) {
          setState(() {
            cargando = '';
            bloqueoTextFields = false;
            userTeclado = true;
            passTeclado = false;
            conectando = false;
          });
        }
        if (message.contains("Authentication is in progress...") &&
            !message.contains("|XX|CT|l0|Bienvenido|")) {
          iniciarTemporizador();
          setState(() {
            cargando = 'Conectando...';
            conectando = true;
          });
        }
        if (message.contains("|XX|CT|l0|Bienvenido|")) {
          setState(() {
            cargando = 'Bienvenido';
            conectando = false;
            barracarga = 0;
          });
          Future.delayed(Duration(seconds: 10), () {
            if (!mounted) return;
            setState(() {
              cargando = '';
            });
          });
        }
      }
    }
  }

  void iniciarTemporizador() {
    final socketProvider = context.read<SocketProvider>();
    final message = socketProvider.lastMessage;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        barracarga = barracarga + 0.1;
      });
      if (conectando && barracarga >= 1) {
        timer.cancel();
        setState(() {
          conectando = false;
          barracarga = 0;
          if (message.contains("|XX|CT|l0|Bienvenido|")) {
            bloqueoTextFields = false;
          }
        });
        //socketProvider.disconnect();
        socketProvider.connect(context);
      }
    });
  }

  void focusear(FocusNode f) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).unfocus();
        Future.delayed(Duration(milliseconds: 50), () {
          FocusScope.of(context).requestFocus(f);
        });
      }
    });
  }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("¡Atención!"),
  //         content: Text(message),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               setState(() {
  //                 bloqueoTextFields = false;
  //               });

  //               WidgetsBinding.instance.addPostFrameCallback((_) {
  //                 if (_userFocusNode.canRequestFocus) {
  //                   _userFocusNode.requestFocus();
  //                 }
  //               });
  //             },
  //             child: Text("Aceptar"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _login() {
    final socketProvider = context.read<SocketProvider>();
    socketProvider.connect(context);
    //socketProvider.cleanIp();
    //iniciarTemporizador();
    setState(() {
      conectando = true;
    });

    focusear(_userFocusNode);
    if (socketProvider.isConnected) {
      iniciarTemporizador();
      socketProvider.sendMessage(_userController.text);
      socketProvider.sendMessage(_passController.text);
      setState(() {
        bloqueoTextFields = true;
        cargando = '';
      });
    } else {
      setState(() {
        conectando = false;
      });
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    socketProvider.removeListener(_socketListener);
    dialog.removeListener(_socketListener);
    timer?.cancel();
    super.dispose();
  }

  verconfig() {
    setState(() {
      mostrarControles = !mostrarControles;
    });
  }

  menuConfig() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Menuconfig()));
  }

  Future lanzarteclado() async {
    String txt;

    if (userTeclado) {
      txt = _userController.text;
    } else if (passTeclado) {
      txt = _passController.text;
    } else {
      txt = '';
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
        if (userTeclado) {
          _userController.text = resultado;
          focusear(_passFocusNode);
          userTeclado = false;
          passTeclado = true;
        } else if (passTeclado) {
          _passController.text = resultado;
          _login();
        }
      });
    } else {
      return '';
    }
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¿Cerrar la aplicación?"),
        content: Text("¿Estás seguro de que deseas salir de la aplicación?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            },
            child: Text("Salir"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Flex(direction: Axis.vertical, children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisAlignment: mostrarControles
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (mostrarControles)
                              GestureDetector(
                                onTap: menuConfig,
                                child: Image.asset(
                                  'assets/Configuracion3.ico',
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            if (mostrarControles)
                              GestureDetector(
                                onTap: () => _confirmExit(context),
                                child: Image.asset(
                                  'assets/Apagado1.ico',
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 125,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onDoubleTap: verconfig,
                              child: Image.asset(
                                'assets/Usuarios3.ico',
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (!mostrarControles)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: userTeclado ? lanzarteclado : () => {},
                                child: const Text('Usuario:',
                                    style: TextStyle(fontSize: 26)),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 120,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextField(
                                  onTap: () {
                                    focusear(_userFocusNode);
                                    userTeclado = true;
                                    passTeclado = false;
                                  },
                                  focusNode: _userFocusNode,
                                  controller: _userController,
                                  readOnly: bloqueoTextFields,
                                  style: TextStyle(fontSize: 20),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 12),
                                  ),
                                  onSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_passFocusNode);
                                    userTeclado = false;
                                    passTeclado = true;
                                  },
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 10),
                        if (!mostrarControles)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: passTeclado ? lanzarteclado : () => {},
                                child: const Text('Contraseña:',
                                    style: TextStyle(fontSize: 26)),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 120,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextField(
                                  onTap: () {
                                    focusear(_passFocusNode);
                                    userTeclado = false;
                                    passTeclado = true;
                                  },
                                  focusNode: _passFocusNode,
                                  controller: _passController,
                                  readOnly: bloqueoTextFields,
                                  obscureText: true,
                                  style: TextStyle(fontSize: 20),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 12),
                                  ),
                                  onSubmitted: (value) => _login(),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 20),
                        if (conectando)
                          LinearProgressIndicator(
                            value: barracarga,
                            backgroundColor: Colors.grey[300],
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                ]),
              ),
              Positioned(
                height: 25,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 20,
                  color: const Color.fromARGB(255, 0, 38, 206),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cargando,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
