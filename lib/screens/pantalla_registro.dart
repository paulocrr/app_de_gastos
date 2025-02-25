import 'package:app_de_gastos/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _contraseniaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrate'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _apellidoController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextFormField(
              controller: _correoController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _contraseniaController,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            TextFormField(
              controller: _contraseniaController,
              decoration: InputDecoration(labelText: 'Repetir Contraseña'),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final authRepo = AuthRepository();

                  await authRepo.registrarUsuario(
                    email: _correoController.text,
                    contrasenia: _contraseniaController.text,
                    nombre: _nombreController.text,
                    apellido: _apellidoController.text,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Usuario creado correctamente'),
                      ),
                    );

                    Navigator.pop(context);
                  }
                } catch (e) {}
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
