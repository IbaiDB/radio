import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class SocketProvider with ChangeNotifier {
  Socket? _socket;
  String _lastMessage = "";
  bool _isConnected = false;
  StringBuffer _buffer = StringBuffer();
  Timer? _timer;
  int _retryDelay = 1; // Tiempo de espera inicial en segundos

  String get lastMessage => _lastMessage;
  bool get isConnected => _isConnected;

  void Function()? onShowReconnectDialog;
  void Function()? onHideReconnectDialog;

  Future<void> connect() async {
    if (_isConnected) return;

    try {
      print('🌐 Intentando conectar al servidor...');
      _socket = await Socket.connect('192.168.78.85', 7212)
          .timeout(Duration(seconds: 5));

      _isConnected = true;
      _retryDelay = 1; // Resetear el tiempo de reconexión en caso de éxito
      print('✅ Conectado al servidor');

      _socket!.listen(
        (List<int> event) {
          _handleData(event);
        },
        onError: (error) {
          print("❌ Error en el socket: $error");
          _handleDisconnection(true);
        },
        onDone: () {
          print("⚠️ Conexión cerrada por el servidor.");
          _handleDisconnection(false);
        },
        cancelOnError: true,
      );
    } on SocketException catch (e) {
      print('🚨 Error de conexión: $e');
      _handleDisconnection(true);
    } on TimeoutException {
      print('⏳ Conexión agotada.');
      _handleDisconnection(true);
    } catch (e) {
      print('⚠️ Error inesperado: $e');
      _handleDisconnection(true);
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

  void _handleDisconnection(bool dialog) {
    disconnect();
    if (dialog) onShowReconnectDialog?.call();
    print("🕒 Esperando $_retryDelay segundos antes de reconectar...");

    Timer(Duration(seconds: _retryDelay), () {
      connect();
      if (dialog) onHideReconnectDialog?.call();
      _retryDelay = (_retryDelay * 2).clamp(1, 60); // Aumenta hasta 60s
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
