import 'package:flutter/material.dart';
import 'package:pac_cabelo/models/product.dart'; // Modelo de produto

class AddProductScreen extends StatelessWidget {
  final Function(Map<String, dynamic>) onSave;

  const AddProductScreen({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController codeController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Criar Produto'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            TextField(
              controller: quantityController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            TextField(
              controller: codeController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Código',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            TextField(
              controller: locationController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Local de Estoque',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Product newProduct = Product(
                  name: nameController.text,
                  quantity: quantityController.text,
                  code: codeController.text,
                  location: locationController.text,
                  description: descriptionController.text,
                  id: '',
                );

                onSave(newProduct.toMap()); // Passa o novo produto para salvar
                Navigator.pop(
                    context); // Volta para a tela de lista de produtos
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Salvar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
