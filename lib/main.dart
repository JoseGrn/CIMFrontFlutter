import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'api/api_service.dart';
import 'repositories/auth_repository.dart';
import 'blocs/auth_bloc.dart';
import 'blocs/cart/cart_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/user_screen.dart';
import 'screens/product_screen.dart';
import 'screens/combo_screen.dart';
import 'screens/sales_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository(ApiService());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (context) => CartBloc(),
      child: MaterialApp(
        title: 'Tienda de Mariscos',
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {
          '/': (context) => BlocProvider(
                create: (context) => AuthBloc(authRepository),
                child: LoginScreen(),
              ),
          '/home': (context) => const HomeScreen(),
          '/cart': (context) => const CartScreen(),
          '/users': (context) => const UserScreen(),
          '/products': (context) => const ProductScreen(),
          '/combos': (context) => const ComboScreen(),
          '/sales': (context) => const SalesScreen(),
        },
      ),
    );
  }
}
