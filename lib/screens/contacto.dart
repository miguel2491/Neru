import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/model/psicologos.dart';
import 'package:neru/services/api.dart' as api_service;
import 'package:neru/services/db_helper.dart';
import 'package:neru/widgets/bottom_nav.dart';
import 'package:neru/widgets/boton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacto extends StatefulWidget {
  const Contacto({super.key});

  @override
  State<Contacto> createState() => _ContactoState();
}

class _ContactoState extends State<Contacto> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final List<String?> _selections = [null, null, null];
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

  @override
  void initState() {
    super.initState();
    _loadPsicologos();
  }

  final List<Psicologo> perfiles = [];
  bool isLoading = true;

  Future<void> _loadPsicologos() async {
    try {
      final psicologos = await api_service.fPsicologos();
      setState(() {
        perfiles.clear();
        perfiles.addAll(psicologos);
        isLoading = false;
      });
    } catch (e) {
      print('⚠️ Error cargando variables: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadSelections() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Si no hay datos, devuelve null
      _selections[0] = prefs.getString('selection_0');
      _selections[1] = prefs.getString('selection_1');
      _selections[2] = prefs.getString('selection_2');
    });

    // Si quieres, puedes hacer algo si ya hay selecciones
    if (_selections.every((element) => element != null)) {
      // Por ejemplo: saltar el intro
      //Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> abrirWhatsApp() async {
    final Uri url = Uri.parse('https://wa.link/iy02th');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir WhatsApp';
    }
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
              child: Transform.translate(
                offset: const Offset(-30, 0), // 👈 mueve 10px a la izquierda
                child: FaIcon(
                  FontAwesomeIcons.phone,
                  color: Colors.white,
                  size: 20,
                ),
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        margin: const EdgeInsets.all(28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 8),
                            const Text(
                              "PSICOLOGOS",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 480,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PageView.builder(
                                controller: PageController(
                                  viewportFraction: 0.85,
                                ),
                                itemCount: perfiles.length,
                                itemBuilder: (context, index) {
                                  final perfil = perfiles[index];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip
                                          .none, // 🔥 permite salir del container
                                      children: [
                                        /// CARD
                                        Container(
                                          margin: const EdgeInsets.only(
                                            top: 45,
                                          ), // espacio para el avatar
                                          padding: const EdgeInsets.fromLTRB(
                                            20,
                                            60,
                                            20,
                                            20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF01406b),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                perfil.nombre,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),

                                              const SizedBox(height: 12),

                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: Text(
                                                    perfil.descripcion,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        /// AVATAR FLOTANTE
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: CircleAvatar(
                                              radius: 45,
                                              backgroundColor: Colors.white,
                                              backgroundImage: NetworkImage(
                                                perfil.imagenUrl,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),

                      const SizedBox(height: 2),
                      Center(
                        child: SizedBox(
                          width: 220, // el ancho que quieras
                          child: CustomActionButton(
                            label: 'Reserva una cita',
                            icon: const FaIcon(
                              FontAwesomeIcons.remove,
                              color: Colors.white,
                            ),
                            color: const Color(0xFFff4000),
                            onPressed: () {
                              abrirWhatsApp();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
