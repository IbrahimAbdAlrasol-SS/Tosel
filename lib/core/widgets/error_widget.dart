import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DefaultErrorWidget extends StatelessWidget {
  const DefaultErrorWidget(
    this.error,
    this.stackTrace, {
    super.key,
    this.onRetry,
  });

  final Object error;
  final StackTrace stackTrace;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/images/network_error.json", width: 200),
            Text("حدث خطأ في الشبكة", style: Theme.of(context).textTheme.titleMedium),
            ElevatedButton.icon(
              onPressed: onRetry,
              label: const Text("اعادة المحاولة"),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
