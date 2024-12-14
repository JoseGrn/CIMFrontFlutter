import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_service.dart';

// Eventos
abstract class SalesEvent {}

class LoadSales extends SalesEvent {
  final String token;
  LoadSales(this.token);
}

// Estados
abstract class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesLoaded extends SalesState {
  final List<Map<String, dynamic>> dailySales;
  final List<Map<String, dynamic>> monthlySales;

  SalesLoaded(this.dailySales, this.monthlySales);
}

class SalesError extends SalesState {
  final String error;
  SalesError(this.error);
}

// BLoC
class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final ApiService apiService;

  SalesBloc(this.apiService) : super(SalesInitial()) {
    on<LoadSales>((event, emit) async {
      emit(SalesLoading());
      try {
        final dailySales = await apiService.fetchDailySales(event.token);
        final monthlySales = await apiService.fetchMonthlySales(event.token);
        emit(SalesLoaded(dailySales, monthlySales));
      } catch (e) {
        emit(SalesError(e.toString()));
      }
    });
  }
}
