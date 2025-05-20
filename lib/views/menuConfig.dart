import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/socketService.dart';
import 'package:radio/views/teclado.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menuconfig extends StatefulWidget {
  const Menuconfig({super.key});

  @override
  State<Menuconfig> createState() => MenuconfigState();
}

Future<String?> getIp() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('server_ip');
}

class MenuconfigState extends State<Menuconfig> {
  var ip = getIp();
  final TextEditingController srvController = new TextEditingController();
  final FocusNode srvFnode = new FocusNode();

  late SocketProvider socketProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
  }

  Future<void> saveIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', ip);
  }

  @override
  void initState() {
    super.initState();
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.marcarEnMenuConfig(true);
    pintarIp();
  }

  pintarIp() async {
    String? ip = await socketProvider.getIp();
    if (ip != null) {
      setState(() {
        srvController.text = ip;
      });
    }
  }

  Future lanzarteclado() async {
    String txt;

    txt = srvController.text;

    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => KeyboardScreenView(
                txt: txt,
              )),
    );
    if (resultado != null) {
      setState(() {
        srvController.text = resultado;
      });
      await saveIp(resultado.trim());
      socketProvider.connect(context);
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    socketProvider.marcarEnMenuConfig(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = context.read<SocketProvider>();
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 50, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onDoubleTap: () {
                            if (socketProvider.isConnected) {
                              Navigator.pop(context);
                            }
                          },
                          child: Image.asset(
                            'assets/Usuarios3.ico',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: lanzarteclado,
                          child: const Text('Servidor:',
                              style: TextStyle(fontSize: 26)),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 180,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            focusNode: srvFnode,
                            controller: srvController,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                            ),
                            onSubmitted: (value) async {
                              if (value.trim().isNotEmpty) {
                                await saveIp(value.trim());
                                socketProvider.connect(context);
                              } else {
                                print("❌ IP vacía, no se guardó.");
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
