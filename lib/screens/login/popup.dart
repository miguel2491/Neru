import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:neru/screens/home_screen.dart';
import 'package:neru/widgets/boton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupScreen extends StatelessWidget {
  final int daysRemaining;

  const PopupScreen({super.key, required this.daysRemaining});
  void _openTerms(BuildContext context) {
    print("Abrir términos");
  }

  void _openPrivacy(BuildContext context) {
    print("Abrir privacidad");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF00406a),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Alinea el título a la derecha
          children: [Text('NERU')],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  "BIENVENIDO A",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Image.asset('assets/logo3.png', height: 80),
                const SizedBox(height: 40),

                Image.asset('assets/logo1.png', height: 120),

                const SizedBox(height: 40),

                const Text(
                  "TU PRUEBA GRATUITA COMIENZA HOY.",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                const Text(
                  "DISFRUTA DE 15 DÍAS DE ACCESO ILIMITADO A TODOS LOS AUDIOS DE LA APLICACIÓN.",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomActionButton(
                  label: 'ACEPTAR',
                  icon: FaIcon(
                    FontAwesomeIcons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                  color: const Color(0xFFff4000),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('bStatusUser', false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                ),
                const SizedBox(height: 50),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      decoration: TextDecoration.underline,
                    ),
                    children: [
                      TextSpan(
                        text: "Términos y Condiciones",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openTerms(context);
                          },
                      ),
                      const TextSpan(text: "   "),
                      TextSpan(
                        text: "Política de Privacidad",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openPrivacy(context);
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _benefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  void _startPurchase(BuildContext context) {
    // Aquí luego conectas in_app_purchase
    print("Iniciar compra");
  }
}
