import 'package:flutter/material.dart';
import 'package:patientcareapp/core/di/injection_container.dart';
import 'package:patientcareapp/data/models/user_model.dart';
import 'package:patientcareapp/domain/usecases/get_all_users_usecase.dart';
import 'package:patientcareapp/domain/usecases/search_users_usecase.dart';

/// Provider para gerenciar estado de usuários
/// 
/// Responsável por:
/// - Buscar usuários da API
/// - Gerenciar loading states
/// - Gerenciar erros
/// - Filtrar usuários por busca
class UsersProvider extends ChangeNotifier {
  final GetAllUsersUseCase _getAllUsersUseCase = getIt<GetAllUsersUseCase>();
  final SearchUsersUseCase _searchUsersUseCase = getIt<SearchUsersUseCase>();

  List<UserModel> _users = [];
  List<UserModel> _allUsers = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  /// Carrega todos os usuários
  Future<void> loadAllUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allUsers = await _getAllUsersUseCase();
      _users = _allUsers;
    } catch (e) {
      _error = 'Erro ao carregar usuários: $e';
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca usuários por nome
  Future<void> searchUsers(String query) async {
    _searchQuery = query;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _searchUsersUseCase(query);
    } catch (e) {
      _error = 'Erro ao buscar usuários: $e';
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpa a busca e volta para todos os usuários
  void clearSearch() {
    _searchQuery = '';
    _users = _allUsers;
    notifyListeners();
  }

  /// Recarrega os usuários
  Future<void> refresh() async {
    await loadAllUsers();
  }

  /// Obtém um usuário por ID
  UserModel? getUserById(int id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}

