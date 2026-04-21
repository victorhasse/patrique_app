import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme_utils.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  final DateTime _hoje = DateTime.now();
  late DateTime _mesSelecionado;

  final Set<DateTime> _diasTreinados = {
    DateTime(2026, 4, 1),
    DateTime(2026, 4, 2),
    DateTime(2026, 4, 3),
    DateTime(2026, 4, 5),
    DateTime(2026, 4, 7),
    DateTime(2026, 4, 8),
    DateTime(2026, 4, 9),
    DateTime(2026, 4, 10),
    DateTime(2026, 4, 11),
    DateTime(2026, 4, 14),
    DateTime(2026, 4, 15),
    DateTime(2026, 4, 16),
    DateTime(2026, 4, 17),
  };

  @override
  void initState() {
    super.initState();
    _mesSelecionado = DateTime(_hoje.year, _hoje.month);
  }

  bool _foiTreinado(DateTime dia) {
    return _diasTreinados.any((d) =>
        d.year == dia.year && d.month == dia.month && d.day == dia.day);
  }

  bool _isHoje(DateTime dia) {
    return dia.year == _hoje.year &&
        dia.month == _hoje.month &&
        dia.day == _hoje.day;
  }

  int get _streakAtual {
    int streak = 5;
    DateTime dia = DateTime(_hoje.year, _hoje.month, _hoje.day);
    while (_foiTreinado(dia)) {
      streak++;
      dia = dia.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int get _totalMes {
    return _diasTreinados
        .where((d) =>
            d.year == _mesSelecionado.year &&
            d.month == _mesSelecionado.month)
        .length;
  }

  void _mesAnterior() {
    setState(() {
      _mesSelecionado =
          DateTime(_mesSelecionado.year, _mesSelecionado.month - 1);
    });
  }

  void _proximoMes() {
    setState(() {
      _mesSelecionado =
          DateTime(_mesSelecionado.year, _mesSelecionado.month + 1);
    });
  }

  List<DateTime?> _getDiasDoMes() {
    final primeiroDia =
        DateTime(_mesSelecionado.year, _mesSelecionado.month, 1);
    final ultimoDia =
        DateTime(_mesSelecionado.year, _mesSelecionado.month + 1, 0);
    int diaSemanaInicio = primeiroDia.weekday - 1;
    List<DateTime?> dias =
        List.filled(diaSemanaInicio, null, growable: true);
    for (int i = 1; i <= ultimoDia.day; i++) {
      dias.add(DateTime(_mesSelecionado.year, _mesSelecionado.month, i));
    }
    return dias;
  }

  String _nomeMes(int mes) {
    const meses = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return meses[mes - 1];
  }

  @override
  Widget build(BuildContext context) {
    final dias = _getDiasDoMes();
    final textColor = context.textColor;
    final subtitleColor = context.subtitleColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Calendário',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Cards de estatísticas
            Row(
              children: [
                Expanded(
                  child: _CardStat(
                    emoji: '🔥',
                    valor: '$_streakAtual',
                    label: 'Streak atual',
                    destaque: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CardStat(
                    emoji: '📅',
                    valor: '$_totalMes',
                    label: 'Treinos no mês',
                    destaque: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CardStat(
                    emoji: '🏆',
                    valor: '${_diasTreinados.length}',
                    label: 'Total geral',
                    destaque: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Calendário
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Navegação de mês
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _mesAnterior,
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '${_nomeMes(_mesSelecionado.month)} ${_mesSelecionado.year}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: _proximoMes,
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Cabeçalho dias da semana
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: ['S', 'T', 'Q', 'Q', 'S', 'S', 'D']
                        .map((l) => SizedBox(
                              width: 32,
                              child: Center(
                                child: Text(
                                  l,
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 12),

                  // Grid de dias
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: dias.length,
                    itemBuilder: (context, index) {
                      final dia = dias[index];
                      if (dia == null) return const SizedBox();
                      final treinado = _foiTreinado(dia);
                      final hoje = _isHoje(dia);

                      return Container(
                        decoration: BoxDecoration(
                          color: treinado
                              ? AppTheme.primary
                              : hoje
                                  ? AppTheme.primary.withValues(alpha: 0.2)
                                  : Colors.transparent,
                          shape: BoxShape.circle,
                          border: hoje && !treinado
                              ? Border.all(
                                  color: AppTheme.primary, width: 1.5)
                              : null,
                        ),
                        child: Center(
                          child: treinado
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 14)
                              : Text(
                                  '${dia.day}',
                                  style: TextStyle(
                                    color: hoje
                                        ? AppTheme.primary
                                        : subtitleColor,
                                    fontSize: 12,
                                    fontWeight: hoje
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Legenda
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendaItem(
                  cor: AppTheme.primary,
                  label: 'Treinou',
                  labelColor: subtitleColor,
                ),
                const SizedBox(width: 24),
                _LegendaItem(
                  cor: AppTheme.primary.withValues(alpha: 0.2),
                  label: 'Hoje',
                  borda: true,
                  labelColor: subtitleColor,
                ),
                const SizedBox(width: 24),
                _LegendaItem(
                  cor: context.cardColor,
                  label: 'Sem treino',
                  labelColor: subtitleColor,
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _CardStat extends StatelessWidget {
  final String emoji;
  final String valor;
  final String label;
  final bool destaque;

  const _CardStat({
    required this.emoji,
    required this.valor,
    required this.label,
    required this.destaque,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: destaque
            ? AppTheme.primary.withValues(alpha: 0.15)
            : context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: destaque
            ? Border.all(color: AppTheme.primary, width: 1)
            : null,
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            valor,
            style: TextStyle(
              color: context.textColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
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

class _LegendaItem extends StatelessWidget {
  final Color cor;
  final String label;
  final bool borda;
  final Color labelColor;

  const _LegendaItem({
    required this.cor,
    required this.label,
    required this.labelColor,
    this.borda = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: cor,
            shape: BoxShape.circle,
            border: borda
                ? Border.all(color: AppTheme.primary, width: 1.5)
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: labelColor, fontSize: 12),
        ),
      ],
    );
  }
}