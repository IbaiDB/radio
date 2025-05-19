import 'package:flutter/material.dart';

class DialogProvider extends ChangeNotifier {
  bool _isDialogOpen = false;

  bool get isDialogOpen => _isDialogOpen;

  void showDialog() {
    _isDialogOpen = true;
    notifyListeners();
  }

  void closeDialog() {
    _isDialogOpen = false;
    notifyListeners();
  }
}
