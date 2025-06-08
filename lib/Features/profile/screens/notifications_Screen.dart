import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/custom_bottom_sheet.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool generalNotifications = true;
  bool offersNotifications = true;
  bool orderNotifications = true;
  bool cartNotifications = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return CustomBottomSheet(
      title: "الإشعارات",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(AppSpaces.medium),
          buildNotificationTile(
            "الإشعارات العامة",
            generalNotifications,
            (value) {
              setState(() {
                generalNotifications = value;
              });
            },
            theme,
          ),
          buildNotificationTile(
            "إشعارات العروض والتخفيضات",
            offersNotifications,
            (value) {
              setState(() {
                offersNotifications = value;
              });
            },
            theme,
          ),
          buildNotificationTile(
            "إشعارات الطلبات والشحن",
            orderNotifications,
            (value) {
              setState(() {
                orderNotifications = value;
              });
            },
            theme,
          ),
          buildNotificationTile(
            "إشعارات السلة",
            cartNotifications,
            (value) {
              setState(() {
                cartNotifications = value;
              });
            },
            theme,
          ),
          const Gap(AppSpaces.medium),
        ],
      ),
    );
  }
}

Widget buildNotificationTile(
    String title, bool value, Function(bool) onChanged, ColorScheme theme) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    color: theme.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(64),
      side: BorderSide(
        color: theme.outline,
        width: 1,
      ),
    ),
    child: ListTile(
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 16,
          color: theme.onSurface,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          width: 75,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: value ? const Color(0xFFEAFAF1) : const Color(0xFFFCF7F7),
          ),
          child: Stack(
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: value ? 43 : 5,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value ? const Color(0xFF44D580) : theme.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
