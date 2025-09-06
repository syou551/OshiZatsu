import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/theme_service.dart';

class ErrorNotificationsWidget extends ConsumerWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ErrorNotificationsWidget({
    super.key,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeServiceProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFDC3545).withOpacity(0.1), // エラー色は固定
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: const Color(0xFFDC3545), // エラー色は固定
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'エラーが発生しました',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFFDC3545), // エラー色は固定
              ),
            ),
            const SizedBox(height: 8),
            if (errorMessage != null)
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: themeState.isDarkMode ? Colors.grey : const Color(0xFF6C757D),
                ),
              ),
            const SizedBox(height: 24),
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('再試行'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeState.selectedColor.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
