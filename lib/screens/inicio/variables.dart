import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/screens/variables/estres.dart';
import 'package:neru/services/api.dart' as api_services;
import 'package:neru/services/db_helper.dart';
import 'package:neru/widgets/audio.dart';
import 'package:neru/widgets/boton.dart';
import 'package:neru/widgets/bottom_nav.dart';

class VariablesScreen extends StatefulWidget {
  const VariablesScreen({super.key});
  @override
  State<VariablesScreen> createState() => _VariablesScreenState();
}

class _VariablesScreenState extends State<VariablesScreen> {
  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
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
    api_services.mVariablesLocales();
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  // Esto asegura que Column se estire
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: AudioPlayButton(
                          color: const Color(0xFFff4000),
                          url:
                              'https://gcconsultoresmexico.com/audios/mi_pem.mp3',
                          label: 'Mi PEM',
                        ),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: FutureBuilder<List<Widget>>(
                          future: _buildButtons(context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            final buttons = snapshot.data ?? [];

                            return Column(children: buttons);
                          },
                        ),
                      ),
                      const Spacer(),
                      // empuja los elementos hacia arriba si hay espacio de sobra
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Future<List<Widget>> _buildButtons(BuildContext context) async {
    final variables = await DBHelper.getVariablesDB();
    return variables.map<Widget>((v) {
      final idVar = v['id'];
      final label = v['nombre'];
      final icono = v['icono'];
      return Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: SizedBox(
          width: double.infinity,
          child: CustomActionButton(
            label: label,
            icon: Image.asset(
              icono,
              width: 24,
              height: 24,
              color: Colors
                  .white, // opcional, si la imagen es un ícono PNG blanco y negro
            ),
            color: const Color(0xFFff4000),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EstresScreen(variable: idVar, t_icono: icono),
                ),
              );
            },
          ),
        ),
      );
    }).toList();
  }
}
