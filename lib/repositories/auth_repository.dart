import '../api/api_service.dart';
import '../models/user.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<User> login(String username, String password) {
    return apiService.login(username, password);
  }
}
