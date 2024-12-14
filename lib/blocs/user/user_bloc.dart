import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_service.dart';
import '../../models/users.dart';

// Eventos
abstract class UserEvent {}

class LoadUsers extends UserEvent {
  final String token;
  LoadUsers(this.token);
}

// Estados
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<Users> users;
  UserLoaded(this.users);
}

class UserError extends UserState {
  final String error;
  UserError(this.error);
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService apiService;

  UserBloc(this.apiService) : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await apiService.fetchUsers(event.token);
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}
