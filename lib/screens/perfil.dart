import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:neru/screens/progreso.dart';
import 'package:neru/widgets/bottom_nav.dart';
import 'package:neru/widgets/divisor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final int _selectedIndex = 0;
  String? nombre;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VariablesScreen()),
      );
      return; // no cambies _selectedIndex si navegas
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProgresoScreen()),
      );
      return;
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    } else if (index == 3) {
      return;
    }
  }

  Future<void> _checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('auth_nombre');
    setState(() {
      nombre = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

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
            Text(
              'HOLA $nombre' ?? "Cargando",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 32),
            Text(
              "TE UNISTE EN 2025",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 32),
            CenteredDivider(title: 'ESTADÍSTICAS'),
            const SizedBox(height: 32),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.hourglass,
                color: Colors.white,
                size: 32,
              ),
              title: Text(
                'Minutos: $nombre',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Tiempo promedio de ejercicios',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.chartPie,
                color: Colors.white,
                size: 32,
              ),
              title: Text(
                'Minutos: $nombre',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Tiempo total de ejercicios',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.play,
                color: Colors.white,
                size: 32,
              ),
              title: Text(
                'Sesiones: $nombre',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Sesiones Terminadas',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
