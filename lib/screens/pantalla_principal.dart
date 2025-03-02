import 'package:app_de_gastos/repositories/auth_repository.dart';
import 'package:app_de_gastos/screens/pantalla_lista_gastos.dart';
import 'package:flutter/material.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final authRepo = AuthRepository();
  var _indiceActual = 0;
  final _tabs = <Widget>[
    PantallaListaGastos(),
    Text('tabs 2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _tabs[_indiceActual],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (value) {
          setState(() {
            _indiceActual = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Gastos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
