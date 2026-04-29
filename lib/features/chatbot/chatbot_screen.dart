import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme_utils.dart';
import 'chatbot_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _mensagemController = TextEditingController();
  final _scrollController = ScrollController();
  final ChatbotService _service = ChatbotService.instance;
  bool _loading = false;
  String? _userEmail;

  final List<Map<String, dynamic>> _mensagens = [
    {
      'texto': 'Olá! Eu sou o PatriqueBot.\nComo posso te ajudar hoje?',
      'isBot': true,
    },
  ];

  final Map<String, dynamic> _fallbackTree = {
    'inicio': {
      'mensagem': 'Escolha uma opção abaixo:',
      'opcoes': [
        'Dúvidas sobre treino',
        'Nutrição',
        'Descanso e recuperação',
        'Acompanhamento',
      ],
    },
    'Voltar ao início': {
      'mensagem': 'Claro! Como posso te ajudar?',
      'opcoes': [
        'Dúvidas sobre treino',
        'Nutrição',
        'Descanso e recuperação',
        'Acompanhamento',
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _loadUserAndStart();
  }

  Future<void> _loadUserAndStart() async {
    final prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('user_email');
    await _responderOpcao('inicio', exibirMensagemUsuario: false);
  }

  Future<void> _responderOpcao(
    String opcao, {
    bool exibirMensagemUsuario = true,
  }) async {
    if (_loading) return;

    if (exibirMensagemUsuario) {
      setState(() {
        _mensagens.add({'texto': opcao, 'isBot': false});
      });
    }

    setState(() {
      _loading = true;
    });

    final reply = await _service.reply(option: opcao, email: _userEmail);
    if (!mounted) return;

    if (reply != null) {
      setState(() {
        _mensagens.add({
          'texto': reply.mensagem,
          'isBot': true,
          'opcoes': reply.opcoes,
        });
        _loading = false;
      });
      _rolarParaBaixo();
      return;
    }

    final fallback = _fallbackTree[opcao] ?? _fallbackTree['inicio'];
    setState(() {
      _mensagens.add({
        'texto': fallback['mensagem'],
        'isBot': true,
        'opcoes': fallback['opcoes'],
      });
      _loading = false;
    });
    _rolarParaBaixo();
  }

  Future<void> _enviarTextoLivre() async {
    final texto = _mensagemController.text.trim();
    if (texto.isEmpty || _loading) return;
    _mensagemController.clear();

    setState(() {
      _mensagens.add({'texto': texto, 'isBot': false});
      _loading = true;
    });

    final reply = await _service.reply(option: texto, email: _userEmail);
    if (!mounted) return;

    if (reply != null) {
      setState(() {
        _mensagens.add({
          'texto': reply.mensagem,
          'isBot': true,
          'opcoes': reply.opcoes,
        });
        _loading = false;
      });
      _rolarParaBaixo();
      return;
    }

    setState(() {
      _mensagens.add({
        'texto':
            'Não entendi essa opção ainda. Use os botões abaixo para eu te ajudar melhor.',
        'isBot': true,
        'opcoes': _fallbackTree['inicio']['opcoes'],
      });
      _loading = false;
    });
    _rolarParaBaixo();
  }

  void _rolarParaBaixo() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.bgColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PatriqueBot',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Text(
                  'Online',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
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
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final msg = _mensagens[index];
                final isBot = msg['isBot'] as bool;
                final opcoes = msg['opcoes'] as List<dynamic>?;

                return Column(
                  crossAxisAlignment:
                      isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isBot ? context.cardColor : AppTheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isBot ? 4 : 16),
                          bottomRight: Radius.circular(isBot ? 16 : 4),
                        ),
                      ),
                      child: Text(
                        msg['texto'],
                        style: TextStyle(
                          color: context.textColor,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                    if (opcoes != null && index == _mensagens.length - 1) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: opcoes.map((opcao) {
                          return GestureDetector(
                            onTap: _loading
                                ? null
                                : () => _responderOpcao(opcao.toString()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
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
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mensagemController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _enviarTextoLivre(),
                      decoration: const InputDecoration(
                        hintText: 'Digite sua mensagem...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _loading ? null : _enviarTextoLivre,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                    color: AppTheme.primary,
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
