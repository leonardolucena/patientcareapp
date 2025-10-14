import 'package:hive/hive.dart';

part 'local_user_model.g.dart';

/// Model para usuário local armazenado no Hive
/// 
/// Representa um usuário cadastrado localmente no app
@HiveType(typeId: 0)
class LocalUserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String passwordHash;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime? lastLoginAt;

  @HiveField(5)
  final String? name;

  const LocalUserModel({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.createdAt,
    this.lastLoginAt,
    this.name,
  });

  /// Cria uma cópia do modelo com campos atualizados
  LocalUserModel copyWith({
    String? id,
    String? email,
    String? passwordHash,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? name,
  }) {
    return LocalUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'LocalUserModel(id: $id, email: $email, name: $name, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocalUserModel && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}

