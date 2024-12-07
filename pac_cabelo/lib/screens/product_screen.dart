import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pac_cabelo/models/product.dart'; // Importando a classe Product
import 'package:pac_cabelo/screens/product_add_screen.dart'; // Tela de criação de produto
import 'package:pac_cabelo/screens/product_detail_screen.dart'; // Tela de detalhes do produto
import 'package:pac_cabelo/models/stock.dart'; // Importando a classe Stock

class ProductListScreen extends StatefulWidget {
  final Stock stock;

  const ProductListScreen({super.key, required this.stock});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<Product> products;
  late Stock stock;

  @override
  void initState() {
    super.initState();
    stock = widget.stock; // Pega o estoque passado para a tela
    products = stock.products; // Inicializa com a lista de produtos do estoque
    _loadProductsFromFirestore();
  }

  // Função que obtém o próximo ID para o produto
  Future<int> getNextProductId(String stockId) async {
    try {
      final counterRef = FirebaseFirestore.instance
          .collection('stocks')
          .doc(stockId)
          .collection('counter') // Contador de IDs para os produtos
          .doc('product_counter'); // Nome do documento do contador

      final docSnapshot = await counterRef.get();
      int nextId = 1;

      if (docSnapshot.exists) {
        final counterData = docSnapshot.data() as Map<String, dynamic>;
        nextId = counterData['current_id'] ?? 1;
      }

      // Atualiza o contador com o próximo ID
      await counterRef.set({
        'current_id': nextId + 1,
      }, SetOptions(merge: true));

      return nextId;
    } catch (e) {
      print('Erro ao gerar o ID: $e');
      return 1; // Retorna 1 caso haja erro
    }
  }

  // Função para carregar os produtos do Firestore
  void _loadProductsFromFirestore() async {
    final stockRef =
        FirebaseFirestore.instance.collection('stocks').doc(stock.id);

    try {
      final docSnapshot = await stockRef.get();
      if (docSnapshot.exists) {
        final stockData = docSnapshot.data() as Map<String, dynamic>;
        List<Product> loadedProducts = [];

        if (stockData['products'] != null) {
          for (var productMap in stockData['products']) {
            loadedProducts
                .add(Product.fromMap(productMap as Map<String, dynamic>));
          }
        }

        setState(() {
          products = loadedProducts;
        });
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
    }
  }

  // Função para adicionar um novo produto no Firestore
  void _addProduct(Product product) async {
    final nextId = await getNextProductId(stock.id);

    final productWithId = Product(
      id: nextId.toString(),
      name: product.name,
      quantity: product.quantity,
      code: product.code,
      location: product.location,
      description: product.description,
    );

    // Salvar o produto no Firestore
    final stockRef =
        FirebaseFirestore.instance.collection('stocks').doc(stock.id);
    stockRef.update({
      'products': FieldValue.arrayUnion([productWithId.toMap()]),
    });

    // Atualizar a lista de produtos
    setState(() {
      products.add(productWithId);
    });
  }

  // Função para atualizar um produto no Firestore
  void _updateProduct(Product updatedProduct) async {
    final stockRef =
        FirebaseFirestore.instance.collection('stocks').doc(stock.id);

    try {
      // Encontrar o índice do produto na lista e substituir
      int productIndex = products.indexWhere((p) => p.id == updatedProduct.id);
      if (productIndex != -1) {
        // Atualizar o produto na lista local
        setState(() {
          products[productIndex] = updatedProduct;
        });

        // Atualizar o produto no Firestore
        await stockRef.update({
          'products': FieldValue.arrayUnion([updatedProduct.toMap()])
        });

        // Recarregar os produtos após a atualização
        _loadProductsFromFirestore();
      }
    } catch (e) {
      print('Erro ao atualizar o produto: $e');
    }
  }

  // Função para excluir um produto no Firestore
  void _deleteProduct(Product product) async {
    final stockRef =
        FirebaseFirestore.instance.collection('stocks').doc(stock.id);

    try {
      // Remover o produto da lista do estoque
      await stockRef.update({
        'products': FieldValue.arrayRemove([product.toMap()])
      });

      // Remover o produto da lista local
      setState(() {
        products.removeWhere((p) => p.id == product.id);
      });
    } catch (e) {
      print('Erro ao excluir o produto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(
            child: products.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum produto cadastrado',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(products[index].name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                        product: products[index],
                                        onSave: (updatedProduct) {
                                          _updateProduct(updatedProduct);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Confirmar a exclusão com o usuário
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Excluir Produto'),
                                      content: const Text(
                                          'Você tem certeza que deseja excluir este produto?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _deleteProduct(products[index]);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Excluir'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  product: products[index],
                                  onSave: (updatedProduct) {
                                    _updateProduct(updatedProduct);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      product: Product(
                          id: '',
                          name: '',
                          quantity: '',
                          code: '',
                          location: '',
                          description: ''),
                      onSave: (updatedProduct) {
                        _addProduct(updatedProduct);
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Adicionar Produto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
