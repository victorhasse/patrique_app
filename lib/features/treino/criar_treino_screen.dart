import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CriarTreinoScreen extends StatefulWidget {
  const CriarTreinoScreen({super.key});

  @override
  State<CriarTreinoScreen> createState() => _CriarTreinoScreenState();
}

class _CriarTreinoScreenState extends State<CriarTreinoScreen> {
  final _nomeController = TextEditingController();
  final List<Map<String, dynamic>> _exercicios = [];
  Color _corSelecionada = AppTheme.primary;

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
      backgroundColor: AppTheme.surface,
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

  void _salvarTreino() {
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dê um nome para o treino!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_exercicios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos um exercício!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Treino criado com sucesso!'),
        backgroundColor: AppTheme.primary,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppTheme.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Novo treino',
            style: Theme.of(context).textTheme.titleLarge),
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
            // Nome do treino
            Text('Nome do treino',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Ex: Peito e Tríceps',
                prefixIcon: Icon(Icons.fitness_center_rounded,
                    color: AppTheme.grey),
              ),
            ),

            const SizedBox(height: 32),

            // Cor do treino
            Text('Cor do treino',
                style: Theme.of(context).textTheme.titleLarge),
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
                      border: selecionada
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: selecionada
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Exercícios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exercícios',
                    style: Theme.of(context).textTheme.titleLarge),
                TextButton.icon(
                  onPressed: _adicionarExercicio,
                  icon: const Icon(Icons.add_rounded,
                      color: AppTheme.primary, size: 20),
                  label: const Text(
                    'Adicionar',
                    style: TextStyle(color: AppTheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Lista de exercícios
            if (_exercicios.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.add_circle_outline_rounded,
                        color: AppTheme.grey, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Nenhum exercício ainda',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toque em "Adicionar" para incluir exercícios',
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
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Número
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
                        // Infos
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ex['nome'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${ex['series']}x${ex['repeticoes']}  •  ${ex['carga']}  •  ${ex['intervalo']}min',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        // Deletar
                        IconButton(
                          onPressed: () => _removerExercicio(index),
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: Colors.redAccent, size: 20),
                        ),
                        // Arrastar
                        const Icon(Icons.drag_handle_rounded,
                            color: AppTheme.grey, size: 20),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            // Botão salvar
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

// Modal para adicionar exercício
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
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome do exercício!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    widget.onAdicionar({
      'nome': _nomeController.text,
      'descricao': _descricaoController.text.isEmpty
          ? 'Execute o movimento com controle e foco na musculatura alvo.'
          : _descricaoController.text,
      'series': _series,
      'repeticoes': '$_repeticoes',
      'carga': _cargaController.text,
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
            // Handle
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

            Text('Adicionar exercício',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),

            // Nome
            TextField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Nome do exercício',
                prefixIcon: Icon(Icons.fitness_center_rounded,
                    color: AppTheme.grey),
              ),
            ),

            const SizedBox(height: 12),

            // Descrição
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                hintText: 'Descrição (opcional)',
                prefixIcon:
                    Icon(Icons.description_outlined, color: AppTheme.grey),
              ),
            ),

            const SizedBox(height: 20),

            // Séries
            _Contador(
              label: 'Séries',
              valor: _series,
              onMenos: () =>
                  setState(() => _series = (_series - 1).clamp(1, 10)),
              onMais: () =>
                  setState(() => _series = (_series + 1).clamp(1, 10)),
            ),

            const SizedBox(height: 12),

            // Repetições
            _Contador(
              label: 'Repetições',
              valor: _repeticoes,
              onMenos: () => setState(
                  () => _repeticoes = (_repeticoes - 1).clamp(1, 50)),
              onMais: () => setState(
                  () => _repeticoes = (_repeticoes + 1).clamp(1, 50)),
            ),

            const SizedBox(height: 12),

            // Intervalo
            _Contador(
              label: 'Intervalo (min)',
              valor: _intervalo,
              onMenos: () => setState(
                  () => _intervalo = (_intervalo - 1).clamp(1, 10)),
              onMais: () => setState(
                  () => _intervalo = (_intervalo + 1).clamp(1, 10)),
            ),

            const SizedBox(height: 12),

            // Carga
            TextField(
              controller: _cargaController,
              decoration: const InputDecoration(
                hintText: 'Carga (ex: 20kg, Peso corporal)',
                prefixIcon: Icon(Icons.monitor_weight_outlined,
                    color: AppTheme.grey),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _adicionar,
              child: const Text('Adicionar exercício'),
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
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          IconButton(
            onPressed: onMenos,
            icon: const Icon(Icons.remove_circle_outline_rounded,
                color: AppTheme.primary),
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
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}