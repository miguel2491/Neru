import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/screens/inicio/slide_page.dart';
import 'package:neru/screens/inicio/variables.dart';
import 'package:neru/screens/perfil.dart';
import 'package:neru/widgets/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({super.key});

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
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
    _loadSelections();
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

  Future<void> _saveSelection(int index, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selection_$index', value);

    setState(() {
      _selections[index] = value;
    });

    print('Selección guardada en página $index: $value');
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });

    if (index == 2) {
      // última página
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/home');
        print("Todas las selecciones: $_selections");
      });
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
        child: Stack(
          children: [
            // 🔹 PageView ocupa toda la pantalla
            PageView(
              controller: _controller,
              onPageChanged: _onPageChanged,
              children: [
                SlidePage(
                  title: "Bienvenido",
                  description:
                      "Elige la primera variable con la que quieres empezar",
                  showSwipeHint: true,
                  actions: [
                    ElevatedButton(
                      onPressed: () => _saveSelection(0, "Concentración"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFff4000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/iconos/i_con.png', // 👈 Ruta a tu imagen local
                            height: 30,
                            width: 30,
                            color: Colors
                                .white, // opcional, útil si es un ícono blanco y negro
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Concentración",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SlidePage(
                  title: "🔓",
                  description:
                      "🔓\nFinaliza tu actividad para desbloquear nuevas actividades",
                  showSwipeHint: true,
                  actions: [
                    ElevatedButton(
                      onPressed: () => _saveSelection(1, "RELAJACIÓN 1"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFff4000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // Ajusta el tamaño al contenido
                        children: const [
                          // Ícono a la izquierda
                          SizedBox(width: 8), // Espacio entre ícono y texto
                          Text(
                            "RELAJACIÓN 1",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    ElevatedButton(
                      onPressed: () => _saveSelection(1, "RELAJACIÓN 1"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF616161),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // Ajusta el tamaño al contenido
                        children: const [
                          // Ícono a la izquierda
                          SizedBox(width: 8), // Espacio entre ícono y texto
                          Text(
                            "RELAJACIÓN 2",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Icon(Icons.lock_open, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    ElevatedButton(
                      onPressed: () => _saveSelection(3, "RELAJACIÓN 3"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF616161),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // Ajusta el tamaño al contenido
                        children: const [
                          // Ícono a la izquierda
                          SizedBox(width: 8), // Espacio entre ícono y texto
                          Text(
                            "RELAJACIÓN 3",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Icon(Icons.lock_open, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
                SlidePage(
                  title: "📈",
                  description:
                      "Trabaja una variable durante mínimo 7 días para mejores resultados",
                  showSwipeHint: false,
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        _saveSelection(4, "Listo");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VariablesScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFff4000),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("EMPEZAR"),
                    ),
                  ],
                ),
              ],
            ),

            // 🔹 Indicador flotando al fondo
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Color(0xFFff4000),
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                  onDotClicked: (index) => _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
