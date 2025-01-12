import 'package:farmer_alert/services/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://hwmxguixxkipefgccero.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3bXhndWl4eGtpcGVmZ2NjZXJvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzODk1MTYsImV4cCI6MjA1MDk2NTUxNn0.hVAC9curfyvPSxxSgAWQb8Kis3XsnI32iLPW9l_XWkM");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthGate(),
    );
  }
}
