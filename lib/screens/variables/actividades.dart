import 'package:flutter/material.dart';
import 'package:neru/screens/calendario.dart';
import 'package:neru/screens/entrenamiento.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/screens/progreso.dart';
import 'package:neru/screens/variables/ejercicio.dart';
import 'package:neru/services/api.dart' as api_services;
import 'package:neru/services/db_helper.dart';
import 'package:neru/widgets/bottom_nav.dart';

class ActividadesScreen extends StatefulWidget {
  final int variable;
  const ActividadesScreen({super.key, required this.variable});
  @override
  State<ActividadesScreen> createState() => _ActividadesScreenState();
}

class _ActividadesScreenState extends State<ActividadesScreen> {
  final int _selectedIndexNav = 0;
  final int _selectedIndex = 0;

  void _onItemTappedNav(int index) {
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

  List<Map<String, dynamic>> _actividades = [];

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
    _loadActividades();
  }

  Future<void> _loadActividades() async {
    final actividades = await DBHelper.getActividadesByVariableId(
      widget.variable,
    );
    print('👻🌋 $actividades');
    setState(() {
      _actividades = actividades;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> imageMap = {
      'Control de estrés y ansiedad': 'Estres',
      'Concentración': 'Concentracion',
      'Autoconfianza y seguridad': 'Autoconfianza',
      'Motivación': 'motivacion',
      'Activación mental': 'Activacion',
      'Control emocional': 'emocional',
      'Objetivos o metas': 'Objetivo',
    };
    final String? variable_ = imageMap[widget.variable];
    return Scaffold(
      appBar: AppBar(
        title: Text('Neru Actividad'),
        centerTitle: true,
        backgroundColor: Color(0xFFBF4141),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: _actividades.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _actividades.length,
                itemBuilder: (context, index) {
                  final actividad = _actividades[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFBF4141,
                        ), // 🎨 color del botón
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EjercicioScreen(
                              ruta: actividad['ruta'],
                              id: actividad['id'],
                              ida: actividad['idvariable'],
                              ide: actividad['id'],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        actividad['nombre'] ?? 'Sin nombre',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndexNav,
        onItemTapped: _onItemTappedNav,
      ),
    );
  }
}
