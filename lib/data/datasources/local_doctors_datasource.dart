import 'package:patientcareapp/data/models/doctor_model.dart';
import 'package:patientcareapp/data/datasources/remote_users_datasource.dart';

/// Datasource local que combina dados da API JSONPlaceholder com dados locais
/// Usa os nomes reais dos usuários da API para criar médicos
class LocalDoctorsDatasource {
  final dynamic _remoteUsersDatasource; // dynamic para permitir mocks nos testes
  List<DoctorModel>? _cachedDoctors;

  LocalDoctorsDatasource(this._remoteUsersDatasource);

  /// Lista de especialidades disponíveis
  static const List<String> _specialties = [
    'Cardiologia',
    'Dermatologia',
    'Pediatria',
    'Ortopedia',
    'Ginecologia',
    'Oftalmologia',
    'Neurologia',
    'Psiquiatria',
  ];

  /// Busca todos os médicos (5 por especialidade = 40 médicos)
  Future<List<DoctorModel>> getAllDoctors() async {
    // Se já temos cache, retorna
    if (_cachedDoctors != null) {
      return _cachedDoctors!;
    }

    try {
      // Busca usuários da API
      final users = await _remoteUsersDatasource.getAllUsers();
      
      final List<DoctorModel> doctors = [];
      int doctorIndex = 0;

      // Para cada especialidade, cria 5 médicos
      for (final specialty in _specialties) {
        for (int i = 0; i < 5; i++) {
          // Usa os usuários da API de forma circular (10 usuários para 40 médicos)
          final user = users[doctorIndex % users.length];
          
          // Determina se é homem ou mulher baseado no índice
          final isMale = doctorIndex % 2 == 0;
          final prefix = isMale ? 'Dr.' : 'Dra.';
          
          // Cria o médico usando dados da API + dados locais
          doctors.add(DoctorModel(
            id: 'doc_${user.id}_${specialty}_$i', // ID único combinando user.id + especialidade
            name: '$prefix ${user.name}', // Nome real da API
            specialty: specialty,
            rating: _generateRating(doctorIndex),
            experience: _generateExperience(doctorIndex),
            price: _generatePrice(doctorIndex),
            image: isMale ? '👨‍⚕️' : '👩‍⚕️',
            patientsCount: _generatePatientsCount(doctorIndex),
          ));
          
          doctorIndex++;
        }
      }

      _cachedDoctors = doctors;
      return doctors;
    } catch (e) {
      // Em caso de erro na API, retorna lista vazia
      // Em produção, você poderia ter um fallback com dados mockados
      print('Erro ao buscar médicos: $e');
      return [];
    }
  }

  /// Busca médicos por especialidade
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty) async {
    final allDoctors = await getAllDoctors();
    return allDoctors.where((doc) => doc.specialty == specialty).toList();
  }

  /// Busca médicos por nome
  Future<List<DoctorModel>> searchDoctorsByName(String name) async {
    final allDoctors = await getAllDoctors();
    return allDoctors
        .where((doc) => doc.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  /// Busca médico por ID
  Future<DoctorModel?> getDoctorById(String id) async {
    final allDoctors = await getAllDoctors();
    try {
      return allDoctors.firstWhere((doc) => doc.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Gera rating aleatório mas consistente baseado no índice
  double _generateRating(int index) {
    final ratings = [4.8, 4.9, 4.7, 4.6, 4.5, 4.4, 4.3, 4.7, 4.8, 4.6];
    return ratings[index % ratings.length];
  }

  /// Gera experiência baseada no índice
  String _generateExperience(int index) {
    final experiences = [
      '15 anos',
      '12 anos',
      '18 anos',
      '10 anos',
      '20 anos',
      '8 anos',
      '14 anos',
      '16 anos',
      '11 anos',
      '13 anos',
    ];
    return experiences[index % experiences.length];
  }

  /// Gera preço baseado no índice
  String _generatePrice(int index) {
    final prices = [
      'R\$ 250',
      'R\$ 280',
      'R\$ 300',
      'R\$ 230',
      'R\$ 270',
      'R\$ 220',
      'R\$ 290',
      'R\$ 260',
      'R\$ 240',
      'R\$ 310',
    ];
    return prices[index % prices.length];
  }

  /// Gera número de pacientes baseado no índice
  int _generatePatientsCount(int index) {
    final counts = [
      1537, 1420, 1650, 1280, 1890, 1150, 1720, 1560, 1340, 1910,
    ];
    return counts[index % counts.length];
  }

  /// Limpa o cache (útil para testes ou refresh)
  void clearCache() {
    _cachedDoctors = null;
  }
}
