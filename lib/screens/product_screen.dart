import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../api/api_service.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el token desde los argumentos de navegación
    final String? token = ModalRoute.of(context)!.settings.arguments as String?;

    if (token == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Productos'),
        ),
        body: const Center(
          child: Text('Error: No se proporcionó el token'),
        ),
      );
    }

    return BlocProvider(
      create: (context) => ProductBloc(ApiService())..add(LoadProducts(token)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Productos'),
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              return ListView.builder(
                itemCount: state.products.length,
                padding: const EdgeInsets.all(8.0), // Padding general para el ListView
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      title: Text(
                        product.nombre,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Precio por Libra: \$${product.precioPorLibra}\n'
                        'Peso Disponible: ${product.pesoDisponible} lbs\n'
                        '${product.descripcion}',
                      ),
                      trailing: const Icon(Icons.shopping_basket, color: Colors.blue),
                    ),
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const Center(child: Text('No hay productos disponibles'));
          },
        ),
      ),
    );
  }
}
