import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme_utils.dart';

class AmigosScreen extends StatefulWidget {
  const AmigosScreen({super.key});

  @override
  State<AmigosScreen> createState() => _AmigosScreenState();
}

class _AmigosScreenState extends State<AmigosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _buscaController = TextEditingController();

  // Dados simulados de amigos
  final List<Map<String, dynamic>> _amigos = [
    {
      'nome': 'Ana Silva',
      'usuario': '@anasilva',
      'streak': 15,
      'treinos': 42,
      'avatar': '👩🏻',
      'online': true,
      'nivel': 'Avançado',
    },
    {
      'nome': 'Carlos Mendes',
      'usuario': '@carlosmendes',
      'streak': 8,
      'treinos': 28,
      'avatar': '👨🏾‍🦱',
      'online': false,
      'nivel': 'Intermediário',
    },
    {
      'nome': 'Beatriz Costa',
      'usuario': '@beatrizcosta',
      'streak': 21,
      'treinos': 65,
      'avatar': '👱🏻‍♀️',
      'online': true,
      'nivel': 'Avançado',
    },
    {
      'nome': 'Diego Rocha',
      'usuario': '@diegorocha',
      'streak': 3,
      'treinos': 12,
      'avatar': '👴🏻',
      'online': false,
      'nivel': 'Iniciante',
    },
    {
      'nome': 'Fernanda Lima',
      'usuario': '@fernandalima',
      'streak': 7,
      'treinos': 19,
      'avatar': '👩🏽‍🦱',
      'online': true,
      'nivel': 'Intermediário',
    },
  ];

  // Ranking semanal
  List<Map<String, dynamic>> get _rankingSemanal {
    final ranking = [
      {'nome': 'Você', 'usuario': '@fulano', 'pontos': 850, 'avatar': '👨🏻'},
      ..._amigos.map((a) => {
            'nome': a['nome'],
            'usuario': a['usuario'],
            'pontos': (a['streak'] as int) * 50 + (a['treinos'] as int) * 10,
            'avatar': a['avatar'],
          }),
    ];
    ranking.sort((a, b) =>
        (b['pontos'] as int).compareTo(a['pontos'] as int));
    return ranking;
  }

  // Desafios
  final List<Map<String, dynamic>> _desafios = [
    {
      'titulo': 'Rei do Streak',
      'descricao': 'Quem mantiver o maior streak da semana vence',
      'premio': '🏆 500 pts',
      'encerra': '3 dias',
      'participantes': 5,
      'tipo': 'semanal',
    },
    {
      'titulo': 'Maratonista',
      'descricao': 'Complete 20 treinos no mês',
      'premio': '🥇 1000 pts',
      'encerra': '12 dias',
      'participantes': 5,
      'tipo': 'mensal',
    },
    {
      'titulo': 'Consistência',
      'descricao': 'Treine pelo menos 5 dias essa semana',
      'premio': '⭐ 300 pts',
      'encerra': '2 dias',
      'participantes': 4,
      'tipo': 'semanal',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _buscaController.dispose();
    super.dispose();
  }

  void _adicionarAmigo() {
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
            Text('Adicionar amigo',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _buscaController,
              decoration: const InputDecoration(
                hintText: 'Buscar por nome ou @usuario',
                prefixIcon:
                    Icon(Icons.search_rounded, color: AppTheme.grey),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Solicitação enviada!'),
                    backgroundColor: AppTheme.primary,
                  ),
                );
              },
              child: const Text('Enviar solicitação'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _verPerfil(Map<String, dynamic> amigo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PerfilAmigoScreen(amigo: amigo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Amigos',
            style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
            onPressed: _adicionarAmigo,
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_add_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: context.subtitleColor,
          tabs: const [
            Tab(text: 'Amigos'),
            Tab(text: 'Ranking'),
            Tab(text: 'Desafios'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AbaAmigos(amigos: _amigos, onVerPerfil: _verPerfil),
          _AbaRanking(ranking: _rankingSemanal),
          _AbaDesafios(desafios: _desafios),
        ],
      ),
    );
  }
}

// ABA AMIGOS
class _AbaAmigos extends StatelessWidget {
  final List<Map<String, dynamic>> amigos;
  final Function(Map<String, dynamic>) onVerPerfil;

  const _AbaAmigos({required this.amigos, required this.onVerPerfil});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: amigos.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final amigo = amigos[index];
        return GestureDetector(
          onTap: () => onVerPerfil(amigo),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: (amigo['online'] as bool)
                  ? Border.all(
                      color: AppTheme.primary.withValues(
                        alpha: context.isDark ? 0.3 : 0.2),
                      width: 1.5,)
                  : Border.all(
                      color: context.isDark
                          ? Colors.transparent
                          : const Color(0xFFEEEEEE),
                  )
            ),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(amigo['avatar'],
                            style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    if (amigo['online'] as bool)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: context.cardColor, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Infos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(amigo['nome'],
                          style:
                              Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(amigo['usuario'],
                          style:
                              Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _PillInfo(
                            texto: '🔥 ${amigo['streak']} dias',
                          ),
                          const SizedBox(width: 8),
                          _PillInfo(
                            texto: '💪 ${amigo['treinos']} treinos',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.arrow_forward_ios_rounded,
                    color: AppTheme.grey, size: 14),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ABA RANKING
class _AbaRanking extends StatelessWidget {
  final List<Map<String, dynamic>> ranking;

  const _AbaRanking({required this.ranking});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pódio top 3
          if (ranking.length >= 3) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text('🏆 Ranking Semanal',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 2º lugar
                      _PodioItem(
                        posicao: 2,
                        nome: ranking[1]['nome'].toString().split(' ')[0],
                        avatar: ranking[1]['avatar'].toString(),
                        pontos: ranking[1]['pontos'] as int,
                        altura: 80,
                        medalha: '🥈',
                      ),
                      // 1º lugar
                      _PodioItem(
                        posicao: 1,
                        nome: ranking[0]['nome'].toString().split(' ')[0],
                        avatar: ranking[0]['avatar'].toString(),
                        pontos: ranking[0]['pontos'] as int,
                        altura: 110,
                        medalha: '🥇',
                      ),
                      // 3º lugar
                      _PodioItem(
                        posicao: 3,
                        nome: ranking[2]['nome'].toString().split(' ')[0],
                        avatar: ranking[2]['avatar'].toString(),
                        pontos: ranking[2]['pontos'] as int,
                        altura: 60,
                        medalha: '🥉',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Lista completa
          Text('Classificação completa',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),

          ...ranking.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            final isVoce = item['nome'] == 'Você';

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isVoce
                    ? AppTheme.primary.withValues(alpha: 0.15)
                    : context.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: isVoce
                    ? Border.all(color: AppTheme.primary)
                    : null,
              ),
              child: Row(
                children: [
                  // Posição
                  SizedBox(
                    width: 32,
                    child: Text(
                      i < 3
                          ? ['🥇', '🥈', '🥉'][i]
                          : '${i + 1}º',
                      style: TextStyle(
                        fontSize: i < 3 ? 20 : 14,
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(item['avatar'].toString(),
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['nome'].toString() +
                              (isVoce ? ' (você)' : ''),
                          style:
                              Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(item['usuario'].toString(),
                            style:
                                Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Text(
                    '${item['pontos']} pts',
                    style: TextStyle(
                      color: isVoce
                          ? AppTheme.primary
                          : context.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ABA DESAFIOS
class _AbaDesafios extends StatelessWidget {
  final List<Map<String, dynamic>> desafios;

  const _AbaDesafios({required this.desafios});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: desafios.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final desafio = desafios[index];
        final isSemanal = desafio['tipo'] == 'semanal';

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSemanal
                  ? AppTheme.primary.withValues(alpha: 0.3)
                  : const Color(0xFF7C3AED).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(desafio['titulo'],
                        style:
                            Theme.of(context).textTheme.titleLarge),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSemanal
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : const Color(0xFF7C3AED).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isSemanal ? 'Semanal' : 'Mensal',
                      style: TextStyle(
                        color: isSemanal
                            ? AppTheme.primary
                            : const Color(0xFF7C3AED),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(desafio['descricao'],
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _PillInfo(texto: desafio['premio']),
                  _PillInfo(texto: '⏰ Encerra em ${desafio['encerra']}'),
                  _PillInfo(texto: '👥 ${desafio['participantes']} participantes'),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Você entrou no desafio "${desafio['titulo']}"!'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isSemanal
                        ? AppTheme.primary
                        : const Color(0xFF7C3AED),
                    side: BorderSide(
                      color: isSemanal
                          ? AppTheme.primary
                          : const Color(0xFF7C3AED),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Participar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// TELA DE PERFIL DO AMIGO
class _PerfilAmigoScreen extends StatelessWidget {
  final Map<String, dynamic> amigo;

  const _PerfilAmigoScreen({required this.amigo});

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
        title: Text(amigo['nome'],
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(amigo['avatar'],
                    style: const TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 12),
            Text(amigo['nome'],
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(amigo['usuario'],
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primary),
              ),
              child: Text(
                amigo['nivel'],
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Estatísticas
            Row(
              children: [
                Expanded(
                  child: _CardEstatAmigo(
                    emoji: '🔥',
                    valor: '${amigo['streak']}',
                    label: 'Streak atual',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CardEstatAmigo(
                    emoji: '💪',
                    valor: '${amigo['treinos']}',
                    label: 'Treinos totais',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CardEstatAmigo(
                    emoji: amigo['online'] ? '🟢' : '🔴',
                    valor: amigo['online'] ? 'Online' : 'Offline',
                    label: 'Status',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Treinos favoritos
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Treinos favoritos',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 12),
            _ItemTreino(
                context: context, nome: 'Peito e Tríceps', vezes: 18),
            const SizedBox(height: 8),
            _ItemTreino(
                context: context, nome: 'Costas e Bíceps', vezes: 14),
            const SizedBox(height: 8),
            _ItemTreino(
                context: context, nome: 'Pernas e Ombros', vezes: 10),

            const SizedBox(height: 28),

            // Botão desafiar
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Desafio enviado para ${amigo['nome']}!'),
                    backgroundColor: AppTheme.primary,
                  ),
                );
              },
              icon: const Icon(Icons.emoji_events_rounded),
              label: const Text('Desafiar para um duelo'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _ItemTreino({
      required BuildContext context,
      required String nome,
      required int vezes}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.fitness_center_rounded,
              color: AppTheme.primary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(nome,
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          Text('$vezes x',
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}

// WIDGETS AUXILIARES
class _PillInfo extends StatelessWidget {
  final String texto;

  const _PillInfo({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,    
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: AppTheme.primary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _PodioItem extends StatelessWidget {
  final int posicao;
  final String nome;
  final String avatar;
  final int pontos;
  final double altura;
  final String medalha;

  const _PodioItem({
    required this.posicao,
    required this.nome,
    required this.avatar,
    required this.pontos,
    required this.altura,
    required this.medalha,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(medalha, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(avatar, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          nome,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        Text(
          '$pontos pts',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: altura,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '$posicao',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardEstatAmigo extends StatelessWidget {
  final String emoji;
  final String valor;
  final String label;

  const _CardEstatAmigo({
    required this.emoji,
    required this.valor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            valor,
            style: TextStyle(
              color: context.textColor,
              fontSize: 16,
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