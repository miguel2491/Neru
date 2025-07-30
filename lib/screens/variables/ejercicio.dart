import 'package:flutter/material.dart';
import 'package:neru/screens/calendario.dart';
import 'package:neru/screens/entrenamiento.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/screens/variables/actividades.dart';
import 'package:neru/services/db_helper.dart';
import 'package:neru/widgets/audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EjercicioScreen extends StatefulWidget {
  final String ruta;
  final int id;
  final int ida;
  final int ide;

  const EjercicioScreen({
    super.key,
    required this.ruta,
    required this.id,
    required this.ida,
    required this.ide,
  });
  @override
  State<EjercicioScreen> createState() => _EjercicioScreenState();
}

class _EjercicioScreenState extends State<EjercicioScreen> {
  final int _selectedIndex = 0;
  String? usuario;

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
        MaterialPageRoute(builder: (context) => const CalendarioScreen()),
      );
      return;
    } else if (index == 2) {
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

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('auth_nombre');
    print('☠️👻${widget.id}');
    final usuarioAct = await DBHelper.getActUsrDB(widget.ide);
    if (usuarioAct.isNotEmpty) {
      if (usuarioAct.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Éxito'),
            content: Text('Actividad YA realizada correctamente'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ActividadesScreen(variable: widget.ida),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
    setState(() {});
  }

  Future<void> _check() async {
    final actividades = await DBHelper.getUserActDB('1');
    print('⌛🔓 $actividades');
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Neru Ejercicio'),
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
        child: Column(
          children: [
            const SizedBox(height: 150),
            // Fila 1
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AudioPlayButton(
                  color: const Color(0xFFBF4141),
                  url: 'https://gcconsultoresmexico.com/audios/${widget.ruta}',
                  label: 'Escuchar explicación',
                ),
              ],
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          //final successMap = actividad.map((v) => v.toMap()).toList();
                          final result = await DBHelper.clearAndInsertUserAct([
                            {
                              'idusuario': usuario,
                              'idactividad': widget.ida,
                              'idejercicio': widget.id,
                              'estatus': '1',
                              'fca_creacion': DateTime.now().toIso8601String(),
                            },
                          ]);
                          if (result > 0) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Éxito'),
                                content: Text(
                                  'Actividad Realizada correctamente',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ActividadesScreen(
                                                variable: widget.ida,
                                              ),
                                        ),
                                      ),
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                  'No se pudo guardar la actividad',
                                ),
                              ),
                            );
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) =>
                          //         ActividadesScreen(variable: widget.id),
                          //   ),
                          // );
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Presiona para Finalizar la Actividad",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
