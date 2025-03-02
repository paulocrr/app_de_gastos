import 'dart:io';
import 'package:app_de_gastos/repositories/gastos_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PantallaListaGastos extends StatefulWidget {
  const PantallaListaGastos({super.key});

  @override
  State<PantallaListaGastos> createState() => _PantallaListaGastosState();
}

class _PantallaListaGastosState extends State<PantallaListaGastos> {
  final _idForm = GlobalKey<FormState>();
  final _descripcionTextController = TextEditingController();
  final _montoTextController = TextEditingController();
  final _gastosRepo = GastosRepository();
  String? rutaImagenPreview;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarFormularioParaAgregar();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Mis Gastos'),
      ),
      body: StreamBuilder(
        stream: _gastosRepo.obtenerFlujoDeGastos(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data;
          if (data != null) {
            return ListView(
              children: [
                ...data.map((gasto) {
                  return ListTile(
                    title: Text(gasto.descripcion),
                    subtitle: gasto.fechaCreacion == null
                        ? null
                        : Text(gasto.fechaCreacion.toString()),
                    leading: Text(
                      'S/${gasto.monto.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        await _gastosRepo.borrarGasto(gasto);
                        // _obtenerGastosUsuario();
                      },
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    ),
                  );
                })
              ],
            );
          }

          return Center(
            child: Text('Data nulla'),
          );
        },
      ),
    );
  }

  void _mostrarFormularioParaAgregar() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return SizedBox(
            height: 800,
            child: Form(
              key: _idForm,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                children: [
                  TextFormField(
                    controller: _descripcionTextController,
                    decoration: InputDecoration(labelText: 'Descripcion'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es requerido';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _montoTextController,
                    decoration: InputDecoration(labelText: 'Monto'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo es requerido';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  if (rutaImagenPreview != null)
                    Image.file(File(rutaImagenPreview!)),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform
                          .pickFiles(type: FileType.image);

                      if (result != null) {
                        setState(() {
                          rutaImagenPreview = result.files.single.path!;
                        });
                      }
                    },
                    child: Text('Surbir archivo'),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      final esValido = _idForm.currentState?.validate();

                      if (esValido == true) {
                        try {
                          await _gastosRepo.guardarGasto(
                            descripcion: _descripcionTextController.text,
                            monto: double.parse(_montoTextController.text),
                          );

                          // await _obtenerGastosUsuario();

                          if (mounted) {
                            Navigator.pop(context);
                            _descripcionTextController.clear();
                            _montoTextController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Se guardo el gasto'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Algo salio mal vuelva a intentarlo'),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: Text('Guardar'),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
