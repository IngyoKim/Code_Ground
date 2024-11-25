import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isFetching;

  const LoadingIndicator({
    super.key,
    required this.isFetching,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isFetching,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
