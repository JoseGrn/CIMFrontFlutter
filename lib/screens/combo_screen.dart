import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/combos/combo_bloc.dart';
import '../api/api_service.dart';

class ComboScreen extends StatelessWidget {
  const ComboScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? token = ModalRoute.of(context)!.settings.arguments as String?;

    if (token == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Combos'),
        ),
        body: const Center(
          child: Text('Error: No se proporcionó el token'),
        ),
      );
    }

    return BlocProvider(
      create: (context) => ComboBloc(ApiService())..add(LoadCombos(token)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Combos'),
        ),
        body: BlocBuilder<ComboBloc, ComboState>(
          builder: (context, state) {
            if (state is ComboLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ComboLoaded) {
              return ListView.builder(
                itemCount: state.combos.length,
                padding: const EdgeInsets.all(8.0), // Padding general para el ListView
                itemBuilder: (context, index) {
                  final combo = state.combos[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      title: Text(
                        combo.nombreCombo,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Precio: \$${combo.precioCombo}\n${combo.descripcion}'),
                      trailing: const Icon(Icons.local_offer, color: Colors.blue),
                    ),
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
    );
  }
}
