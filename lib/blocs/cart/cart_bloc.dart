import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product.dart';
import '../../models/combo.dart';

// Eventos
abstract class CartEvent {}

class AddProductToCart extends CartEvent {
  final Product product;
  AddProductToCart(this.product);
}

class AddComboToCart extends CartEvent {
  final Combo combo;
  AddComboToCart(this.combo);
}

class ClearCart extends CartEvent {}

// Estados
abstract class CartState {
  final List<dynamic> items;
  CartState(this.items);
}

class CartInitial extends CartState {
  CartInitial() : super([]);
}

class CartUpdated extends CartState {
  CartUpdated(List<dynamic> items) : super(items);
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    // Agregar producto al carrito
    on<AddProductToCart>((event, emit) {
      final updatedItems = List<dynamic>.from(state.items)..add(event.product);
      emit(CartUpdated(updatedItems));
    });

    // Agregar combo al carrito
    on<AddComboToCart>((event, emit) {
      final updatedItems = List<dynamic>.from(state.items)..add(event.combo);
      emit(CartUpdated(updatedItems));
    });

    // Limpiar el carrito
    on<ClearCart>((event, emit) {
      emit(CartInitial());
    });
  }
}
