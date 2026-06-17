import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme_utils.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

  String _objetivoSelecionado = 'Hipertrofia';
  String _nivelSelecionado = 'Intermediário';
  String? _fotoPerfilPath;
  bool _carregando = false;

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
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  String _normalizeText(String value) {
    final lower = value.trim().toLowerCase();
    return lower
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }

  String _toUiObjetivo(String? value) {
    final normalized = _normalizeText(value ?? '');
    if (normalized == 'forca') return 'Força';
    if (normalized == 'resistencia') return 'Resistência';
    if (normalized == 'saude geral') return 'Saúde geral';
    if (normalized == 'emagrecimento') return 'Emagrecimento';
    return 'Hipertrofia';
  }

  String _toUiNivel(String? value) {
    final normalized = _normalizeText(value ?? '');
    if (normalized == 'avancado') return 'Avançado';
    if (normalized == 'intermediario') return 'Intermediário';
    return 'Iniciante';
  }

  Future<void> _editarFotoPerfil() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      allowMultiple: false,
    );

    if (!mounted || result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null || path.trim().isEmpty) return;

    setState(() => _fotoPerfilPath = path);
  }

  Future<void> _carregarPerfil() async {
    setState(() => _carregando = true);

    final prefs = await SharedPreferences.getInstance();
    final foto = prefs.getString('user_foto_perfil');

    _nomeController.text = prefs.getString('user_nome') ?? 'Usuario Patrique';
    _emailController.text = prefs.getString('user_email') ?? 'demo@gmail.com';
    _pesoController.text = prefs.getString('user_peso') ?? '75';
    _alturaController.text = prefs.getString('user_altura') ?? '175';
    _fotoPerfilPath = (foto != null && foto.trim().isNotEmpty) ? foto : null;
    _objetivoSelecionado = _toUiObjetivo(
      prefs.getString('user_objetivo') ?? 'Hipertrofia',
    );
    _nivelSelecionado = _toUiNivel(
      prefs.getString('user_nivel_experiencia') ?? 'Intermediário',
    );

    if (mounted) setState(() => _carregando = false);
  }

  Future<void> _salvar() async {
    if (_nomeController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome e e-mail são obrigatórios'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_nome', _nomeController.text.trim());
      await prefs.setString('user_email', _emailController.text.trim());
      await prefs.setString('user_peso', _pesoController.text.trim());
      await prefs.setString('user_altura', _alturaController.text.trim());
      await prefs.setString('user_objetivo', _objetivoSelecionado);
      await prefs.setString('user_nivel_experiencia', _nivelSelecionado);
      await prefs.setString('user_foto_perfil', _fotoPerfilPath ?? '');

      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: AppTheme.primary,
        ),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao atualizar perfil'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: context.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Editar perfil', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          TextButton(
            onPressed: _carregando ? null : _salvar,
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
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _editarFotoPerfil,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: (_fotoPerfilPath != null &&
                              _fotoPerfilPath!.isNotEmpty &&
                              File(_fotoPerfilPath!).existsSync())
                          ? Image.file(
                              File(_fotoPerfilPath!),
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _editarFotoPerfil,
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Dados pessoais', style: Theme.of(context).textTheme.titleLarge),
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
              somenteLeitura: true,
            ),
            const SizedBox(height: 32),
            Text('Dados físicos', style: Theme.of(context).textTheme.titleLarge),
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
            Text('Objetivo', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _objetivos.map((obj) {
                final selecionado = _objetivoSelecionado == obj;
                return GestureDetector(
                  onTap: () => setState(() => _objetivoSelecionado = obj),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selecionado
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : context.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selecionado ? AppTheme.primary : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      obj,
                      style: TextStyle(
                        color: selecionado ? AppTheme.primary : context.textColor,
                        fontWeight: selecionado ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Text('Nível de experiência', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _niveis.map((nivel) {
                  final selecionado = _nivelSelecionado == nivel;
                  return InkWell(
                    onTap: () => setState(() => _nivelSelecionado = nivel),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              nivel,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          if (selecionado)
                            const Icon(Icons.check_rounded, color: AppTheme.primary, size: 20),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _carregando ? null : _salvar,
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
  final bool somenteLeitura;

  const _Campo({
    required this.label,
    required this.controller,
    required this.icone,
    required this.tipo,
    this.somenteLeitura = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: tipo,
          readOnly: somenteLeitura,
          decoration: InputDecoration(
            prefixIcon: Icon(icone, color: context.subtitleColor),
          ),
        ),
      ],
    );
  }
}
