import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../core/theme/app_theme.dart';
import '../auth/planos_screen.dart';
import '../../core/theme/app_transitions.dart';
import '../auth/login_screen.dart';
import 'notificacoes_screen.dart';
import 'editar_perfil_screen.dart';
import '../../core/theme_controller.dart';
import '../../core/theme_utils.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String _nome = 'UsuÃ¡rio';
  String _email = 'Sem e-mail';
  String? _fotoPerfilPath;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = prefs.getString('user_nome');
    final email = prefs.getString('user_email');

    if (!mounted) return;
    setState(() {
      _nome = (nome != null && nome.trim().isNotEmpty) ? nome : 'UsuÃ¡rio';
      _email = (email != null && email.trim().isNotEmpty) ? email : 'Sem e-mail';
      final foto = prefs.getString('user_foto_perfil');
      _fotoPerfilPath = (foto != null && foto.trim().isNotEmpty) ? foto : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Avatar e nome
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          AppTransitions.slideFromRight(
                            const EditarPerfilScreen(),
                          ),
                        ).then((_) => _carregarDadosUsuario());
                      },
                      child: Stack(
                      children: [
                        Container(
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
                              Icons.edit_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _nome,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    // Badge do plano
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primary),
                      ),
                      child: const Text(
                        'Plano Anual',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Cards de estatÃ­sticas
              Row(
                children: [
                  Expanded(
                    child: _CardEstat(
                      valor: '13',
                      label: 'Treinos\nno mÃªs',
                      icone: Icons.fitness_center_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CardEstat(
                      valor: '5',
                      label: 'Streak\natual',
                      icone: Icons.local_fire_department_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CardEstat(
                      valor: '13',
                      label: 'Treinos\nno total',
                      icone: Icons.emoji_events_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // SeÃ§Ã£o configuraÃ§Ãµes
              _SecaoMenu(
                titulo: 'Conta',
                itens: [
                  _ItemMenu(
                    icone: Icons.person_outline_rounded,
                    label: 'Meu perfil',
                    onTap: () {
                      Navigator.push(
                        context,
                        AppTransitions.slideFromRight(
                            const EditarPerfilScreen()),
                      ).then((_) => _carregarDadosUsuario());
                    },
                  ),
                  _ItemMenu(
                    icone: Icons.lock_outline_rounded,
                    label: 'Alterar senha',
                    onTap: () {},
                  ),
                  _ItemMenu(
                    icone: Icons.credit_card_rounded,
                    label: 'Meu plano',
                    onTap: () {
                      Navigator.push(
                        context,
                        AppTransitions.slideFromRight(const PlanosScreen()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _SecaoMenu(
                titulo: 'PreferÃªncias',
                itens: [
                  _ItemMenu(
                    icone: Icons.notifications_outlined,
                    label: 'NotificaÃ§Ãµes',
                    onTap: () {
                      Navigator.push(
                        context,
                        AppTransitions.slideFromRight(
                            const NotificacoesScreen()),
                      );
                    },
                  ),
                  _ItemMenu(
                    icone: Icons.language_rounded,
                    label: 'Idioma',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _SecaoMenu(
                titulo: 'Suporte',
                itens: [
                  _ItemMenu(
                    icone: Icons.help_outline_rounded,
                    label: 'Ajuda',
                    onTap: () {},
                  ),
                  _ItemMenu(
                    icone: Icons.star_outline_rounded,
                    label: 'Avaliar o app',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _SecaoMenu(
                titulo: 'AparÃªncia',
                itens: [
                Padding(
                  padding:(const EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
                  child: Row(
                    children: [
                      Icon(
                        ThemeController().isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: AppTheme.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          ThemeController().isDark ? 'Modo escuro' : 'Modo claro',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Switch(
                            value: ThemeController().isDark,
                            activeThumbColor: AppTheme.primary,
                            onChanged: (_) async {
                              await ThemeController().toggleTheme();
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ],
              ),

              const SizedBox(height: 16),

              // BotÃ£o sair
              OutlinedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    AppTransitions.fadeScale(const LoginScreen()),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sair da conta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardEstat extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icone;

  const _CardEstat({
    required this.valor,
    required this.label,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icone, color: AppTheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              color: context.textColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.subtitleColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecaoMenu extends StatelessWidget {
  final String titulo;
  final List<Widget> itens;

  const _SecaoMenu({required this.titulo, required this.itens});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: context.subtitleColor,
                fontSize: 13,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: itens),
        ),
      ],
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final IconData icone;
  final String label;
  final VoidCallback onTap;

  const _ItemMenu({
    required this.icone,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icone, color: AppTheme.primary, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.subtitleColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

