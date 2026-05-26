import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_transitions.dart';
import '../../core/theme_utils.dart';
import '../../shared/widgets/animated_button.dart';
import 'criar_treino_screen.dart';
import 'detalhe_treino_screen.dart';

class TreinoScreen extends StatefulWidget {
  const TreinoScreen({super.key});

  @override
  State<TreinoScreen> createState() => _TreinoScreenState();
}

class _TreinoScreenState extends State<TreinoScreen> {
  static const String _storageKey = 'treinos_personalizados_v1';

  static final List<Map<String, dynamic>> _treinoA = [
    {
      'nome': 'Supino Reto',
      'descricao': 'Exercicio composto para peitoral maior, deltoide anterior e triceps.',
      'series': 4,
      'repeticoes': '10-12',
      'carga': '60kg',
      'intervalo': 2,
      'videoId': 'rT7DgCr-3pg',
    },
    {
      'nome': 'Supino Inclinado',
      'descricao': 'Foca na porcao superior do peitoral com maior amplitude.',
      'series': 3,
      'repeticoes': '10-12',
      'carga': '50kg',
      'intervalo': 2,
      'videoId': 'DbFgADa2PL8',
    },
    {
      'nome': 'Crucifixo',
      'descricao': 'Isolamento do peitoral com movimento de abertura dos bracos.',
      'series': 3,
      'repeticoes': '12-15',
      'carga': '14kg',
      'intervalo': 1,
      'videoId': 'eozdVDA78K0',
    },
    {
      'nome': 'Triceps Pulley',
      'descricao': 'Isolamento do triceps com cabo.',
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
      'descricao': 'Exercicio composto para grande dorsal e biceps.',
      'series': 4,
      'repeticoes': '10-12',
      'carga': '70kg',
      'intervalo': 2,
      'videoId': 'CAwf7n6Luuc',
    },
    {
      'nome': 'Remada Curvada',
      'descricao': 'Fortalece dorsal, romboides e trapezio medio.',
      'series': 4,
      'repeticoes': '10-12',
      'carga': '60kg',
      'intervalo': 2,
      'videoId': 'kBWAon7ItDw',
    },
    {
      'nome': 'Rosca Direta',
      'descricao': 'Isolamento classico do biceps braquial.',
      'series': 3,
      'repeticoes': '12-15',
      'carga': '20kg',
      'intervalo': 1,
      'videoId': 'ykJmrZ5v0Oo',
    },
    {
      'nome': 'Rosca Martelo',
      'descricao': 'Trabalha biceps e braquiorradial com pegada neutra.',
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
      'descricao': 'Exercicio composto para quadriceps, gluteos e posterior.',
      'series': 4,
      'repeticoes': '8-10',
      'carga': '80kg',
      'intervalo': 3,
      'videoId': 'ultWZbUMPL8',
    },
    {
      'nome': 'Leg Press',
      'descricao': 'Fortalece quadriceps e gluteos com menor carga lombar.',
      'series': 4,
      'repeticoes': '12-15',
      'carga': '150kg',
      'intervalo': 2,
      'videoId': 'IZxyjW7MPJQ',
    },
    {
      'nome': 'Desenvolvimento',
      'descricao': 'Exercicio composto para deltoides anterior e lateral.',
      'series': 4,
      'repeticoes': '10-12',
      'carga': '40kg',
      'intervalo': 2,
      'videoId': 'qEwKCR5JCog',
    },
    {
      'nome': 'Elevacao Lateral',
      'descricao': 'Isolamento do deltoide lateral.',
      'series': 3,
      'repeticoes': '12-15',
      'carga': '10kg',
      'intervalo': 1,
      'videoId': '3VcKaXpzqRo',
    },
  ];

  final List<Map<String, dynamic>> _treinosPersonalizados = [];

  @override
  void initState() {
    super.initState();
    _carregarTreinosPersonalizados();
  }

  Future<void> _carregarTreinosPersonalizados() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.trim().isEmpty) return;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      final carregados = <Map<String, dynamic>>[];
      for (final item in decoded) {
        if (item is! Map) continue;

        final tituloRaw = item['titulo'];
        final exerciciosRaw = item['exercicios'];
        final corRaw = item['cor'];

        if (tituloRaw is! String || tituloRaw.trim().isEmpty) continue;
        if (exerciciosRaw is! List) continue;

        final exercicios = exerciciosRaw
            .whereType<Map>()
            .map((ex) => Map<String, dynamic>.from(ex))
            .toList();
        if (exercicios.isEmpty) continue;

        final corValue = corRaw is num ? corRaw.toInt() : AppTheme.primary.value;
        carregados.add({
          'titulo': tituloRaw.trim(),
          'cor': Color(corValue),
          'exercicios': exercicios,
        });
      }

      if (!mounted) return;
      setState(() {
        _treinosPersonalizados
          ..clear()
          ..addAll(carregados);
      });
    } catch (_) {
      // Mantem a tela funcional mesmo se o dado salvo estiver invalido.
    }
  }

  Future<void> _salvarTreinosPersonalizados() async {
    final prefs = await SharedPreferences.getInstance();
    final serializavel = _treinosPersonalizados.map((treino) {
      final cor = treino['cor'] as Color? ?? AppTheme.primary;
      final exercicios =
          treino['exercicios'] as List<Map<String, dynamic>>? ?? <Map<String, dynamic>>[];
      return {
        'titulo': treino['titulo'],
        'cor': cor.value,
        'exercicios': exercicios,
      };
    }).toList();

    await prefs.setString(_storageKey, jsonEncode(serializavel));
  }

  Future<void> _abrirCriadorTreino() async {
    final resultado = await Navigator.push<Map<String, dynamic>>(
      context,
      AppTransitions.slideFromBottom<Map<String, dynamic>>(
        const CriarTreinoScreen(),
      ),
    );

    if (!mounted || resultado == null) return;

    final tituloRaw = resultado['titulo'];
    final exerciciosRaw = resultado['exercicios'];
    final corRaw = resultado['cor'];

    if (tituloRaw is! String || tituloRaw.trim().isEmpty) return;
    if (exerciciosRaw is! List) return;

    final exercicios = exerciciosRaw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
    if (exercicios.isEmpty) return;

    final cor = corRaw is Color ? corRaw : AppTheme.primary;

    setState(() {
      _treinosPersonalizados.add({
        'titulo': tituloRaw.trim(),
        'cor': cor,
        'exercicios': exercicios,
      });
    });
    await _salvarTreinosPersonalizados();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Treino salvo em "Treinos personalizados".'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  String _letraDoTreino(String titulo, int index) {
    final trimmed = titulo.trim();
    if (trimmed.isEmpty) return 'P${index + 1}';
    return trimmed.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCriadorTreino,
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
              Text('Meus Treinos', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Selecione um treino para comecar',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryDark, AppTheme.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Bora treinar!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Crie seu treino automatico por dias, objetivo e perfil.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      'assets/images/patrique_estrela.png',
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _CardGrupoMuscular(
                letra: 'A',
                titulo: 'Peito e Triceps',
                exercicios: _treinoA,
                cor: AppTheme.primary,
              ),
              const SizedBox(height: 16),
              _CardGrupoMuscular(
                letra: 'B',
                titulo: 'Costas e Biceps',
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
              if (_treinosPersonalizados.isNotEmpty) ...[
                const SizedBox(height: 28),
                Text(
                  'Treinos personalizados',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ..._treinosPersonalizados.asMap().entries.map((entry) {
                  final index = entry.key;
                  final treino = entry.value;
                  final titulo = treino['titulo'] as String;
                  final cor = treino['cor'] as Color;
                  final exercicios =
                      treino['exercicios'] as List<Map<String, dynamic>>;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _CardGrupoMuscular(
                      letra: _letraDoTreino(titulo, index),
                      titulo: titulo,
                      exercicios: exercicios,
                      cor: cor,
                    ),
                  );
                }),
              ],
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
          color: context.cardColor,
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
                  Text(titulo, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${exercicios.length} exercicios',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: cor, size: 18),
          ],
        ),
      ),
    );
  }
}
