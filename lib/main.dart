import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme_controller.dart';
import 'core/notification_service.dart';
import 'features/auth/splash_screen.dart';
import 'features/home/home_screen.dart';
import 'features/treino/treino_screen.dart';
import 'features/treino/detalhe_treino_screen.dart';
import 'features/chatbot/chatbot_screen.dart';
import 'features/amigos/amigos_screen.dart';
import 'features/nutricao/nutricao_screen.dart';
import 'features/perfil/perfil_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await ThemeController().init();
  runApp(const PatriqueApp());
}

class PatriqueApp extends StatefulWidget {
  const PatriqueApp({super.key});

  @override
  State<PatriqueApp> createState() => _PatriqueAppState();
}

class _PatriqueAppState extends State<PatriqueApp> {
  final _themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    _themeController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patrique Fitness',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeController.themeMode,
      home: const SplashScreen(),
    );
  }
}

final mainScreenKey = GlobalKey<MainScreenState>();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void trocarAba(int index) {
    setState(() => _currentIndex = index);
  }

  void irParaTreino({
    required String titulo,
    required Color cor,
    required List<Map<String, dynamic>> exercicios,
  }) {
    setState(() => _currentIndex = 1);
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalheTreinoScreen(
              titulo: titulo,
              cor: cor,
              exercicios: exercicios,
            ),
          ),
        );
      }
    });
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    TreinoScreen(),
    ChatbotScreen(),
    AmigosScreen(),
    NutricaoScreen(),
    PerfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_rounded), label: 'Treino'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded), label: 'Chatbot'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded), label: 'Amigos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_rounded), label: 'Nutrição'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}