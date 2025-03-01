import 'package:app_de_gastos/repositories/auth_repository.dart';
import 'package:app_de_gastos/screens/pantalla_registro.dart';
import 'package:app_de_gastos/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final authRepo = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _passwordController,
                  // obscureText: true,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await authRepo.login(
                        correo: _emailController.text,
                        contrasenia: _passwordController.text,
                      );
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return SplashScreen();
                            },
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('No se pudo ignresar al sistema'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Ingresar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return PantallaRegistro();
                        },
                      ),
                    );
                  },
                  child: Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
