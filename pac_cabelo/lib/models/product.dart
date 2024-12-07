class Product {
  final String? id;
  final String name;
  final String quantity;
  final String code;
  final String location;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.code,
    required this.location,
    required this.description,
  });

  // Função copyWith para copiar o produto com um novo ID
  Product copyWith({String? id}) {
    return Product(
      id: id ?? this.id,
      name: this.name,
      quantity: this.quantity,
      code: this.code,
      location: this.location,
      description: this.description,
    );
  }

  // Convertendo o produto em um mapa para enviar ao Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'code': code,
      'location': location,
      'description': description,
    };
  }

  // Convertendo um mapa em um objeto Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String?,
      name: map['name'] as String,
      quantity: map['quantity'] as String,
      code: map['code'] as String,
      location: map['location'] as String,
      description: map['description'] as String,
    );
  }
}
