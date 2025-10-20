import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cultivo.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
