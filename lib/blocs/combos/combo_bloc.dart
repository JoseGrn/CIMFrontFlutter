import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_service.dart';
import '../../models/combo.dart';

abstract class ComboEvent {}
class LoadCombos extends ComboEvent {
  final String token;
  LoadCombos(this.token);
}

abstract class ComboState {}
class ComboInitial extends ComboState {}
class ComboLoading extends ComboState {}
class ComboLoaded extends ComboState {
  final List<Combo> combos;
  ComboLoaded(this.combos);
}
class ComboError extends ComboState {
  final String error;
  ComboError(this.error);
}

class ComboBloc extends Bloc<ComboEvent, ComboState> {
  final ApiService apiService;

  ComboBloc(this.apiService) : super(ComboInitial()) {
    on<LoadCombos>((event, emit) async {
      emit(ComboLoading());
      try {
        final combos = await apiService.fetchCombos(event.token);
        emit(ComboLoaded(combos));
      } catch (e) {
        emit(ComboError(e.toString()));
      }
    });
  }
}
