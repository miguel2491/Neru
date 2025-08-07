import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:neru/screens/login/login_screen.dart';
import 'package:neru/services/db_helper.dart';
import 'package:neru/widgets/boton.dart';
import 'package:neru/widgets/bottom_nav.dart';
import 'package:neru/widgets/divisor.dart';
import 'package:percent_indicator/percent_indicator.dart';

// 🔹 Asegúrate de tener tus clases DBHelper, LoginScreen, CustomActionButton, CenteredDivider ya creadas

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final int _selectedIndex = 2;
  String nombre = "Usuario"; // 🔹 Aquí pones el nombre dinámico
  double progreso = 0.65; // 🔹 Entre 0.0 y 1.0
  final List<String> etiquetas = ["Éstres", "AutoConfianza", "Concentración"];

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
                FontAwesomeIcons.user,
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Text(
                    "Desarrolla tu mente, una habilidad por semana.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'HOLA $nombre',
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'Te Uniste en  2025',
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
                Center(
                  child: Text(
                    'FUTBOL',
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 32),
                const CenteredDivider(title: 'ESTADÍSTICAS'),
                const SizedBox(height: 32),

                // 🔹 Tarjeta 1
                ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.hourglass,
                    color: Colors.white,
                    size: 32,
                  ),
                  title: Text(
                    'Minutos: $nombre',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Tiempo promedio de ejercicios',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: 24),

                // 🔹 Tarjeta 2
                ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.chartPie,
                    color: Colors.white,
                    size: 32,
                  ),
                  title: Text(
                    'Minutos: $nombre',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Tiempo total de ejercicios',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: 24),

                // 🔹 Tarjeta 3
                ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.play,
                    color: Colors.white,
                    size: 32,
                  ),
                  title: Text(
                    'Sesiones: $nombre',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Sesiones Terminadas',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const SizedBox(height: 24),

                // 🔹 Indicador circular
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
                // 🔹 Gráfica con tamaño fijo para evitar overflow
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: SizedBox(
                //     height: 320,
                //     width: etiquetas.length * 180,
                //     child: Container(
                //       padding: const EdgeInsets.all(18),
                //       decoration: BoxDecoration(
                //         color: Colors.white, // Fondo blanco
                //         borderRadius: BorderRadius.circular(
                //           12,
                //         ), // Bordes redondeados opcional
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black26,
                //             blurRadius: 6,
                //             offset: Offset(0, 3),
                //           ),
                //         ],
                //       ),
                //       child: BarChart(
                //         BarChartData(
                //           gridData: FlGridData(show: true),
                //           titlesData: FlTitlesData(
                //             topTitles: AxisTitles(
                //               sideTitles: SideTitles(showTitles: false),
                //             ),
                //             rightTitles: AxisTitles(
                //               sideTitles: SideTitles(showTitles: false),
                //             ),
                //             bottomTitles: AxisTitles(
                //               sideTitles: SideTitles(
                //                 showTitles: true,
                //                 getTitlesWidget: (value, meta) {
                //                   // 🔹 Lista de nombres según el índice
                //                   if (value.toInt() >= 0 &&
                //                       value.toInt() < etiquetas.length) {
                //                     return Padding(
                //                       padding: const EdgeInsets.only(top: 8.0),
                //                       child: Text(
                //                         etiquetas[value.toInt()],
                //                         style: const TextStyle(
                //                           color: Colors.black,
                //                           fontSize: 12,
                //                           fontWeight: FontWeight.bold,
                //                         ),
                //                       ),
                //                     );
                //                   }
                //                   return const SizedBox();
                //                 },
                //               ),
                //             ),
                //           ),
                //           borderData: FlBorderData(show: true),
                //           barGroups: List.generate(
                //             etiquetas.length,
                //             (index) => BarChartGroupData(
                //               x: index,
                //               barRods: [
                //                 BarChartRodData(
                //                   toY:
                //                       (index + 1) *
                //                       1.5, // 🔹 Ejemplo de valor dinámico
                //                   color: Colors.blue,
                //                   width: 16,
                //                   borderRadius: BorderRadius.circular(4),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ), // 🔹 Botón de cerrar sesión
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ESTRÉS',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.4, // 40%
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(0xFFBF4141),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('40%', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CONCENTRACIÓN',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.8, // 40%
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(0xFFBF4141),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('40%', style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 32),
                CustomActionButton(
                  label: 'Cerrar Sesión',
                  icon: FaIcon(FontAwesomeIcons.close, color: Colors.white),
                  color: const Color(0xFFff4000),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Cerrar sesión"),
                          content: const Text("¿Desea cerrar sesión?"),
                          actions: [
                            TextButton(
                              child: const Text("Cancelar"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: const Text("Sí, salir"),
                              onPressed: () async {
                                await DBHelper.borrarTablasLocales();
                                if (mounted) {
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
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
