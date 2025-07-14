import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:neru/screens/login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();
  final passwordController = TextEditingController();
  final nombreController = TextEditingController();
  final appController = TextEditingController();
  final tokenController = TextEditingController();

  bool loading = false;

  Future<void> _register() async {
    final username = userController.text.trim();
    final email = emailController.text.trim();
    final telefono = telefonoController.text.trim();
    final password = passwordController.text;
    final nombre = nombreController.text.trim();
    final app = appController.text.trim();

    setState(() => loading = true);
    final url = Uri.parse(
      'https://gcconsultoresmexico.com/api/api.php?action=set_user',
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': username,
        'email': email,
        'telefono': telefono,
        'password': password,
        'nombre': nombre,
        'app': app,
        'token': '-',
        'direccion': '--',
        'rol': 'usuario',
        'estatus': 'PreActivo',
      }),
    );

    setState(() => loading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Se creo correctamente!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), // opcional, igual al delay
        ),
      );

      // Esperar 2 segundos antes de navegar
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    } else {
      _showError('Error del servidor (${response.statusCode})');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    userController.dispose();
    emailController.dispose();
    telefonoController.dispose();
    passwordController.dispose();
    nombreController.dispose();
    appController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
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
                  const SizedBox(height: 30),
                  const Text(
                    'Registrate',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Nombre de Usuario',
                    controller: userController,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Nombre',
                    controller: nombreController,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Apellidos',
                    controller: appController,
                  ),
                  const SizedBox(height: 20),
                  _buildEmail(
                    label: 'Correo Electronico',
                    controller: emailController,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Password',
                    controller: passwordController,
                    obscure: true,
                  ),
                  const SizedBox(height: 20),
                  _textNumber(
                    label: 'Teléfono',
                    controller: telefonoController,
                    onlyNumbers: true,
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
                            'GUARDAR',
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

  Widget _textNumber({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    bool onlyNumbers = false, // parámetro opcional
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: onlyNumbers ? TextInputType.number : TextInputType.text,
      inputFormatters: onlyNumbers
          ? [FilteringTextInputFormatter.digitsOnly]
          : [],
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

  Widget _buildEmail({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    bool onlyNumbers = false,
    bool isEmail = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : (onlyNumbers ? TextInputType.number : TextInputType.text),
      inputFormatters: onlyNumbers
          ? [FilteringTextInputFormatter.digitsOnly]
          : [],
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
