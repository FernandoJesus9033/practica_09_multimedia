import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09_multimedia_sensores/main.dart';

void main() {
  testWidgets('La app de sensores carga correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SensoresPage()));
    
    // Verifica que el título de la AppBar esté presente
    expect(find.text('Cámara y Acelerómetro'), findsOneWidget);
  });
}