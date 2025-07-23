import 'package:flutter/material.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/screens/progreso.dart';
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
        MaterialPageRoute(builder: (context) => const ProgresoScreen()),
      );
      return;
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      return;
    } else if (index == 3) {
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
        title: Text('Neru'),
        centerTitle: true,
        backgroundColor: Color(0xFFBF4141),
        foregroundColor: Colors.white,
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
                          color: const Color(0xFFBF4141),
                          url: 'audio/muscular.mp3',
                          label: 'Escuchar explicación',
                        ),
                      ),
                      const SizedBox(height: 32),
                      FutureBuilder<List<Widget>>(
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
                      const Spacer(), // empuja los elementos hacia arriba si hay espacio de sobra
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: SizedBox(
          width: double.infinity,
          child: CustomActionButton(
            label: label,
            icon: Icons.show_chart,
            color: const Color(0xFFBF4141),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EstresScreen(variable: idVar),
                ),
              );
            },
          ),
        ),
      );
    }).toList();
  }
}
