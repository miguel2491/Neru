import 'package:flutter/material.dart';
import 'package:neru/screens/inicio/intro_psic.dart';
import 'package:neru/screens/inicio/intro_slider.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/screens/progreso.dart';
import 'package:neru/widgets/bottom_nav.dart';
//import '../widgets/app_drawer.dart';
import 'package:neru/widgets/boton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;

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
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PerfilScreen()),
      );
      return;
    }
  }

  final List<Widget> _pages = [
    Center(
      child: Text("", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Progreso", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Home", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Calendario", style: TextStyle(color: Colors.white)),
    ),
    Center(
      child: Text("Perfil", style: TextStyle(color: Colors.white)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NERU'),
        centerTitle: true,
        backgroundColor: Color(0xFFBF4141),
        foregroundColor: Colors.white,
      ),
      // drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          print('FAB presionado');
          // Puedes navegar a otra pantalla si quieres
          // Navigator.push(context, MaterialPageRoute(builder: (_) => OtraPantalla()));
        },
        child: const Icon(Icons.help),
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
            const SizedBox(height: 10),
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 4),
            const Text(
              "Bienvenido",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Monserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: '¿Que es la psicología del deporte?',
              icon: Icons.show_chart,
              color: const Color(0xFFBF4141),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IntroScreen()),
                );
              },
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: 'Iniciar Entrenamiento mental',
              icon: Icons.show_chart,
              color: const Color(0xFFBF4141),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IntroSlider()),
                );
              },
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: 'Contacta un psicologo en el deporte',
              icon: Icons.show_chart,
              color: const Color(0xFFBF4141),
              onPressed: () {
                Navigator.pushNamed(context, '/progreso');
              },
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: 'Chat IA (Próximamente)',
              icon: Icons.show_chart,
              color: const Color(0xFFBF4141),
              onPressed: () {
                //Navigator.pushNamed(context, '/progreso');
              },
            ),
            const SizedBox(height: 32),
            Expanded(child: _pages[_selectedIndex]),
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
