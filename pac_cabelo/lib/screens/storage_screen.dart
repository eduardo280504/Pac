import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pac_cabelo/models/stock.dart'; // Importando o modelo Stock
import 'package:pac_cabelo/screens/product_screen.dart'; // Sua tela de produtos

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<Stock> stocks = [];

  // Função para carregar estoques do Firebase
  Future<void> _loadStocks() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('stocks').get();
    setState(() {
      stocks = snapshot.docs
          .map((doc) =>
              Stock.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Função para criar um novo estoque no Firebase
  Future<void> _createStock() async {
    final newStock = Stock(
      id: '', // ID temporário, será atribuído pelo Firebase
      name: 'Estoque ${stocks.length + 1}',
      products: [],
    );

    void _updateStockInFirebase(Stock stock) async {
      final stockRef =
          FirebaseFirestore.instance.collection('stocks').doc(stock.id);

      try {
        // Atualizando o estoque no Firebase
        await stockRef.update({
          'products': FieldValue.arrayUnion(
              stock.products.map((product) => product.toMap()).toList()),
        });
      } catch (e) {
        print('Erro ao atualizar estoque no Firebase: $e');
      }
    }

    // Cria um documento para o estoque no Firebase
    final stockRef = FirebaseFirestore.instance.collection('stocks').doc();

    // Atribui o ID gerado pelo Firebase ao estoque
    newStock.id = stockRef.id;

    // Salva o novo estoque no Firebase
    await stockRef.set(newStock.toMap());

    // Atualiza a lista local de estoques
    setState(() {
      stocks.add(newStock);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStocks(); // Carrega os estoques ao inicializar a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Column(
          children: [
            // Logo do Estoque
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Image.asset(
                  'image2.png',
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Listagem de Estoques
            Expanded(
              child: stocks.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum estoque disponível',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: stocks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey[700],
                          child: ListTile(
                            title: Text(
                              stocks[index].name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              // Navega para a tela de lista de produtos do estoque
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductListScreen(stock: stocks[index]),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),

            // Botão "Criar Estoque"
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: _createStock,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'CRIAR ESTOQUE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
