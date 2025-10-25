import 'package:agroconecta/config/theme/app_theme.dart';
import 'package:agroconecta/features/shared/widgets/custom_text_form_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: colorList[2].withValues(alpha: 0.7),
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
                height: 650, //altura de la tarjeta
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo_con_texto.svg',
                      height: 200, // ajusta según tu diseño
                    ),
                    const SizedBox(height: 16),
                    //Texto principal
                    const Text(
                      'Tecnología que siembra futuro.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    const SizedBox(height: 30),

                    //Campo de usuario/correo
                    const CustomTextFormField(
                      label: 'Correo',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    //Campo contraseña
                    const CustomTextFormField(
                      label: 'Contraseña',
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    //Links inferiores
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => context.push('/forgot-password'),
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: Color(0xFF22A788),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    //Boton principal
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorList[0],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes cuenta? ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/sign-up'),
                          child: const Text(
                            'Regístrate aquí',
                            style: TextStyle(
                              color: Color(0xFF22A788),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
