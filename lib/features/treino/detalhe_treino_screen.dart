import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'executar_treino_screen.dart';
import '../../core/theme/app_transitions.dart';
import '../../core/theme_utils.dart';

class DetalheTreinoScreen extends StatelessWidget {
  final String titulo;
  final Color cor;
  final List<Map<String, dynamic>> exercicios;

  const DetalheTreinoScreen({
    super.key,
    required this.titulo,
    required this.cor,
    required this.exercicios,
  });

  @override
  Widget build(BuildContext context) {
    final totalSeries =
        exercicios.fold<int>(0, (sum, e) => sum + (e['series'] as int));
    final totalMin = exercicios.fold<int>(
        0, (sum, e) => sum + (e['intervalo'] as int) * (e['series'] as int));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(titulo,
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner do treino
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cor.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: cor),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${exercicios.length} exercícios  •  $totalSeries séries totais',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Aprox. $totalMin min de intervalo',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.fitness_center_rounded, color: cor, size: 40),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Text('Exercícios',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            // Lista de exercícios
            ...exercicios.asMap().entries.map((entry) {
              final i = entry.key;
              final ex = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Número
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: cor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: cor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Infos
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex['nome'],
                            style:
                                Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${ex['series']}x${ex['repeticoes']}  •  ${ex['carga']}  •  ${ex['intervalo']}min intervalo',
                            style:
                                Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.play_circle_outline_rounded,
                        color: cor, size: 28),
                  ],
                ),
              );
            }),

            const SizedBox(height: 32),

            // Botão Play
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  AppTransitions.slideFromBottom(ExecutarTreinoScreen(
                      titulo: titulo,
                      cor: cor,
                      exercicios: exercicios,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded, size: 28),
              label: const Text('Iniciar treino'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}