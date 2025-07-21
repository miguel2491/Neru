import 'package:flutter/material.dart';
import 'package:neru/screens/calendario.dart';
import 'package:neru/screens/entrenamiento.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/screens/progreso.dart';
import 'package:neru/screens/variables/actividades.dart';

class EstresScreen extends StatefulWidget {
  final int variable;

  const EstresScreen({super.key, required this.variable});
  @override
  State<EstresScreen> createState() => _EstresScreenState();
}

class _EstresScreenState extends State<EstresScreen> {
  final int _selectedIndex = 0;

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, String> imageMap = {
      1: 'assets/variables/Estres.jpg',
      2: 'assets/variables/Concentracion.jpg',
      3: 'assets/variables/Autoconfianza.jpg',
      4: 'assets/variables/motivacion.jpg',
      5: 'assets/variables/Activacion.jpg',
      6: 'assets/variables/emocional.jpg',
      7: 'assets/variables/Objetivo.jpg',
    };

    final String? imagePath = imageMap[widget.variable];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActividadesScreen(variable: widget.variable),
            ),
          );
        },
        child: const Icon(Icons.arrow_circle_right),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath ?? 'assets/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Agrega más contenido aquí si quieres
          ],
        ),
      ),
    );
  }
}
