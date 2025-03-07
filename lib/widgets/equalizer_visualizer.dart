import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class EqualizerVisualizer extends StatefulWidget {
  final bool isPlaying;

  const EqualizerVisualizer({super.key, required this.isPlaying});

  @override
  State<EqualizerVisualizer> createState() => _EqualizerVisualizerState();
}

class _EqualizerVisualizerState extends State<EqualizerVisualizer> {
  final Random _random = Random();
  late List<double> barHeights;
  late Timer _timer;
  int _waveOffset = 0; // To track horizontal movement

  @override
  void initState() {
    super.initState();
    // Initialize bar heights
    barHeights = List.generate(20, (_) => 10.0);

    // Initialize a dummy timer to avoid errors
    _timer = Timer(Duration.zero, () {});

    // Start the wave animation
    _startAnimation();
  }

  @override
  void didUpdateWidget(covariant EqualizerVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _timer.cancel(); // Cancel previous timer safely

    if (widget.isPlaying) {
      // Update the wave every 100ms for smooth motion
      _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() {
          // Generate dynamic heights for the wave effect
          barHeights = List.generate(
            20,
            (index) => _random.nextDouble() * (index.isEven ? 60 : 40) + 20,
          );
          // Move the wave to the right (looping effect)
          _waveOffset = (_waveOffset + 1) % 20;
        });
      });
    } else {
      // Reset bar heights when not playing
      setState(() {
        barHeights = List.generate(20, (_) => 10.0);
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Clean up the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity, // Full width
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(20, (index) {
          // Circular movement: (index + offset) % length
          int movingIndex = (_waveOffset + index) % 20;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: barHeights[movingIndex], // Dynamic height from wave
            width: MediaQuery.of(context).size.width / 40, // Adaptive width
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade400, // Base color
                  Colors.white, // Highlight color
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }),
      ),
    );
  }
}
