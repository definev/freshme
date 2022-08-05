import 'package:flutter/material.dart';

class FreshLoadingIndicator extends StatelessWidget {
  const FreshLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
