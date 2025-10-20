import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

          //Contenido Centrado
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: colorList[1].withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.2,
                    ), //Color de la sombra
                    blurRadius: 2, //Difuminación de la sombra
                    offset: const Offset(
                      0,
                      4,
                    ), //Indica que la sombra se desplaza hacia abajo
                  ),
                ],
              ),
              height: 600, //altura de la tarjeta
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/logo_con_texto.svg',
                    height: 200, // ajusta según tu diseño
                  ),
                  const SizedBox(height: 30),

                  const Text('Bienvenido a AgroConecta Q.Roo'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
