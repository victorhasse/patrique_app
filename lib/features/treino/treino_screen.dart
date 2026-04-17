import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TreinoScreen extends StatelessWidget {
  const TreinoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header
              Text(
                'Meus Treinos',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Selecione um treino para começar',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // Cards de treino
              _CardGrupoMuscular(
                letra: 'A',
                titulo: 'Peito e Tríceps',
                exercicios: const [
                  'Supino reto',
                  'Supino inclinado',
                  'Crucifixo',
                  'Tríceps pulley',
                  'Tríceps testa',
                  'Mergulho',
                ],
                cor: AppTheme.primary,
              ),

              const SizedBox(height: 16),

              _CardGrupoMuscular(
                letra: 'B',
                titulo: 'Costas e Bíceps',
                exercicios: const [
                  'Puxada frontal',
                  'Remada curvada',
                  'Remada unilateral',
                  'Rosca direta',
                  'Rosca martelo',
                ],
                cor: const Color(0xFF7C3AED),
              ),

              const SizedBox(height: 16),

              _CardGrupoMuscular(
                letra: 'C',
                titulo: 'Pernas e Ombros',
                exercicios: const [
                  'Agachamento',
                  'Leg press',
                  'Cadeira extensora',
                  'Desenvolvimento',
                  'Elevação lateral',
                  'Panturrilha',
                ],
                cor: const Color(0xFF059669),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardGrupoMuscular extends StatefulWidget {
  final String letra;
  final String titulo;
  final List<String> exercicios;
  final Color cor;

  const _CardGrupoMuscular({
    required this.letra,
    required this.titulo,
    required this.exercicios,
    required this.cor,
  });

  @override
  State<_CardGrupoMuscular> createState() => _CardGrupoMuscularState();
}

class _CardGrupoMuscularState extends State<_CardGrupoMuscular> {
  bool _expandido = false;
  final List<bool> _concluidos = [];

  @override
  void initState() {
    super.initState();
    _concluidos.addAll(
      List.generate(widget.exercicios.length, (_) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final concluidos = _concluidos.where((c) => c).length;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header do card
          InkWell(
            onTap: () => setState(() => _expandido = !_expandido),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Letra do treino
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.cor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.letra,
                        style: TextStyle(
                          color: widget.cor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Título e progresso
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.titulo,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$concluidos/${widget.exercicios.length} exercícios',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  // Seta expandir
                  Icon(
                    _expandido
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.grey,
                  ),
                ],
              ),
            ),
          ),

          // Barra de progresso
          if (concluidos > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(
                value: concluidos / widget.exercicios.length,
                backgroundColor: AppTheme.background,
                valueColor: AlwaysStoppedAnimation<Color>(widget.cor),
                borderRadius: BorderRadius.circular(4),
              ),
            ),

          // Lista de exercícios expandida
          if (_expandido) ...[
            const Divider(color: AppTheme.background, height: 1),
            ...List.generate(widget.exercicios.length, (i) {
              return CheckboxListTile(
                value: _concluidos[i],
                onChanged: (val) =>
                    setState(() => _concluidos[i] = val ?? false),
                activeColor: widget.cor,
                title: Text(
                  widget.exercicios[i],
                  style: TextStyle(
                    color: _concluidos[i] ? AppTheme.grey : AppTheme.white,
                    decoration:
                        _concluidos[i] ? TextDecoration.lineThrough : null,
                    fontSize: 15,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
              );
            }),
            const SizedBox(height: 8),

            // Botão iniciar treino
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.cor,
                ),
                child: const Text('Iniciar treino'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}