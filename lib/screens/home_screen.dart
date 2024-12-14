import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/api_service.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/combos/combo_bloc.dart';
import '../models/product.dart';
import '../models/combo.dart';
import '../blocs/cart/cart_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el token desde los argumentos de navegación
    final String token = ModalRoute.of(context)!.settings.arguments as String;

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(ApiService())..add(LoadProducts(token)),
        ),
        BlocProvider<ComboBloc>(
          create: (context) => ComboBloc(ApiService())..add(LoadCombos(token)),
        ),
        // Elimina el CartBloc del MultiBlocProvider para evitar sobrescribirlo
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menú Principal'),
          actions: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return IconButton(
                  icon: Badge(
                    label: Text(state.items.length.toString()),
                    child: const Icon(Icons.shopping_cart),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Opciones', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Usuarios'),
                onTap: () {
                  final String? token = ModalRoute.of(context)!.settings.arguments as String?;
                  if (token != null) {
                    Navigator.pushNamed(context, '/users', arguments: token);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error: No se encontró el token')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Productos'),
                onTap: () {
                  final String? token = ModalRoute.of(context)!.settings.arguments as String?;
                  if (token != null) {
                    Navigator.pushNamed(context, '/products', arguments: token);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error: No se encontró el token')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_offer),
                title: const Text('Combos'),
                onTap: () {
                  final String? token = ModalRoute.of(context)!.settings.arguments as String?;
                  if (token != null) {
                    Navigator.pushNamed(context, '/combos', arguments: token);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error: No se encontró el token')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Ventas'),
                onTap: () {
                  final String? token = ModalRoute.of(context)!.settings.arguments as String?;
                  if (token != null) {
                    Navigator.pushNamed(context, '/sales', arguments: token);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error: No se encontró el token')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Productos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoaded) {
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ListTile(
                          title: Text(product.nombre),
                          subtitle: Text('Precio: \$${product.precioPorLibra} por libra'),
                          onTap: () {
                            context.read<CartBloc>().add(AddProductToCart(product));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.nombre} agregado al carrito')),
                            );
                          },
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
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Combos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: BlocBuilder<ComboBloc, ComboState>(
                builder: (context, state) {
                  if (state is ComboLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ComboLoaded) {
                    return ListView.builder(
                      itemCount: state.combos.length,
                      itemBuilder: (context, index) {
                        final combo = state.combos[index];
                        return ListTile(
                          title: Text(combo.nombreCombo),
                          subtitle: Text('Precio: \$${combo.precioCombo}'),
                          onTap: () {
                            context.read<CartBloc>().add(AddComboToCart(combo));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${combo.nombreCombo} agregado al carrito')),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is ComboError) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  return const Center(child: Text('No hay combos disponibles'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
