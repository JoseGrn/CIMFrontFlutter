import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../models/product.dart';
import '../models/combo.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _realizarVenta(BuildContext context, List<dynamic> items) {
    // Aquí procesamos los ítems del carrito y mostramos un mensaje de confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Venta realizada con éxito')),
    );

    // Limpiar el carrito después de realizar la venta
    context.read<CartBloc>().add(ClearCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('El carrito está vacío.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    if (item is Product) {
                      return ListTile(
                        title: Text(item.nombre),
                        subtitle: Text('Producto - \$${item.precioPorLibra} por libra'),
                      );
                    } else if (item is Combo) {
                      return ListTile(
                        title: Text(item.nombreCombo),
                        subtitle: Text('Combo - \$${item.precioCombo}'),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _realizarVenta(context, state.items),
                    child: const Text('Realizar Venta'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
