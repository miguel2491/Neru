import 'package:flutter/material.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil 🧘"),
        centerTitle: true,
        backgroundColor: Color(0xFFBF4141),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 16),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/fondo.png',
            ), // Aquí pones tu imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              "Desarrolla tu mente, una habilidad por semana.",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
