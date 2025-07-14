import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgresoScreen extends StatefulWidget {
  const ProgresoScreen({super.key});

  @override
  _ProgresoScreenState createState() => _ProgresoScreenState();
}

class _ProgresoScreenState extends State<ProgresoScreen> {
  double progreso = 0.0;

  void aumentarProgreso() {
    setState(() {
      if (progreso < 1.0) {
        progreso += 0.1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progreso 📈"),
        centerTitle: true,
        backgroundColor: const Color(0xFFBF4141),
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              "Desarrolla tu mente, una habilidad por semana.",
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Circular progress
            CircularPercentIndicator(
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

            const SizedBox(height: 32),

            // Linear progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: LinearPercentIndicator(
                lineHeight: 20.0,
                percent: progreso,
                center: Text(
                  "${(progreso * 100).toInt()}%",
                  style: const TextStyle(color: Colors.white),
                ),
                progressColor: Colors.redAccent,
                backgroundColor: Colors.white30,
                animation: true,
                barRadius: const Radius.circular(16),
              ),
            ),

            const SizedBox(height: 32),

            // Button to increase progress
            ElevatedButton.icon(
              onPressed: aumentarProgreso,
              icon: const Icon(Icons.arrow_upward),
              label: const Text("Aumentar progreso"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
