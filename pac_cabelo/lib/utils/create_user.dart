import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Exibir mensagens de erro
  String _errorMessage = '';

  Future<void> _createUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'As senhas não coincidem!';
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context); // Retorna à tela anterior após o cadastro
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao criar usuário: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[850], // Cor de fundo cinza, similar ao da imagem.
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo da empresa
              Image.asset(
                'image2.png', // Coloque o caminho correto da imagem do logo
                height: 100,
              ),
              const SizedBox(
                  height:
                      50), // Espaçamento entre o logo e os campos de entrada

              // Campo de E-mail
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),

              // Campo de Senha
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),

              // Campo de Confirmar Senha
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Botão para criar a conta
              ElevatedButton(
                onPressed: _createUser,
                child: const Text('Criar Conta'),
              ),

              // Exibir mensagem de erro, se houver
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
