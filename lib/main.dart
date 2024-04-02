import 'package:chat_verse/src/app_widget.dart';
import 'package:chat_verse/src/core/app_config.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppConfig(child: AppWidget()));
}
