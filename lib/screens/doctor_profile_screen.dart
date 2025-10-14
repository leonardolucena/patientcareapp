import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  // Traduzir especialidade de português para o idioma atual
  String _translateSpecialty(String portugueseName, AppLocalizations l10n) {
    switch (portugueseName) {
      case 'Cardiologia':
        return l10n.cardiology;
      case 'Dermatologia':
        return l10n.dermatology;
      case 'Ortopedia':
        return l10n.orthopedics;
      case 'Pediatria':
        return l10n.pediatrics;
      case 'Neurologia':
        return l10n.neurology;
      case 'Oftalmologia':
        return l10n.ophthalmology;
      case 'Ginecologia':
        return l10n.gynecology;
      case 'Psiquiatria':
        return l10n.psychiatry;
      default:
        return portugueseName;
    }
  }

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
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor.withValues(alpha: 0.1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.doctor['name'],
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.shareProfile)),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFavorite
                        ? l10n.addedToFavorites
                        : l10n.removedFromFavorites,
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
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
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
                '${_translateSpecialty(widget.doctor['specialty'], l10n)} • ${l10n.generalPractitioner}',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                  ' (165 ${l10n.reviews})',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
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
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.patients,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divisor
                    Container(
                      width: 1,
                      height: 50,
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
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
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.yearsExp,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divisor
                    Container(
                      width: 1,
                      height: 50,
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
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
                            l10n.brazil,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                  Text(
                    l10n.location,
                    style: const TextStyle(
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
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
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
                          child: Container(
                            height: 2,
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2,
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 100,
                          child: Container(
                            width: 2,
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 100,
                          child: Container(
                            width: 2,
                            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        // Marcador
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.local_hospital,
                                  color: Theme.of(context).colorScheme.onError,
                                  size: 32,
                                ),
                              ),
                              Container(
                                width: 3,
                                height: 15,
                                color: Theme.of(context).colorScheme.error,
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
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
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
                      Text(
                        l10n.ratingsLabel,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.seeAllReviews),
                            ),
                          );
                        },
                        child: Text(l10n.seeAll),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Resumo de avaliações
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
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
                              l10n.reviewsCount(165),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                              _buildRatingBar(context, 5, 120),
                              _buildRatingBar(context, 4, 30),
                              _buildRatingBar(context, 3, 10),
                              _buildRatingBar(context, 2, 3),
                              _buildRatingBar(context, 1, 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Lista de comentários
                  ..._reviews.map((review) => _buildReviewCard(context, review)),
                ],
              ),
            ),
            const SizedBox(height: 100), // Espaço para o botão
          ],
        ),
      ),
      // Botão de agendar fixo no bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
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
                  l10n.consultationPrice,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  widget.doctor['price'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _showScheduleBottomSheet(context, l10n);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.scheduleAppointment,
                  style: const TextStyle(
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

  Widget _buildRatingBar(BuildContext context, int stars, int count) {
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
                backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[600]!),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12, 
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
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
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showScheduleBottomSheet(BuildContext context, AppLocalizations l10n) {
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
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
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
                              Text(
                                l10n.scheduleAppointment,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Mostrar conteúdo baseado na página
                          if (_bottomSheetPage == 1) ...[
                            // PÁGINA 1: Tipo de consulta, dia e hora
                            
                            // Tipo de consulta
                            Text(
                              l10n.consultationType,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildConsultationTypeCard(
                                    l10n.online,
                                    Icons.videocam_outlined,
                                    _selectedConsultationType == l10n.online,
                                    () {
                                      setModalState(() {
                                        _selectedConsultationType = l10n.online;
                                      });
                                      setState(() {
                                        _selectedConsultationType = l10n.online;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildConsultationTypeCard(
                                    l10n.inPerson,
                                    Icons.local_hospital_outlined,
                                    _selectedConsultationType == l10n.inPerson,
                                    () {
                                      setModalState(() {
                                        _selectedConsultationType = l10n.inPerson;
                                      });
                                      setState(() {
                                        _selectedConsultationType = l10n.inPerson;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Selecione o dia
                            Text(
                              l10n.selectDay,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDaySelector(setModalState, l10n),
                            const SizedBox(height: 24),

                            // Selecione a hora
                            Text(
                              l10n.selectTime,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTimeSelector(setModalState),
                          ] else ...[
                            // PÁGINA 2: Confirmação, prioridade e pagamento
                            
                            // Aviso com informações selecionadas
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline, 
                                        color: Theme.of(context).colorScheme.primary, 
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        l10n.yourAppointmentWillBe,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoRow(context, Icons.medical_services, l10n.type, _selectedConsultationType),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(context, Icons.calendar_today, l10n.date, '${_getDayName(_selectedDay, l10n)}, ${l10n.day} ${_getDayNumber(_selectedDay)}'),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(context, Icons.access_time, l10n.time, _selectedTime),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Prioridade
                            Text(
                              l10n.priority,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildOptionCard(
                                    l10n.normal,
                                    Icons.schedule_outlined,
                                    _selectedPriority == l10n.normal,
                                    () {
                                      setModalState(() {
                                        _selectedPriority = l10n.normal;
                                      });
                                      setState(() {
                                        _selectedPriority = l10n.normal;
                                      });
                                    },
                                    setModalState,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildOptionCard(
                                    l10n.urgent,
                                    Icons.warning_amber_outlined,
                                    _selectedPriority == l10n.urgent,
                                    () {
                                      setModalState(() {
                                        _selectedPriority = l10n.urgent;
                                      });
                                      setState(() {
                                        _selectedPriority = l10n.urgent;
                                      });
                                    },
                                    setModalState,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Método de pagamento
                            Text(
                              l10n.paymentMethod,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildOptionCard(
                                    l10n.cash,
                                    Icons.attach_money,
                                    _selectedPaymentMethod == l10n.cash,
                                    () {
                                      setModalState(() {
                                        _selectedPaymentMethod = l10n.cash;
                                      });
                                      setState(() {
                                        _selectedPaymentMethod = l10n.cash;
                                      });
                                    },
                                    setModalState,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildOptionCard(
                                    l10n.creditCard,
                                    Icons.credit_card,
                                    _selectedPaymentMethod == l10n.creditCard,
                                    () {
                                      setModalState(() {
                                        _selectedPaymentMethod = l10n.creditCard;
                                      });
                                      setState(() {
                                        _selectedPaymentMethod = l10n.creditCard;
                                      });
                                    },
                                    setModalState,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Botão Continuar
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
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
                                        'dayName': _getDayName(_selectedDay, l10n),
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
                            disabledBackgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
                          ),
                          child: Text(
                            _bottomSheetPage == 1 ? l10n.continueButton : l10n.confirmAppointment,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) 
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector(StateSetter setModalState, AppLocalizations l10n) {
    final List<Map<String, dynamic>> days = [
      {'name': l10n.mondayShort, 'day': 14, 'enabled': true},
      {'name': l10n.tuesdayShort, 'day': 15, 'enabled': true},
      {'name': l10n.wednesdayShort, 'day': 16, 'enabled': false}, // Desabilitado
      {'name': l10n.thursdayShort, 'day': 17, 'enabled': true},
      {'name': l10n.fridayShort, 'day': 18, 'enabled': true},
      {'name': l10n.saturdayShort, 'day': 19, 'enabled': false}, // Desabilitado
      {'name': l10n.sundayShort, 'day': 20, 'enabled': false}, // Desabilitado
    ];

    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = _selectedDay == index;
          final isEnabled = day['enabled'] as bool;

          return Padding(
            padding: EdgeInsets.only(right: index < days.length - 1 ? 12 : 0),
            child: GestureDetector(
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
                width: 50,
                decoration: BoxDecoration(
                  color: !isEnabled
                      ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05)
                      : isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: !isEnabled
                        ? Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)
                        : isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
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
                            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)
                            : isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${day['day']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: !isEnabled
                            ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)
                            : isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected 
                    ? Theme.of(context).colorScheme.onPrimary 
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getDayName(int index, AppLocalizations l10n) {
    final days = [l10n.monday, l10n.tuesday, l10n.wednesday, l10n.thursday, l10n.friday, l10n.saturday, l10n.sunday];
    return days[index];
  }

  int _getDayNumber(int index) {
    final dayNumbers = [14, 15, 16, 17, 18, 19, 20];
    return dayNumbers[index];
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon, 
          size: 16, 
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) 
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

