import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_transitions.dart';
import '../../core/theme_utils.dart';
import '../../shared/widgets/animated_button.dart';
import 'calendario_screen.dart';
import 'home_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _carregando = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _carregando ? const HomeShimmer() : const _HomeConteudo(),
      ),
    );
  }
}

class _HomeConteudo extends StatelessWidget {
  const _HomeConteudo();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, Fulano! 👋',
                      style: Theme.of(context).textTheme.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pronto para treinar hoje?',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Card streak
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryDark, AppTheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '5 dias seguidos!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Continue assim, não perca seu streak!',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Dias da semana
          Text(
            'Sua semana',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _SemanaWidget(isDark: isDark),

          const SizedBox(height: 12),

          // Botão calendário
          AnimatedButton(
            onTap: () {
              Navigator.push(
                context,
                AppTransitions.slideFromBottom(const CalendarioScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: const Center(
                child: Text(
                  'Ver calendário completo →',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Próximo treino
          Text(
            'Próximo treino',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          AnimatedButton(
            onTap: () {},
            child: _CardTreino(
              titulo: 'Peito e Tríceps',
              exercicios: '6 exercícios',
              duracao: '45 min',
              icone: Icons.fitness_center_rounded,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedButton(
            onTap: () {},
            child: _CardTreino(
              titulo: 'Costas e Bíceps',
              exercicios: '5 exercícios',
              duracao: '40 min',
              icone: Icons.sports_gymnastics_rounded,
              isDark: isDark,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SemanaWidget extends StatelessWidget {
  final bool isDark;

  const _SemanaWidget({required this.isDark});

  final List<Map<String, dynamic>> dias = const [
    {'dia': 'S', 'feito': true},
    {'dia': 'T', 'feito': true},
    {'dia': 'Q', 'feito': true},
    {'dia': 'Q', 'feito': true},
    {'dia': 'S', 'feito': true},
    {'dia': 'S', 'feito': false},
    {'dia': 'D', 'feito': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: dias.map((d) {
        final feito = d['feito'] as bool;
        return Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: feito
                    ? AppTheme.primary
                    : isDark
                        ? AppTheme.surface
                        : const Color(0xFFEEEEEE),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: feito
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18)
                    : Text(
                        d['dia'],
                        style: TextStyle(
                          color: isDark
                              ? AppTheme.grey
                              : const Color(0xFF888888),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              d['dia'],
              style: TextStyle(
                color: isDark ? AppTheme.grey : const Color(0xFF888888),
                fontSize: 11,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _CardTreino extends StatelessWidget {
  final String titulo;
  final String exercicios;
  final String duracao;
  final IconData icone;
  final bool isDark;

  const _CardTreino({
    required this.titulo,
    required this.exercicios,
    required this.duracao,
    required this.icone,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? null
            : Border.all(color: const Color(0xFFFFD6E5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icone, color: AppTheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$exercicios · $duracao',
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: isDark ? AppTheme.grey : const Color(0xFFBBBBBB),
            size: 16,
          ),
        ],
      ),
    );
  }
}