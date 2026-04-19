import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ConclusaoTreinoScreen extends StatefulWidget {
  final String titulo;
  final Color cor;
  final int tempoTotal;
  final int totalExercicios;

  const ConclusaoTreinoScreen({
    super.key,
    required this.titulo,
    required this.cor,
    required this.tempoTotal,
    required this.totalExercicios,
  });

  @override
  State<ConclusaoTreinoScreen> createState() => _ConclusaoTreinoScreenState();
}

class _ConclusaoTreinoScreenState extends State<ConclusaoTreinoScreen>
    with SingleTickerProviderStateMixin {
  int _estrelas = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatarTempo(int segundos) {
    final m = (segundos ~/ 60).toString().padLeft(2, '0');
    final s = (segundos % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _mensagemEstrelas() {
    switch (_estrelas) {
      case 1:
        return 'Foi difícil, mas você foi!';
      case 2:
        return 'Bom treino, continue assim!';
      case 3:
        return 'Treino incrível! 🔥';
      case 4:
        return 'Você arrasou hoje!';
      case 5:
        return 'Treino perfeito! Você é demais! 🏆';
      default:
        return 'Como foi seu treino?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Animação de conclusão
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: widget.cor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.cor, width: 2),
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: widget.cor,
                    size: 60,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Treino concluído!',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.titulo,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: widget.cor),
              ),

              const SizedBox(height: 32),

              // Streak
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryDark,
                      AppTheme.primary
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🔥',
                        style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Streak aumentado!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '8 dias seguidos!',
                          style: TextStyle(
                            color: AppTheme.primaryLight,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Estatísticas do treino
              Row(
                children: [
                  Expanded(
                    child: _CardResultado(
                      emoji: '⏱️',
                      valor: _formatarTempo(widget.tempoTotal),
                      label: 'Tempo total',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CardResultado(
                      emoji: '💪',
                      valor: '${widget.totalExercicios}',
                      label: 'Exercícios',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Avaliação com estrelas
              Text(
                _mensagemEstrelas(),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () => setState(() => _estrelas = i + 1),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        i < _estrelas
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: i < _estrelas
                            ? Colors.amber
                            : AppTheme.grey,
                        size: 44,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Botão voltar para home
              ElevatedButton(
                onPressed: _estrelas == 0
                    ? null
                    : () {
                        Navigator.popUntil(
                            context, (route) => route.isFirst);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.cor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  disabledBackgroundColor:
                      AppTheme.surface,
                ),
                child: Text(
                  _estrelas == 0
                      ? 'Avalie para continuar'
                      : 'Voltar para o início',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardResultado extends StatelessWidget {
  final String emoji;
  final String valor;
  final String label;

  const _CardResultado({
    required this.emoji,
    required this.valor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}