import 'package:flutter/material.dart';
import 'package:neru/screens/inicio/swipe_arrow.dart';

class SlidePage extends StatelessWidget {
  final String title;
  final String description;
  final bool showSwipeHint;
  final List<Widget>? actions;

  const SlidePage({
    super.key,
    required this.title,
    required this.description,
    this.showSwipeHint = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/fondo.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Mostrar botones si existen
                  if (actions != null) Column(children: actions!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
