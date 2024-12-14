import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/users.dart';
import '../models/product.dart';
import '../models/combo.dart';

class ApiService {
  final String baseUrl = 'http://192.168.0.112:5000/api';

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al iniciar sesión');
    }
  }

  // Obtener productos
  Future<List<Product>> fetchProducts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/product/all'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['products'] as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  // Obtener combos
  Future<List<Combo>> fetchCombos(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/combo/all'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['combos'] as List)
          .map((combo) => Combo.fromJson(combo))
          .toList();
    } else {
      throw Exception('Error al cargar los combos');
    }
  }

  Future<List<Users>> fetchUsers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/all'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['users'] as List)
          .map((user) => Users.fromJson(user))
          .toList();
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }

  // Obtener ventas por día
  Future<List<Map<String, dynamic>>> fetchDailySales(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/sales/day'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['sales']);
    } else {
      throw Exception('Error al cargar las ventas diarias');
    }
  }

  // Obtener ventas por mes
  Future<List<Map<String, dynamic>>> fetchMonthlySales(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/sales/month'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['sales']);
    } else {
      throw Exception('Error al cargar las ventas mensuales');
    }
  }
}
