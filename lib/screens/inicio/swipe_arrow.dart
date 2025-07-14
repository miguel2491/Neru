import 'package:flutter/material.dart';

class SwipeArrowHint extends StatefulWidget {
  const SwipeArrowHint({super.key});

  @override
  State<SwipeArrowHint> createState() => _SwipeArrowHintState();
}

class _SwipeArrowHintState extends State<SwipeArrowHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.2, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 4),
    );
  }
}
