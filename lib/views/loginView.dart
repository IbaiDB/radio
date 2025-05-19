import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/dialogProvider.dart';
import 'package:radio/socketService.dart';

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
    final isDialogOpen = context.read<DialogProvider>().isDialogOpen;
    if (isDialogOpen) {
      print("🛑 Hay un diálogo abierto en MainScreen");
    } else {
      print("✅ No hay diálogos abiertos");
      if (message.contains("Login failed")) {
        if (message.contains("Login username:")) {
          focusear(_userFocusNode);
          setState(() {
            bloqueoTextFields = false;
            _passController.clear();
            _userController.clear();
          });
        }
      } else {
        if (message.contains("Login username:") &&
            !message.contains("Authentication is in progress...")) {
          setState(() {
            bloqueoTextFields = false;
          });
        }
      }
    }
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("¡Atención!"),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => bloqueoTextFields = false);

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_userFocusNode.canRequestFocus) {
                    _userFocusNode.requestFocus();
                  }
                });
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  void _login() {
    final socketProvider = context.read<SocketProvider>();
    socketProvider.sendMessage(_userController.text);
    socketProvider.sendMessage(_passController.text);
    focusear(_userFocusNode);
    setState(() => bloqueoTextFields = true);
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    socketProvider.removeListener(_socketListener);
    dialog.removeListener(_socketListener);
    super.dispose();
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
                padding: const EdgeInsets.all(16.0),
                child: Flex(direction: Axis.vertical, children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Usuario:', style: TextStyle(fontSize: 26)),
                            SizedBox(width: 10),
                            Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
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
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Contraseña:', style: TextStyle(fontSize: 26)),
                            SizedBox(width: 10),
                            Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
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
                      ],
                    ),
                  )
                ]),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 20,
                  color: const Color.fromARGB(255, 0, 38, 206),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
