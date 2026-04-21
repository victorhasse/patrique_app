import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/theme/app_theme.dart';
import '../../core/notification_service.dart';
import '../../core/theme_utils.dart';

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});

  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  bool _lembreteAtivo = false;
  TimeOfDay _horarioSelecionado = const TimeOfDay(hour: 7, minute: 0);
  bool _notifStreak = true;
  bool _notifConclusao = true;

  Future<void> _selecionarHorario() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horarioSelecionado,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primary,
              surface: context.cardColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _horarioSelecionado = picked);
      if (_lembreteAtivo) {
        await NotificationService().agendarLembrete(
          hora: picked.hour,
          minuto: picked.minute,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Lembrete atualizado para ${picked.format(context)}',
              ),
              backgroundColor: AppTheme.primary,
            ),
          );
        }
      }
    }
  }

  Future<void> _toggleLembrete(bool valor) async {
    setState(() => _lembreteAtivo = valor);

    if (valor) {
      await NotificationService().agendarLembrete(
        hora: _horarioSelecionado.hour,
        minuto: _horarioSelecionado.minute,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Lembrete ativado para ${_horarioSelecionado.format(context)}',
            ),
            backgroundColor: AppTheme.primary,
          ),
        );
      }
    } else {
      await NotificationService().cancelarTodos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lembretes desativados'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: context.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notificações',
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lembrete de treino
            Text('Lembrete de treino',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Receba um lembrete diário para não esquecer de treinar',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Toggle lembrete
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_rounded,
                            color: AppTheme.primary, size: 22),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Lembrete diário',
                            style:
                                Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        CupertinoSwitch(
                          value: _lembreteAtivo,
                          activeTrackColor: AppTheme.primary,
                          onChanged: _toggleLembrete,
                        ),
                      ],
                    ),
                  ),

                  // Horário
                  if (_lembreteAtivo) ...[
                    Divider(
                        color: context.subtitleColor, height: 1),
                    InkWell(
                      onTap: _selecionarHorario,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded,
                                color: AppTheme.primary, size: 22),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Horário',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),
                            ),
                            Text(
                              _horarioSelecionado.format(context),
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: context.subtitleColor,
                                size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Outras notificações
            Text('Outras notificações',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Streak em risco
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        const Text('🔥',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text('Streak em risco',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge),
                              Text(
                                'Aviso quando seu streak estiver em risco',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                          value: _notifStreak,
                          activeTrackColor: AppTheme.primary,
                          onChanged: (v) =>
                              setState(() => _notifStreak = v),
                        ),
                      ],
                    ),
                  ),

                  Divider(color: context.subtitleColor, height: 10),

                  // Treino concluído
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        const Text('🏆',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text('Conquistas',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge),
                              Text(
                                'Notificação ao bater recordes',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        CupertinoSwitch(
                          value: _notifConclusao,
                          activeTrackColor: AppTheme.primary,
                          onChanged: (v) =>
                              setState(() => _notifConclusao = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Card informativo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppTheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'As notificações ajudam a manter seu streak ativo e seus treinos em dia!',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}