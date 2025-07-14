import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const CustomActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = Colors.redAccent,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320, // 🔹 Ancho fijo aquí dentro del build
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
        label: Text(label, style: TextStyle(fontSize: 16, color: textColor)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
