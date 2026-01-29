import 'package:belema_test_app/features/pin/set_pin_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/login_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    setTransactionPin: (context) => const SetPinScreen(),
  };
  static String login = '/login';
  static String setTransactionPin = '/reset-password';
}