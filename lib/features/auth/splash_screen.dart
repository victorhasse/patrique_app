import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_transitions.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isDark = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _carregarTemaENavegar();
  }

  Future<void> _carregarTemaENavegar() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('tema_escuro') ?? true;

    if (mounted) {
      setState(() => _isDark = isDark);
    }

    _controller.forward();

    await Future.delayed(const Duration(milliseconds: 2800));

    if (!mounted) return;

    final jaViuOnboarding = prefs.getBool('onboarding_concluido') ?? false;

    Navigator.pushReplacement(
      context,
      AppTransitions.fadeScale(
        jaViuOnboarding ? const LoginScreen() : const OnboardingScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDark ? const Color(0xFF111217) : Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                _isDark
                    ? 'assets/images/marca_fundo_transparente.png'
                    : 'assets/images/marca_fundo_branco.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}