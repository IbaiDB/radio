import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/dialogProvider.dart';
import 'package:radio/views/cCview.dart';
import 'package:radio/views/f0view.dart';
import 'package:radio/views/inView.dart';
import 'package:radio/views/p2View.dart';
import 'package:radio/views/pIview.dart';
import 'package:radio/views/prView.dart';
import 'package:radio/views/r0View.dart';
import 'package:radio/views/r1view.dart';
import 'package:radio/views/r2view.dart';
import 'package:radio/views/rEview.dart';
import 'package:radio/views/rcView.dart';
import 'package:radio/views/sOview.dart';
import 'package:radio/views/t0view.dart';
import 'package:radio/views/t1view.dart';
import 'package:radio/views/t2view.dart';
import 'package:radio/views/tEview.dart';
import 'package:radio/views/tRview.dart';
import 'package:radio/views/tTview.dart';
import 'package:radio/views/x0view.dart';
import 'package:radio/views/x1view.dart';
import 'package:radio/views/xCview.dart';
import 'package:radio/views/xNview.dart';
import 'socketService.dart';
import 'views/loginView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Captura errores sin manejar en zonas asíncronas
  FlutterError.onError = (FlutterErrorDetails details) {
    print("🚨 ERROR CAPTURADO POR FlutterError.onError: ${details.exception}");
  };

  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SocketProvider()),
          ChangeNotifierProvider(create: (context) => DialogProvider()),
        ],
        child: MyApp(),
      ),
    );
  }, (error, stackTrace) {
    print("🚨 ERROR NO MANEJADO (runZonedGuarded): $error");
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: '/MainScreen',
      routes: {
        '/MainScreen': (context) => MainScreen(),
      },
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late SocketProvider _socketProvider;
  String error = '';
  bool isPrViewOpen = false;
  String? lastRoute = "";

  @override
  void initState() {
    super.initState();
    _socketProvider = Provider.of<SocketProvider>(context, listen: false);
    _socketProvider.connect(context);
    _socketProvider.onShowReconnectDialog = () {
      if (getCurrentRoute() != "/LoginView") {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Se ha perdido la conexión. Reconectando..."),
              ],
            ),
          ),
        );
      }
    };

    _socketProvider.onHideReconnectDialog = () {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    };
    _socketProvider.addListener(_socketListener);
  }

  void dividirLabels(List<String> lines) {
    print("🔍 Procesando líneas:");
    for (String line in lines) {
      line = line.trim().replaceAll(RegExp(r'[^\x20-\x7E|]'), '');
      List<String> parts = line.split('|');
      String lastPart = parts.reversed
          .firstWhere((part) => part.isNotEmpty, orElse: () => "Error")
          .trim();
      if (line.contains("MB") && mounted) setState(() => error = lastPart);
    }
  }

  void _socketListener() {
    final message = _socketProvider.lastMessage;

    if (message.contains("|MB|")) {
      dividirLabels(message.split('\n'));
      _showErrorDialog(error);
    } else if (message.contains("|R0|")) {
      _navigateToR0view();
    } else if (message.contains("|R1|")) {
      _navigateToR1view();
    } else if (message.contains("|R2|")) {
      _navigateToR2view();
    } else if (message.contains("|IN|")) {
      _navigateToInview();
    } else if (message.contains("|RC|")) {
      _navigateToRcview();
    } else if (message.contains("|RE|")) {
      _navigateToReview();
    } else if (message.contains("|P2|MF|")) {
      _navigateToP2view();
    } else if (message.contains("Introduzca su nombre de usuario y clave")) {
      _navigateToLogin();
    } else if (message.contains("|PR|DI|") &&
        !message.contains("|CC|") &&
        !message.contains("|SO|")) {
      _navigateToPrview();
    } else if (message.contains("|TE|")) {
      _navigateToTeview();
    } else if (message.contains("|TR|")) {
      _navigateToTrview();
    } else if (message.contains("|TT|DI|")) {
      _navigateToTtview();
    } else if (message.contains("|T1|")) {
      _navigateToT1view();
    } else if (message.contains("|T2|")) {
      _navigateToT2view();
    } else if (message.contains("|T0|")) {
      _navigateToT0view();
    } else if (message.contains("|CC|")) {
      _navigateToCcview();
    } else if (message.contains("|SO|")) {
      _navigateToSOview();
    } else if (message.contains("|X0|")) {
      _navigateToX0view();
    } else if (message.contains("|X1|")) {
      _navigateToX1view();
    } else if (message.contains("|XN|")) {
      _navigateToXnview();
    } else if (message.contains("|XC|")) {
      _navigateToXcview();
    } else if (message.contains("|F0|")) {
      _navigateToF0view();
    } else if (message.contains("|PI|DI|")) {
      _navigateToPiview();
    } else if (message.contains("Login failed...")) {
      final dialogProvider =
          Provider.of<DialogProvider>(context, listen: false);
      dialogProvider.showDialog();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("¡Atención!"),
            content: const Text("Login incorrecto..."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  dialogProvider.closeDialog();
                  Navigator.of(context).pop(true);
                },
                child: const Text("Aceptar"),
              ),
            ],
          );
        },
      );
    }
  }

  void _navigateToR0view() {
    navigateTo('/R0View', R0view(navigatorKey: navigatorKey));
  }

  void _navigateToR1view() {
    navigateTo('/R1View', R1view(navigatorKey: navigatorKey));
  }

  void _navigateToR2view() {
    navigateTo('/R2View', R2view(navigatorKey: navigatorKey));
  }

  void _navigateToInview() {
    navigateTo('/InView', Inview(navigatorKey: navigatorKey));
  }

  void _navigateToRcview() {
    navigateTo('/RcView', Rcview(navigatorKey: navigatorKey));
  }

  void _navigateToReview() {
    navigateTo('/ReView', Review(navigatorKey: navigatorKey));
  }

  void _navigateToP2view() {
    navigateTo('/P2View', P2view(navigatorKey: navigatorKey));
  }

  void _navigateToLogin() {
    navigateTo('/LoginView', LoginView(navigatorKey: navigatorKey));
  }

  void _navigateToPrview() {
    navigateTo('/PrView', Prview(navigatorKey: navigatorKey));
  }

  void _navigateToSOview() {
    navigateTo('/SOView', S0View(navigatorKey: navigatorKey),
        removeUntilMain: false);
  }

  void _navigateToCcview() {
    navigateTo('/CcView', CcView(navigatorKey: navigatorKey),
        removeUntilMain: false);
  }

  void _navigateToT0view() {
    navigateTo('/T0View', T0view(navigatorKey: navigatorKey));
  }

  void _navigateToTeview() {
    navigateTo('/TeView', Teview(navigatorKey: navigatorKey));
  }

  void _navigateToTrview() {
    navigateTo('/TrView', Trview(navigatorKey: navigatorKey));
  }

  void _navigateToTtview() {
    navigateTo('/TtView', Ttview(navigatorKey: navigatorKey));
  }

  void _navigateToT1view() {
    navigateTo('/T1View', T1view(navigatorKey: navigatorKey));
  }

  void _navigateToT2view() {
    navigateTo('/T2View', T2view(navigatorKey: navigatorKey));
  }

  void _navigateToX0view() {
    navigateTo('/X0View', X0view(navigatorKey: navigatorKey));
  }

  void _navigateToX1view() {
    navigateTo('/X1View', X1view(navigatorKey: navigatorKey));
  }

  void _navigateToPiview() {
    navigateTo('/PiView', Piview(navigatorKey: navigatorKey));
  }

  void _navigateToXnview() {
    navigateTo('/XnView', Xnview(navigatorKey: navigatorKey));
  }

  void _navigateToF0view() {
    navigateTo('/F0View', F0view(navigatorKey: navigatorKey));
  }

  void _navigateToXcview() {
    navigateTo('/XcView', Xcview(navigatorKey: navigatorKey));
  }

  void navigateTo(String routeToGo, Widget screen,
      {bool removeUntilMain = true}) {
    final currentRoute = getCurrentRoute();

    print("🔹 Ruta actual: $currentRoute");
    print("🔹 Intentando navegar a: $routeToGo");

    if (currentRoute == routeToGo || _socketProvider.isInMenuConfig) {
      print("⚠️ Ya estamos en $routeToGo, no navegamos de nuevo.");
      return;
    }

    if (removeUntilMain) {
      if (getCurrentRoute() == '/SOView' || getCurrentRoute() == '/CcView') {
        if (lastRoute == routeToGo) {
          lastRoute = currentRoute;
          navigatorKey.currentState?.pop();
        } else {
          navigatorKey.currentState?.pop();
          lastRoute = currentRoute;
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => screen,
              settings: RouteSettings(name: routeToGo),
            ),
            (route) => route.settings.name == '/MainScreen',
          );
        }
      } else {
        lastRoute = currentRoute;
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => screen,
            settings: RouteSettings(name: routeToGo),
          ),
          (route) => route.settings.name == '/MainScreen',
        );
      }
    } else {
      lastRoute = currentRoute;
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => screen,
          settings: RouteSettings(name: routeToGo),
        ),
      );
    }
  }

  String? getCurrentRoute() {
    final navigatorState = navigatorKey.currentState;
    if (navigatorState == null) return null;

    Route? currentRoute;
    navigatorState.popUntil((route) {
      currentRoute = route;
      return true;
    });

    return currentRoute?.settings.name;
  }

  void _showErrorDialog(String message) {
    final dialogProvider = Provider.of<DialogProvider>(context, listen: false);
    dialogProvider.showDialog();
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
                dialogProvider.closeDialog();
                Navigator.of(context).pop(true);
                _socketProvider.sendMessage("\r");
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  conectarSocketProvider() {
    _socketProvider.connect(context);
  }

  @override
  void dispose() {
    _socketProvider.removeListener(_socketListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );
  }
}
