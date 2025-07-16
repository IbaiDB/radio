import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:radio/views/menuConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocketProvider with ChangeNotifier {
  Socket? _socket;
  String _lastMessage = "";
  bool _isConnected = false;
  StringBuffer _buffer = StringBuffer();
  Timer? _timer;
  int _retryDelay = 1;
  int intentosconex = 0;

  String get lastMessage => _lastMessage;
  bool get isConnected => _isConnected;

  void Function()? onShowReconnectDialog;
  void Function()? onHideReconnectDialog;

  bool _isInMenuConfig = false;

  void marcarEnMenuConfig(bool valor) {
    _isInMenuConfig = valor;
  }

  bool get isInMenuConfig => _isInMenuConfig;

  Future<String?> getIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('server_ip');
  }

  Future<void> cleanIp() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> connect(BuildContext context) async {
    if (_isConnected) return;

    final ip = await getIp();

    if (ip == null && !isInMenuConfig) {
      print("❌ IP no encontrada en SharedPreferences.");
      disconnect();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Menuconfig()));
      return;
    }

    try {
      print('🌐 Intentando conectar al servidor...');
      Socket.connect(ip, 7212)
          .timeout(const Duration(seconds: 5))
          .then((socket) {
        _socket = socket;
        _isConnected = true;
        _retryDelay = 1;
        print('✅ Conectado al servidor');

        // Aquí va el try-catch del listen
      }).catchError((e, st) {
        // print("💥 Error al conectar: $e\n$st");
        // _handleDisconnection(context, true);
      });

      _isConnected = true;
      _retryDelay = 1;
      print('✅ Conectado al servidor');

      final socket =
          await Socket.connect(ip, 7212).timeout(const Duration(seconds: 5));
      _socket = socket;
      _isConnected = true;
      _retryDelay = 1;
      print('✅ Conectado al servidor');
      intentosconex = 0;

      // Solo si socket no es null, crea el listener
      if (_socket != null) {
        try {
          _socket!.listen(
            (List<int> event) {
              try {
                _handleData(event);
              } catch (e, st) {
                print("❌ Error interno procesando datos: $e\n$st");
              }
            },
            onError: (error, [stackTrace]) {
              print("❌ Error en el socket (onError): $error\n$stackTrace");
              _handleDisconnection(context, true);
            },
            onDone: () {
              print("⚠️ Conexión cerrada por el servidor.");
              _handleDisconnection(context, false);
            },
            cancelOnError: true,
          );
        } catch (e, st) {
          print(
              "🔥 Excepción grave al establecer el listener del socket: $e\n$st");
          _handleDisconnection(context, true);
        }
      }
    } on SocketException catch (e) {
      if (e.message.contains('No route to host')) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error de conexión'),
              content: Text('No se pudo conectar. La IP puede ser incorrecta.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cerrar'),
                ),
              ],
            ),
          );
        }
        return;
      } else {
        print('🚨 Error de conexión: $e');
        _handleDisconnection(context, true);
      }
    } on TimeoutException {
      print('⏳ Conexión agotada.');
      _handleDisconnection(context, true);
    } catch (e) {
      print('⚠️ Error inesperado: $e');
      _handleDisconnection(context, true);
    }
  }

  void _handleData(List<int> event) {
    try {
      String serverResponse = utf8.decode(event, allowMalformed: true);
      if (serverResponse.trim().isEmpty) return;

      _buffer.write(serverResponse);

      _timer?.cancel();

      _timer = Timer(Duration(milliseconds: 600), () {
        _lastMessage = _buffer.toString();
        print("ESTE ES BUFFER ==>" + _buffer.toString());
        print("ESTE ES LASTMESAGE ==>" + _lastMessage);
        notifyListeners();
        _buffer.clear();
      });
    } catch (e) {
      print("⚠️ Error al procesar datos: $e");
    }
  }

  void _handleDisconnection(BuildContext context, bool dialog) async {
    disconnect();

    final ip = await getIp();
    if (dialog && ip != null && !isInMenuConfig && intentosconex <= 10) {
      onShowReconnectDialog?.call();
      print("🕒 Esperando $_retryDelay segundos antes de reconectar...");
      intentosconex++;
    }

    Timer(Duration(seconds: _retryDelay), () {
      connect(context);
      if (dialog) onHideReconnectDialog?.call();
      _retryDelay = (_retryDelay * 2).clamp(1, 60);
    });
  }

  void sendMessage(String message) {
    if (_socket != null && _isConnected) {
      if (lastMessage.contains("|MB|")) {
        _socket!.write(message);
      } else {
        _socket!.write("$message\r");
      }
    } else {
      print("⚠️ No se pudo enviar el mensaje, socket desconectado.");
    }
  }

  void disconnect() {
    _socket?.destroy();
    _timer?.cancel();
    _socket = null;
    _isConnected = false;
    _lastMessage = "";
  }
}
