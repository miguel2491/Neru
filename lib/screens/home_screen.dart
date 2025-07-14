import 'package:flutter/material.dart';
import 'package:neru/screens/calendario.dart';
import 'package:neru/screens/entrenamiento.dart';
import 'package:neru/screens/inicio/intro_psic.dart';
import 'package:neru/screens/inicio/intro_slider.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/screens/progreso.dart';
import '../widgets/app_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/widgets/boton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EntrenamientoScreen()),
      );
      return; // no cambies _selectedIndex si navegas
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProgresoScreen()),
      );
      return;
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CalendarioScreen()),
      );
      return;
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PerfilScreen()),
      );
      return;
    }
    // setState(() {
    //   _selectedIndex = index;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neru'),
        centerTitle: true,
        backgroundColor: Color(0xFFBF4141),
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
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
            const SizedBox(height: 40),
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 16),
            const Text(
              "Bienvenido",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: '¿Que es la psicología del deporte?',
              icon: Icons.show_chart,
              color: Colors.teal,
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
              color: Colors.teal,
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
              color: Colors.teal,
              onPressed: () {
                Navigator.pushNamed(context, '/progreso');
              },
            ),
            const SizedBox(height: 32),
            CustomActionButton(
              label: 'Chat IA',
              icon: Icons.show_chart,
              color: Colors.teal,
              onPressed: () {
                Navigator.pushNamed(context, '/progreso');
              },
            ),
            const SizedBox(height: 32),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFBF4141),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.brain),
            label: 'Entreno',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.chartPie),
            label: 'Progreso',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
