import 'package:flutter/material.dart';
import 'package:pac_cabelo/models/product.dart'; // Modelo de produto
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final Function(Product) onSave;

  const ProductDetailScreen(
      {super.key, required this.product, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: product.name);
    final TextEditingController quantityController =
        TextEditingController(text: product.quantity);
    final TextEditingController codeController =
        TextEditingController(text: product.code);
    final TextEditingController locationController =
        TextEditingController(text: product.location);
    final TextEditingController descriptionController =
        TextEditingController(text: product.description);

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text('Detalhes do Produto: ${product.name}'),
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
                // Cria um novo produto com os dados da edição, mas mantém o id original
                Product updatedProduct = Product(
                  name: nameController.text,
                  quantity: quantityController.text,
                  code: codeController.text,
                  location: locationController.text,
                  description: descriptionController.text,
                  id: product.id, // Mantém o ID original do produto
                );

                // Chama a função onSave para atualizar no Firestore
                onSave(updatedProduct);

                Navigator.pop(context); // Retorna para a lista de produtos
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
