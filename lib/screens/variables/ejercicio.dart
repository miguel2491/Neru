import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool _actividadYaRealizada = false;

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
    final usuarioAct = await DBHelper.getActUsrDB(widget.ide + 1);
    if (usuarioAct.isNotEmpty) {
      setState(() {
        _actividadYaRealizada = usuarioAct.isNotEmpty; // 👈 true si ya existe
      });
      // if (usuarioAct.isNotEmpty) {
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text('Éxito'),
      //       content: Text('Actividad YA realizada correctamente'),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) =>
      //                     ActividadesScreen(variable: widget.ida),
      //               ),
      //             );
      //           },
      //           child: Text('OK'),
      //         ),
      //       ],
      //     ),
      //   );
      // }
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
        backgroundColor: Color(0xFF00406a),
        foregroundColor: Colors.white,
        title: Stack(
          children: [
            // 🔹 Ícono centrado
            Align(
              alignment: Alignment.center,
              child: FaIcon(
                FontAwesomeIcons.brain,
                color: Colors.white,
                size: 20,
              ),
            ),
            // 🔹 Texto alineado a la derecha
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'NERU',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
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
                  color: const Color(0xFFff4000),
                  url: 'https://gcconsultoresmexico.com/audios/${widget.ruta}',
                  label: 'Escuchar explicación',
                ),
              ],
            ),
            const SizedBox(height: 80),
            if (!_actividadYaRealizada)
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
                            final result = await DBHelper.clearAndInsertUserAct(
                              [
                                {
                                  'idusuario': usuario,
                                  'idactividad': widget.ida,
                                  'idejercicio': widget.id + 1,
                                  'estatus': '1',
                                  'fca_creacion': DateTime.now()
                                      .toIso8601String(),
                                },
                              ],
                            );
                            if (result > 0) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Color(
                                    0xFF00406a,
                                  ), // 👈 color del fondo del modal
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                    'Éxito',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          Colors.white, // 👈 color del título
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          backgroundColor: Color(0xFFff4000),
                                          color: Colors
                                              .white, // 👈 color del botón
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
