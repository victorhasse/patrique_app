import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_transitions.dart';
import '../../core/theme_utils.dart';
import '../../shared/widgets/animated_button.dart';
import 'calendario_screen.dart';
import 'home_shimmer.dart';
import '../../../main.dart';
import '../treino/detalhe_treino_screen.dart';

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
                      'Olá, Fulano!',
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
                child: const Icon(Icons.person_rounded, color: Colors.white),
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
          Text('Sua semana', style: Theme.of(context).textTheme.titleLarge),
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
          Text('Próximo treino', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          AnimatedButton(
            onTap: () {
              Navigator.push(
                context,
                AppTransitions.slideFromRight(
                  DetalheTreinoScreen(
                    titulo: 'Peito e Tríceps',
                    cor: AppTheme.primary,
                    exercicios: const [
                      {
                        'nome': 'Supino Reto',
                        'descricao': 'Exercício composto para peitoral maior, deltóide anterior e tríceps.',
                        'series': 4,
                        'repeticoes': '10-12',
                        'carga': '60kg',
                        'intervalo': 2,
                        'videoId': 'rT7DgCr-3pg',
                      },
                      {
                        'nome': 'Supino Inclinado',
                        'descricao': 'Foca na porção superior do peitoral com maior amplitude.',
                        'series': 3,
                        'repeticoes': '10-12',
                        'carga': '50kg',
                        'intervalo': 2,
                        'videoId': 'DbFgADa2PL8',
                      },
                      {
                        'nome': 'Crucifixo',
                        'descricao': 'Isolamento do peitoral com movimento de abertura dos braços.',
                        'series': 3,
                        'repeticoes': '12-15',
                        'carga': '14kg',
                        'intervalo': 1,
                        'videoId': 'eozdVDA78K0',
                      },
                      {
                        'nome': 'Tríceps Pulley',
                        'descricao': 'Isolamento do tríceps com cabo, excelente para definição.',
                        'series': 4,
                        'repeticoes': '12-15',
                        'carga': '30kg',
                        'intervalo': 1,
                        'videoId': '2-LAMcpzODU',
                      },
                    ],
                  ),
                ),
              );
            },
            child: _CardTreino(
              titulo: 'Peito e Tríceps',
              exercicios: '4 exercícios',
              duracao: '45 min',
              icone: Icons.fitness_center_rounded,
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedButton(
            onTap: () {
              Navigator.push(
                context,
                AppTransitions.slideFromRight(
                  DetalheTreinoScreen(
                    titulo: 'Costas e Bíceps',
                    cor: const Color(0xFF7C3AED),
                    exercicios: const [
                      {
                        'nome': 'Puxada Frontal',
                        'descricao': 'Exercício composto para grande dorsal e bíceps.',
                        'series': 4,
                        'repeticoes': '10-12',
                        'carga': '70kg',
                        'intervalo': 2,
                        'videoId': 'CAwf7n6Luuc',
                      },
                      {
                        'nome': 'Remada Curvada',
                        'descricao': 'Fortalece o dorsal, romboides e trapézio médio.',
                        'series': 4,
                        'repeticoes': '10-12',
                        'carga': '60kg',
                        'intervalo': 2,
                        'videoId': 'kBWAon7ItDw',
                      },
                      {
                        'nome': 'Rosca Direta',
                        'descricao': 'Isolamento clássico do bíceps braquial.',
                        'series': 3,
                        'repeticoes': '12-15',
                        'carga': '20kg',
                        'intervalo': 1,
                        'videoId': 'ykJmrZ5v0Oo',
                      },
                      {
                        'nome': 'Rosca Martelo',
                        'descricao': 'Trabalha bíceps e braquiorradial com pegada neutra.',
                        'series': 3,
                        'repeticoes': '12-15',
                        'carga': '16kg',
                        'intervalo': 1,
                        'videoId': 'zC3nLlEvin4',
                      },
                    ],
                  ),
                ),
              );
            },
            child: _CardTreino(
              titulo: 'Costas e Bíceps',
              exercicios: '4 exercícios',
              duracao: '40 min',
              icone: Icons.sports_gymnastics_rounded,
              isDark: isDark,
            ),
          ),

          const SizedBox(height: 28),

          // Seção Chad Esponja → Nutrição
          Text('Nutrição', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          AnimatedButton(
            onTap: () {
              mainScreenKey.currentState?.trocarAba(4);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF059669).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/chad_esponja.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Plano de dieta',
                          style: TextStyle(
                            color: Color(0xFF059669),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Monte sua dieta e acompanhe suas calorias diárias!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Ver nutrição →',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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