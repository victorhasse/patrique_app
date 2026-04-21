import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../core/theme/app_theme.dart';
import 'conclusao_treino_screen.dart';
import '../../core/theme_utils.dart';

class ExecutarTreinoScreen extends StatefulWidget {
  final String titulo;
  final Color cor;
  final List<Map<String, dynamic>> exercicios;

  const ExecutarTreinoScreen({
    super.key,
    required this.titulo,
    required this.cor,
    required this.exercicios,
  });

  @override
  State<ExecutarTreinoScreen> createState() => _ExecutarTreinoScreenState();
}

class _ExecutarTreinoScreenState extends State<ExecutarTreinoScreen> {
  int _exercicioAtual = 0;
  int _segundosTotais = 0;
  int _segundosIntervalo = 0;
  bool _emIntervalo = false;
  late Timer _timerTotal;
  Timer? _timerIntervalo;
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _iniciarTimerTotal();
    _criarController();
  }

  void _criarController() {
    final videoId = widget.exercicios[_exercicioAtual]['videoId'] as String;
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
        loop: false,
        enableCaption: false,
      ),
    );
  }

  void _iniciarTimerTotal() {
    _timerTotal = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _segundosTotais++);
    });
  }

  void _iniciarIntervalo() {
    final minutos = widget.exercicios[_exercicioAtual]['intervalo'] as int;
    setState(() {
      _emIntervalo = true;
      _segundosIntervalo = minutos * 60;
    });

    _timerIntervalo =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_segundosIntervalo > 0) {
          _segundosIntervalo--;
        } else {
          timer.cancel();
          _emIntervalo = false;
        }
      });
    });
  }

  void _proximoExercicio() {
    if (_exercicioAtual < widget.exercicios.length - 1) {
      _timerIntervalo?.cancel();

      // Dispose do controller antigo
      final oldController = _youtubeController;

      setState(() {
        _exercicioAtual++;
        _emIntervalo = false;
      });

      // Cria novo controller após setState
      _criarController();

      // Dispose do antigo com delay para evitar o erro
      Future.delayed(const Duration(milliseconds: 300), () {
        oldController.dispose();
      });
    }
  }

  void _finalizarTreino() {
    _timerTotal.cancel();
    _timerIntervalo?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ConclusaoTreinoScreen(
          titulo: widget.titulo,
          cor: widget.cor,
          tempoTotal: _segundosTotais,
          totalExercicios: widget.exercicios.length,
        ),
      ),
    );
  }

  String _formatarTempo(int segundos) {
    final m = (segundos ~/ 60).toString().padLeft(2, '0');
    final s = (segundos % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timerTotal.cancel();
    _timerIntervalo?.cancel();
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercicios[_exercicioAtual];
    final isUltimo = _exercicioAtual == widget.exercicios.length - 1;

    return YoutubePlayerBuilder(
      // Key força recriação completa do player ao trocar exercício
      key: ValueKey(_exercicioAtual),
      player: YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: widget.cor,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: context.bgColor,
          appBar: AppBar(
            backgroundColor: context.bgColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close_rounded, color: context.textColor),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: context.bgColor,
                    title: Text('Sair do treino?',
                        style: TextStyle(color: context.textColor)),
                    content: Text(
                        'Seu progresso não será salvo.',
                        style: TextStyle(color: context.textColor)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Continuar treino',
                            style: TextStyle(color: AppTheme.primary)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Sair',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer_outlined,
                    color: context.textColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  _formatarTempo(_segundosTotais),
                  style: TextStyle(
                      color: context.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '${_exercicioAtual + 1}/${widget.exercicios.length}',
                    style: TextStyle(
                        color: widget.cor,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra de progresso
                LinearProgressIndicator(
                  value: (_exercicioAtual + 1) / widget.exercicios.length,
                  backgroundColor: context.bgColor,
                  valueColor: AlwaysStoppedAnimation<Color>(widget.cor),
                  minHeight: 4,
                ),

                // Player de vídeo
                player,

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ex['nome'],
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ex['descricao'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 20),

                      // Infos do exercício
                      Row(
                        children: [
                          Expanded(
                            child: _CardInfo(
                              icone: Icons.repeat_rounded,
                              valor: '${ex['series']}x${ex['repeticoes']}',
                              label: 'Séries x Rep.',
                              cor: widget.cor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _CardInfo(
                              icone: Icons.fitness_center_rounded,
                              valor: ex['carga'],
                              label: 'Carga',
                              cor: widget.cor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _CardInfo(
                              icone: Icons.timer_rounded,
                              valor: '${ex['intervalo']}min',
                              label: 'Intervalo',
                              cor: widget.cor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Intervalo ativo
                      if (_emIntervalo) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: widget.cor.withValues(alpha: 0.4)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Intervalo',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: widget.cor),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatarTempo(_segundosIntervalo),
                                style: TextStyle(
                                  color: widget.cor,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  _timerIntervalo?.cancel();
                                  setState(() => _emIntervalo = false);
                                },
                                child: Text(
                                  'Pular intervalo',
                                  style: TextStyle(color: context.subtitleColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Botões de ação
                      if (!_emIntervalo) ...[
                        ElevatedButton.icon(
                          onPressed: _iniciarIntervalo,
                          icon: const Icon(Icons.timer_rounded),
                          label: const Text(
                              'Série concluída — iniciar intervalo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.cor,
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: isUltimo
                              ? _finalizarTreino
                              : _proximoExercicio,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: widget.cor,
                            minimumSize: const Size(double.infinity, 52),
                            side: BorderSide(color: widget.cor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isUltimo
                                ? 'Finalizar treino'
                                : 'Próximo exercício',
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CardInfo extends StatelessWidget {
  final IconData icone;
  final String valor;
  final String label;
  final Color cor;

  const _CardInfo({
    required this.icone,
    required this.valor,
    required this.label,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icone, color: cor, size: 20),
          const SizedBox(height: 6),
          Text(
            valor,
            style: TextStyle(
              color: context.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: context.subtitleColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}