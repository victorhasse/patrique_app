import 'package:flutter/material.dart';
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
      'texto': 'Olá! Eu sou o PatriqueBot 💪\nComo posso te ajudar hoje?',
      'isBot': true,
    },
  ];

  // Árvore de decisões
  final Map<String, dynamic> _arvore = {
    'inicio': {
      'mensagem': 'Escolha uma opção abaixo:',
      'opcoes': ['🏋️ Dúvidas sobre treino', '🥗 Nutrição', '😴 Descanso e recuperação', '📊 Acompanhamento'],
    },
    '🏋️ Dúvidas sobre treino': {
      'mensagem': 'Qual sua dúvida sobre treino?',
      'opcoes': ['Como montar uma série?', 'Quantas vezes treinar por semana?', 'Como evoluir no treino?'],
    },
    '🥗 Nutrição': {
      'mensagem': 'O que você quer saber sobre nutrição?',
      'opcoes': ['O que comer antes do treino?', 'O que comer depois do treino?', 'Quanto de proteína por dia?'],
    },
    '😴 Descanso e recuperação': {
      'mensagem': 'O que você quer saber sobre recuperação?',
      'opcoes': ['Quantas horas dormir?', 'O que é overtraining?', 'Quando posso treinar com dor muscular?'],
    },
    '📊 Acompanhamento': {
      'mensagem': 'O que deseja acompanhar?',
      'opcoes': ['Ver meu progresso', 'Meus treinos da semana', 'Meu streak atual'],
    },
    'Como montar uma série?': {
      'mensagem': 'Para iniciantes, recomendo:\n\n• 3 séries de 12 repetições\n• Descanso de 60 segundos\n• Foco na técnica antes do peso\n\nQuer saber mais alguma coisa?',
      'opcoes': ['Voltar ao início', 'Quantas vezes treinar por semana?'],
    },
    'Quantas vezes treinar por semana?': {
      'mensagem': 'Depende do seu nível:\n\n• Iniciante: 3x por semana\n• Intermediário: 4x por semana\n• Avançado: 5-6x por semana\n\nSempre respeitando o descanso!',
      'opcoes': ['Voltar ao início', 'Como evoluir no treino?'],
    },
    'Como evoluir no treino?': {
      'mensagem': 'A chave é a sobrecarga progressiva:\n\n• Aumente o peso gradualmente\n• Adicione mais repetições\n• Reduza o tempo de descanso\n• Varie os exercícios a cada 4-6 semanas',
      'opcoes': ['Voltar ao início', 'Quantas vezes treinar por semana?'],
    },
    'O que comer antes do treino?': {
      'mensagem': 'Ideal comer 1-2h antes:\n\n• Carboidratos de fácil digestão\n• Banana com pasta de amendoim\n• Pão integral com ovo\n• Aveia com frutas\n\nEvite gorduras e fibras em excesso!',
      'opcoes': ['Voltar ao início', 'O que comer depois do treino?'],
    },
    'O que comer depois do treino?': {
      'mensagem': 'Até 1h após o treino:\n\n• Proteína para recuperação muscular\n• Frango com arroz e legumes\n• Atum com batata doce\n• Whey protein com fruta\n\nEsse é o momento mais importante!',
      'opcoes': ['Voltar ao início', 'Quanto de proteína por dia?'],
    },
    'Quanto de proteína por dia?': {
      'mensagem': 'A recomendação geral é:\n\n• 1.6g a 2.2g por kg de peso corporal\n• Exemplo: 70kg = 112g a 154g/dia\n• Distribua em 4-5 refeições\n\nConsulte um nutricionista para orientação personalizada!',
      'opcoes': ['Voltar ao início', 'O que comer antes do treino?'],
    },
    'Quantas horas dormir?': {
      'mensagem': 'O sono é fundamental para os resultados:\n\n• Mínimo de 7-8 horas por noite\n• É durante o sono que o músculo cresce\n• Evite telas 1h antes de dormir\n• Mantenha horários regulares',
      'opcoes': ['Voltar ao início', 'O que é overtraining?'],
    },
    'O que é overtraining?': {
      'mensagem': 'Overtraining é o excesso de treino:\n\n• Queda no desempenho\n• Cansaço excessivo\n• Irritabilidade\n• Dificuldade para dormir\n\nSe identificar esses sinais, descanse por 1 semana!',
      'opcoes': ['Voltar ao início', 'Quando posso treinar com dor muscular?'],
    },
    'Quando posso treinar com dor muscular?': {
      'mensagem': 'Depende do tipo de dor:\n\n• Dor muscular tardia (DOMS): pode treinar outro grupo muscular\n• Dor articular ou aguda: PARE e descanse\n• Dor leve: ok treinar com intensidade reduzida\n\nSempre ouça seu corpo!',
      'opcoes': ['Voltar ao início', 'O que é overtraining?'],
    },
    'Ver meu progresso': {
      'mensagem': 'Você está indo muito bem! 🎉\n\n• Streak atual: 7 dias 🔥\n• Treinos esse mês: 18\n• Grupo favorito: Peito e Tríceps\n\nContinue assim!',
      'opcoes': ['Voltar ao início', 'Meus treinos da semana'],
    },
    'Meus treinos da semana': {
      'mensagem': 'Sua semana até agora:\n\n✅ Segunda — Peito e Tríceps\n✅ Terça — Costas e Bíceps\n✅ Quarta — Pernas\n✅ Quinta — Ombros\n✅ Sexta — Cardio\n⬜ Sábado\n⬜ Domingo',
      'opcoes': ['Voltar ao início', 'Meu streak atual'],
    },
    'Meu streak atual': {
      'mensagem': '🔥 Seu streak atual é de 7 dias!\n\nVocê está entre os 10% mais consistentes da plataforma. Continue treinando amanhã para manter!',
      'opcoes': ['Voltar ao início', 'Ver meu progresso'],
    },
    'Voltar ao início': {
      'mensagem': 'Claro! Como posso te ajudar?',
      'opcoes': ['🏋️ Dúvidas sobre treino', '🥗 Nutrição', '😴 Descanso e recuperação', '📊 Acompanhamento'],
    },
  };

  void _responderOpcao(String opcao) {
    setState(() {
      // Mensagem do usuário
      _mensagens.add({'texto': opcao, 'isBot': false});
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      final resposta = _arvore[opcao];
      if (resposta != null) {
        setState(() {
          _mensagens.add({
            'texto': resposta['mensagem'],
            'isBot': true,
            'opcoes': resposta['opcoes'],
          });
        });
      }
      _rolarParaBaixo();
    });
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
  void initState() {
    super.initState();
    // Adiciona opções iniciais
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _mensagens.add({
          'texto': 'Escolha uma opção abaixo:',
          'isBot': true,
          'opcoes': _arvore['inicio']!['opcoes'],
        });
      });
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
              child: const Icon(Icons.smart_toy_rounded,
                  color: Colors.white, size: 20),
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
          // Lista de mensagens
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
                  crossAxisAlignment: isBot
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    // Bolha de mensagem
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                            color: context.textColor, fontSize: 15, height: 1.4),
                      ),
                    ),

                    // Opções de resposta rápida
                    if (opcoes != null &&
                        index == _mensagens.length - 1) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: opcoes.map((opcao) {
                          return GestureDetector(
                            onTap: () => _responderOpcao(opcao.toString()),
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
        ],
      ),
    );
  }
}