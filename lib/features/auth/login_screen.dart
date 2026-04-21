import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_transitions.dart';
import 'register_screen.dart';
import '../../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _senhaVisivel = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    // Por enquanto aceita qualquer email/senha preenchidos
    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o e-mail e a senha'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      AppTransitions.fadeScale(const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // Logo / título
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/marca_fundo_transparente.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bem-vindo de volta!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Campo email
              Text('E-mail',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'seu@email.com',
                  prefixIcon:
                      Icon(Icons.email_outlined, color: AppTheme.grey),
                ),
              ),

              const SizedBox(height: 20),

              // Campo senha
              Text('Senha',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _senhaController,
                obscureText: !_senhaVisivel,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outlined,
                      color: AppTheme.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.grey,
                    ),
                    onPressed: () =>
                        setState(() => _senhaVisivel = !_senhaVisivel),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Esqueci a senha
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(color: AppTheme.primary),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Botão entrar
              ElevatedButton(
                onPressed: _entrar,
                child: const Text('Entrar'),
              ),

              const SizedBox(height: 16),

              // Divisor
              Row(
                children: [
                  const Expanded(child: Divider(color: AppTheme.surface)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'ou',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Expanded(child: Divider(color: AppTheme.surface)),
                ],
              ),

              const SizedBox(height: 16),

              // Botão cadastro
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    AppTransitions.slideFromRight(const RegisterScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppTheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Criar conta',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
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