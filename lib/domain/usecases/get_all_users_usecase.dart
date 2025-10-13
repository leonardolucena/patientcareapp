import 'package:patientcareapp/data/models/user_model.dart';
import 'package:patientcareapp/domain/repositories/user_repository.dart';

/// Use Case para buscar todos os usuários
/// 
/// Encapsula a lógica de negócio para obter lista de usuários
/// Segue o Single Responsibility Principle (SRP)
class GetAllUsersUseCase {
  final UserRepository _repository;

  GetAllUsersUseCase(this._repository);

  Future<List<UserModel>> call() async {
    return await _repository.getAllUsers();
  }
}

