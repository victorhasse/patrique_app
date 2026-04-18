import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PlanosScreen extends StatefulWidget {
  const PlanosScreen({super.key});

  @override
  State<PlanosScreen> createState() => _PlanosScreenState();
}

class _PlanosScreenState extends State<PlanosScreen> {
  String _planoSelecionado = 'anual';

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Título
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.primary),
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Escolha seu plano',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cancele quando quiser',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Card plano mensal
              _CardPlano(
                titulo: 'Mensal',
                preco: 'R\$ 159,90',
                periodo: '/mês',
                descricao: 'Cobrado mensalmente',
                selecionado: _planoSelecionado == 'mensal',
                tag: null,
                onTap: () => setState(() => _planoSelecionado = 'mensal'),
              ),

              const SizedBox(height: 12),

              // Card plano anual
              _CardPlano(
                titulo: 'Anual',
                preco: 'R\$ 107,13',
                periodo: '/mês',
                descricao: 'Cobrado R\$ 1.285,60/ano • Economize 33%',
                selecionado: _planoSelecionado == 'anual',
                tag: 'MAIS POPULAR',
                onTap: () => setState(() => _planoSelecionado = 'anual'),
              ),

              const SizedBox(height: 32),

              // Benefícios
              Text(
                'O que está incluso',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const _ItemBeneficio(texto: 'Acesso a academia da rede \nPatrique mais próxima de você!'),
              const _ItemBeneficio(texto: 'Controle seus treinos e evolução'),
              const _ItemBeneficio(texto: 'Chatbot disponível 24h'),
              const _ItemBeneficio(texto: 'Calendário e streak'),
              const _ItemBeneficio(texto: 'Histórico completo'),
              const _ItemBeneficio(texto: 'Suporte prioritário'),

              const SizedBox(height: 32),

              // Botão assinar
              ElevatedButton(
                onPressed: () {
                  _mostrarConfirmacao(context);
                },
                child: Text(
                  _planoSelecionado == 'anual'
                      ? 'Assinar por R\$ 1.285,60/ano'
                      : 'Assinar por R\$ 159,90/mês',
                ),
              ),

              const SizedBox(height: 12),

              // Termos
              Center(
                child: Text(
                  'Ao assinar você concorda com os Termos de Uso.\nCancele a qualquer momento.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 12),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarConfirmacao(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
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
            const SizedBox(height: 24),
            const Icon(
              Icons.check_circle_rounded,
              color: AppTheme.primary,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              'Tudo certo!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _planoSelecionado == 'anual'
                  ? 'Plano Anual ativado com sucesso!'
                  : 'Plano Mensal ativado com sucesso!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuar'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CardPlano extends StatelessWidget {
  final String titulo;
  final String preco;
  final String periodo;
  final String descricao;
  final bool selecionado;
  final String? tag;
  final VoidCallback onTap;

  const _CardPlano({
    required this.titulo,
    required this.preco,
    required this.periodo,
    required this.descricao,
    required this.selecionado,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selecionado
              ? AppTheme.primary.withOpacity(0.1)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selecionado ? AppTheme.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selecionado ? AppTheme.primary : AppTheme.grey,
                  width: 2,
                ),
              ),
              child: selecionado
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        titulo,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (tag != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descricao,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Preço
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  preco,
                  style: TextStyle(
                    color: selecionado ? AppTheme.primary : AppTheme.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  periodo,
                  style: const TextStyle(
                    color: AppTheme.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemBeneficio extends StatelessWidget {
  final String texto;
  const _ItemBeneficio({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppTheme.primary,
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            texto,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}