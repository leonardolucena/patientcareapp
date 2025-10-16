import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/reminder_provider.dart';
import '../data/models/reminder_model.dart';

/// Tela de visualização de lembretes de consultas
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderProvider>().refreshReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembretes de Consultas'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          _buildStatistics(),
          Expanded(child: _buildRemindersList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/reminders/add'),
        icon: const Icon(Icons.add),
        label: const Text('Novo Lembrete'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  /// Chips de filtro
  Widget _buildFilterChips() {
    return Consumer<ReminderProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  'Todos',
                  'all',
                  provider.filterType == 'all',
                  provider.reminders.length,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Hoje',
                  'today',
                  provider.filterType == 'today',
                  provider.todayCount,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Próximos',
                  'upcoming',
                  provider.filterType == 'upcoming',
                  provider.upcomingCount,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  'Vencidos',
                  'overdue',
                  provider.filterType == 'overdue',
                  provider.overdueCount,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String value, bool isSelected, int count) {
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (_) {
        context.read<ReminderProvider>().setFilter(value);
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  /// Estatísticas dos lembretes
  Widget _buildStatistics() {
    return Consumer<ReminderProvider>(
      builder: (context, provider, _) {
        if (provider.reminders.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                Icons.today,
                'Hoje',
                provider.todayCount.toString(),
                Colors.blue,
              ),
              _buildStatDivider(),
              _buildStatItem(
                Icons.schedule,
                'Próximos',
                provider.upcomingCount.toString(),
                Colors.green,
              ),
              _buildStatDivider(),
              _buildStatItem(
                Icons.warning_amber_rounded,
                'Vencidos',
                provider.overdueCount.toString(),
                Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey[300],
    );
  }

  /// Lista de lembretes
  Widget _buildRemindersList() {
    return Consumer<ReminderProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.refreshReminders(),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        final reminders = provider.filteredReminders;

        if (reminders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum lembrete encontrado',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adicione lembretes para suas consultas',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.refreshReminders(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              return _buildReminderCard(reminders[index]);
            },
          ),
        );
      },
    );
  }

  /// Card de lembrete individual
  Widget _buildReminderCard(ReminderModel reminder) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    Color statusColor = Colors.green;
    IconData statusIcon = Icons.schedule;
    String statusText = 'Próximo';

    if (reminder.isOverdue) {
      statusColor = Colors.orange;
      statusIcon = Icons.warning_amber_rounded;
      statusText = 'Vencido';
    } else if (reminder.isToday) {
      statusColor = Colors.blue;
      statusIcon = Icons.today;
      statusText = 'Hoje';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: reminder.isOverdue ? Colors.orange.withValues(alpha: 0.3) : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          context.push('/reminders/add', extra: reminder);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (!reminder.isToday && !reminder.isOverdue) ...[
                              const SizedBox(width: 8),
                              Text(
                                'Em ${reminder.daysUntilAppointment} dias',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red[300],
                    onPressed: () => _confirmDelete(reminder),
                  ),
                ],
              ),
              if (reminder.description.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text(
                  reminder.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Consulta: ${dateFormat.format(reminder.appointmentDate)}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.notifications_active, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Lembrar: ${dateFormat.format(reminder.reminderDate)} às ${timeFormat.format(reminder.reminderDate)}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
              if (reminder.doctorName?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Dr(a). ${reminder.doctorName ?? ''}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
              if (reminder.location?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        reminder.location ?? '',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Confirma exclusão do lembrete
  Future<void> _confirmDelete(ReminderModel reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Lembrete'),
        content: Text('Deseja realmente excluir o lembrete "${reminder.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<ReminderProvider>().deleteReminder(reminder.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lembrete excluído com sucesso')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir lembrete: $e')),
          );
        }
      }
    }
  }
}

