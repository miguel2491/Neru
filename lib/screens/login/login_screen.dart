import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neru/services/api.dart' as api_service;
import 'package:neru/services/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

      if (data is List && data.isNotEmpty) {
        final user = data[0];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_usuario', username);
        await prefs.setString('auth_nombre', user['nombre']);
        await prefs.setString('auth_rol', user['rol']);
        await prefs.setString('auth_token', user['token']);

        // 🔹 Ahora carga variables y actividades con el usuario ya guardado
        await _loadVariables();
        await _loadActividades();

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
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

  Future<void> _loadVariables() async {
    try {
      final variables = await api_service.fVariable();
      // Transforma Variable -> Map<String, dynamic>
      final variableMaps = variables.map((v) => v.toMap()).toList();
      await DBHelper.clearAndInsertVar(variableMaps);
    } catch (e) {
      print('⚠️ Error cargando variables: $e');
    }
  }

  Future<void> _loadActividades() async {
    try {
      final actividad = await api_service.fActividades();
      print('☠️ $actividad');
      final actividadesMap = actividad.map((v) => v.toMap()).toList();
      await DBHelper.clearAndInsertAct(actividadesMap);
    } catch (e) {
      print('⚠️ Error cargando variables: $e');
    }
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF00406a),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Alinea el título a la derecha
          children: [Text('NERU')],
        ),
      ),
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
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', height: 120),
                  const SizedBox(height: 20),
                  const Text(
                    'Bienvenido',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Correo electrónico',
                    controller: emailController,
                  ),
                  // const SizedBox(height: 32),
                  // Dropdown(
                  //   label: 'Tipo',
                  //   selectedValue: _sTipo,
                  //   items: _tipo,
                  //   onChanged: (newValue) {
                  //     setState(() {
                  //       _sTipo = newValue;
                  //     });
                  //   },
                  // ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    label: 'Contraseña',
                    controller: passwordController,
                    obscure: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFff4000),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Sin redondeo
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
                      backgroundColor: Color(0xFFff4000),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Sin redondeo
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
