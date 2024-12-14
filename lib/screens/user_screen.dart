import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../api/api_service.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el token desde los argumentos de navegación
    final String? token = ModalRoute.of(context)!.settings.arguments as String?;

    if (token == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Usuarios'),
        ),
        body: const Center(
          child: Text('Error: No se proporcionó el token'),
        ),
      );
    }

    return BlocProvider(
      create: (context) => UserBloc(ApiService())..add(LoadUsers(token)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Usuarios'),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                padding: const EdgeInsets.all(8.0), // Padding general para el ListView
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      leading: const Icon(Icons.person, color: Colors.blue, size: 40),
                      title: Text(
                        '${user.nombre} ${user.apellido}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Username: ${user.username}'),
                          Text('Email: ${user.email}'),
                          Text('Rol: ${user.rol}'),
                          Text('Estado: ${user.estado ? 'Activo' : 'Inactivo'}'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            } else if (state is UserError) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const Center(child: Text('No hay usuarios disponibles'));
          },
        ),
      ),
    );
  }
}
