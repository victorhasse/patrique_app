import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'detalhe_treino_screen.dart';
import '../../core/theme/app_transitions.dart';
import '../../shared/widgets/animated_button.dart';
import 'criar_treino_screen.dart';

class TreinoScreen extends StatelessWidget {
  const TreinoScreen({super.key});

  static final List<Map<String, dynamic>> _treinoA = [
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
  ];

  static final List<Map<String, dynamic>> _treinoB = [
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
  ];

  static final List<Map<String, dynamic>> _treinoC = [
    {
      'nome': 'Agachamento Livre',
      'descricao': 'Rei dos exercícios — quadríceps, glúteos e posterior de coxa.',
      'series': 4,
      'repeticoes': '8-10',
      'carga': '80kg',
      'intervalo': 3,
      'videoId': 'ultWZbUMPL8',
    },
    {
      'nome': 'Leg Press',
      'descricao': 'Fortalece quadríceps e glúteos com menor risco para coluna.',
      'series': 4,
      'repeticoes': '12-15',
      'carga': '150kg',
      'intervalo': 2,
      'videoId': 'IZxyjW7MPJQ',
    },
    {
      'nome': 'Desenvolvimento',
      'descricao': 'Exercício composto para deltóides anterior e lateral.',
      'series': 4,
      'repeticoes': '10-12',
      'carga': '40kg',
      'intervalo': 2,
      'videoId': 'qEwKCR5JCog',
    },
    {
      'nome': 'Elevação Lateral',
      'descricao': 'Isolamento do deltóide lateral para ombros mais largos.',
      'series': 3,
      'repeticoes': '12-15',
      'carga': '10kg',
      'intervalo': 1,
      'videoId': '3VcKaXpzqRo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            AppTransitions.slideFromBottom(const CriarTreinoScreen()),
          );
        },
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Novo treino',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('Meus Treinos',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('Selecione um treino para começar',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              _CardGrupoMuscular(
                letra: 'A',
                titulo: 'Peito e Tríceps',
                exercicios: _treinoA,
                cor: AppTheme.primary,
              ),
              const SizedBox(height: 16),
              _CardGrupoMuscular(
                letra: 'B',
                titulo: 'Costas e Bíceps',
                exercicios: _treinoB,
                cor: const Color(0xFF7C3AED),
              ),
              const SizedBox(height: 16),
              _CardGrupoMuscular(
                letra: 'C',
                titulo: 'Pernas e Ombros',
                exercicios: _treinoC,
                cor: const Color(0xFF059669),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardGrupoMuscular extends StatelessWidget {
  final String letra;
  final String titulo;
  final List<Map<String, dynamic>> exercicios;
  final Color cor;

  const _CardGrupoMuscular({
    required this.letra,
    required this.titulo,
    required this.exercicios,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: () {
        Navigator.push(
          context,
          AppTransitions.slideFromRight(
            DetalheTreinoScreen(
              titulo: titulo,
              cor: cor,
              exercicios: exercicios,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  letra,
                  style: TextStyle(
                    color: cor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
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
                    '${exercicios.length} exercícios',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: cor, size: 18),
          ],
        ),
      ),
    );
  }
}