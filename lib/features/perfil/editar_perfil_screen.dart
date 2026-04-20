import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _nomeController = TextEditingController(text: 'Fulano da Silva');
  final _emailController = TextEditingController(text: 'fulano@email.com');
  final _pesoController = TextEditingController(text: '75');
  final _alturaController = TextEditingController(text: '180');
  String _objetivoSelecionado = 'Hipertrofia';
  String _nivelSelecionado = 'Intermediário';

  final List<String> _objetivos = [
    'Hipertrofia',
    'Emagrecimento',
    'Resistência',
    'Força',
    'Saúde geral',
  ];

  final List<String> _niveis = [
    'Iniciante',
    'Intermediário',
    'Avançado',
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  void _salvar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil atualizado com sucesso!'),
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
        title: Text('Editar perfil',
            style: Theme.of(context).textTheme.titleLarge),
        actions: [
          TextButton(
            onPressed: _salvar,
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
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Dados pessoais
            Text('Dados pessoais',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            _Campo(
              label: 'Nome completo',
              controller: _nomeController,
              icone: Icons.person_outline_rounded,
              tipo: TextInputType.name,
            ),
            const SizedBox(height: 16),
            _Campo(
              label: 'E-mail',
              controller: _emailController,
              icone: Icons.email_outlined,
              tipo: TextInputType.emailAddress,
            ),

            const SizedBox(height: 32),

            // Dados físicos
            Text('Dados físicos',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _Campo(
                    label: 'Peso (kg)',
                    controller: _pesoController,
                    icone: Icons.monitor_weight_outlined,
                    tipo: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _Campo(
                    label: 'Altura (cm)',
                    controller: _alturaController,
                    icone: Icons.height_rounded,
                    tipo: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Objetivo
            Text('Objetivo',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _objetivos.map((obj) {
                final selecionado = _objetivoSelecionado == obj;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _objetivoSelecionado = obj),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selecionado
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selecionado
                            ? AppTheme.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      obj,
                      style: TextStyle(
                        color: selecionado
                            ? AppTheme.primary
                            : AppTheme.white,
                        fontWeight: selecionado
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Nível
            Text('Nível de experiência',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _niveis.map((nivel) {
                  final selecionado = _nivelSelecionado == nivel;
                  return InkWell(
                    onTap: () =>
                        setState(() => _nivelSelecionado = nivel),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              nivel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge,
                            ),
                          ),
                          if (selecionado)
                            const Icon(Icons.check_rounded,
                                color: AppTheme.primary, size: 20),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Botão salvar
            ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar alterações'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Campo extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icone;
  final TextInputType tipo;

  const _Campo({
    required this.label,
    required this.controller,
    required this.icone,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: tipo,
          decoration: InputDecoration(
            prefixIcon: Icon(icone, color: AppTheme.grey),
          ),
        ),
      ],
    );
  }
}