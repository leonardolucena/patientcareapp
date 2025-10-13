import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorProfileScreen extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final String clinicName;

  const DoctorProfileScreen({
    super.key,
    required this.doctor,
    required this.clinicName,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _isFavorite = false;
  String _selectedConsultationType = '';
  int _selectedDay = -1;
  String _selectedTime = '';
  int _bottomSheetPage = 1; // 1 = primeira parte, 2 = segunda parte
  String _selectedPriority = '';
  String _selectedPaymentMethod = '';

  // Reviews fictícios
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Maria Silva',
      'date': '15 dias atrás',
      'rating': 5.0,
      'comment':
          'Excelente profissional! Muito atencioso e dedicado. Recomendo fortemente.',
      'avatar': '👩',
    },
    {
      'name': 'João Santos',
      'date': '1 mês atrás',
      'rating': 4.5,
      'comment':
          'Ótimo médico, explicou tudo detalhadamente. Consulta muito proveitosa.',
      'avatar': '👨',
    },
    {
      'name': 'Ana Paula',
      'date': '2 meses atrás',
      'rating': 5.0,
      'comment':
          'Profissional extremamente competente e empático. Melhor médico que já consultei!',
      'avatar': '👩',
    },
    {
      'name': 'Pedro Oliveira',
      'date': '2 meses atrás',
      'rating': 4.0,
      'comment': 'Muito bom atendimento, porém a espera foi um pouco longa.',
      'avatar': '👨',
    },
    {
      'name': 'Carla Mendes',
      'date': '3 meses atrás',
      'rating': 5.0,
      'comment':
          'Adorei! Médico super qualificado e consultório muito bem equipado.',
      'avatar': '👩',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.doctor['name'],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compartilhar perfil')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? 'Adicionado aos favoritos'
                        : 'Removido dos favoritos',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            // Foto do médico
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.doctor['image'],
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nome do médico
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                widget.doctor['name'],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),

            // Especialidade
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                '${widget.doctor['specialty']} • Clínico Geral',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Avaliação
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber[600], size: 24),
                const SizedBox(width: 4),
                Text(
                  '${widget.doctor['rating']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' (165 avaliações)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Banner de informações (Pacientes | Experiência | País)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Pacientes
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '1537',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pacientes',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divisor
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.grey[300],
                    ),
                    // Experiência
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            widget.doctor['experience'].split(' ')[0],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Anos exp.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divisor
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.grey[300],
                    ),
                    // País
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '🇧🇷',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Brasil',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Localização
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Localização',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[100]!,
                          Colors.green[100]!,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Linhas simulando ruas
                        Positioned(
                          top: 60,
                          left: 0,
                          right: 0,
                          child: Container(height: 2, color: Colors.grey[300]),
                        ),
                        Positioned(
                          top: 120,
                          left: 0,
                          right: 0,
                          child: Container(height: 2, color: Colors.grey[300]),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 100,
                          child: Container(width: 2, color: Colors.grey[300]),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 100,
                          child: Container(width: 2, color: Colors.grey[300]),
                        ),
                        // Marcador
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.local_hospital,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              Container(
                                width: 3,
                                height: 15,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                        // Endereço
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.location_on, size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Av. Paulista, 1000 - São Paulo, SP',
                                    style: TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Reviews
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Avaliações',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ver todas as avaliações'),
                            ),
                          );
                        },
                        child: const Text('Ver todas'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Resumo de avaliações
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Nota grande
                        Column(
                          children: [
                            Text(
                              '${widget.doctor['rating']}',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < widget.doctor['rating'].floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber[600],
                                  size: 20,
                                );
                              }),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '165 reviews',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        // Barras de avaliação
                        Expanded(
                          child: Column(
                            children: [
                              _buildRatingBar(5, 120),
                              _buildRatingBar(4, 30),
                              _buildRatingBar(3, 10),
                              _buildRatingBar(2, 3),
                              _buildRatingBar(1, 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Lista de comentários
                  ..._reviews.map((review) => _buildReviewCard(review)),
                ],
              ),
            ),
            const SizedBox(height: 100), // Espaço para o botão
          ],
        ),
      ),
      // Botão de agendar fixo no bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Valor da consulta',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  widget.doctor['price'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showScheduleBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Agendar Consulta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Icon(Icons.star, size: 12, color: Colors.amber[600]),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: count / 165,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[600]!),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review['avatar'],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nome e data
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      review['date'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Estrelas
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review['rating'].floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber[600],
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showScheduleBottomSheet(BuildContext context) {
    setState(() {
      _selectedConsultationType = '';
      _selectedDay = -1;
      _selectedTime = '';
      _bottomSheetPage = 1;
      _selectedPriority = '';
      _selectedPaymentMethod = '';
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título com seta de voltar (se estiver na página 2)
                        Row(
                          children: [
                            if (_bottomSheetPage == 2)
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  setModalState(() {
                                    _bottomSheetPage = 1;
                                  });
                                  setState(() {
                                    _bottomSheetPage = 1;
                                  });
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            if (_bottomSheetPage == 2) const SizedBox(width: 12),
                            const Text(
                              'Agendar Consulta',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Mostrar conteúdo baseado na página
                        if (_bottomSheetPage == 1) ...[
                          // PÁGINA 1: Tipo de consulta, dia e hora
                          
                          // Tipo de consulta
                          const Text(
                            'Tipo de consulta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildConsultationTypeCard(
                                  'Online',
                                  Icons.videocam_outlined,
                                  _selectedConsultationType == 'Online',
                                  () {
                                    setModalState(() {
                                      _selectedConsultationType = 'Online';
                                    });
                                    setState(() {
                                      _selectedConsultationType = 'Online';
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildConsultationTypeCard(
                                  'Presencial',
                                  Icons.local_hospital_outlined,
                                  _selectedConsultationType == 'Presencial',
                                  () {
                                    setModalState(() {
                                      _selectedConsultationType = 'Presencial';
                                    });
                                    setState(() {
                                      _selectedConsultationType = 'Presencial';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Selecione o dia
                          const Text(
                            'Selecione o dia',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildDaySelector(setModalState),
                          const SizedBox(height: 32),

                          // Selecione a hora
                          const Text(
                            'Selecione a hora',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTimeSelector(setModalState),
                        ] else ...[
                          // PÁGINA 2: Confirmação, prioridade e pagamento
                          
                          // Aviso com informações selecionadas
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blue[200]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Seu agendamento será:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(Icons.medical_services, 'Tipo', _selectedConsultationType),
                                const SizedBox(height: 8),
                                _buildInfoRow(Icons.calendar_today, 'Data', '${_getDayName(_selectedDay)}, dia ${_getDayNumber(_selectedDay)}'),
                                const SizedBox(height: 8),
                                _buildInfoRow(Icons.access_time, 'Horário', _selectedTime),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Prioridade
                          const Text(
                            'Prioridade',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildOptionCard(
                                  'Normal',
                                  Icons.schedule_outlined,
                                  _selectedPriority == 'Normal',
                                  () {
                                    setModalState(() {
                                      _selectedPriority = 'Normal';
                                    });
                                    setState(() {
                                      _selectedPriority = 'Normal';
                                    });
                                  },
                                  setModalState,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildOptionCard(
                                  'Urgência',
                                  Icons.warning_amber_outlined,
                                  _selectedPriority == 'Urgência',
                                  () {
                                    setModalState(() {
                                      _selectedPriority = 'Urgência';
                                    });
                                    setState(() {
                                      _selectedPriority = 'Urgência';
                                    });
                                  },
                                  setModalState,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Método de pagamento
                          const Text(
                            'Método de pagamento',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildOptionCard(
                                  'Dinheiro',
                                  Icons.attach_money,
                                  _selectedPaymentMethod == 'Dinheiro',
                                  () {
                                    setModalState(() {
                                      _selectedPaymentMethod = 'Dinheiro';
                                    });
                                    setState(() {
                                      _selectedPaymentMethod = 'Dinheiro';
                                    });
                                  },
                                  setModalState,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildOptionCard(
                                  'Cartão de crédito',
                                  Icons.credit_card,
                                  _selectedPaymentMethod == 'Cartão de crédito',
                                  () {
                                    setModalState(() {
                                      _selectedPaymentMethod = 'Cartão de crédito';
                                    });
                                    setState(() {
                                      _selectedPaymentMethod = 'Cartão de crédito';
                                    });
                                  },
                                  setModalState,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 100), // Espaço para o botão
                      ],
                    ),
                  ),
                ),

                // Botão Continuar
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _bottomSheetPage == 1
                          ? (_selectedConsultationType.isEmpty ||
                                  _selectedDay == -1 ||
                                  _selectedTime.isEmpty
                              ? null
                              : () {
                                  setModalState(() {
                                    _bottomSheetPage = 2;
                                  });
                                  setState(() {
                                    _bottomSheetPage = 2;
                                  });
                                })
                          : (_selectedPriority.isEmpty ||
                                  _selectedPaymentMethod.isEmpty
                              ? null
                              : () {
                                  Navigator.pop(context);
                                  context.push('/appointment-confirmation', extra: {
                                    'doctorName': widget.doctor['name'],
                                    'clinicName': widget.clinicName,
                                    'consultationType': _selectedConsultationType,
                                    'dayName': _getDayName(_selectedDay),
                                    'dayNumber': _getDayNumber(_selectedDay),
                                    'time': _selectedTime,
                                    'priority': _selectedPriority,
                                    'paymentMethod': _selectedPaymentMethod,
                                  });
                                }),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: Text(
                        _bottomSheetPage == 1 ? 'Continuar' : 'Confirmar Agendamento',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConsultationTypeCard(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector(StateSetter setModalState) {
    final List<Map<String, dynamic>> days = [
      {'name': 'Seg', 'day': 14, 'enabled': true},
      {'name': 'Ter', 'day': 15, 'enabled': true},
      {'name': 'Qua', 'day': 16, 'enabled': false}, // Desabilitado
      {'name': 'Qui', 'day': 17, 'enabled': true},
      {'name': 'Sex', 'day': 18, 'enabled': true},
      {'name': 'Sáb', 'day': 19, 'enabled': false}, // Desabilitado
      {'name': 'Dom', 'day': 20, 'enabled': false}, // Desabilitado
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: days.asMap().entries.map((entry) {
        final index = entry.key;
        final day = entry.value;
        final isSelected = _selectedDay == index;
        final isEnabled = day['enabled'] as bool;

        return GestureDetector(
          onTap: isEnabled
              ? () {
                  setModalState(() {
                    _selectedDay = index;
                  });
                  setState(() {
                    _selectedDay = index;
                  });
                }
              : null,
          child: Container(
            width: 45,
            height: 70,
            decoration: BoxDecoration(
              color: !isEnabled
                  ? Colors.grey[100]
                  : isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: !isEnabled
                    ? Colors.grey[300]!
                    : isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: !isEnabled
                        ? Colors.grey[400]
                        : isSelected
                            ? Colors.white
                            : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${day['day']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: !isEnabled
                        ? Colors.grey[400]
                        : isSelected
                            ? Colors.white
                            : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeSelector(StateSetter setModalState) {
    final List<String> times = [
      '08:00',
      '08:30',
      '09:00',
      '09:30',
      '10:00',
      '10:30',
      '11:00',
      '11:30',
      '12:00',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: times.map((time) {
        final isSelected = _selectedTime == time;
        return GestureDetector(
          onTap: () {
            setModalState(() {
              _selectedTime = time;
            });
            setState(() {
              _selectedTime = time;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[800],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getDayName(int index) {
    final days = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
    return days[index];
  }

  int _getDayNumber(int index) {
    final dayNumbers = [14, 15, 16, 17, 18, 19, 20];
    return dayNumbers[index];
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blue[700]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    StateSetter setModalState,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

