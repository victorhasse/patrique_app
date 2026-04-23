import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme_controller.dart';
import 'features/auth/splash_screen.dart';
import 'features/home/home_screen.dart';
import 'features/treino/treino_screen.dart';
import 'features/chatbot/chatbot_screen.dart';
import 'features/perfil/perfil_screen.dart';
import 'core/notification_service.dart';
import 'features/amigos/amigos_screen.dart';
import 'features/nutricao/nutricao_screen.dart';

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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

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
              icon: Icon(Icons.group_rounded), label: 'Amigos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department_rounded), label: 'Nutrição'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Perfil'),
        ],
      ),
    );
  }
}