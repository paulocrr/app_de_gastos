import 'package:cloud_firestore/cloud_firestore.dart';

class Gasto {
  final String id;
  final String descripcion;
  final double monto;
  final String idUsuario;
  final DateTime? fechaCreacion;

  Gasto({
    required this.id,
    required this.descripcion,
    required this.monto,
    required this.idUsuario,
    this.fechaCreacion,
  });

  factory Gasto.fromFirestore(Map<String, dynamic> data) {
    return Gasto(
      id: data['id'],
      descripcion: data['descripcion'],
      monto: data['monto'],
      idUsuario: data['id_usuario'],
      fechaCreacion: data['fecha_creacion'] == null
          ? null
          : DateTime.fromMicrosecondsSinceEpoch(
              (data['fecha_creacion'] as Timestamp).microsecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'monto': monto,
      'id_usuario': idUsuario,
      'fecha_creacion': fechaCreacion,
    };
  }
}
