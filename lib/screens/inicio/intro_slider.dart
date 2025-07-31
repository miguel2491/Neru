import 'package:flutter/material.dart';
import 'package:neru/screens/inicio/slide_page.dart';
import 'package:neru/screens/inicio/variables.dart';
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
                      "Elige la primera variable con la que quieres empezar y tu primera actividad",
                  showSwipeHint: true,
                  actions: [
                    ElevatedButton(
                      onPressed: () => _saveSelection(0, "Concentración"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBF4141),
                      ),
                      child: const Text(
                        "Concentración",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _saveSelection(1, "Motivación"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBF4141),
                      ),
                      child: const Text(
                        "Motivación",
                        style: TextStyle(color: Colors.white),
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
                      onPressed: () => _saveSelection(2, "Aceptado"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBF4141),
                      ),
                      child: const Text(
                        "Aceptar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SlidePage(
                  title: "📈",
                  description:
                      "Haz cada actividad durante 7 días para mejores resultados",
                  showSwipeHint: false,
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        _saveSelection(2, "Listo");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VariablesScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBF4141),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Empezar"),
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
                    activeDotColor: Color(0xFFBF4141),
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
    );
  }
}
