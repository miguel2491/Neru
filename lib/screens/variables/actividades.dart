import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/screens/calendario.dart';
import 'package:neru/screens/entrenamiento.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/screens/progreso.dart';
import 'package:neru/screens/variables/ejercicio.dart';
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
  String nameVar = '';
  String iconVar = '';

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
    final actsUsr = await DBHelper.getUserActDB('1');
    final variableData = await DBHelper.getVariableById(widget.variable);
    final userActIds = actsUsr.map((act) => act['id']).toSet();

    if (variableData != null) {
      setState(() {
        nameVar = variableData['nombre'] ?? '';
        iconVar = variableData['icono'] ?? '';
      });
    }

    // Fusionamos: añadimos 'isSelected' para cada actividad
    final mergedActividades = actividades.map((item) {
      final isSelected = userActIds.contains(item['id']);
      return {...item, 'isSelected': isSelected};
    }).toList();
    print('🌋 $mergedActividades');
    setState(() {
      _actividades = mergedActividades;
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
        child: SafeArea(
          // evita que quede debajo de status bar / notch
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              // botón visible y centrado
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: ElevatedButton(
                  onPressed: () {
                    // tu acción
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // 🔹 Fondo transparente
                    shadowColor: Colors.transparent, // 🔹 Sin sombra
                    side: const BorderSide(
                      color: Colors.white, // 🔹 Color del borde
                      width: 2, // 🔹 Grosor del borde
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Ajusta al contenido
                    children: [
                      Image.asset(
                        iconVar.isNotEmpty
                            ? iconVar
                            : 'assets/iconos/i_autocon.png', // Cambia por tu imagen
                        width: 24,
                        height: 24,
                        color: Colors
                            .white, // 🔹 Pinta la imagen en blanco (si es PNG transparente)
                      ),
                      const SizedBox(width: 8), // Espacio entre imagen y texto
                      Text(
                        nameVar,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // LISTA: debe estar dentro de Expanded para que ocupe el espacio restante
              Expanded(
                child: _actividades.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        itemCount: _actividades.length,
                        itemBuilder: (context, index) {
                          final item = _actividades[index];
                          final isSelected = item['isSelected'] ?? false;

                          return InkWell(
                            onTap: !isSelected
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EjercicioScreen(
                                          ruta: item['ruta'],
                                          id: item['id'],
                                          ida: item['idvariable'],
                                          ide: item['id'],
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            child: Card(
                              color: !isSelected
                                  ? const Color(0xFF616161) // Gris si bloqueado
                                  : isSelected
                                  ? Color(0xFFff4000) // Color para seleccionado
                                  : const Color(
                                      0xFFFF4000,
                                    ), // Naranja si activo pero no seleccionado
                              child: ListTile(
                                title: Text(
                                  item['nombre']?.toString() ?? 'Sin nombre',
                                ),
                                textColor: Colors.white,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isSelected
                                        ? const FaIcon(
                                            FontAwesomeIcons.lockOpen,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                        : const FaIcon(
                                            FontAwesomeIcons.lock,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndexNav,
        onItemTapped: _onItemTappedNav,
      ),
    );
  }
}
