import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/atf_logo.dart';

enum _NotificationKind { deposit, security, update }

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.message,
    required this.date,
    required this.kind,
  });

  final String title;
  final String message;
  final DateTime date;
  final _NotificationKind kind;

  IconData get icon => switch (kind) {
    _NotificationKind.deposit => Icons.south_west_rounded,
    _NotificationKind.security => Icons.shield_outlined,
    _NotificationKind.update => Icons.system_update_alt_rounded,
  };

  Color color(BuildContext context) => switch (kind) {
    _NotificationKind.deposit => const Color(0xFF168653),
    _NotificationKind.security => Theme.of(context).colorScheme.error,
    _NotificationKind.update => Theme.of(context).colorScheme.primary,
  };
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static List<_NotificationItem> _demoNotifications() {
    final now = DateTime.now();
    return [
      _NotificationItem(
        title: 'Dépôt reçu',
        message: 'Exemple de notification : un dépôt Mobile Money a été reçu.',
        date: now.subtract(const Duration(minutes: 18)),
        kind: _NotificationKind.deposit,
      ),
      _NotificationItem(
        title: 'Alerte de sécurité',
        message: 'Exemple de notification : une nouvelle connexion nécessite votre attention.',
        date: now.subtract(const Duration(hours: 2)),
        kind: _NotificationKind.security,
      ),
      _NotificationItem(
        title: 'Mise à jour de l’application',
        message: 'Découvrez les améliorations apportées à votre espace African Trust Fund.',
        date: now.subtract(const Duration(days: 1, hours: 2)),
        kind: _NotificationKind.update,
      ),
    ]..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _demoNotifications();
    final grouped = <String, List<_NotificationItem>>{};
    final now = DateTime.now();
    for (final item in notifications) {
      grouped.putIfAbsent(_dateHeading(item.date, now), () => []).add(item);
    }

    return Scaffold(
      backgroundColor: context.appSurface,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const AtfLogo(width: 68, height: 36, padding: 3),
            const SizedBox(width: 10),
            Text(
              'Notifications',
              style: TextStyle(
                color: context.appText,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          Text(
            'Restez informé de l’activité de votre compte.',
            style: TextStyle(color: context.appMuted, fontSize: 13),
          ),
          const SizedBox(height: 22),
          for (final group in grouped.entries) ...[
            _DateHeading(label: group.key),
            ...group.value.map((item) => _NotificationCard(item: item)),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          Text(
            'Notifications de démonstration — les événements réels doivent '
            'être fournis par le serveur.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.appMuted,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  static String _dateHeading(DateTime date, DateTime now) {
    if (_isSameDay(date, now)) return 'Aujourd’hui';
    final yesterday = now.subtract(const Duration(days: 1));
    if (_isSameDay(date, yesterday)) return 'Hier';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  static bool _isSameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

class _DateHeading extends StatelessWidget {
  const _DateHeading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      label,
      style: TextStyle(
        color: context.appText,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.color(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    color: context.appText,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: TextStyle(
                    color: context.appMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  _timeLabel(item.date),
                  style: TextStyle(color: context.appMuted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeLabel(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Aujourd’hui • ${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
