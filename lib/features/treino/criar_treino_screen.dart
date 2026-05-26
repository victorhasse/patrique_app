import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme_utils.dart';

class CriarTreinoScreen extends StatefulWidget {
  const CriarTreinoScreen({super.key});

  @override
  State<CriarTreinoScreen> createState() => _CriarTreinoScreenState();
}

class _CriarTreinoScreenState extends State<CriarTreinoScreen> {
  final _nomeController = TextEditingController();
  final List<Map<String, dynamic>> _exercicios = [];
  Color _corSelecionada = AppTheme.primary;

  int _diasPorSemana = 3;
  int _diaSelecionado = 1;
  String _sexoSelecionado = 'Nao informar';
  String _objetivoSelecionado = 'Hipertrofia';

  final List<int> _diasOpcoes = [2, 3, 4, 5];
  final List<String> _sexos = ['Nao informar', 'Feminino', 'Masculino'];
  final List<String> _objetivos = [
    'Hipertrofia',
    'Forca',
    'Emagrecimento',
    'Resistencia',
  ];

  final List<Color> _cores = [
    AppTheme.primary,
    const Color(0xFF7C3AED),
    const Color(0xFF059669),
    const Color(0xFFFF6B35),
    const Color(0xFF0EA5E9),
    const Color(0xFFEAB308),
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _adicionarExercicio() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.bgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ModalExercicio(
        onAdicionar: (exercicio) {
          setState(() => _exercicios.add(exercicio));
        },
      ),
    );
  }

  void _removerExercicio(int index) {
    setState(() => _exercicios.removeAt(index));
  }

  void _gerarTreinoAutomatico() {
    final nomeSugerido = _nomeSugeridoTreino(_diasPorSemana, _diaSelecionado);
    final parametros = _parametrosPorObjetivo(_objetivoSelecionado);
    final base = _templateBasePorDia(_diasPorSemana, _diaSelecionado);
    final ajustadoSexo = _ajustarPorSexo(base, _sexoSelecionado);

    final exerciciosGerados = ajustadoSexo.map((ex) {
      return <String, dynamic>{
        'nome': ex.nome,
        'descricao': ex.descricao,
        'series': parametros.series,
        'repeticoes': parametros.repeticoes,
        'carga': parametros.cargaSugerida,
        'intervalo': parametros.intervaloMin,
        'videoId': ex.videoId,
      };
    }).toList();

    setState(() {
      _nomeController.text = nomeSugerido;
      _corSelecionada = _cores[(_diaSelecionado - 1) % _cores.length];
      _exercicios
        ..clear()
        ..addAll(exerciciosGerados);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Treino automatico gerado com sucesso!'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  List<_ExercicioBase> _templateBasePorDia(int dias, int dia) {
    switch (dias) {
      case 2:
        if (dia == 1) {
          return const [
            _ExercicioBase(
              nome: 'Agachamento Livre',
              descricao: 'Trabalha quadriceps, gluteos e core.',
              videoId: 'ultWZbUMPL8',
            ),
            _ExercicioBase(
              nome: 'Supino Reto',
              descricao: 'Exercicio composto para peito e triceps.',
              videoId: 'rT7DgCr-3pg',
            ),
            _ExercicioBase(
              nome: 'Remada Curvada',
              descricao: 'Foco em costas e estabilidade de tronco.',
              videoId: 'kBWAon7ItDw',
            ),
            _ExercicioBase(
              nome: 'Desenvolvimento',
              descricao: 'Fortalece ombros e triceps.',
              videoId: 'qEwKCR5JCog',
            ),
            _ExercicioBase(
              nome: 'Prancha',
              descricao: 'Fortalecimento de core e postura.',
              videoId: 'ASdvN_XEl_c',
            ),
          ];
        }
        return const [
          _ExercicioBase(
            nome: 'Levantamento Terra Romeno',
            descricao: 'Posterior de coxa, gluteos e lombar.',
            videoId: '2SHsk9AzdjA',
          ),
          _ExercicioBase(
            nome: 'Puxada Frontal',
            descricao: 'Costas e biceps.',
            videoId: 'CAwf7n6Luuc',
          ),
          _ExercicioBase(
            nome: 'Leg Press',
            descricao: 'Trabalho de pernas com alta estabilidade.',
            videoId: 'IZxyjW7MPJQ',
          ),
          _ExercicioBase(
            nome: 'Flexao de Braco',
            descricao: 'Peito, ombros e triceps com peso corporal.',
            videoId: 'IODxDxX7oi4',
          ),
          _ExercicioBase(
            nome: 'Panturrilha em Pe',
            descricao: 'Fortalecimento de gastrocnemio e soleo.',
            videoId: 'gwLzBJYoWlI',
          ),
        ];
      case 3:
        if (dia == 1) {
          return const [
            _ExercicioBase(
              nome: 'Supino Reto',
              descricao: 'Principal composto para peitoral.',
              videoId: 'rT7DgCr-3pg',
            ),
            _ExercicioBase(
              nome: 'Supino Inclinado',
              descricao: 'Enfase na porcao superior do peitoral.',
              videoId: 'DbFgADa2PL8',
            ),
            _ExercicioBase(
              nome: 'Desenvolvimento',
              descricao: 'Ombros e triceps.',
              videoId: 'qEwKCR5JCog',
            ),
            _ExercicioBase(
              nome: 'Elevacao Lateral',
              descricao: 'Isolamento de deltoide lateral.',
              videoId: '3VcKaXpzqRo',
            ),
            _ExercicioBase(
              nome: 'Triceps Pulley',
              descricao: 'Isolamento de triceps.',
              videoId: '2-LAMcpzODU',
            ),
          ];
        }
        if (dia == 2) {
          return const [
            _ExercicioBase(
              nome: 'Puxada Frontal',
              descricao: 'Costas e biceps.',
              videoId: 'CAwf7n6Luuc',
            ),
            _ExercicioBase(
              nome: 'Remada Curvada',
              descricao: 'Costas com alta ativacao de dorsais.',
              videoId: 'kBWAon7ItDw',
            ),
            _ExercicioBase(
              nome: 'Remada Unilateral',
              descricao: 'Correcao de assimetrias entre lados.',
              videoId: 'pYcpY20QaE8',
            ),
            _ExercicioBase(
              nome: 'Rosca Direta',
              descricao: 'Biceps braquial.',
              videoId: 'ykJmrZ5v0Oo',
            ),
            _ExercicioBase(
              nome: 'Rosca Martelo',
              descricao: 'Biceps e antebraco.',
              videoId: 'zC3nLlEvin4',
            ),
          ];
        }
        return const [
          _ExercicioBase(
            nome: 'Agachamento Livre',
            descricao: 'Base de forca para membros inferiores.',
            videoId: 'ultWZbUMPL8',
          ),
          _ExercicioBase(
            nome: 'Leg Press',
            descricao: 'Volume de quadriceps e gluteos.',
            videoId: 'IZxyjW7MPJQ',
          ),
          _ExercicioBase(
            nome: 'Cadeira Extensora',
            descricao: 'Isolamento de quadriceps.',
            videoId: 'YyvSfVjQeL0',
          ),
          _ExercicioBase(
            nome: 'Mesa Flexora',
            descricao: 'Posterior de coxa.',
            videoId: '1Tq3QdYUuHs',
          ),
          _ExercicioBase(
            nome: 'Panturrilha em Pe',
            descricao: 'Fortalecimento de panturrilhas.',
            videoId: 'gwLzBJYoWlI',
          ),
        ];
      case 4:
        if (dia == 1) {
          return const [
            _ExercicioBase(
              nome: 'Supino Reto',
              descricao: 'Peitoral e triceps.',
              videoId: 'rT7DgCr-3pg',
            ),
            _ExercicioBase(
              nome: 'Remada Curvada',
              descricao: 'Costas e estabilizadores.',
              videoId: 'kBWAon7ItDw',
            ),
            _ExercicioBase(
              nome: 'Desenvolvimento',
              descricao: 'Forca de ombros.',
              videoId: 'qEwKCR5JCog',
            ),
            _ExercicioBase(
              nome: 'Puxada Frontal',
              descricao: 'Dorsais e biceps.',
              videoId: 'CAwf7n6Luuc',
            ),
            _ExercicioBase(
              nome: 'Triceps Pulley',
              descricao: 'Acabamento de triceps.',
              videoId: '2-LAMcpzODU',
            ),
            _ExercicioBase(
              nome: 'Rosca Direta',
              descricao: 'Acabamento de biceps.',
              videoId: 'ykJmrZ5v0Oo',
            ),
          ];
        }
        if (dia == 2) {
          return const [
            _ExercicioBase(
              nome: 'Agachamento Livre',
              descricao: 'Principal composto de pernas.',
              videoId: 'ultWZbUMPL8',
            ),
            _ExercicioBase(
              nome: 'Leg Press',
              descricao: 'Volume de quadriceps e gluteos.',
              videoId: 'IZxyjW7MPJQ',
            ),
            _ExercicioBase(
              nome: 'Levantamento Terra Romeno',
              descricao: 'Posterior de coxa e gluteos.',
              videoId: '2SHsk9AzdjA',
            ),
            _ExercicioBase(
              nome: 'Cadeira Extensora',
              descricao: 'Isolamento de quadriceps.',
              videoId: 'YyvSfVjQeL0',
            ),
            _ExercicioBase(
              nome: 'Panturrilha em Pe',
              descricao: 'Panturrilhas.',
              videoId: 'gwLzBJYoWlI',
            ),
          ];
        }
        if (dia == 3) {
          return const [
            _ExercicioBase(
              nome: 'Supino Inclinado',
              descricao: 'Enfase em peitoral superior.',
              videoId: 'DbFgADa2PL8',
            ),
            _ExercicioBase(
              nome: 'Remada Unilateral',
              descricao: 'Melhora equilibrio entre lados.',
              videoId: 'pYcpY20QaE8',
            ),
            _ExercicioBase(
              nome: 'Face Pull',
              descricao: 'Saude de ombros e postura.',
              videoId: 'rep-qVOkqgk',
            ),
            _ExercicioBase(
              nome: 'Elevacao Lateral',
              descricao: 'Deltoide lateral.',
              videoId: '3VcKaXpzqRo',
            ),
            _ExercicioBase(
              nome: 'Triceps Frances',
              descricao: 'Isolamento de triceps.',
              videoId: 'VdVfKti0vzw',
            ),
            _ExercicioBase(
              nome: 'Rosca Martelo',
              descricao: 'Biceps e antebraco.',
              videoId: 'zC3nLlEvin4',
            ),
          ];
        }
        return const [
          _ExercicioBase(
            nome: 'Levantamento Terra Romeno',
            descricao: 'Posterior de coxa e gluteos.',
            videoId: '2SHsk9AzdjA',
          ),
          _ExercicioBase(
            nome: 'Afundo',
            descricao: 'Unilateral para forca e estabilidade.',
            videoId: 'QOVaHwm-Q6U',
          ),
          _ExercicioBase(
            nome: 'Hip Thrust',
            descricao: 'Enfase em gluteos.',
            videoId: 'LM8XHLYJoYs',
          ),
          _ExercicioBase(
            nome: 'Mesa Flexora',
            descricao: 'Posterior de coxa.',
            videoId: '1Tq3QdYUuHs',
          ),
          _ExercicioBase(
            nome: 'Panturrilha Sentado',
            descricao: 'Panturrilha com foco em soleo.',
            videoId: 'YMmgqO8Jo-k',
          ),
        ];
      default:
        if (dia == 1) {
          return _templateBasePorDia(3, 1);
        }
        if (dia == 2) {
          return _templateBasePorDia(3, 2);
        }
        if (dia == 3) {
          return _templateBasePorDia(3, 3);
        }
        if (dia == 4) {
          return _templateBasePorDia(4, 1);
        }
        return _templateBasePorDia(4, 2);
    }
  }

  List<_ExercicioBase> _ajustarPorSexo(
    List<_ExercicioBase> base,
    String sexo,
  ) {
    final copy = List<_ExercicioBase>.from(base);
    final nomes = copy.map((e) => e.nome).toSet();
    final lowerDay = copy.any((e) =>
        e.nome.contains('Agachamento') ||
        e.nome.contains('Leg Press') ||
        e.nome.contains('Flexora') ||
        e.nome.contains('Afundo') ||
        e.nome.contains('Hip Thrust'));

    if (sexo == 'Feminino' && lowerDay && !nomes.contains('Cadeira Abdutora')) {
      copy.add(const _ExercicioBase(
        nome: 'Cadeira Abdutora',
        descricao: 'Enfase em gluteo medio e estabilidade de quadril.',
        videoId: 'G_8LItOiZ0Q',
      ));
    }

    if (sexo == 'Masculino' && !lowerDay && !nomes.contains('Barra Fixa')) {
      copy.add(const _ExercicioBase(
        nome: 'Barra Fixa',
        descricao: 'Composto para dorsais, biceps e core.',
        videoId: 'eGo4IYlbE5g',
      ));
    }

    return copy;
  }

  _ParametrosObjetivo _parametrosPorObjetivo(String objetivo) {
    switch (objetivo) {
      case 'Forca':
        return const _ParametrosObjetivo(
          series: 5,
          repeticoes: '4-6',
          intervaloMin: 3,
          cargaSugerida: '80-90% 1RM',
        );
      case 'Emagrecimento':
        return const _ParametrosObjetivo(
          series: 3,
          repeticoes: '12-15',
          intervaloMin: 1,
          cargaSugerida: '55-70% 1RM',
        );
      case 'Resistencia':
        return const _ParametrosObjetivo(
          series: 3,
          repeticoes: '15-20',
          intervaloMin: 1,
          cargaSugerida: '50-65% 1RM',
        );
      default:
        return const _ParametrosObjetivo(
          series: 4,
          repeticoes: '8-12',
          intervaloMin: 2,
          cargaSugerida: '65-80% 1RM',
        );
    }
  }

  String _nomeSugeridoTreino(int dias, int dia) {
    String baseNome;
    if (dias == 2) {
      baseNome = dia == 1 ? 'Full Body A' : 'Full Body B';
    } else if (dias == 3) {
      baseNome = dia == 1
          ? 'Push'
          : dia == 2
              ? 'Pull'
              : 'Legs';
    } else if (dias == 4) {
      baseNome = dia == 1
          ? 'Upper A'
          : dia == 2
              ? 'Lower A'
              : dia == 3
                  ? 'Upper B'
                  : 'Lower B';
    } else {
      baseNome = dia == 1
          ? 'Push'
          : dia == 2
              ? 'Pull'
              : dia == 3
                  ? 'Legs'
                  : dia == 4
                      ? 'Upper'
                      : 'Lower';
    }
    return '$baseNome - $_objetivoSelecionado';
  }

  void _salvarTreino() {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('De um nome para o treino!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_exercicios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos um exercicio!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'titulo': _nomeController.text.trim(),
      'cor': _corSelecionada,
      'exercicios': List<Map<String, dynamic>>.from(_exercicios),
      'diasPorSemana': _diasPorSemana,
      'diaSelecionado': _diaSelecionado,
      'sexo': _sexoSelecionado,
      'objetivo': _objetivoSelecionado,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppTheme.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Novo treino', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          TextButton(
            onPressed: _salvarTreino,
            child: const Text(
              'Salvar',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome do treino', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Ex: Push - Hipertrofia',
                prefixIcon: Icon(
                  Icons.fitness_center_rounded,
                  color: AppTheme.grey,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Geracao automatica',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: _diasPorSemana,
                    decoration: const InputDecoration(
                      labelText: 'Dias de treino por semana',
                    ),
                    items: _diasOpcoes
                        .map(
                          (dias) => DropdownMenuItem<int>(
                            value: dias,
                            child: Text('$dias dias'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _diasPorSemana = value;
                        if (_diaSelecionado > _diasPorSemana) {
                          _diaSelecionado = _diasPorSemana;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: _diaSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Dia do plano semanal',
                    ),
                    items: List.generate(_diasPorSemana, (index) => index + 1)
                        .map(
                          (dia) => DropdownMenuItem<int>(
                            value: dia,
                            child: Text('Dia $dia'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _diaSelecionado = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _sexoSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Sexo',
                    ),
                    items: _sexos
                        .map(
                          (sexo) => DropdownMenuItem<String>(
                            value: sexo,
                            child: Text(sexo),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _sexoSelecionado = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _objetivoSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Objetivo',
                    ),
                    items: _objetivos
                        .map(
                          (objetivo) => DropdownMenuItem<String>(
                            value: objetivo,
                            child: Text(objetivo),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _objetivoSelecionado = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _gerarTreinoAutomatico,
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: const Text('Gerar treino automatico'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Cor do treino', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: _cores.map((cor) {
                final selecionada = _corSelecionada == cor;
                return GestureDetector(
                  onTap: () => setState(() => _corSelecionada = cor),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12),
                    width: selecionada ? 40 : 32,
                    height: selecionada ? 40 : 32,
                    decoration: BoxDecoration(
                      color: cor,
                      shape: BoxShape.circle,
                      border:
                          selecionada ? Border.all(color: Colors.white, width: 2) : null,
                    ),
                    child: selecionada
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exercicios', style: Theme.of(context).textTheme.titleLarge),
                TextButton.icon(
                  onPressed: _adicionarExercicio,
                  icon: const Icon(Icons.add_rounded, color: AppTheme.primary, size: 20),
                  label: const Text(
                    'Adicionar',
                    style: TextStyle(color: AppTheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_exercicios.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.add_circle_outline_rounded, color: AppTheme.grey, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Nenhum exercicio ainda',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Use "Gerar treino automatico" ou toque em "Adicionar".',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _exercicios.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = _exercicios.removeAt(oldIndex);
                    _exercicios.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) {
                  final ex = _exercicios[index];
                  return Container(
                    key: ValueKey(index),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _corSelecionada.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: _corSelecionada,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ex['nome'], style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text(
                                '${ex['series']}x${ex['repeticoes']}  •  ${ex['carga']}  •  ${ex['intervalo']}min',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _removerExercicio(index),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                        ),
                        const Icon(Icons.drag_handle_rounded, color: AppTheme.grey, size: 20),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvarTreino,
              style: ElevatedButton.styleFrom(
                backgroundColor: _corSelecionada,
              ),
              child: const Text('Salvar treino'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ModalExercicio extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdicionar;

  const _ModalExercicio({required this.onAdicionar});

  @override
  State<_ModalExercicio> createState() => _ModalExercicioState();
}

class _ModalExercicioState extends State<_ModalExercicio> {
  final _nomeController = TextEditingController();
  final _cargaController = TextEditingController(text: '20kg');
  final _descricaoController = TextEditingController();
  int _series = 3;
  int _repeticoes = 12;
  int _intervalo = 1;

  @override
  void dispose() {
    _nomeController.dispose();
    _cargaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _adicionar() {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome do exercicio!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    widget.onAdicionar({
      'nome': _nomeController.text.trim(),
      'descricao': _descricaoController.text.trim().isEmpty
          ? 'Execute o movimento com controle e foco na musculatura alvo.'
          : _descricaoController.text.trim(),
      'series': _series,
      'repeticoes': '$_repeticoes',
      'carga': _cargaController.text.trim().isEmpty ? 'Carga livre' : _cargaController.text.trim(),
      'intervalo': _intervalo,
      'videoId': 'dQw4w9WgXcQ',
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Adicionar exercicio', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            TextField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Nome do exercicio',
                prefixIcon: Icon(Icons.fitness_center_rounded, color: AppTheme.grey),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                hintText: 'Descricao (opcional)',
                prefixIcon: Icon(Icons.description_outlined, color: AppTheme.grey),
              ),
            ),
            const SizedBox(height: 20),
            _Contador(
              label: 'Series',
              valor: _series,
              onMenos: () => setState(() => _series = (_series - 1).clamp(1, 10)),
              onMais: () => setState(() => _series = (_series + 1).clamp(1, 10)),
            ),
            const SizedBox(height: 12),
            _Contador(
              label: 'Repeticoes',
              valor: _repeticoes,
              onMenos: () =>
                  setState(() => _repeticoes = (_repeticoes - 1).clamp(1, 50)),
              onMais: () =>
                  setState(() => _repeticoes = (_repeticoes + 1).clamp(1, 50)),
            ),
            const SizedBox(height: 12),
            _Contador(
              label: 'Intervalo (min)',
              valor: _intervalo,
              onMenos: () =>
                  setState(() => _intervalo = (_intervalo - 1).clamp(1, 10)),
              onMais: () =>
                  setState(() => _intervalo = (_intervalo + 1).clamp(1, 10)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cargaController,
              decoration: const InputDecoration(
                hintText: 'Carga (ex: 20kg, Peso corporal)',
                prefixIcon: Icon(Icons.monitor_weight_outlined, color: AppTheme.grey),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _adicionar,
              child: const Text('Adicionar exercicio'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Contador extends StatelessWidget {
  final String label;
  final int valor;
  final VoidCallback onMenos;
  final VoidCallback onMais;

  const _Contador({
    required this.label,
    required this.valor,
    required this.onMenos,
    required this.onMais,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          IconButton(
            onPressed: onMenos,
            icon: const Icon(Icons.remove_circle_outline_rounded, color: AppTheme.primary),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$valor',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: onMais,
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}

class _ExercicioBase {
  final String nome;
  final String descricao;
  final String videoId;

  const _ExercicioBase({
    required this.nome,
    required this.descricao,
    required this.videoId,
  });
}

class _ParametrosObjetivo {
  final int series;
  final String repeticoes;
  final int intervaloMin;
  final String cargaSugerida;

  const _ParametrosObjetivo({
    required this.series,
    required this.repeticoes,
    required this.intervaloMin,
    required this.cargaSugerida,
  });
}
