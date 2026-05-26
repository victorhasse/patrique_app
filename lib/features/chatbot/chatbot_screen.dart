import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme_utils.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _mensagemController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _mensagens = [
    {
      'texto': 'Ola! Eu sou o PatriqueBot.\nComo posso te ajudar hoje?',
      'isBot': true,
    },
  ];

  bool _carregandoResposta = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _enviarOpcao('inicio', mostrarMensagemUsuario: false);
    });
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _enviarOpcao(
    String opcao, {
    bool mostrarMensagemUsuario = true,
    String? textoUsuario,
  }) async {
    if (_carregandoResposta) return;

    setState(() {
      if (mostrarMensagemUsuario) {
        _mensagens.add({'texto': textoUsuario ?? opcao, 'isBot': false});
      }
      _carregandoResposta = true;
    });
    _rolarParaBaixo();

    final resposta = await _buscarResposta(opcao);
    if (!mounted) return;

    setState(() {
      _carregandoResposta = false;
      _mensagens.add({
        'texto': resposta?.mensagem ??
            'Nao consegui responder agora. Tente novamente em alguns segundos.',
        'isBot': true,
        'opcoes': resposta?.opcoes ?? const ['Voltar ao inicio'],
      });
    });
    _rolarParaBaixo();
  }

  Future<void> _enviarTextoLivre() async {
    final texto = _mensagemController.text.trim();
    if (texto.isEmpty) return;
    _mensagemController.clear();

    final opcaoRelacionada = _opcaoMaisProximaPara(texto);
    await _enviarOpcao(
      opcaoRelacionada ?? texto,
      textoUsuario: texto,
    );
  }

  String? _opcaoMaisProximaPara(String textoDigitado) {
    final textoNormalizado = _normalizarTexto(textoDigitado);
    if (textoNormalizado.isEmpty) return null;

    List<dynamic>? opcoes;
    for (var i = _mensagens.length - 1; i >= 0; i--) {
      final atual = _mensagens[i];
      if (atual['isBot'] == true && atual['opcoes'] is List<dynamic>) {
        opcoes = atual['opcoes'] as List<dynamic>;
        break;
      }
    }

    if (opcoes == null || opcoes.isEmpty) return null;

    final opcoesTexto = opcoes.map((e) => e.toString()).toList();

    // 1) Match exato (mais seguro)
    for (final opcao in opcoesTexto) {
      if (_normalizarTexto(opcao) == textoNormalizado) {
        return opcao;
      }
    }

    // 2) Atalho por indice (ex.: "1", "opcao 2", "terceira")
    final index = _indexFromShortcut(textoNormalizado);
    if (index != null && index >= 0 && index < opcoesTexto.length) {
      return opcoesTexto[index];
    }

    // Fora desses casos, envia texto livre para o backend interpretar.
    return null;
  }

  int? _indexFromShortcut(String normalizedInput) {
    const directMap = <String, int>{
      '1': 0,
      'opcao 1': 0,
      'primeira': 0,
      'primeira opcao': 0,
      '2': 1,
      'opcao 2': 1,
      'segunda': 1,
      'segunda opcao': 1,
      '3': 2,
      'opcao 3': 2,
      'terceira': 2,
      'terceira opcao': 2,
      '4': 3,
      'opcao 4': 3,
      'quarta': 3,
      'quarta opcao': 3,
      '5': 4,
      'opcao 5': 4,
      'quinta': 4,
      'quinta opcao': 4,
    };

    return directMap[normalizedInput];
  }

  String _normalizarTexto(String valor) {
    final lower = valor.trim().toLowerCase();
    final buffer = StringBuffer();

    for (final rune in lower.runes) {
      buffer.write(_asciiForRune(rune));
    }

    return buffer.toString().replaceAll(RegExp(r'[^\w\s]'), '').trim();
  }

  String _asciiForRune(int rune) {
    switch (rune) {
      case 225:
      case 224:
      case 226:
      case 227:
      case 228:
        return 'a';
      case 233:
      case 232:
      case 234:
      case 235:
        return 'e';
      case 237:
      case 236:
      case 238:
      case 239:
        return 'i';
      case 243:
      case 242:
      case 244:
      case 245:
      case 246:
        return 'o';
      case 250:
      case 249:
      case 251:
      case 252:
        return 'u';
      case 231:
        return 'c';
      default:
        return String.fromCharCode(rune);
    }
  }

  Future<_RespostaChatbot?> _buscarResposta(String opcao) async {
    final prefs = await SharedPreferences.getInstance();
    final token = (prefs.getString('auth_token') ?? '').trim();

    if (token.isEmpty) {
      _mostrarErro('Sessao expirada. Faca login novamente.');
      return null;
    }

    final client = HttpClient();
    try {
      final uri = Uri.parse('${_baseUrl()}/chatbot/reply');
      final request = await client.postUrl(uri).timeout(const Duration(seconds: 12));
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      request.add(utf8.encode(jsonEncode({'option': opcao})));

      final response = await request.close().timeout(const Duration(seconds: 12));
      final responseText = await response.transform(utf8.decoder).join();
      final decoded = responseText.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(responseText);
      final json = decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final mensagem = (json['mensagem'] is String)
            ? (json['mensagem'] as String).trim()
            : '';
        final opcoesRaw = json['opcoes'];
        final opcoes = opcoesRaw is List
            ? opcoesRaw.map((item) => item.toString()).toList()
            : <String>[];

        return _RespostaChatbot(
          mensagem:
              mensagem.isEmpty ? 'Recebi uma resposta vazia do servidor.' : mensagem,
          opcoes: opcoes,
        );
      }

      final mensagemErro = (json['message'] is String &&
              (json['message'] as String).trim().isNotEmpty)
          ? (json['message'] as String)
          : _mensagemPorStatus(response.statusCode);
      _mostrarErro(mensagemErro);
      return null;
    } on TimeoutException {
      _mostrarErro('Tempo de conexao esgotado');
      return null;
    } on SocketException {
      _mostrarErro('Nao foi possivel conectar ao servidor');
      return null;
    } catch (_) {
      _mostrarErro('Erro ao conversar com o chatbot');
      return null;
    } finally {
      client.close(force: true);
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  String _mensagemPorStatus(int statusCode) {
    if (statusCode == 401) {
      return 'Sessao expirada. Faca login novamente.';
    }
    if (statusCode >= 500) {
      return 'Erro interno do servidor';
    }
    return 'Nao foi possivel obter resposta do chatbot';
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

  void _rolarParaBaixo() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalMensagens = _mensagens.length + (_carregandoResposta ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/patrique_estrela.png',
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PatriqueBot',
                    style: Theme.of(context).textTheme.titleMedium),
                const Text('Online',
                    style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: totalMensagens,
              itemBuilder: (context, index) {
                if (_carregandoResposta && index == totalMensagens - 1) {
                  return const _BolhaMensagem(
                    texto: 'PatriqueBot esta digitando...',
                    isBot: true,
                  );
                }

                final msg = _mensagens[index];
                final isBot = msg['isBot'] as bool;
                final opcoes = msg['opcoes'] as List<dynamic>?;

                return Column(
                  crossAxisAlignment: isBot
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    _BolhaMensagem(
                      texto: msg['texto'] as String,
                      isBot: isBot,
                    ),
                    if (opcoes != null &&
                        index == _mensagens.length - 1 &&
                        !_carregandoResposta) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: opcoes.map((opcao) {
                          return GestureDetector(
                            onTap: () => _enviarOpcao(opcao.toString()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.primary),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                opcao.toString(),
                                style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mensagemController,
                      enabled: !_carregandoResposta,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _enviarTextoLivre(),
                      decoration: const InputDecoration(
                        hintText: 'Digite sua duvida...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                      onPressed: _carregandoResposta ? null : _enviarTextoLivre,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.send_rounded, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BolhaMensagem extends StatelessWidget {
  const _BolhaMensagem({
    required this.texto,
    required this.isBot,
  });

  final String texto;
  final bool isBot;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(
        color: isBot ? AppTheme.surface : AppTheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isBot ? 4 : 16),
          bottomRight: Radius.circular(isBot ? 16 : 4),
        ),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          height: 1.4,
        ),
      ),
    );
  }
}

class _RespostaChatbot {
  const _RespostaChatbot({
    required this.mensagem,
    required this.opcoes,
  });

  final String mensagem;
  final List<String> opcoes;
}
