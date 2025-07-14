import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/combo.dart';
import '../register_screen.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  //Tipo
  String? _sTipo; // Variable para almacenar la planta seleccionada
  final List<String> _tipo = [
    'Psicologo',
    'Deportista',
    'Padre/Madre',
    'Estudiante',
  ];

  Future<void> _login() async {
    final username = emailController.text.trim();
    final password = passwordController.text;
    setState(() => loading = true);
    final url = Uri.parse(
      'https://gcconsultoresmexico.com/api/api.php?action=get_user',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': username, 'password': password}),
    );

    setState(() => loading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('==========> $data');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      if (data.length > 0) {
        print('😎 $data');
        final data_ = jsonDecode(response.body);
        if (data_ is List && data_.isNotEmpty) {
          final user = data[0]; // Primer usuario de la lista

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_usuario', user['usuario']);
          await prefs.setString('auth_nombre', user['nombre']);
          await prefs.setString('auth_rol', user['rol']);
          await prefs.setString(
            'auth_token',
            user['token'],
          ); // Aunque ahora es "-"

          print('Usuario guardado: ${user['usuario']}');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error en la conexión al servidor')),
          );
        }
      } else {
        _showError('Usuario o contraseña incorrectos');
      }
    } else {
      _showError('Error del servidor (${response.statusCode})');
    }
  }

  Future<void> _register() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/fondo.png',
            ), // Aquí pones tu imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', height: 100),
                  const SizedBox(height: 20),
                  const Text(
                    'Bienvenido',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'User Name',
                    controller: emailController,
                  ),
                  const SizedBox(height: 32),
                  Dropdown(
                    label: 'Tipo',
                    selectedValue: _sTipo,
                    items: _tipo,
                    onChanged: (newValue) {
                      setState(() {
                        _sTipo = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    label: 'Password',
                    controller: passwordController,
                    obscure: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF23535),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: loading ? null : _login,
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Iniciar sesión',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF23535),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: loading ? null : _register,
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Registrarme',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
