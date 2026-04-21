import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_transitions.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _paginaAtual = 0;

  final List<Map<String, dynamic>> _paginas = [
    {
      'emoji': '💪',
      'titulo': 'Seus treinos,\nsua evolução.',
      'descricao':
          'Monte e acompanhe seus treinos de forma simples e eficiente. Tudo organizado em um só lugar.',
      'cor': AppTheme.primary,
    },
    {
      'emoji': '🔥',
      'titulo': 'Mantenha\nseu streak!',
      'descricao':
          'Treine todos os dias e veja sua sequência crescer. Acompanhe seu progresso e mantenha a motivação lá em cima.',
      'cor': Color(0xFFFF6B35),
    },
    {
      'emoji': '🤖',
      'titulo': 'Tire dúvidas\ncom o bot.',
      'descricao':
          'O PatriqueBot responde suas dúvidas sobre treino, nutrição e recuperação a qualquer hora.',
      'cor': Color(0xFF7C3AED),
    },
    {
      'emoji': '🏆',
      'titulo': 'Comece agora\nde graça!',
      'descricao':
          'Experimente grátis e descubra como a Patrique Fitness pode transformar sua rotina.',
      'cor': Color(0xFF059669),
    },
  ];

  void _proximaPagina() {
    if (_paginaAtual < _paginas.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _irParaLogin();
    }
  }

  Future<void> _irParaLogin() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_concluido', true);
    
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      AppTransitions.fadeScale(const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagina = _paginas[_paginaAtual];
    final cor = pagina['cor'] as Color;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Botão pular
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _irParaLogin,
                  child: const Text(
                    'Pular',
                    style: TextStyle(color: AppTheme.grey),
                  ),
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/marca_fundo_transparente.png',
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _paginaAtual = i),
                itemCount: _paginas.length,
                itemBuilder: (context, index) {
                  final p = _paginas[index];
                  final c = p['cor'] as Color;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Emoji com fundo
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: c.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: c.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              p['emoji'],
                              style: const TextStyle(fontSize: 64),
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        Text(
                          p['titulo'],
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(height: 1.2),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          p['descricao'],
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(height: 1.6),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicadores e botão
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Dots indicadores
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _paginas.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _paginaAtual ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _paginaAtual ? cor : AppTheme.surface,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Botão próximo / começar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      onPressed: _proximaPagina,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cor,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _paginaAtual == _paginas.length - 1
                            ? 'Começar agora!'
                            : 'Próximo',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}