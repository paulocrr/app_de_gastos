import 'package:app_de_gastos/core/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final firebaseAuth = FirebaseAuth.instance;

  bool estaLogeado() {
    return firebaseAuth.currentUser != null ? true : false;
  }

  Future<void> registrarUsuario({
    required String email,
    required String contrasenia,
    required String nombre,
    required String apellido,
  }) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: contrasenia);
    } catch (e) {
      throw ExcepcionRegistrarse();
    }
  }
}
