import 'package:patientcareapp/data/models/user_model.dart';

/// Interface do Repository de Usuários
/// 
/// Define o contrato que deve ser implementado
/// Segue o Dependency Inversion Principle (DIP)
abstract class UserRepository {
  Future<List<UserModel>> getAllUsers();
  Future<UserModel?> getUserById(int id);
  Future<List<UserModel>> searchUsersByName(String name);
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(int id);
}

