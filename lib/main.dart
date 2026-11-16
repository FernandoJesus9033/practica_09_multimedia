import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SensoresPage(),
    ));

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  XFile? foto;
  double x = 0, y = 0, z = 0;

  @override
  void initState() {
    super.initState();
    accelerometerEventStream().listen((e) {
      if (mounted) {
        setState(() {
          x = e.x;
          y = e.y;
          z = e.z;
        });
      }
    });
  }

  Future<void> tomarFoto() async {
    final f = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );
    if (f != null) setState(() => foto = f);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Cámara y Acelerómetro')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (foto != null)
              Image.file(File(foto!.path), height: 200, fit: BoxFit.cover)
            else
              const SizedBox(
                height: 200,
                child: Center(child: Text('No hay foto')),
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: tomarFoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Tomar foto'),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Acelerómetro',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('X: ${x.toStringAsFixed(2)}'),
                    Text('Y: ${y.toStringAsFixed(2)}'),
                    Text('Z: ${z.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}