import 'package:app_de_gastos/core/exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final firebaseAuth = FirebaseAuth.instance;
  final cloudFirestore = FirebaseFirestore.instance;

  bool estaLogeado() {
    return firebaseAuth.currentUser != null ? true : false;
  }

  Future<void> login(
      {required String correo, required String contrasenia}) async {
    try {
      final result = await cloudFirestore
          .collection('usuarios')
          .where('correo', isEqualTo: correo)
          .get();
      if (result.docs.isEmpty) {
        throw ExcepcionLogin();
      }

      final crendentials = await firebaseAuth.signInWithEmailAndPassword(
          email: correo, password: contrasenia);
      if (crendentials.user == null) {
        throw ExcepcionLogin();
      }
    } catch (e) {
      throw ExcepcionLogin();
    }
  }

  Future<void> registrarUsuario({
    required String email,
    required String contrasenia,
    required String nombre,
    required String apellido,
  }) async {
    try {
      final result = await cloudFirestore
          .collection('usuarios')
          .where('correo', isEqualTo: email)
          .get();

      if (result.docs.isNotEmpty) {
        throw ExceptionUsuarioYaExiste();
      }

      final credentials = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: contrasenia);

      final usuarioFirebase = credentials.user;
      if (usuarioFirebase == null) {
        throw ExcepcionRegistrarse();
      }

      final firebaseIdUsuario = usuarioFirebase.uid;

      await cloudFirestore.collection('usuarios').doc(firebaseIdUsuario).set(
        {
          'id': firebaseIdUsuario,
          'nombre': nombre,
          'apellido': apellido,
          'correo': email
        },
      );
    } catch (e) {
      throw ExcepcionRegistrarse();
    }
  }

  Future<void> cambiarContrasenia(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ExceptionLogout();
    }
  }
}
