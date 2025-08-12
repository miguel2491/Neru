import 'package:flutter/material.dart';

class IconRadioGroup extends StatefulWidget {
  const IconRadioGroup({super.key});

  @override
  State<IconRadioGroup> createState() => _IconRadioGroupState();
}

class _IconRadioGroupState extends State<IconRadioGroup> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> options = [
    {"image": "assets/iconos/i_futbol.png", "label": "Futbol"},
    {"image": "assets/iconos/i_natacion.png", "label": "Natación"},
    {"image": "assets/iconos/i_voleibol.png", "label": "Voleibol"},
    {"image": "assets/iconos/i_tae.png", "label": "TaeKwondo"},
    {"image": "assets/iconos/i_baloncesto.png", "label": "Baloncesto"},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: List.generate(options.length, (index) {
        final isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Color(0xFFff4000) : Colors.white54,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(options[index]["image"], width: 40, height: 40),
                const SizedBox(height: 4),
                Text(
                  options[index]["label"],
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
