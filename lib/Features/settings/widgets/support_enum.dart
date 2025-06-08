import 'dart:ui';

class SupportStatus {
  final String name;
  final Color color;
  final Color textColor;

  SupportStatus({
    required this.name,
    required this.color,
    required this.textColor,
  });

  static final List<SupportStatus> values = [
    SupportStatus(
      name: 'قيد المراجعة',
      color: const Color(0xFFFFFAE5),
      textColor: const Color(0xFF524100),
    ),
    SupportStatus(
      name: 'قيد الحل',
      color: const Color(0xFFFFF5F5),
      textColor: const Color(0xFF520000),
    ),
    SupportStatus(
      name: 'مغلقة',
      color: const Color(0xFFE5FFE5),
      textColor: const Color(0xFF005200),
    ),
  ];
}