import 'package:patientcareapp/data/models/user_model.dart';
import 'package:patientcareapp/domain/repositories/user_repository.dart';

/// Use Case para buscar usuários por nome
/// 
/// Se a query estiver vazia, retorna todos os usuários
class SearchUsersUseCase {
  final UserRepository _repository;

  SearchUsersUseCase(this._repository);

  Future<List<UserModel>> call(String query) async {
    if (query.isEmpty) {
      return await _repository.getAllUsers();
    }
    
    return await _repository.searchUsersByName(query);
  }
}

