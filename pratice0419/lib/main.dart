import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'thememodenotifier.dart';
import 'package:flutter/foundation.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'dart:io';
const double windowWidth = 400;
const double windowHeight = 800;
void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    doWhenWindowReady(() {
      const initialSize = Size(windowWidth, windowHeight);
      appWindow.minSize = initialSize;
      appWindow.maxSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.title = "資工購物平台";
      appWindow.show();
    });
  }
}
void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeModeNotifier(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  MainAppState createState()=>MainAppState();
}
class MainAppState extends State<MainApp>{
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeModeNotifier>(context);
    return MaterialApp(
      home: LoginScreen(),
      themeMode: themeNotifier.themeMode == '深色模式' ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false
    );
  }
}
