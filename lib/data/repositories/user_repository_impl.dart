import 'package:patientcareapp/data/datasources/remote_users_datasource.dart';
import 'package:patientcareapp/data/models/user_model.dart';
import 'package:patientcareapp/domain/repositories/user_repository.dart';

/// Implementação do Repository de Usuários
/// 
/// Responsável por:
/// - Intermediar entre Use Cases e Datasources
/// - Gerenciar cache (futuro)
/// - Tratar dados (futuro)
class UserRepositoryImpl implements UserRepository {
  final RemoteUsersDatasource _remoteDatasource;

  UserRepositoryImpl(this._remoteDatasource);

  @override
  Future<List<UserModel>> getAllUsers() async {
    return await _remoteDatasource.getAllUsers();
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    return await _remoteDatasource.getUserById(id);
  }

  @override
  Future<List<UserModel>> searchUsersByName(String name) async {
    return await _remoteDatasource.searchUsersByName(name);
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    return await _remoteDatasource.createUser(user);
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    return await _remoteDatasource.updateUser(user);
  }

  @override
  Future<void> deleteUser(int id) async {
    return await _remoteDatasource.deleteUser(id);
  }
}

