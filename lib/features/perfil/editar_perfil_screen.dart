import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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

  String _toDbObjetivo(String value) {
    final normalized = _normalizeText(value);
    if (normalized == 'forca') return 'Forca';
    if (normalized == 'resistencia') return 'Resistencia';
    if (normalized == 'saude geral') return 'Saude geral';
    if (normalized == 'emagrecimento') return 'Emagrecimento';
    return 'Hipertrofia';
  }

  String _toDbNivel(String value) {
    final normalized = _normalizeText(value);
    if (normalized == 'avancado') return 'Avancado';
    if (normalized == 'intermediario') return 'Intermediario';
    return 'Iniciante';
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
    final email = prefs.getString('user_email') ?? '';

    if (email.isEmpty) {
      if (!mounted) return;
      setState(() => _carregando = false);
      return;
    }

    try {
      final client = HttpClient();
      final uri = Uri.parse(
        '${_baseUrl()}/user/profile?email=${Uri.encodeComponent(email)}',
      );
      final request = await client.getUrl(uri).timeout(const Duration(seconds: 12));
      final response = await request.close().timeout(const Duration(seconds: 12));
      final responseText = await response.transform(utf8.decoder).join();
      client.close(force: true);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        if (!mounted) return;
        setState(() => _carregando = false);
        return;
      }

      final decoded = jsonDecode(responseText);
      final user = decoded is Map<String, dynamic> ? decoded['user'] : null;
      if (user is! Map<String, dynamic>) {
        if (!mounted) return;
        setState(() => _carregando = false);
        return;
      }

      _nomeController.text = (user['nome'] as String?) ?? '';
      _emailController.text = (user['email'] as String?) ?? '';
      _pesoController.text = user['peso'] == null ? '' : '${user['peso']}';
      _alturaController.text = user['altura'] == null ? '' : '${user['altura']}';
      _fotoPerfilPath = (user['foto_perfil'] as String?)?.trim().isEmpty == true
          ? null
          : user['foto_perfil'] as String?;

      _objetivoSelecionado = _toUiObjetivo(user['objetivo'] as String?);
      _nivelSelecionado = _toUiNivel(user['nivel_experiencia'] as String?);
    } catch (_) {
      // Mantém a tela funcionando mesmo sem resposta do backend.
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
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
      final client = HttpClient();
      final uri = Uri.parse('${_baseUrl()}/user/profile');
      final request = await client.putUrl(uri).timeout(const Duration(seconds: 12));
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.add(
        utf8.encode(
          jsonEncode({
            'email': _emailController.text.trim(),
            'nome': _nomeController.text.trim(),
            'peso': _pesoController.text.trim(),
            'altura': _alturaController.text.trim(),
            'objetivo': _toDbObjetivo(_objetivoSelecionado),
            'nivel_experiencia': _toDbNivel(_nivelSelecionado),
            'foto_perfil': _fotoPerfilPath,
          }),
        ),
      );

      final response = await request.close().timeout(const Duration(seconds: 12));
      final responseText = await response.transform(utf8.decoder).join();
      client.close(force: true);

      final decoded = responseText.isEmpty ? <String, dynamic>{} : jsonDecode(responseText);
      final json = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = (json['message'] as String?) ?? 'Não foi possível salvar o perfil';
        if (!mounted) return;
        setState(() => _carregando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_nome', _nomeController.text.trim());
      await prefs.setString('user_email', _emailController.text.trim());

      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: AppTheme.primary,
        ),
      );
      Navigator.pop(context);
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tempo de conexão esgotado'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } on SocketException {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível conectar ao servidor'),
          backgroundColor: Colors.redAccent,
        ),
      );
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

  String _baseUrl() {
    const envBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }

    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      default:
        return 'http://localhost:3000';
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
