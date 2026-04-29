import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme_utils.dart';

class NutricaoScreen extends StatefulWidget {
  const NutricaoScreen({super.key});

  @override
  State<NutricaoScreen> createState() => _NutricaoScreenState();
}

class _NutricaoScreenState extends State<NutricaoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dados do dia
  int _caloriasConsumidas = 1240;
  final int _caloriasAlvo = 2200;
  final int _streakDieta = 4;

  // Refeições do dia
  final List<Map<String, dynamic>> _refeicoes = [
    {
      'nome': 'Café da manhã',
      'icone': '☕',
      'horario': '07:30',
      'calorias': 420,
      'alimentos': ['Ovos mexidos', 'Pão integral', 'Banana', 'Café preto'],
      'concluida': true,
    },
    {
      'nome': 'Almoço',
      'icone': '🍽️',
      'horario': '12:00',
      'calorias': 680,
      'alimentos': ['Frango grelhado', 'Arroz integral', 'Feijão', 'Salada'],
      'concluida': true,
    },
    {
      'nome': 'Lanche',
      'icone': '🍎',
      'horario': '15:30',
      'calorias': 140,
      'alimentos': ['Whey protein', 'Maçã'],
      'concluida': false,
    },
    {
      'nome': 'Jantar',
      'icone': '🌙',
      'horario': '19:00',
      'calorias': 580,
      'alimentos': ['Salmão', 'Batata doce', 'Brócolis'],
      'concluida': false,
    },
  ];

  // Macros
  final Map<String, dynamic> _macros = {
    'proteina': {'consumido': 85, 'alvo': 150, 'cor': const Color(0xFFFF3E7D)},
    'carboidrato': {'consumido': 140, 'alvo': 250, 'cor': const Color(0xFF7C3AED)},
    'gordura': {'consumido': 42, 'alvo': 70, 'cor': const Color(0xFF059669)},
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _progresso => _caloriasConsumidas / _caloriasAlvo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Nutrição',
            style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
            onPressed: _abrirDicas,
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF059669),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tips_and_updates_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF059669),
          labelColor: const Color(0xFF059669),
          unselectedLabelColor: context.subtitleColor,
          tabs: const [
            Tab(text: 'Hoje'),
            Tab(text: 'Histórico'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AbaHoje(
            caloriasConsumidas: _caloriasConsumidas,
            caloriasAlvo: _caloriasAlvo,
            progresso: _progresso,
            streakDieta: _streakDieta,
            refeicoes: _refeicoes,
            macros: _macros,
            onToggleRefeicao: (index) {
              setState(() {
                final concluida =
                    _refeicoes[index]['concluida'] as bool;
                _refeicoes[index]['concluida'] = !concluida;
                if (!concluida) {
                  _caloriasConsumidas +=
                      _refeicoes[index]['calorias'] as int;
                } else {
                  _caloriasConsumidas -=
                      _refeicoes[index]['calorias'] as int;
                }
              });
            },
            onAdicionarAlimento: _abrirAdicionarAlimento,
          ),
          _AbaHistorico(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirConsultaNutricionista,
        backgroundColor: const Color(0xFF059669),
        icon: const Icon(Icons.calendar_month_rounded,
            color: Colors.white),
        label: const Text(
          'Consultar nutricionista',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _abrirDicas() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text('🥗', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('Dica do dia',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              'Você está indo muito bem! Lembre-se de beber pelo menos 2 litros de água hoje. A hidratação é fundamental para o desempenho nos treinos e na recuperação muscular! 💪',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
              ),
              child: const Text('Entendido!'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _abrirAdicionarAlimento(int refeicaoIndex) {
    final nomeController = TextEditingController();
    final caloriasController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text(
              'Adicionar alimento — ${_refeicoes[refeicaoIndex]['nome']}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                hintText: 'Nome do alimento',
                prefixIcon: Icon(Icons.restaurant_rounded,
                    color: AppTheme.grey),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: caloriasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Calorias (kcal)',
                prefixIcon:
                    Icon(Icons.local_fire_department_rounded,
                        color: AppTheme.grey),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nomeController.text.isNotEmpty) {
                  setState(() {
                    (_refeicoes[refeicaoIndex]['alimentos']
                            as List)
                        .add(nomeController.text);
                    if (caloriasController.text.isNotEmpty) {
                      _refeicoes[refeicaoIndex]['calorias'] =
                          (_refeicoes[refeicaoIndex]['calorias']
                                  as int) +
                              int.parse(caloriasController.text);
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alimento adicionado! 🥗'),
                      backgroundColor: Color(0xFF059669),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
              ),
              child: const Text('Adicionar'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _abrirConsultaNutricionista() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text('📱', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('Agendar consulta',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Fale com um dos nossos nutricionistas da Patrique Fitness pelo WhatsApp!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chat_rounded),
              label: const Text('Abrir WhatsApp'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Agora não',
                  style:
                      TextStyle(color: context.subtitleColor)),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ABA HOJE
class _AbaHoje extends StatelessWidget {
  final int caloriasConsumidas;
  final int caloriasAlvo;
  final double progresso;
  final int streakDieta;
  final List<Map<String, dynamic>> refeicoes;
  final Map<String, dynamic> macros;
  final Function(int) onToggleRefeicao;
  final Function(int) onAdicionarAlimento;

  const _AbaHoje({
    required this.caloriasConsumidas,
    required this.caloriasAlvo,
    required this.progresso,
    required this.streakDieta,
    required this.refeicoes,
    required this.macros,
    required this.onToggleRefeicao,
    required this.onAdicionarAlimento,
  });

  @override
  Widget build(BuildContext context) {
    final restantes = caloriasAlvo - caloriasConsumidas;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card principal de calorias
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Calorias hoje',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          '$caloriasConsumidas',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'de $caloriasAlvo kcal',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('🔥',
                            style: TextStyle(fontSize: 32)),
                        Text(
                          '$streakDieta dias',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const Text('streak dieta',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progresso.clamp(0.0, 1.0),
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      restantes > 0
                          ? '$restantes kcal restantes'
                          : 'Meta atingida! 🎉',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '${(progresso * 100).toInt()}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Macros
          Text('Macronutrientes',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CardMacro(
                  nome: 'Proteína',
                  consumido: macros['proteina']['consumido'] as int,
                  alvo: macros['proteina']['alvo'] as int,
                  cor: macros['proteina']['cor'] as Color,
                  unidade: 'g',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CardMacro(
                  nome: 'Carbo',
                  consumido:
                      macros['carboidrato']['consumido'] as int,
                  alvo: macros['carboidrato']['alvo'] as int,
                  cor: macros['carboidrato']['cor'] as Color,
                  unidade: 'g',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CardMacro(
                  nome: 'Gordura',
                  consumido: macros['gordura']['consumido'] as int,
                  alvo: macros['gordura']['alvo'] as int,
                  cor: macros['gordura']['cor'] as Color,
                  unidade: 'g',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Refeições
          Text('Refeições de hoje',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          ...refeicoes.asMap().entries.map((entry) {
            final i = entry.key;
            final refeicao = entry.value;
            final concluida = refeicao['concluida'] as bool;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: concluida
                    ? Border.all(
                        color: const Color(0xFF059669)
                            .withValues(alpha: 0.4))
                    : null,
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Text(refeicao['icone'],
                      style: const TextStyle(fontSize: 28)),
                  title: Text(refeicao['nome'],
                      style:
                          Theme.of(context).textTheme.titleMedium),
                  subtitle: Text(
                    '${refeicao['calorias']} kcal · ${refeicao['horario']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: GestureDetector(
                    onTap: () => onToggleRefeicao(i),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: concluida
                            ? const Color(0xFF059669)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: concluida
                              ? const Color(0xFF059669)
                              : AppTheme.grey,
                          width: 2,
                        ),
                      ),
                      child: concluida
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16, 0, 16, 12),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          ...( refeicao['alimentos'] as List)
                              .map((alimento) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 4),
                                    child: Row(
                                      children: [
                                        const Icon(
                                            Icons.circle,
                                            size: 6,
                                            color: Color(0xFF059669)),
                                        const SizedBox(width: 8),
                                        Text(alimento.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ],
                                    ),
                                  )),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () =>
                                onAdicionarAlimento(i),
                            icon: const Icon(
                                Icons.add_circle_outline_rounded,
                                color: Color(0xFF059669),
                                size: 18),
                            label: const Text(
                              'Adicionar alimento',
                              style: TextStyle(
                                  color: Color(0xFF059669)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

// ABA HISTÓRICO
class _AbaHistorico extends StatelessWidget {
  final List<Map<String, dynamic>> _historico = const [
    {
      'data': 'Hoje',
      'calorias': 1240,
      'alvo': 2200,
      'concluido': false
    },
    {
      'data': 'Ontem',
      'calorias': 2180,
      'alvo': 2200,
      'concluido': true
    },
    {
      'data': 'Seg, 21 Abr',
      'calorias': 2050,
      'alvo': 2200,
      'concluido': true
    },
    {
      'data': 'Dom, 20 Abr',
      'calorias': 1950,
      'alvo': 2200,
      'concluido': true
    },
    {
      'data': 'Sáb, 19 Abr',
      'calorias': 2300,
      'alvo': 2200,
      'concluido': false
    },
    {
      'data': 'Sex, 18 Abr',
      'calorias': 2150,
      'alvo': 2200,
      'concluido': true
    },
    {
      'data': 'Qui, 17 Abr',
      'calorias': 1980,
      'alvo': 2200,
      'concluido': true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _historico.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final dia = _historico[index];
        final concluido = dia['concluido'] as bool;
        final calorias = dia['calorias'] as int;
        final alvo = dia['alvo'] as int;
        final pct = (calorias / alvo * 100).toInt();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: concluido
                ? Border.all(
                    color: const Color(0xFF059669).withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: concluido
                      ? const Color(0xFF059669).withValues(alpha: 0.15)
                      : AppTheme.grey.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    concluido ? '✅' : '❌',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dia['data'].toString(),
                        style:
                            Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      '$calorias / $alvo kcal ($pct%)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (calorias / alvo).clamp(0.0, 1.0),
                        backgroundColor:
                            AppTheme.grey.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          concluido
                              ? const Color(0xFF059669)
                              : AppTheme.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// WIDGETS AUXILIARES
class _CardMacro extends StatelessWidget {
  final String nome;
  final int consumido;
  final int alvo;
  final Color cor;
  final String unidade;

  const _CardMacro({
    required this.nome,
    required this.consumido,
    required this.alvo,
    required this.cor,
    required this.unidade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: context.isDark
          ? null
          : Border.all(color: cor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            nome,
            style: TextStyle(
              color: context.subtitleColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$consumido$unidade',
            style: TextStyle(
              color: cor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'de $alvo$unidade',
            style: TextStyle(
              color: context.subtitleColor,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (consumido / alvo).clamp(0.0, 1.0),
              backgroundColor: cor.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(cor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}