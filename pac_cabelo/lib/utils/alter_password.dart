import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pac_cabelo/screens/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  String _successMessage = '';

  Future<void> _resetPassword() async {
    setState(() {
      _errorMessage = ''; // Limpa mensagens de erro ao tentar novamente
      _successMessage = ''; // Limpa a mensagem de sucesso
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      setState(() {
        _successMessage =
            'E-mail de recuperação enviado! Verifique sua caixa de entrada.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao enviar e-mail de recuperação: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850], // Cor de fundo cinza
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo da empresa
              Image.asset(
                'image2.png', // Coloque o caminho correto da imagem do logo
                height: 100,
              ),
              const SizedBox(
                  height: 50), // Espaçamento entre o logo e o campo de entrada

              // Campo de E-mail
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Digite seu e-mail',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                    color: Colors.white), // Cor do texto do input
              ),
              const SizedBox(height: 30),

              // Botão de enviar
              ElevatedButton(
                onPressed: () {
                  _resetPassword;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white, // Cor do texto do botão
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15)),
                child: const Text(
                  'ENVIAR E-MAIL DE RECUPERAÇÃO',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Mensagem de erro ou sucesso
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (_successMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    _successMessage,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
