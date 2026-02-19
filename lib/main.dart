// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/product_provider.dart';
import 'screens/login_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FakeStore App',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        // ใช้ initialRoute แทน home เพื่อกำหนดหน้าแรก
        initialRoute: '/login', 
        // ลงทะเบียน Routes ทั้งหมดตรงนี้
        routes: {
          '/login': (context) => const LoginScreen(),
          '/users': (context) => const UserListScreen(),
          '/products': (context) => const ProductListScreen(),
        },
      ),
    );
  }
}