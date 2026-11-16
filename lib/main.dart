import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:intl/intl.dart'; // Para la fecha y hora

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: BitacoraPage()),
);

class BitacoraPage extends StatefulWidget {
  const BitacoraPage({super.key});

  @override
  State<BitacoraPage> createState() => _BitacoraPageState();
}

class _BitacoraPageState extends State<BitacoraPage> {
  XFile? foto;
  String fechaHora = '';
  double accX = 0, accY = 0, accZ = 0;
  double gyrX = 0, gyrY = 0, gyrZ = 0;

  @override
  void initState() {
    super.initState();
    // Actualizar fecha y hora
    fechaHora = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    // Escuchar Acelerómetro
    accelerometerEventStream().listen((e) {
      if (mounted) {
        setState(() {
          accX = e.x;
          accY = e.y;
          accZ = e.z;
        });
      }
    });

    // Escuchar Giroscopio
    gyroscopeEventStream().listen((e) {
      if (mounted) {
        setState(() {
          gyrX = e.x;
          gyrY = e.y;
          gyrZ = e.z;
        });
      }
    });
  }

  Future<void> tomarFoto() async {
    try {
      final f = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );
      // Si el usuario cancela, f es null y no hace nada (manejo de cancelación)
      if (f != null) {
        setState(() {
          foto = f;
          // Actualizamos la fecha y hora al momento de la captura
          fechaHora = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al abrir cámara: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bitácora de Inspección')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tarjeta de Evidencia',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(height: 10),

                // 1. Foto
                if (foto != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(foto!.path),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Sin fotografía')),
                  ),
                const SizedBox(height: 10),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: tomarFoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Capturar Fotografía'),
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Fecha y Hora
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      'Fecha/Hora: $fechaHora',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 3. Acelerómetro
                const Text(
                  'Acelerómetro (m/s²)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'X: ${accX.toStringAsFixed(2)}  |  Y: ${accY.toStringAsFixed(2)}  |  Z: ${accZ.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 15),

                // 4. Giroscopio
                const Text(
                  'Giroscopio (rad/s)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'X: ${gyrX.toStringAsFixed(2)}  |  Y: ${gyrY.toStringAsFixed(2)}  |  Z: ${gyrZ.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
