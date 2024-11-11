import 'package:flutter/material.dart';
import 'dart:math';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({super.key});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  final double distance = 100.0; // 버튼들이 퍼져나가는 거리

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter, // 화면 하단 중앙에 고정
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0), // 하단 여백
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (_isExpanded)
              Stack(
                alignment: Alignment.bottomCenter,
                children: _buildSemiCircleButtons(),
              ),
            FloatingActionButton(
              onPressed: _toggle,
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animation,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSemiCircleButtons() {
    final baseAngles = [180, 135, 90, 45]; // 반원을 위한 각도
    final icons = [
      Icons.message,
      Icons.photo,
      Icons.location_on,
      Icons.videocam,
    ];
    final tooltips = [
      "메시지",
      "사진",
      "위치",
      "비디오",
    ];

    return List<Widget>.generate(baseAngles.length, (index) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final rad = baseAngles[index] * pi / 180;
          final x = distance * cos(rad) * _animation.value;
          final y = -distance * sin(rad) * _animation.value;
          return Transform.translate(
            offset: Offset(x, y),
            child: child,
          );
        },
        child: FloatingActionButton(
          mini: true,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${tooltips[index]} 버튼 눌림")),
            );
          },
          tooltip: tooltips[index],
          child: Icon(icons[index]),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
