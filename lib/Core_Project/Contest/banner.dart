import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:competitivecodingarena/Core_Project/Contest/featured.dart';

class ScreenBannerAndFeatured extends StatefulWidget {
  final Size size;
  const ScreenBannerAndFeatured({required this.size, super.key});

  @override
  State<ScreenBannerAndFeatured> createState() => _ScreenBannerAndFeatured();
}

class _ScreenBannerAndFeatured extends State<ScreenBannerAndFeatured>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Container(
          width: widget.size.width,
          height: widget.size.height * 0.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.amber.shade700,
                Colors.blue.shade800,
                Colors.amber.shade700,
              ],
            ),
          ),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => Positioned(
                  top: -50 + 30 * math.sin(_controller.value * 2 * math.pi),
                  right: -50 + 30 * math.cos(_controller.value * 2 * math.pi),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => Positioned(
                  bottom: -100 + 40 * math.cos(_controller.value * 2 * math.pi),
                  left: -100 + 40 * math.sin(_controller.value * 2 * math.pi),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(
                            0, 15 * math.sin(_controller.value * 2 * math.pi)),
                        child: Transform.rotate(
                          angle:
                              0.05 * math.sin(_controller.value * 4 * math.pi),
                          child: child,
                        ),
                      ),
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (_, child) => Transform.scale(
                          scale: 1 + 0.05 * _pulseController.value,
                          child: child,
                        ),
                        child: Hero(
                          tag: 'trophy',
                          child: Icon(
                            Icons.emoji_events_outlined,
                            size: widget.size.height * 0.25,
                            color: Colors.amber.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, child) => Transform.scale(
                        scale: 1 + 0.03 * _pulseController.value,
                        child: child,
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Competitive Coding Arena",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: " Contest",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Compete weekly. Rise in the rankings!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        FeaturedContest(size: widget.size)
      ],
    );
  }
}
