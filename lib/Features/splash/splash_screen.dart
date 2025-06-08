import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Tosell/core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _topCircleOffset;
  late Animation<Offset> _bottomCircleOffset;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _topCircleOffset = Tween<Offset>(
      begin: const Offset(-1.5, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _bottomCircleOffset = Tween<Offset>(
      begin: const Offset(1.5, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      GoRouter.of(context)
          .go(initialLocation); // replace with your initial route
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildCircle({
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(24, 55, 38, 82),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF16CA8B), Color(0xFF109365)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Top circle animation
          Positioned(
            top: -600,
            right: -300,
            child: SlideTransition(
              position: _topCircleOffset,
              child: buildCircle(
                height: size.height * 1.4,
                width: size.width * 1.4,
              ),
            ),
          ),

          // Bottom circle animation
          Positioned(
            bottom: -600,
            left: -300,
            child: SlideTransition(
              position: _bottomCircleOffset,
              child: buildCircle(
                height: size.height * 1.4,
                width: size.width * 1.4,
              ),
            ),
          ),

          // Logo fade animation
          Positioned(
            top: size.height * 0.35,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _logoOpacity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/svg/Group.svg",
                    width: size.width * 0.3,
                    height: size.height * 0.15,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    "assets/images/Name.png",
                    width: size.width * 0.4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
