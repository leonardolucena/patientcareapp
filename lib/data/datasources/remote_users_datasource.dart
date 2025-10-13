import 'dart:convert';
import 'package:patientcareapp/core/network/api_gateway.dart';
import 'package:patientcareapp/data/models/user_model.dart';

/// Datasource remoto para usuários
/// 
/// Responsável por fazer chamadas HTTP para a API JSONPlaceholder
class RemoteUsersDatasource {
  final ApiGateway _apiGateway;

  RemoteUsersDatasource(this._apiGateway);

  /// Busca todos os usuários
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _apiGateway.get('/users');
      final List<dynamic> jsonList = json.decode(response.body);
      
      return jsonList
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar usuários: $e');
    }
  }

  /// Busca um usuário por ID
  Future<UserModel?> getUserById(int id) async {
    try {
      final response = await _apiGateway.get('/users/$id');
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      
      return UserModel.fromJson(json);
    } catch (e) {
      throw Exception('Erro ao buscar usuário $id: $e');
    }
  }

  /// Busca usuários por nome
  Future<List<UserModel>> searchUsersByName(String name) async {
    try {
      final allUsers = await getAllUsers();
      
      return allUsers
          .where((user) => 
            user.name.toLowerCase().contains(name.toLowerCase()) ||
            user.username.toLowerCase().contains(name.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar usuários por nome: $e');
    }
  }

  /// Cria um novo usuário (simulado - JSONPlaceholder não persiste)
  Future<UserModel> createUser(UserModel user) async {
    try {
      final response = await _apiGateway.post(
        '/users',
        body: user.toJson(),
      );
      
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  /// Atualiza um usuário (simulado - JSONPlaceholder não persiste)
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response = await _apiGateway.put(
        '/users/${user.id}',
        body: user.toJson(),
      );
      
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (e) {
      throw Exception('Erro ao atualizar usuário: $e');
    }
  }

  /// Deleta um usuário (simulado - JSONPlaceholder não persiste)
  Future<void> deleteUser(int id) async {
    try {
      await _apiGateway.delete('/users/$id');
    } catch (e) {
      throw Exception('Erro ao deletar usuário: $e');
    }
  }
}

