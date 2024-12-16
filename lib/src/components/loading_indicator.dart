import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isFetching;
  final String? message;

  const LoadingIndicator({
    super.key,
    required this.isFetching,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFetching) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16.0),
            Text(
              message!,
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
