import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:neru/services/db_helper.dart';
import 'package:neru/widgets/bottom_nav.dart';
import 'package:neru/widgets/divisor.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final int _selectedIndex = 0;
  String? nombre;
  double progreso = 0.0;

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

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('auth_nombre');
    final usuarioAct = await DBHelper.getUserActDB(user!);
    final activTotal = await DBHelper.getActividadesDB();

    if (usuarioAct.isEmpty) {
      print('❌ No hay Actividades guardadas');
    } else {
      print('📊 Total de registros: ${usuarioAct.length}');
      print('🚕 Total de registros: ${activTotal.length}');
      final promedio = usuarioAct.length / activTotal.length;
      final promedioR = promedio.toStringAsFixed(2);
      print('📈 Promedio: $promedioR');
      print('🎈 Progreso: ${(promedio * 100).toStringAsFixed(2)}%');
      progreso = promedio;
      setState(() {
        progreso = promedio;
      });
      for (var user in usuarioAct) {
        print(
          '📦 Variable: ${user['id']} | ${user['idusuario']} | ${user['idactividad']} | ${user['estatus']} | ${user['fca_creacion']}',
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkStatus();
    //_checkLoginStatus();
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
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  "Desarrolla tu mente, una habilidad por semana.",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 32),
                Text(
                  'HOLA $nombre',
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
                const SizedBox(height: 24),
                Center(
                  child: CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 12.0,
                    percent: progreso,
                    center: Text(
                      "${(progreso * 100).toInt()}%",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    progressColor: Colors.redAccent,
                    backgroundColor: Colors.white24,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                  ),
                ),
                const SizedBox(height: 32),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
