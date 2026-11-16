import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09_multimedia_sensores/main.dart';

void main() {
  testWidgets('La bitacora carga correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BitacoraPage()));
    expect(find.text('Bitácora de Inspección'), findsOneWidget);
  });
}