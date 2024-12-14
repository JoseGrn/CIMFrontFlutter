import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_service.dart';
import '../../models/product.dart';

abstract class ProductEvent {}
class LoadProducts extends ProductEvent {
  final String token;
  LoadProducts(this.token);
}

abstract class ProductState {}
class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}
class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}
class ProductError extends ProductState {
  final String error;
  ProductError(this.error);
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;

  ProductBloc(this.apiService) : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await apiService.fetchProducts(event.token);
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
