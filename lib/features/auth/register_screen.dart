import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_transitions.dart';
import '../../../main.dart';
import '../../core/theme_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _senhaVisivel = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _cadastrar() {
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _senhaController.text.isEmpty ||
        _confirmarSenhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_senhaController.text != _confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não coincidem'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Cadastro bem sucedido — vai para o app
    Navigator.pushAndRemoveUntil(
      context,
      AppTransitions.fadeScale(const MainScreen()),
      (route) => false,
    );
  }

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Text('Criar conta',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Preencha os dados para começar',
                  style: Theme.of(context).textTheme.bodyMedium),

              const SizedBox(height: 36),

              // Nome
              Text('Nome completo',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Seu nome',
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      color: context.subtitleColor),
                ),
              ),

              const SizedBox(height: 20),

              // Email
              Text('E-mail',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'seu@email.com',
                  prefixIcon:
                      Icon(Icons.email_outlined, color: context.subtitleColor),
                ),
              ),

              const SizedBox(height: 20),

              // Senha
              Text('Senha',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _senhaController,
                obscureText: !_senhaVisivel,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: Icon(Icons.lock_outlined,
                      color: context.subtitleColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: context.subtitleColor,
                    ),
                    onPressed: () =>
                        setState(() => _senhaVisivel = !_senhaVisivel),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirmar senha
              Text('Confirmar senha',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmarSenhaController,
                obscureText: !_senhaVisivel,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: Icon(Icons.lock_outlined,
                      color: context.subtitleColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: context.subtitleColor,
                    ),
                    onPressed: () =>
                        setState(() => _senhaVisivel = !_senhaVisivel),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Botão cadastrar
              ElevatedButton(
                onPressed: _cadastrar,
                child: const Text('Cadastrar'),
              ),

              const SizedBox(height: 16),

              // Voltar pro login
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text.rich(
                    TextSpan(
                      text: 'Já tem conta? ',
                      style: TextStyle(color: context.subtitleColor),
                      children: [
                        TextSpan(
                          text: 'Entrar',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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