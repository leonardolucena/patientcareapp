import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:patientcareapp/data/models/local_user_model.dart';

/// Serviço de autenticação local usando Hive
/// 
/// Responsável por:
/// - Cadastrar novos usuários
/// - Fazer login
/// - Verificar se email já existe
/// - Hash de senhas
/// - Gerenciar sessão do usuário
class AuthService {
  static const String _usersBoxName = 'users';
  static const String _currentUserKey = 'current_user_email';

  /// Box do Hive para armazenar usuários
  late Box<LocalUserModel> _usersBox;

  /// Inicializa o serviço e abre o box do Hive
  Future<void> initialize() async {
    _usersBox = await Hive.openBox<LocalUserModel>(_usersBoxName);
  }

  /// Gera hash SHA256 da senha
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Gera um ID único baseado no email e timestamp
  String _generateUserId(String email) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${email.hashCode}_$timestamp';
  }

  /// Verifica se um email já está cadastrado
  Future<bool> emailExists(String email) async {
    final normalizedEmail = email.toLowerCase().trim();
    return _usersBox.values.any((user) => user.email == normalizedEmail);
  }

  /// Cadastra um novo usuário
  Future<LocalUserModel> register(String email, String password) async {
    final normalizedEmail = email.toLowerCase().trim();

    // Verifica se email já existe
    if (await emailExists(normalizedEmail)) {
      throw Exception('Email já cadastrado');
    }

    // Cria o novo usuário
    final user = LocalUserModel(
      id: _generateUserId(normalizedEmail),
      email: normalizedEmail,
      passwordHash: _hashPassword(password),
      createdAt: DateTime.now(),
    );

    // Salva no Hive
    await _usersBox.put(normalizedEmail, user);

    return user;
  }

  /// Faz login do usuário
  Future<LocalUserModel?> login(String email, String password) async {
    final normalizedEmail = email.toLowerCase().trim();
    final user = _usersBox.get(normalizedEmail);

    if (user == null) {
      return null; // Usuário não encontrado
    }

    // Verifica se a senha está correta
    if (user.passwordHash != _hashPassword(password)) {
      return null; // Senha incorreta
    }

    // Atualiza último login
    final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
    await _usersBox.put(normalizedEmail, updatedUser);

    // Salva email do usuário atual
    await _saveCurrentUserEmail(normalizedEmail);

    return updatedUser;
  }

  /// Salva o email do usuário atual (sessão)
  Future<void> _saveCurrentUserEmail(String email) async {
    final prefs = await Hive.openBox('preferences');
    await prefs.put(_currentUserKey, email);
  }

  /// Obtém o email do usuário atualmente logado
  Future<String?> getCurrentUserEmail() async {
    final prefs = await Hive.openBox('preferences');
    return prefs.get(_currentUserKey) as String?;
  }

  /// Obtém o usuário atualmente logado
  Future<LocalUserModel?> getCurrentUser() async {
    final email = await getCurrentUserEmail();
    if (email == null) return null;
    return _usersBox.get(email);
  }

  /// Verifica se há um usuário logado
  Future<bool> isLoggedIn() async {
    final email = await getCurrentUserEmail();
    return email != null && _usersBox.containsKey(email);
  }

  /// Faz logout do usuário atual
  Future<void> logout() async {
    final prefs = await Hive.openBox('preferences');
    await prefs.delete(_currentUserKey);
  }

  /// Deleta um usuário (use com cuidado)
  Future<void> deleteUser(String email) async {
    final normalizedEmail = email.toLowerCase().trim();
    await _usersBox.delete(normalizedEmail);
    
    // Se for o usuário atual, faz logout
    final currentEmail = await getCurrentUserEmail();
    if (currentEmail == normalizedEmail) {
      await logout();
    }
  }

  /// Lista todos os usuários cadastrados (útil para debug)
  List<LocalUserModel> getAllUsers() {
    return _usersBox.values.toList();
  }

  /// Limpa todos os dados (útil para testes)
  Future<void> clearAll() async {
    await _usersBox.clear();
    await logout();
  }

  /// Fecha o box do Hive
  Future<void> dispose() async {
    await _usersBox.close();
  }
}

