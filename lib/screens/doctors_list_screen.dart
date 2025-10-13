import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorsListScreen extends StatefulWidget {
  final String clinicName;

  const DoctorsListScreen({
    super.key,
    required this.clinicName,
  });

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  String _selectedSpecialty = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  // Lista de especialidades
  final List<Map<String, dynamic>> _specialties = [
    {'name': 'Todos', 'icon': Icons.medical_services},
    {'name': 'Cardiologia', 'icon': Icons.favorite},
    {'name': 'Dermatologia', 'icon': Icons.face},
    {'name': 'Ortopedia', 'icon': Icons.accessibility_new},
    {'name': 'Pediatria', 'icon': Icons.child_care},
    {'name': 'Neurologia', 'icon': Icons.psychology},
    {'name': 'Oftalmologia', 'icon': Icons.remove_red_eye},
    {'name': 'Ginecologia', 'icon': Icons.pregnant_woman},
    {'name': 'Psiquiatria', 'icon': Icons.mood},
  ];

  // Lista de médicos fictícios (10+ por especialidade)
  final List<Map<String, dynamic>> _doctors = [
    // CARDIOLOGIA (10 médicos)
    {
      'name': 'Dr. Carlos Silva',
      'specialty': 'Cardiologia',
      'rating': 4.8,
      'experience': '15 anos',
      'price': 'R\$ 250',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Ana Santos',
      'specialty': 'Cardiologia',
      'rating': 4.9,
      'experience': '12 anos',
      'price': 'R\$ 280',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Pedro Costa',
      'specialty': 'Cardiologia',
      'rating': 4.7,
      'experience': '10 anos',
      'price': 'R\$ 220',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Lívia Andrade',
      'specialty': 'Cardiologia',
      'rating': 4.9,
      'experience': '18 anos',
      'price': 'R\$ 300',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Roberto Mendes',
      'specialty': 'Cardiologia',
      'rating': 4.6,
      'experience': '14 anos',
      'price': 'R\$ 240',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Viviane Lopes',
      'specialty': 'Cardiologia',
      'rating': 4.8,
      'experience': '11 anos',
      'price': 'R\$ 260',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Gabriel Moura',
      'specialty': 'Cardiologia',
      'rating': 4.7,
      'experience': '13 anos',
      'price': 'R\$ 255',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Renata Cruz',
      'specialty': 'Cardiologia',
      'rating': 4.9,
      'experience': '16 anos',
      'price': 'R\$ 290',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Thiago Pereira',
      'specialty': 'Cardiologia',
      'rating': 4.8,
      'experience': '9 anos',
      'price': 'R\$ 235',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Vanessa Lima',
      'specialty': 'Cardiologia',
      'rating': 5.0,
      'experience': '20 anos',
      'price': 'R\$ 320',
      'image': '👩‍⚕️',
    },
    
    // DERMATOLOGIA (10 médicos)
    {
      'name': 'Dra. Maria Oliveira',
      'specialty': 'Dermatologia',
      'rating': 4.9,
      'experience': '18 anos',
      'price': 'R\$ 300',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. João Ferreira',
      'specialty': 'Dermatologia',
      'rating': 4.6,
      'experience': '8 anos',
      'price': 'R\$ 200',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Paula Souza',
      'specialty': 'Dermatologia',
      'rating': 4.8,
      'experience': '14 anos',
      'price': 'R\$ 270',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. André Batista',
      'specialty': 'Dermatologia',
      'rating': 4.7,
      'experience': '12 anos',
      'price': 'R\$ 250',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Claudia Ramos',
      'specialty': 'Dermatologia',
      'rating': 4.9,
      'experience': '15 anos',
      'price': 'R\$ 280',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Henrique Duarte',
      'specialty': 'Dermatologia',
      'rating': 4.8,
      'experience': '10 anos',
      'price': 'R\$ 240',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Bruna Cardoso',
      'specialty': 'Dermatologia',
      'rating': 4.6,
      'experience': '9 anos',
      'price': 'R\$ 220',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Márcio Tavares',
      'specialty': 'Dermatologia',
      'rating': 4.9,
      'experience': '19 anos',
      'price': 'R\$ 310',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Simone Vieira',
      'specialty': 'Dermatologia',
      'rating': 4.7,
      'experience': '11 anos',
      'price': 'R\$ 245',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Diego Campos',
      'specialty': 'Dermatologia',
      'rating': 4.8,
      'experience': '13 anos',
      'price': 'R\$ 265',
      'image': '👨‍⚕️',
    },
    
    // ORTOPEDIA (10 médicos)
    {
      'name': 'Dr. Ricardo Lima',
      'specialty': 'Ortopedia',
      'rating': 4.9,
      'experience': '20 anos',
      'price': 'R\$ 320',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Juliana Alves',
      'specialty': 'Ortopedia',
      'rating': 4.7,
      'experience': '11 anos',
      'price': 'R\$ 240',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Fernando Rocha',
      'specialty': 'Ortopedia',
      'rating': 4.8,
      'experience': '16 anos',
      'price': 'R\$ 290',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dr. Sérgio Pinto',
      'specialty': 'Ortopedia',
      'rating': 4.6,
      'experience': '12 anos',
      'price': 'R\$ 260',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Amanda Costa',
      'specialty': 'Ortopedia',
      'rating': 4.9,
      'experience': '14 anos',
      'price': 'R\$ 280',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Vinícius Barros',
      'specialty': 'Ortopedia',
      'rating': 4.8,
      'experience': '18 anos',
      'price': 'R\$ 300',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Natália Freitas',
      'specialty': 'Ortopedia',
      'rating': 4.7,
      'experience': '10 anos',
      'price': 'R\$ 250',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Alexandre Santos',
      'specialty': 'Ortopedia',
      'rating': 5.0,
      'experience': '22 anos',
      'price': 'R\$ 350',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Priscila Moreira',
      'specialty': 'Ortopedia',
      'rating': 4.8,
      'experience': '13 anos',
      'price': 'R\$ 270',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Leandro Dias',
      'specialty': 'Ortopedia',
      'rating': 4.7,
      'experience': '15 anos',
      'price': 'R\$ 285',
      'image': '👨‍⚕️',
    },
    
    // PEDIATRIA (10 médicos)
    {
      'name': 'Dra. Camila Martins',
      'specialty': 'Pediatria',
      'rating': 5.0,
      'experience': '13 anos',
      'price': 'R\$ 260',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Lucas Barbosa',
      'specialty': 'Pediatria',
      'rating': 4.8,
      'experience': '9 anos',
      'price': 'R\$ 230',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Beatriz Gomes',
      'specialty': 'Pediatria',
      'rating': 4.9,
      'experience': '17 anos',
      'price': 'R\$ 280',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dra. Letícia Cunha',
      'specialty': 'Pediatria',
      'rating': 4.9,
      'experience': '15 anos',
      'price': 'R\$ 270',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Rodrigo Silva',
      'specialty': 'Pediatria',
      'rating': 4.7,
      'experience': '11 anos',
      'price': 'R\$ 245',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Débora Nunes',
      'specialty': 'Pediatria',
      'rating': 4.8,
      'experience': '14 anos',
      'price': 'R\$ 265',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Felipe Azevedo',
      'specialty': 'Pediatria',
      'rating': 4.6,
      'experience': '8 anos',
      'price': 'R\$ 220',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Tatiana Lopes',
      'specialty': 'Pediatria',
      'rating': 4.9,
      'experience': '16 anos',
      'price': 'R\$ 275',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Mateus Rodrigues',
      'specialty': 'Pediatria',
      'rating': 4.8,
      'experience': '12 anos',
      'price': 'R\$ 255',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Raquel Monteiro',
      'specialty': 'Pediatria',
      'rating': 5.0,
      'experience': '19 anos',
      'price': 'R\$ 290',
      'image': '👩‍⚕️',
    },
    
    // NEUROLOGIA (10 médicos)
    {
      'name': 'Dr. Marcos Dias',
      'specialty': 'Neurologia',
      'rating': 4.7,
      'experience': '22 anos',
      'price': 'R\$ 350',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Larissa Ribeiro',
      'specialty': 'Neurologia',
      'rating': 4.9,
      'experience': '14 anos',
      'price': 'R\$ 310',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Rafael Cardoso',
      'specialty': 'Neurologia',
      'rating': 4.6,
      'experience': '10 anos',
      'price': 'R\$ 270',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Elaine Borges',
      'specialty': 'Neurologia',
      'rating': 4.8,
      'experience': '16 anos',
      'price': 'R\$ 320',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Fábio Machado',
      'specialty': 'Neurologia',
      'rating': 4.9,
      'experience': '18 anos',
      'price': 'R\$ 330',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Cristina Farias',
      'specialty': 'Neurologia',
      'rating': 4.7,
      'experience': '12 anos',
      'price': 'R\$ 290',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Juliano Reis',
      'specialty': 'Neurologia',
      'rating': 4.8,
      'experience': '15 anos',
      'price': 'R\$ 305',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Sandra Oliveira',
      'specialty': 'Neurologia',
      'rating': 5.0,
      'experience': '20 anos',
      'price': 'R\$ 360',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Daniel Fernandes',
      'specialty': 'Neurologia',
      'rating': 4.7,
      'experience': '11 anos',
      'price': 'R\$ 280',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Mônica Castro',
      'specialty': 'Neurologia',
      'rating': 4.9,
      'experience': '17 anos',
      'price': 'R\$ 325',
      'image': '👩‍⚕️',
    },
    
    // OFTALMOLOGIA (10 médicos)
    {
      'name': 'Dra. Patrícia Mendes',
      'specialty': 'Oftalmologia',
      'rating': 4.8,
      'experience': '15 anos',
      'price': 'R\$ 280',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Gustavo Nunes',
      'specialty': 'Oftalmologia',
      'rating': 4.7,
      'experience': '12 anos',
      'price': 'R\$ 250',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Fernanda Castro',
      'specialty': 'Oftalmologia',
      'rating': 4.9,
      'experience': '18 anos',
      'price': 'R\$ 300',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Wilson Teixeira',
      'specialty': 'Oftalmologia',
      'rating': 4.6,
      'experience': '10 anos',
      'price': 'R\$ 240',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Lígia Amaral',
      'specialty': 'Oftalmologia',
      'rating': 4.9,
      'experience': '16 anos',
      'price': 'R\$ 290',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. César Medeiros',
      'specialty': 'Oftalmologia',
      'rating': 4.8,
      'experience': '14 anos',
      'price': 'R\$ 270',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Adriana Sousa',
      'specialty': 'Oftalmologia',
      'rating': 4.7,
      'experience': '11 anos',
      'price': 'R\$ 255',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Igor Vasconcelos',
      'specialty': 'Oftalmologia',
      'rating': 5.0,
      'experience': '20 anos',
      'price': 'R\$ 320',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Helena Barros',
      'specialty': 'Oftalmologia',
      'rating': 4.8,
      'experience': '13 anos',
      'price': 'R\$ 265',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Antônio Correia',
      'specialty': 'Oftalmologia',
      'rating': 4.7,
      'experience': '9 anos',
      'price': 'R\$ 245',
      'image': '👨‍⚕️',
    },
    
    // GINECOLOGIA (10 médicos)
    {
      'name': 'Dra. Isabela Freitas',
      'specialty': 'Ginecologia',
      'rating': 5.0,
      'experience': '16 anos',
      'price': 'R\$ 290',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dra. Mariana Pinto',
      'specialty': 'Ginecologia',
      'rating': 4.8,
      'experience': '13 anos',
      'price': 'R\$ 270',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dra. Carolina Araújo',
      'specialty': 'Ginecologia',
      'rating': 4.9,
      'experience': '19 anos',
      'price': 'R\$ 310',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dra. Gabriela Melo',
      'specialty': 'Ginecologia',
      'rating': 4.7,
      'experience': '12 anos',
      'price': 'R\$ 260',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dra. Júlia Carvalho',
      'specialty': 'Ginecologia',
      'rating': 4.9,
      'experience': '15 anos',
      'price': 'R\$ 280',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dra. Luciana Resende',
      'specialty': 'Ginecologia',
      'rating': 4.8,
      'experience': '14 anos',
      'price': 'R\$ 275',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dra. Roberta Pacheco',
      'specialty': 'Ginecologia',
      'rating': 4.6,
      'experience': '10 anos',
      'price': 'R\$ 250',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dra. Silvia Teixeira',
      'specialty': 'Ginecologia',
      'rating': 4.9,
      'experience': '18 anos',
      'price': 'R\$ 300',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dra. Andréa Lima',
      'specialty': 'Ginecologia',
      'rating': 5.0,
      'experience': '20 anos',
      'price': 'R\$ 320',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dra. Verônica Santos',
      'specialty': 'Ginecologia',
      'rating': 4.8,
      'experience': '11 anos',
      'price': 'R\$ 255',
      'image': '👩‍⚕️',
    },
    
    // PSIQUIATRIA (10 médicos)
    {
      'name': 'Dr. Bruno Teixeira',
      'specialty': 'Psiquiatria',
      'rating': 4.7,
      'experience': '14 anos',
      'price': 'R\$ 300',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Aline Moreira',
      'specialty': 'Psiquiatria',
      'rating': 4.9,
      'experience': '11 anos',
      'price': 'R\$ 280',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Eduardo Correia',
      'specialty': 'Psiquiatria',
      'rating': 4.8,
      'experience': '17 anos',
      'price': 'R\$ 320',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Bianca Ferreira',
      'specialty': 'Psiquiatria',
      'rating': 4.9,
      'experience': '15 anos',
      'price': 'R\$ 310',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Marcelo Ribeiro',
      'specialty': 'Psiquiatria',
      'rating': 4.6,
      'experience': '9 anos',
      'price': 'R\$ 270',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Carla Duarte',
      'specialty': 'Psiquiatria',
      'rating': 4.8,
      'experience': '13 anos',
      'price': 'R\$ 290',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Paulo Mendes',
      'specialty': 'Psiquiatria',
      'rating': 5.0,
      'experience': '20 anos',
      'price': 'R\$ 350',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Regina Costa',
      'specialty': 'Psiquiatria',
      'rating': 4.7,
      'experience': '12 anos',
      'price': 'R\$ 285',
      'image': '👩‍⚕️',
    },
    {
      'name': 'Dr. Sandro Almeida',
      'specialty': 'Psiquiatria',
      'rating': 4.8,
      'experience': '16 anos',
      'price': 'R\$ 315',
      'image': '👨‍⚕️',
    },
    {
      'name': 'Dra. Valéria Campos',
      'specialty': 'Psiquiatria',
      'rating': 4.9,
      'experience': '18 anos',
      'price': 'R\$ 330',
      'image': '👩‍⚕️',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDoctors {
    List<Map<String, dynamic>> filtered = _doctors;

    // Filtrar por especialidade
    if (_selectedSpecialty != 'Todos') {
      filtered = filtered
          .where((doctor) => doctor['specialty'] == _selectedSpecialty)
          .toList();
    }

    // Filtrar por nome (busca)
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered
          .where((doctor) =>
              doctor['name'].toLowerCase().contains(searchTerm))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.clinicName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Banner com foto da médica
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Texto e botão
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cuidando da sua saúde\ncom excelência e carinho',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Funcionalidade em desenvolvimento'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Saiba mais',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Foto da médica
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '👩‍⚕️',
                        style: TextStyle(fontSize: 50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Lista de especialidades (rolagem horizontal)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _specialties.length,
              itemBuilder: (context, index) {
                final specialty = _specialties[index];
                final isSelected = _selectedSpecialty == specialty['name'];

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSpecialty = specialty['name'];
                      });
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              specialty['icon'],
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            specialty['name'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Campo de busca por nome
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar médico pelo nome',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 24),

          // Título da lista de médicos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedSpecialty == 'Todos'
                      ? 'Todos os Médicos'
                      : _selectedSpecialty,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_filteredDoctors.length} disponíveis',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Lista de médicos (somente ela rola)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              itemCount: _filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = _filteredDoctors[index];
                return _buildDoctorCard(doctor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Foto do médico
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                doctor['image'],
                style: const TextStyle(fontSize: 35),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Informações do médico
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor['specialty'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${doctor['rating']}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.work_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      doctor['experience'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Preço e botão
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                doctor['price'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  context.push('/doctor-profile', extra: {
                    'doctor': doctor,
                    'clinicName': widget.clinicName,
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Ver'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

