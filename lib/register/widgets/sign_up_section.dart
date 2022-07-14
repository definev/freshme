import 'package:flutter/material.dart';
import 'package:freshme/fresh_widget/fresh_text_field.dart';

class SignUpSection extends StatelessWidget {
  const SignUpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        FreshTextField(),
        FreshTextField(),
      ],
    );
  }
}
