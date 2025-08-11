// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'ConversationProvider.dart';
import 'gemini_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
        Provider(create: (_) => GeminiService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kids AI Assistant',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
        home: HomeScreen(),
      ),
    );
  }
}
