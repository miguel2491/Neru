import 'package:flutter/material.dart';
import 'package:neru/widgets/audio.dart';
import 'package:neru/widgets/boton.dart';

class VariablesScreen extends StatefulWidget {
  const VariablesScreen({super.key});
  @override
  State<VariablesScreen> createState() => _VariablesScreenState();
}

class _VariablesScreenState extends State<VariablesScreen> {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: AudioPlayButton(
                  assetPath: 'audio/muscular.mp3',
                  label: 'Escuchar explicación',
                ),
              ),
              const SizedBox(height: 32),
              ..._buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    final buttons = [
      'Control de estrés y ansiedad',
      'Concentración',
      'Autoconfianza y seguridad',
      'Motivación',
      'Activación mental',
      'Control emocional',
      'Objetivos o metas',
    ];

    return buttons
        .map(
          (label) => Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: SizedBox(
              width: double.infinity,
              child: CustomActionButton(
                label: label,
                icon: Icons.show_chart,
                color: Colors.teal,
                onPressed: () {
                  Navigator.pushNamed(context, '/progreso');
                },
              ),
            ),
          ),
        )
        .toList();
  }
}
