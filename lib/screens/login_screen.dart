import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'user_list_screen.dart';
import 'product_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isObscure = true;

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameCtrl.text.trim();
      final password = _passwordCtrl.text.trim();

      // 1. แสดง Loading Dialog ระหว่างรอ API
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // 2. เรียกใช้ Provider เพื่อดึงข้อมูล Users ทั้งหมดมาตรวจสอบ
      final provider = context.read<UserProvider>();
      await provider.loadUsers(); 

      // ตรวจสอบว่าหน้าจอยังเปิดอยู่หรือไม่ก่อนทำงานต่อ (ป้องกัน Error ของ Flutter)
      if (!mounted) return;
      
      // ปิด Loading Dialog
      Navigator.pop(context);

      // แจ้งเตือนถ้า API มีปัญหา
      if (provider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${provider.error}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // 3. ค้นหา User ที่ Username และ Password ตรงกัน
      final user = provider.users.cast<UserModel?>().firstWhere(
        (u) => u!.username == username && u.password == password,
        orElse: () => null,
      );

      // 4. ตรวจสอบเงื่อนไขหลังจากการค้นหา
      if (user != null) {
        // หากพบ User (รหัสผ่านถูกต้อง) -> เช็ค ID ต่อ
        if (user.id == 1) {
          // ID = 1 ไปหน้าจัดการ User
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserListScreen()),
          );
        } else {
          // ID อื่นๆ ไปหน้าแสดงสินค้า
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProductListScreen()),
          );
        }
      } else {
        // หากไม่พบ User (รหัสผ่านผิด)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username หรือ Password ไม่ถูกต้อง'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.storefront, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'FakeStore Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'กรุณากรอก Username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'กรุณากรอก Password' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: _handleLogin,
                    child: const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}