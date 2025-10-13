import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchClinicsScreen extends StatefulWidget {
  const SearchClinicsScreen({super.key});

  @override
  State<SearchClinicsScreen> createState() => _SearchClinicsScreenState();
}

class _SearchClinicsScreenState extends State<SearchClinicsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Lista de clínicas fictícias
  final List<Map<String, dynamic>> _clinics = [
    {
      'name': 'Clínica São Paulo',
      'address': 'Av. Paulista, 1000',
      'distance': '2.3 km',
      'top': 0.2,
      'left': 0.3,
    },
    {
      'name': 'Hospital Santa Maria',
      'address': 'Rua Augusta, 500',
      'distance': '3.5 km',
      'top': 0.5,
      'left': 0.6,
    },
    {
      'name': 'Clínica Vida Saudável',
      'address': 'Av. Brasil, 250',
      'distance': '1.8 km',
      'top': 0.7,
      'left': 0.4,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Título
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Procure sua clínica',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo de busca
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Digite o nome da clínica',
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
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            
            // Mapa Fictício
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          Theme.of(context).colorScheme.tertiary.withOpacity(0.15),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Linhas simulando ruas
                        ..._buildStreetLines(),
                        
                        // Marcadores de clínicas
                        ..._clinics.map((clinic) {
                          return Positioned(
                            top: MediaQuery.of(context).size.height * clinic['top'],
                            left: MediaQuery.of(context).size.width * clinic['left'],
                            child: GestureDetector(
                              onTap: () {
                                _showClinicInfo(clinic);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.error,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).shadowColor.withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.local_hospital,
                                      color: Theme.of(context).colorScheme.onError,
                                      size: 24,
                                    ),
                                  ),
                                  Container(
                                    width: 3,
                                    height: 12,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        
                        // Botão de localização
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Centralizando sua localização...'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: const Icon(Icons.my_location),
                          ),
                        ),
                        
                        // Indicador "Mapa Fictício" no topo
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Mapa Fictício',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStreetLines() {
    final lineColor = Theme.of(context).colorScheme.outline.withOpacity(0.3);
    return [
      // Linhas horizontais
      Positioned(
        top: 100,
        left: 0,
        right: 0,
        child: Container(height: 2, color: lineColor),
      ),
      Positioned(
        top: 200,
        left: 0,
        right: 0,
        child: Container(height: 2, color: lineColor),
      ),
      Positioned(
        top: 300,
        left: 0,
        right: 0,
        child: Container(height: 2, color: lineColor),
      ),
      // Linhas verticais
      Positioned(
        top: 0,
        bottom: 0,
        left: 100,
        child: Container(width: 2, color: lineColor),
      ),
      Positioned(
        top: 0,
        bottom: 0,
        left: 200,
        child: Container(width: 2, color: lineColor),
      ),
      Positioned(
        top: 0,
        bottom: 0,
        left: 300,
        child: Container(width: 2, color: lineColor),
      ),
    ];
  }

  void _showClinicInfo(Map<String, dynamic> clinic) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_hospital,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      clinic['name'],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      clinic['address'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.directions_walk,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    clinic['distance'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navega para a tela de médicos passando o nome da clínica
                    context.push('/doctors/${Uri.encodeComponent(clinic['name'])}');
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Agendar Consulta'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

