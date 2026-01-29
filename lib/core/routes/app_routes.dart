import 'package:belema_test_app/features/pin/set_pin_screen.dart';
import 'package:belema_test_app/features/transfer/transfer_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    dashboardScreen: (context) => const DashboardScreen(),
    setTransactionPin: (context) => const SetPinScreen(),
    transferScreen: (context) => const TransferScreen(),
  };
  static String login = '/login';
  static String transferScreen = '/transfer_screen';
  static String setTransactionPin = '/set_pin';
  static String dashboardScreen = '/dashboard_screen';
}