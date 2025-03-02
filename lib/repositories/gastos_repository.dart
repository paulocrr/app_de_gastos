import 'package:app_de_gastos/core/exceptions.dart';
import 'package:app_de_gastos/models/gasto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GastosRepository {
  final cloudFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  Future<List<Gasto>> obtenerGastos() async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw ExceptionObtenerGastos();
      }

      final querySnapshot = await cloudFirestore
          .collection('gastos')
          .where('id_usuario', isEqualTo: userId)
          .get();

      final docs = querySnapshot.docs;

      final listaGastos = List<Gasto>.from(
        docs.map<Gasto>(
          (doc) {
            final data = doc.data();
            return Gasto.fromFirestore(data);
          },
        ),
      );

      return listaGastos;
    } catch (e) {
      throw ExceptionObtenerGastos();
    }
  }

  Stream<List<Gasto>> obtenerFlujoDeGastos() {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw ExceptionObtenerGastos();
      }

      return cloudFirestore
          .collection('gastos')
          .snapshots()
          .asyncMap((querySnanpshot) {
        final docs = querySnanpshot.docs;

        final listaGastos = List<Gasto>.from(
          docs.map<Gasto>(
            (doc) {
              final data = doc.data();
              return Gasto.fromFirestore(data);
            },
          ),
        );

        return listaGastos;
      });
    } catch (e) {
      throw ExceptionObtenerGastos();
    }
  }

  Future<void> borrarGasto(Gasto gasto) async {
    try {
      await cloudFirestore.collection('gastos').doc(gasto.id).delete();
    } catch (e) {
      throw ExceptionAlBorrarGasto();
    }
  }

  Future<void> guardarGasto(
      {required String descripcion, required double monto}) async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw ExcepcionGuardarGasto();
      }
      final idFirebase = cloudFirestore.collection('gastos').doc().id;

      final gasto = Gasto(
        id: idFirebase,
        descripcion: descripcion,
        monto: monto,
        idUsuario: userId,
        fechaCreacion: DateTime.now(),
      );

      await cloudFirestore
          .collection('gastos')
          .doc(idFirebase)
          .set(gasto.toMap());
    } catch (e) {
      throw ExcepcionGuardarGasto();
    }
  }
}
