import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_transitions.dart';
import 'calendario_screen.dart';
import 'home_shimmer.dart';
import '../../shared/widgets/animated_button.dart';

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
    // Simula carregamento de dados
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _carregando = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _carregando ? const HomeShimmer() : _HomeConteudo(),
      ),
    );
  }
}

class _HomeConteudo extends StatelessWidget {
  const _HomeConteudo();

  @override
  Widget build(BuildContext context) {
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
                child: const Icon(Icons.person_rounded,
                    color: Colors.white),
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
                      Text(
                        '5 dias seguidos!',
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Continue assim, não perca seu streak!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppTheme.primaryLight),
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
          Text('Sua semana',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _SemanaWidget(),

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
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
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
          Text('Próximo treino',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          AnimatedButton(
            onTap: () {},
            child: const _CardTreino(
              titulo: 'Peito e Tríceps',
              exercicios: '6 exercícios',
              duracao: '45 min',
              icone: Icons.fitness_center_rounded,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedButton(
            onTap: () {},
            child: const _CardTreino(
              titulo: 'Costas e Bíceps',
              exercicios: '5 exercícios',
              duracao: '40 min',
              icone: Icons.sports_gymnastics_rounded,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SemanaWidget extends StatelessWidget {
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
                color: feito ? AppTheme.primary : AppTheme.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: feito
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18)
                    : Text(
                        d['dia'],
                        style: const TextStyle(
                          color: AppTheme.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              d['dia'],
              style:
                  const TextStyle(color: AppTheme.grey, fontSize: 11),
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

  const _CardTreino({
    required this.titulo,
    required this.exercicios,
    required this.duracao,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
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
                Text(titulo,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '$exercicios · $duracao',
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              color: AppTheme.grey, size: 16),
        ],
      ),
    );
  }
}