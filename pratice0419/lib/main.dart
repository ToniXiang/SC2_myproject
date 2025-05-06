import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'thememodenotifier.dart';

void main() {
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
