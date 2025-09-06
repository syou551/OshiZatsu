import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/theme_service.dart';

class EmptyNotificationsWidget extends ConsumerWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeServiceProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: themeState.selectedColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.notifications_none,
              size: 60,
              color: themeState.selectedColor.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '通知がありません',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: themeState.isDarkMode ? Colors.grey : const Color(0xFF6C757D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '推しのライブ配信通知が\nここに表示されます',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: themeState.isDarkMode ? Colors.grey : const Color(0xFF6C757D),
            ),
          ),
        ],
      ),
    );
  }
}
